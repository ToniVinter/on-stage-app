import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';
import 'package:on_stage_app/app/features/positions/presentation/position_members_modal.dart';
import 'package:on_stage_app/app/shared/square_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class GroupEventCard extends ConsumerStatefulWidget {
  const GroupEventCard({
    required this.groupId,
    required this.eventId,
    this.onTap,
    super.key,
  });

  final String groupId;
  final String eventId;
  final VoidCallback? onTap;

  @override
  ConsumerState<GroupEventCard> createState() => _GroupEventCardState();
}

class _GroupEventCardState extends ConsumerState<GroupEventCard> {
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
    GroupEvent group;

    group = ref.watch(groupEventNotifierProvider).groupEvents.firstWhere(
          (group) => group.id == widget.groupId,
          orElse: () => throw StateError('Group not found: ${widget.groupId}'),
        );

    return Card(
      margin: const EdgeInsets.all(6),
      color: context.colorScheme.onSurfaceVariant,
      elevation: 0,
      // Flat design
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _doActionOnTap(context),
        overlayColor:
            WidgetStateProperty.all(context.colorScheme.surfaceBright),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (group.membersCount > 0)
                    Expanded(
                      child: ParticipantsOnTile(
                        participantsLength: group.membersCount,
                        textColor: Colors.white,
                        participantsProfileName: const [],
                        useRandomColors: true,
                        participantsMax: 5,
                      ),
                    )
                  else
                    SquareIconButton(
                      icon: LucideIcons.plus,
                      onPressed: () => _doActionOnTap(context),
                      backgroundColor: context.isDarkMode
                          ? const Color(0xFF43474E)
                          : context.colorScheme.surface,
                    ),
                ],
              ),
              const Spacer(),
              Text(
                group.name,
                style: context.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              _buildSubtitle(group, context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _doActionOnTap(BuildContext context) async {
    await PositionMembersModal.show(
      context: context,
      groupId: widget.groupId,
      eventId: widget.eventId,
    );
    unawaited(
      ref
          .read(groupEventNotifierProvider.notifier)
          .getGroupEventById(widget.eventId, widget.groupId),
    );
  }

  Widget _buildSubtitle(GroupEvent group, BuildContext context) {
    var subtitle = '${group.membersCount} Members';
    final currentEvent = ref.watch(eventNotifierProvider).event;

    if (currentEvent?.eventStatus == EventStatus.published &&
        group.membersCount > 0) {
      subtitle = '${group.confirmedCount}/${group.membersCount} Confirmed';
    }
    return Text(
      subtitle,
      style: context.textTheme.bodyMedium!
          .copyWith(color: context.colorScheme.outline),
    );
  }
}
