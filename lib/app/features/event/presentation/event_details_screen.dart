import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/event/presentation/create_rehearsal_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/invite_people_to_event_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/decline_event_invitation_modal.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
import 'package:on_stage_app/app/shared/rehearsal_tile.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventDetailsScreen extends ConsumerStatefulWidget {
  const EventDetailsScreen(this.eventId, {super.key});

  final String eventId;

  @override
  EventDetailsScreenState createState() => EventDetailsScreenState();
}

class EventDetailsScreenState extends ConsumerState<EventDetailsScreen>
    with TickerProviderStateMixin {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  bool _isPublishButtonLoading = false;
  bool _isPublishSuccess = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    ref.read(eventNotifierProvider.notifier).resetState();
    unawaited(
      ref.read(eventNotifierProvider.notifier).initEventById(widget.eventId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasEditorRoles = ref.watch(permissionServiceProvider).hasAccessToEdit;
    final stagers = ref.watch(eventNotifierProvider).stagers;
    final event = ref.watch(
      eventNotifierProvider.select((state) => state.event),
    );
    final rehearsals =
        ref.watch(eventNotifierProvider.select((state) => state.rehearsals));
    return Scaffold(
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: 'Event',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SettingsTrailingAppBarButton(
              rightPadding: 12,
              onTap: () {
                if (ref.watch(permissionServiceProvider).hasAccessToEdit) {
                  context.pushNamed(AppRoute.eventSettings.name);
                } else {
                  DeclineEventInvitationModal.show(
                    context: context,
                    onDeclineInvitation: () {
                      _onDeclineInvitation(context);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          ref.watch(permissionServiceProvider).hasAccessToEdit &&
                  event?.eventStatus == EventStatus.draft
              ? _buildFloatingButton()
              : null,
      body: Padding(
        padding: defaultScreenPadding,
        child: ListView(
          children: [
            _buildEnhancedEventTile(event, stagers),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: PreferencesActionTile(
                    title: 'Schedule',
                    color: context.colorScheme.primary,
                    leadingWidget: Icon(
                      LucideIcons.list_music,
                      color: context.colorScheme.primary,
                    ),
                    height: 54,
                    onTap: () {
                      context.pushNamed(
                        AppRoute.addEventSongs.name,
                        queryParameters: {
                          'eventId': widget.eventId,
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PreferencesActionTile(
                    title: 'Start Event',
                    color: Colors.white,
                    backgroundColor: const Color(0xFF40A54A),
                    leadingWidget: const Icon(
                      LucideIcons.circle_play,
                      color: Colors.white,
                    ),
                    height: 54,
                    onTap: () {
                      context.pushNamed(
                        AppRoute.songDetailsWithPages.name,
                        queryParameters: {
                          'eventId': widget.eventId,
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: Insets.medium),
            Text(
              'Rehearsals',
              style: context.textTheme.titleSmall,
            ),
            if (rehearsals.isNotEmpty)
              ...rehearsals.asMap().entries.map(
                (entry) {
                  final rehearsal = entry.value;

                  return RehearsalTile(
                    key: ValueKey(rehearsal.id),
                    onDelete: () {
                      ref
                          .read(eventNotifierProvider.notifier)
                          .deleteRehearsal(rehearsal.id!);

                      setState(() {
                        rehearsals.removeAt(entry.key);
                      });
                    },
                    title: rehearsal.name ?? '',
                    dateTime: rehearsal.dateTime ?? DateTime.now(),
                    onTap: () {
                      CreateRehearsalModal.show(
                        enabled: false,
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
            else if (!hasEditorRoles)
              Container(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'No rehearsals added',
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              ),
            if (hasEditorRoles) ...[
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
            ] else if (!hasEditorRoles)
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'No rehearsals added',
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              ),
            if (hasEditorRoles) ...[
              const SizedBox(height: Insets.smallNormal),
              _buildInvitePeopleButton(),
            ],
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  void _onDeclineInvitation(BuildContext context) {
    const stagerRequest = StagerRequest(
      participationStatus: StagerStatusEnum.DECLINED,
    );
    ref.read(eventNotifierProvider.notifier).updateStager(stagerRequest);
    context
      ..popDialog()
      ..pop();
  }

  Widget _buildEnhancedEventTile(EventModel? event, List<Stager> stagers) {
    return SizedBox(
      height: 174,
      child: EventTileEnhanced(
        title: event?.name ?? '',
        locationName: event?.location ?? '',
        dateTime: event?.dateTime ?? DateTime.now(),
        onTap: () {},
        participantsProfileBytes: stagers.map((e) => e.profilePicture).toList(),
        participantsCount: stagers.length,
        participantsName: stagers.isNotEmpty ? stagers[0].name ?? '' : '',
      ),
    );
  }

  Widget _buildFloatingButton() {
    return Padding(
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
    );
  }

  Widget _buildPublishButton(BuildContext context, StateSetter setState) {
    return ContinueButton(
      onPressed: _isPublishButtonLoading
          ? () {}
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
      isLoading: _isPublishButtonLoading,
      text: 'Publish Event',
      isEnabled: true,
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

  Widget _buildParticipantsList() {
    final stagers = ref.watch(eventNotifierProvider).stagers;
    final currentUserId = ref.watch(userNotifierProvider).currentUser?.id;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...stagers.map(
            (stager) => ParticipantListingItem(
              userId: stager.userId ?? '',
              canEdit: ref.watch(permissionServiceProvider).hasAccessToEdit &&
                  stager.userId != currentUserId,
              name: stager.name ?? '',
              photo: stager.profilePicture,
              status: stager.participationStatus,
              onDelete: () {
                ref
                    .read(eventNotifierProvider.notifier)
                    .removeStagerFromEvent(stager.id);
              },
            ),
          ),
        ],
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
          InvitePeopleToEventModal.show(
            context: context,
            onPressed: _addStagersToEvent,
            eventId: widget.eventId,
          );
        }
      },
      text: 'Invite People to Event',
      icon: Icons.add,
    );
  }

  void _addStagersToEvent() {
    ref.read(eventControllerProvider.notifier).resetAddedMembersToCache();
    ref.read(eventControllerProvider.notifier).addMembersToCache();
    ref.read(eventControllerProvider.notifier).resetSelectedMembersFromList();
    final addedTeamMembers = ref.read(eventControllerProvider).addedMembers;

    ref.read(eventNotifierProvider.notifier).addStagersToEvent(
          CreateStagersRequest(
            eventId: widget.eventId,
            teamMemberIds: addedTeamMembers.map((e) => e.id).toList(),
          ),
        );
  }
}
