import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/member_tile.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TeamMemberModal extends ConsumerStatefulWidget {
  const TeamMemberModal({
    this.onSave,
    super.key,
  });

  final void Function(RehearsalModel)? onSave;

  @override
  TeamMemberModalState createState() => TeamMemberModalState();

  static void show({
    required BuildContext context,
    void Function(RehearsalModel)? onSave,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Team Member'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: TeamMemberModal(
              onSave: onSave,
            ),
          ),
        ),
      ),
    );
  }
}

class TeamMemberModalState extends ConsumerState<TeamMemberModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: MemberTileWidget(
              name: 'Ionut Petrescu',
              trailing: 'Pian',
              photo: 'assets/images/profile1.png',
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: MemberTileWidget(
              name: 'Change permissions',
              trailing: 'Member',
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Remove member',
              style: context.textTheme.titleMedium!
                  .copyWith(color: context.colorScheme.error),
            ),
          ),
          const SizedBox(height: 64),
          ContinueButton(
            text: 'Save Edit',
            onPressed: () {},
            isEnabled: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}