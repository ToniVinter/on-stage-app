import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/amazon_s3/amazon_s3_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_state.dart';
import 'package:on_stage_app/app/features/team_member/data/team_member_repository.dart';
import 'package:on_stage_app/app/features/team_member/domain/create_team_member_request/create_team_member_request.dart';
import 'package:on_stage_app/app/features/team_member/domain/edit_team_member_request/edit_team_member_request.dart';
import 'package:on_stage_app/app/features/team_member/domain/invite_status/invite_status.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_photo/team_member_photo.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/shared/data/enums/error_type.dart';
import 'package:on_stage_app/app/shared/data/error_model/error_model.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:pool/pool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'team_members_notifier.g.dart';

@riverpod
class TeamMembersNotifier extends _$TeamMembersNotifier {
  TeamMemberRepository? _teamMemberRepository;

  TeamMemberRepository get teamMemberRepository {
    _teamMemberRepository ??= TeamMemberRepository(ref.watch(dioProvider));
    return _teamMemberRepository!;
  }

  @override
  TeamMembersState build() {
    return const TeamMembersState();
  }

  Future<void> getTeamMembers({bool? includeCurrentUser}) async {
    final teamMembers = await teamMemberRepository.getTeamMembers(
      includeCurrentUser: includeCurrentUser,
    );
    state = state.copyWith(teamMembers: teamMembers);
    final teamMembersWithPhoto = await Future.wait(
      teamMembers.map(_getMemberWithPhotoFromLocalStorage),
    );
    state = state.copyWith(teamMembers: teamMembersWithPhoto);
  }

  Future<void> getUninvitedTeamMembers({String? eventId}) async {
    state = state.copyWith(isLoading: true);
    try {
      final members = await teamMemberRepository.getUninvitedTeamMembers(
        eventId: eventId,
        includeCurrentUser: true,
      );
      final uninvitedMembersWithPhoto = await Future.wait(
        members.map(_getMemberWithPhotoFromLocalStorage),
      );
      state = state.copyWith(uninvitedTeamMembers: uninvitedMembersWithPhoto);
    } catch (e) {
      logger.e('Error getting uninvited team members: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<String?> resendInvitationOnTeamMember(
    String? teamMemberInvited,
    TeamMemberRole? role,
  ) async {
    if (teamMemberInvited.isNullEmptyOrWhitespace) {
      return 'Team member email is empty';
    }

    final createTeamMemberRequest = CreateTeamMemberRequest(
      teamMemberInvited: teamMemberInvited,
      newMemberRole: role,
    );

    try {
      await teamMemberRepository.inviteTeamMember(createTeamMemberRequest);
      return 'Invitation resent successfully';
    } catch (e, s) {
      logger.e('Error resending invitation on team member: $e $s');
      return 'An error occurred while resending the invitation';
    }
  }

  Future<String?> inviteTeamMember(
    String email,
    TeamMemberRole role,
  ) async {
    if (email.isNullEmptyOrWhitespace) {
      return 'Email is empty';
    }

    try {
      final createTeamMemberRequest = CreateTeamMemberRequest(
        email: email,
        newMemberRole: role,
      );

      final teamMember =
          await teamMemberRepository.inviteTeamMember(createTeamMemberRequest);

      if (teamMember != null) {
        if (state.teamMembers.any((member) => member.id == teamMember.id)) {
          logger.i('Team member with ID ${teamMember.id} '
              'already exists, resending invitation');
          return null;
        }

        final teamMemberWithPhoto =
            await _getMemberWithPhotoFromLocalStorage(teamMember);

        state = state.copyWith(
          teamMembers: [
            ...state.teamMembers,
            teamMemberWithPhoto,
          ],
        );

        return null;
      } else {
        logger.i('Failed to invite team member. API returned null.');
        return 'User with this email or username not found. ';
      }
    } on DioException catch (e) {
      logger.i('Error inviting team member: $e');

      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final errorModel = ApiErrorResponse.fromJson(errorData);
        if (errorModel.errorName == ErrorType.RESOURCE_NOT_FOUND) {
          return errorModel.errorName
              ?.getDescription('User with email or username');
        } else if (errorModel.errorName ==
            ErrorType.TEAM_MEMBER_ALREADY_EXISTS) {
          return errorModel.errorName
              ?.getDescription('User with email or username');
        }
      }

      return 'An error occurred while inviting the team member';
    } catch (e) {
      logger.i('Error inviting team member: $e');
      return 'An error occurred while inviting the team member';
    }
  }

  Future<void> fetchAndSaveTeamMemberPhotos() async {
    try {
      logger.i('Starting to fetch team member photos');

      final teamMemberPhotos = await _getTeamMemberPhotos();
      logger.i('Fetched ${teamMemberPhotos.length} team member photos');

      await _saveTeamMemberPhotosToLocalStorage(teamMemberPhotos);
      logger.i('Saved team member photos to local storage');
    } catch (e) {
      logger.e('Error in fetchAndSaveTeamMemberPhotos', e);
    }
  }

  Future<void> updateTeamMemberInvitation(
    String teamMemberId, {
    required InviteStatus inviteStatus,
  }) async {
    final teamMember = EditTeamMemberRequest(inviteStatus: inviteStatus);
    await teamMemberRepository.updateTeamMember(teamMemberId, teamMember);
  }

  Future<void> updateTeamMemberRole(
    String teamMemberId,
    TeamMemberRole role,
  ) async {
    final teamMember = EditTeamMemberRequest(role: role);
    await teamMemberRepository.updateTeamMember(teamMemberId, teamMember);
  }

  Future<void> removeTeamMember(String id) async {
    try {
      state = state.copyWith(
        teamMembers:
            state.teamMembers.where((member) => member.id != id).toList(),
      );
      await teamMemberRepository.deleteTeamMember(id);
    } catch (e) {
      logger.e('Error deleting team member: $e');
    }
  }

  Future<List<TeamMemberPhoto>> _getTeamMemberPhotos() async {
    final memberPhotosResponse =
        await teamMemberRepository.getTeamMemberPhotos();
    final pool = Pool(10);

    final photoFutures = memberPhotosResponse.map((photo) {
      return pool.withResource(() async {
        final photoUrl = photo.photoUrl;
        if (photoUrl != null && photoUrl.isNotEmpty) {
          final photoData = await ref
              .read(amazonS3NotifierProvider.notifier)
              .getPhotoFromAWS(photoUrl);
          return TeamMemberPhoto(
            userId: photo.userId,
            profilePicture: photoData,
          );
        } else {
          return TeamMemberPhoto(userId: photo.userId);
        }
      });
    }).toList();

    final results = await Future.wait(photoFutures);
    unawaited(pool.close());
    return results;
  }

  Future<void> _saveTeamMemberPhotosToLocalStorage(
    List<TeamMemberPhoto> teamMemberPhotos,
  ) async {
    final database = ref.read(databaseProvider);

    await database.transaction(() async {
      for (final member in teamMemberPhotos) {
        if (member.profilePicture != null) {
          if (member.userId.isEmpty) {
            logger.w('Invalid ID format: ${member.userId}');
            continue;
          }

          await database
              .into(database.profilePictureTable)
              .insertOnConflictUpdate(
                ProfilePictureTableCompanion(
                  id: Value(member.userId),
                  picture: Value(member.profilePicture),
                ),
              );
          logger.i('Upserted profile picture for ID: ${member.userId}');
        }
      }
    });
  }

  Future<TeamMember> _getMemberWithPhotoFromLocalStorage(
    TeamMember member,
  ) async {
    final photo =
        await ref.read(databaseProvider).getTeamMemberPhoto(member.userId);
    return member.copyWith(profilePicture: photo?.profilePicture);
  }
}
