import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/assigned_persons.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventItemTile extends StatefulWidget {
  const EventItemTile({
    required this.name,
    required this.artist,
    required this.songKey,
    required this.isSong,
    required this.isAdmin,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final String name;
  final String artist;
  final String songKey;
  final bool isSong;
  final void Function()? onTap;
  final void Function()? onDelete;
  final bool isAdmin;

  @override
  _EventItemTileState createState() => _EventItemTileState();
}

class _EventItemTileState extends State<EventItemTile> {
  bool isSliding = false;

  void _setSliding(bool sliding) {
    setState(() {
      isSliding = sliding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(8),
      highlightColor: Theme.of(context).colorScheme.surfaceBright,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Slidable(
          key: ValueKey(widget.name),
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
                  color: widget.isSong
                      ? context.colorScheme.onSurfaceVariant
                      : context.colorScheme.tertiary,
                  borderRadius: isSliding
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        )
                      : BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.isSong
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: context.textTheme.titleMedium!.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          if (!widget.isSong) ...[
                            // if(description.isNotEmpty)
                            _buildDescription(context),
                          ],
                          if (widget.isSong) ...[
                            _buildSongDetails(context),
                          ],
                          // if(stagers.isNotEmpty)
                          AssignedPersons(
                            isSong: widget.isSong,
                            stagers: const [
                              Stager(
                                id: '1',
                                name: 'Timotei Popescu',
                                profilePicture: null,
                                participationStatus: null,
                                userId: '1',
                              ),
                              Stager(
                                id: '1',
                                name: 'Ana Basescu',
                                profilePicture: null,
                                participationStatus: null,
                                userId: '1',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Badge(
                          label: Text(
                            '12:05',
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.outline,
                            ),
                          ),
                          backgroundColor: context.colorScheme.surface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
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
      'Descriere vine aici sub title',
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
            vertical: 4,
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
    } else if (widget.isSong) {
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
