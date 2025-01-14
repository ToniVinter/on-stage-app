import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/assigned_persons.dart';
import 'package:on_stage_app/app/shared/adaptive_duration_picker.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class EventItemTile extends ConsumerStatefulWidget {
  const EventItemTile({
    required this.eventItem,
    required this.artist,
    required this.songKey,
    required this.isAdmin,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final EventItem eventItem;
  final String artist;
  final String songKey;
  final void Function()? onTap;
  final void Function()? onDelete;
  final bool isAdmin;

  @override
  EventItemTileState createState() => EventItemTileState();
}

class EventItemTileState extends ConsumerState<EventItemTile> {
  bool isSliding = false;

  void _setSliding(bool sliding) {
    setState(() {
      isSliding = sliding;
    });
  }

  bool get isSong => widget.eventItem.song?.id != null;

  @override
  Widget build(BuildContext context) {
    final eventStartDate = ref.watch(eventNotifierProvider).event?.dateTime;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(8),
      highlightColor: Theme.of(context).colorScheme.surfaceBright,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Slidable(
          key: ValueKey(widget.eventItem.name),
          endActionPane: widget.isAdmin ? _buildActionPane(context) : null,
          child: Builder(
            builder: (context) {
              final controller = Slidable.of(context);
              if (controller != null) {
                Slidable.of(context)!.actionPaneType.addListener(() {
                  if (Slidable.of(context)!.actionPaneType.value ==
                      ActionPaneType.none) {
                    _setSliding(false);
                  } else {
                    _setSliding(true);
                  }
                });
              }
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: widget.eventItem.song?.id != null
                      ? context.colorScheme.onSurfaceVariant
                      : context.colorScheme.tertiary,
                  borderRadius: isSliding
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        )
                      : BorderRadius.circular(8),
                  border: Border.all(
                    color: isSong
                        ? context.colorScheme.onSurfaceVariant
                        : context.colorScheme.tertiary,
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _buildIcon(),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.eventItem.name ?? '',
                              style: context.textTheme.titleMedium!.copyWith(
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                            if (!isSong &&
                                widget.eventItem.description
                                    .isNotNullEmptyOrWhitespace) ...[
                              _buildDescription(context),
                            ],
                            if (isSong) ...[
                              _buildSongDetails(context),
                            ],
                            if (widget.eventItem.leadVocals.isNotNullOrEmpty)
                              AssignedPersons(
                                isSong: isSong,
                                stagers: widget.eventItem.leadVocals!
                                    .map(
                                      (e) => Stager(
                                        id: e.id,
                                        name: e.name,
                                        profilePicture: e.profilePicture,
                                        participationStatus:
                                            e.participationStatus,
                                        userId: e.userId,
                                      ),
                                    )
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Material(
                          color: context.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            overlayColor: WidgetStateProperty.all(
                              context.colorScheme.surfaceBright,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => AdaptiveDurationPicker.show(
                              context: context,
                              initialDuration: Duration.zero,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: context.colorScheme.outline,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                widget.eventItem
                                    .getTime(eventStartDate ?? DateTime.now()),
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: context.colorScheme.outline,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      'fsfgdfdasfhsbf dfasjkhfb sdf sadf ajhb ',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: context.textTheme.bodyMedium!
          .copyWith(color: context.colorScheme.outline),
    );
  }

  Widget _buildSongDetails(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.artist,
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 1,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.songKey,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }

  Icon _buildIcon() {
    if (widget.isAdmin) {
      return const Icon(
        Icons.drag_indicator_rounded,
        color: Color(0xFF828282),
        size: 20,
      );
    } else if (isSong) {
      return Icon(
        Icons.music_note_rounded,
        color: context.colorScheme.error,
        size: 20,
      );
    } else {
      return Icon(
        Icons.mic,
        color: context.colorScheme.primary,
        size: 20,
      );
    }
  }

  ActionPane _buildActionPane(BuildContext context) {
    return ActionPane(
      extentRatio: 0.3,
      dragDismissible: false,
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(onDismissed: () {}),
      children: [
        Expanded(
          child: InkWell(
            onTap: widget.onDelete,
            child: Container(
              height: double.infinity,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style:
                    context.textTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
