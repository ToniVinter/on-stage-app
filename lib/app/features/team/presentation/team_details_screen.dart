import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_setting_tile.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/edit_field_modal.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team/domain/team_request/team_request.dart';
import 'package:on_stage_app/app/features/team/presentation/team_member_modal.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/team_member/domain/invite_status/invite_status.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/member_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TeamDetailsScreen extends ConsumerStatefulWidget {
  const TeamDetailsScreen({
    this.isCreating = false,
    super.key,
  });

  final bool isCreating;

  @override
  TeamDetailsScreenState createState() => TeamDetailsScreenState();
}

class TeamDetailsScreenState extends ConsumerState<TeamDetailsScreen> {
  final teamNameController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isCreating) {
        ref.read(teamMembersNotifierProvider.notifier).getTeamMembers();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StageAppBar(
        title: widget.isCreating ? 'Create New Team' : 'Team Details',
        isBackButtonVisible: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ref.watch(permissionServiceProvider).hasAccessToEdit) ...[
                const SizedBox(height: 16),
                const Text('Manage'),
                const SizedBox(height: 8),
                PreferencesActionTile(
                  title: 'Groups',
                  trailingIcon: Icons.keyboard_arrow_right_rounded,
                  leadingWidget: Icon(
                    LucideIcons.users_round,
                    size: 20,
                    color: context.colorScheme.outline,
                  ),
                  height: 54,
                  onTap: () {
                    context.goNamed(AppRoute.groups.name);
                  },
                ),
              ],
              const SizedBox(height: 16),
              CustomSettingTile(
                backgroundColor: context.colorScheme.onSurfaceVariant,
                placeholder:
                    ref.watch(teamNotifierProvider).currentTeam?.name ??
                        'Enter Team Name',
                headline: 'Team Name',
                suffix: const SizedBox(),
                onTap: () {
                  if (!ref.watch(permissionServiceProvider).isLeaderOnTeam) {
                    return;
                  }
                  EditFieldModal.show(
                    context: context,
                    fieldName: 'Team Name',
                    value: ref.watch(teamNotifierProvider).currentTeam?.name ??
                        'Enter Team Name',
                    onSubmitted: (value) {
                      ref
                          .read(teamNotifierProvider.notifier)
                          .updateTeamName(value);
                    },
                  );
                },
                controller: widget.isCreating ? teamNameController : null,
              ),
              const SizedBox(height: 16),
              Text('Members', style: context.textTheme.titleSmall),
              const SizedBox(height: 8),
              _buildParticipantsList(),
              if (ref.watch(permissionServiceProvider).hasAccessToEdit) ...[
                const SizedBox(height: 12),
                EventActionButton(
                  onTap: () {
                    ref
                        .watch(permissionServiceProvider)
                        .callMethodIfHasPermission(
                          context: context,
                          permissionType: PermissionType.addTeamMembers,
                          onGranted: () {
                            context.pushNamed(AppRoute.addTeamMember.name);
                          },
                        );
                  },
                  text: 'Invite People',
                  icon: Icons.add,
                ),
              ],
              if (widget.isCreating) ...[
                const Spacer(),
                ContinueButton(
                  text: 'Create',
                  onPressed: () {
                    ref.read(teamNotifierProvider.notifier).createTeam(
                          TeamRequest(
                            name: teamNameController.text,
                            membersCount: 1,
                          ),
                        );
                    context.pop();
                  },
                  isEnabled: true,
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsList() {
    final teamMembers = ref
        .watch(teamMembersNotifierProvider)
        .teamMembers
        .where(
          (member) =>
              member.inviteStatus == InviteStatus.pending ||
              member.inviteStatus == InviteStatus.confirmed,
        )
        .toList();
    if (teamMembers.isEmpty) {
      return const SizedBox();
    }
    return Ink(
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          return MemberTileWidget(
            name: teamMembers[index].name ?? 'Name',
            photo: teamMembers[index].profilePicture,
            trailing: _getTrailingText(teamMembers[index], index),
            onTap: () {
              final currentTeamMemberId =
                  ref.read(currentTeamMemberNotifierProvider).teamMember?.id;
              final hasAccessToEdit =
                  ref.watch(permissionServiceProvider).hasAccessToEdit;
              if (currentTeamMemberId == teamMembers[index].id ||
                  !hasAccessToEdit) {
                context.pushNamed(
                  AppRoute.userProfileInfo.name,
                  queryParameters: {
                    'userId': teamMembers[index].userId,
                  },
                );
              } else {
                TeamMemberModal.show(
                  onSave: (model) {},
                  context: context,
                  teamMember: teamMembers[index],
                );
              }
            },
          );
        },
      ),
    );
  }

  String _getTrailingText(TeamMember member, int index) {
    if (member.inviteStatus == InviteStatus.pending) {
      return member.inviteStatus!.name;
    }
    return member.role?.title ?? 'Role';
  }
}
