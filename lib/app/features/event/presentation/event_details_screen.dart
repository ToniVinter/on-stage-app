import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/presentation/add_participants_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/create_rehearsal_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/rehearsal_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventDetailsScreen extends ConsumerStatefulWidget {
  const EventDetailsScreen(this.eventId, {super.key});

  final String eventId;

  @override
  EventDetailsScreenState createState() => EventDetailsScreenState();
}

class EventDetailsScreenState extends ConsumerState<EventDetailsScreen> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final _isAdmin = true;
  bool _isPublishButtonLoading = false;
  bool _isPublishSuccess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(
      eventNotifierProvider.select((state) => state.event),
    );
    final rehearsals =
        ref.watch(eventNotifierProvider.select((state) => state.rehearsals));
    final stagers =
        ref.watch(eventNotifierProvider.select((state) => state.stagers));
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: event?.eventStatus == EventStatus.draft
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.surface,
                          blurRadius: 30,
                          spreadRadius: 35,
                          offset: const Offset(0, 24),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _isPublishSuccess
                          ? _buildSuccessButton(context)
                          : _buildPublishButton(context, setState),
                    ),
                  );
                },
              ),
            )
          : null,
      body: _buildBody(event, context, rehearsals, stagers),
    );
  }

  Widget _buildPublishButton(BuildContext context, StateSetter setState) {
    return TextButton(
      key: const ValueKey('publish'),
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 54)),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        backgroundColor: WidgetStateProperty.all(context.colorScheme.primary),
      ),
      onPressed: _isPublishButtonLoading
          ? null
          : () async {
              setState(() {
                _isPublishButtonLoading = true;
              });
              await ref.read(eventNotifierProvider.notifier).publishEvent();
              setState(() {
                _isPublishButtonLoading = false;
                _isPublishSuccess = true;
              });
              _updateEventsAfterPublishing();
            },
      child: _isPublishButtonLoading
          ? const SizedBox(
              height: 24,
              child: LoadingIndicator(
                colors: [Colors.white],
                indicatorType: Indicator.lineSpinFadeLoader,
              ),
            )
          : Text(
              'Publish Event',
              style: context.textTheme.titleMedium!.copyWith(
                color: context.colorScheme.onPrimary,
              ),
            ),
    );
  }

  void _updateEventsAfterPublishing() {
    unawaited(
      ref
          .read(eventNotifierProvider.notifier)
          .getEventById(widget.eventId)
          .then((_) {
        final updatedEvent = ref.read(eventNotifierProvider).event;
        if (updatedEvent?.eventStatus == EventStatus.published) {
          setState(() {
            _isPublishSuccess = false;
          });
        }
      }),
    );
    unawaited(ref.read(eventsNotifierProvider.notifier).getUpcomingEvents());
    unawaited(ref.read(eventsNotifierProvider.notifier).getUpcomingEvent());
  }

  Widget _buildSuccessButton(BuildContext context) {
    return Container(
      key: const ValueKey('success'),
      height: 54,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.check, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildBody(
    EventModel? event,
    BuildContext context,
    List<RehearsalModel> rehearsals,
    List<Stager> stagers,
  ) {
    print('EventDetailsScreenState: _buildBody');
    return ref.watch(eventNotifierProvider).isLoading
        ? const OnStageLoadingIndicator()
        : Padding(
            padding: defaultScreenPadding,
            child: ListView(
              children: [
                SizedBox(
                  height: 174,
                  child: EventTileEnhanced(
                    title: event?.name ?? '',
                    locationName: event?.location ?? '',
                    dateTime: event?.dateTime ?? DateTime.now(),
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: Insets.medium),
                Text(
                  'Rehearsals',
                  style: context.textTheme.titleSmall,
                ),
                if (rehearsals.isNotEmpty)
                  ...rehearsals.map(
                    (rehearsal) {
                      return RehearsalTile(
                        onDelete: () {
                          ref
                              .read(eventNotifierProvider.notifier)
                              .deleteRehearsal(rehearsal.id!);
                        },
                        title: rehearsal.name ?? '',
                        dateTime: rehearsal.dateTime ?? DateTime.now(),
                        onTap: () {
                          CreateRehearsalModal.show(
                            context: context,
                            rehearsal: rehearsal,
                            onRehearsalCreated: (RehearsalModel rehearsal) {
                              ref
                                  .read(eventNotifierProvider.notifier)
                                  .updateRehearsal(rehearsal);
                            },
                          );
                        },
                      );
                    },
                  )
                else if (!_isAdmin)
                  Container(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'No rehearsals added',
                      style: context.textTheme.titleSmall!.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ),
                if (_isAdmin) ...[
                  const SizedBox(height: Insets.extraSmall),
                  _buildCreateRehearsalButton(),
                ],
                const SizedBox(height: Insets.medium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Participants',
                      style: context.textTheme.titleSmall,
                    ),
                    Text(
                      ref
                          .watch(eventControllerProvider.notifier)
                          .getAcceptedInviteesLabel(),
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                if (stagers.isNotEmpty) ...[
                  const SizedBox(height: Insets.smallNormal),
                  _buildParticipantsList(),
                ] else if (!_isAdmin)
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'No rehearsals added',
                      style: context.textTheme.titleSmall!.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ),
                if (_isAdmin) ...[
                  const SizedBox(height: Insets.smallNormal),
                  _buildInvitePeopleButton(),
                ],
                const SizedBox(height: 120),
              ],
            ),
          );
  }

  Widget _buildParticipantsList() {
    final stagers = ref.read(eventNotifierProvider).stagers;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: stagers.length,
        itemBuilder: (context, index) {
          return ParticipantListingItem(
            name: stagers[index].name ?? '',
            assetPath: 'assets/images/profile1.png',
            status: stagers[index].participationStatus!,
            onDelete: () {
              ref
                  .read(eventNotifierProvider.notifier)
                  .removeStagerFromEvent(stagers[index].id);
            },
          );
        },
      ),
    );
  }

  Widget _buildCreateRehearsalButton() {
    return EventActionButton(
      onTap: () {
        CreateRehearsalModal.show(
          context: context,
          onRehearsalCreated: (RehearsalModel rehearsal) {
            ref.read(eventNotifierProvider.notifier).addRehearsal(rehearsal);
          },
        );
      },
      text: 'Create new Rehearsal',
      icon: Icons.add,
    );
  }

  Widget _buildInvitePeopleButton() {
    return EventActionButton(
      onTap: () {
        if (mounted) {
          AddParticipantsScreen.show(
            context: context,
            onPressed: _addStagersToEvent,
            eventId: widget.eventId,
          );
        }
      },
      text: 'Invite People',
      icon: Icons.add,
    );
  }

  void _addStagersToEvent() {
    final addedUsers = ref.read(eventControllerProvider).addedUsers;

    ref.read(eventNotifierProvider.notifier).addStagerToEvent(
          CreateStagerRequest(
            eventId: widget.eventId,
            userIds: addedUsers.map((e) => e.id).toList(),
          ),
        );
  }
}
