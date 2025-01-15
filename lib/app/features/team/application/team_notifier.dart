import 'dart:async';
import 'dart:typed_data';

import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/team/application/team_state.dart';
import 'package:on_stage_app/app/features/team/application/teams/teams_notifier.dart';
import 'package:on_stage_app/app/features/team/data/team_repository.dart';
import 'package:on_stage_app/app/features/team/domain/team_request/team_request.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'team_notifier.g.dart';

@riverpod
class TeamNotifier extends _$TeamNotifier {
  TeamRepository? _teamRepository;

  TeamRepository get teamRepository {
    _teamRepository ??= TeamRepository(ref.watch(dioProvider));
    return _teamRepository!;
  }

  @override
  TeamState build() {
    final dio = ref.watch(dioProvider);
    _teamRepository = TeamRepository(dio);

    return const TeamState();
  }

  Future<void> getCurrentTeam() async {
    state = state.copyWith(isLoading: true);
    var currentTeam = await teamRepository.getCurrentTeam();

    final first3PhotosForTeam =
        await _setPhotosFromLocalStorage(currentTeam.membersUserIds);

    currentTeam = currentTeam.copyWith(
      memberPhotos: first3PhotosForTeam,
    );

    state = state.copyWith(isLoading: false, currentTeam: currentTeam);
  }

  Future<void> updateTeamName(String name) async {
    if (state.currentTeam?.id == null) return;

    final teamRequest = TeamRequest(name: name);
    final updatedTeam = await teamRepository.updateTeam(
      state.currentTeam!.id,
      teamRequest,
    );
    state = state.copyWith(currentTeam: updatedTeam);
  }

  Future<void> createTeam(TeamRequest team) async {
    await teamRepository.createTeam(team);
    unawaited(ref.read(teamsNotifierProvider.notifier).getTeams());
  }

  Future<List<Uint8List?>> _setPhotosFromLocalStorage(
    List<String> userIds,
  ) async {
    final photos = await Future.wait(
      userIds.map((userId) async {
        final photo =
            await ref.read(databaseProvider).getTeamMemberPhoto(userId);
        return photo?.profilePicture;
      }),
    );
    return photos;
  }
}
