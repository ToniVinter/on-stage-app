import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/presentation/uninvited_people_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/positions/domain/position.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';

class PositionMembersCard extends ConsumerWidget {
  const PositionMembersCard({
    required this.position,
    required this.groupId,
    required this.eventId,
    required this.onTap,
    super.key,
  });

  final Position position;
  final String groupId;
  final String eventId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentEventStatus =
        ref.watch(eventNotifierProvider).event?.eventStatus;
    final stagersByPosition = ref.watch(
      eventNotifierProvider.select(
        (state) =>
            state.stagers.where((stager) => stager.positionId == position.id),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  position.name,
                  style: context.textTheme.titleMedium,
                ),
                if (ref.watch(permissionServiceProvider).hasAccessToEdit)
                  AddNewButton(
                    text: 'Add',
                    onPressed: () => _handleAddMembers(context, ref),
                  ),
              ],
            ),
          ),
          Divider(
            color: context.colorScheme.surfaceContainerHighest,
            thickness: 1,
            height: 0,
          ),
          if (stagersByPosition.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No members yet.',
                style: context.textTheme.titleMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: stagersByPosition.length,
                itemBuilder: (context, index) {
                  final stager = stagersByPosition.elementAt(index);
                  return ParticipantListingItem(
                    key: ValueKey(stager.id),
                    userId: stager.userId ?? '',
                    name: stager.name ?? '',
                    photo: stager.profilePicture ?? Uint8List(0),
                    status: currentEventStatus == EventStatus.published
                        ? stager.participationStatus
                        : null,
                    canEdit:
                        ref.watch(permissionServiceProvider).hasAccessToEdit,
                    onDelete: () {
                      ref
                          .read(eventNotifierProvider.notifier)
                          .removeStagerFromEvent(stager.id);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleAddMembers(BuildContext context, WidgetRef ref) async {
    final selectedMemberIds = await UninvitedPeopleModal.show(
      context: context,
      positionName: position.name,
      eventId: eventId,
    );

    if (!context.mounted) return;

    if (selectedMemberIds.isNotNullOrEmpty) {
      await ref.read(eventNotifierProvider.notifier).addStagersToEvent(
            selectedMemberIds!,
            position.id,
            groupId,
          );
    }
  }
}
