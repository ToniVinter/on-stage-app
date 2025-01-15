import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/event_shimmer_list.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/events_content.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/events_search_bar.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/search_result_list.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/stage_tooltip/stage_tooltip.dart';
import 'package:on_stage_app/app/features/subscription/presentation/paywall_modal.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/features/user_settings/domain/user_settings.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:sliver_tools/sliver_tools.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends ConsumerState<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;
  final GlobalKey<StageTooltipState> _createEventTooltipKey =
      GlobalKey<StageTooltipState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeEvents();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted &&
            ref.read(userSettingsNotifierProvider).isCreateEventTooltipShown ==
                false) {
          //TODO: See if it's needed
          // _createEventTooltipKey.currentState?.showTooltip();
        }
      });
    });
  }

  Future<void> _initializeEvents() async {
    _searchFocusNode.addListener(_onSearchFocusChange);
    unawaited(
      Future.wait([
        ref.read(eventsNotifierProvider.notifier).getUpcomingEvents(),
        ref.read(eventsNotifierProvider.notifier).getPastEvents(),
        ref.read(eventsNotifierProvider.notifier).getUpcomingEvent(),
      ]),
    );
  }

  void _onSearchFocusChange() {
    setState(() {
      _isSearchFocused =
          _searchFocusNode.hasFocus || _searchController.text.isNotEmpty;
    });
    if (_isSearchFocused && _searchController.text.isEmpty) {
      ref.read(eventsNotifierProvider.notifier).searchEvents('');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventsNotifierProvider);

    return Scaffold(
      appBar: StageAppBar(
        title: 'Events',
        trailing: ref.watch(permissionServiceProvider).hasAccessToEdit
            ? _buildTrailingButton(context)
            : const SizedBox(),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _initializeEvents,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            EventsSearchBar(
              focusNode: _searchFocusNode,
              controller: _searchController,
              notifier: ref.read(eventsNotifierProvider.notifier),
            ),
            if (eventsState.isLoading && !_isSearchFocused)
              const EventShimmerList()
            else
              SliverAnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isSearchFocused
                    ? SearchResultsList(
                        key: const ValueKey('search'),
                        events: eventsState.filteredEventsResponse.events,
                      )
                    : const EventsContent(
                        key: ValueKey('content'),
                      ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingButton(BuildContext context) {
    final userSettingsNotifier = ref.watch(userSettingsNotifierProvider);
    return Container(
      padding: const EdgeInsets.only(right: 12),
      child: StageTooltip(
        message: 'Add your first Event',
        key: _createEventTooltipKey,
        child: IconButton(
          style: IconButton.styleFrom(
            visualDensity: VisualDensity.compact,
            highlightColor: context.colorScheme.surfaceBright,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
          onPressed: () async {
            if (userSettingsNotifier.isCreateEventTooltipShown == false) {
              _disableTooltip();
            }
//TODO: implement new method for permission
            if (ref.watch(permissionServiceProvider).canAddEvents) {
              await ref.read(eventNotifierProvider.notifier).createEmptyEvent();
              if (mounted) {
                unawaited(context.pushNamed(AppRoute.addEvent.name));
              }
            } else {
              PaywallModal.show(
                context: context,
                permissionType: PermissionType.addEvents,
              );
            }
          },
          icon: Icon(Icons.add, color: context.colorScheme.surfaceDim),
        ),
      ),
    );
  }

  void _disableTooltip() {
    _createEventTooltipKey.currentState?.hideTooltip();
    ref.read(userSettingsNotifierProvider.notifier).updateUserSettings(
          const UserSettings(
            isCreateEventTooltipShown: true,
          ),
        );
  }
}
