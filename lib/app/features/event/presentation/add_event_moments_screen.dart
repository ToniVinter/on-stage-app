import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/presentation/add_items_to_event_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/moment_event_item_tile.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

final hasChangesProvider = StateProvider.autoDispose<bool>((ref) => false);

class AddEventMomentsScreen extends ConsumerStatefulWidget {
  const AddEventMomentsScreen({
    required this.eventId,
    this.onSave,
    super.key,
  });

  final String eventId;
  final void Function()? onSave;

  @override
  AddEventMomentsScreenState createState() => AddEventMomentsScreenState();
}

class AddEventMomentsScreenState extends ConsumerState<AddEventMomentsScreen> {
  bool _areEventItemsLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestEventItems();
    });
    super.initState();
  }

  Future<void> _requestEventItems() async {
    setState(() {
      _areEventItemsLoading = true;
    });
    await ref
        .read(eventItemsNotifierProvider.notifier)
        .getEventItems(widget.eventId);

    setState(() {
      _areEventItemsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventItemsState = ref.watch(eventItemsNotifierProvider);
    final hasEditorRights =
        ref.watch(permissionServiceProvider).hasAccessToEdit;

    return Scaffold(
      appBar: const StageAppBar(
        title: 'Schedule',
        isBackButtonVisible: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: hasEditorRights ? _buildSaveButton() : null,
      body: RefreshIndicator.adaptive(
        onRefresh: _requestEventItems,
        child: Padding(
          padding: defaultScreenPadding,
          child: _areEventItemsLoading
              ? _buildShimmerList()
              : hasEditorRights
                  ? _buildReordableList(eventItemsState.eventItems)
                  : eventItemsState.eventItems.isNotEmpty
                      ? _buildStaticList(eventItemsState.eventItems)
                      : const Center(
                          child: Text('No items added yet'),
                        ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Shimmer.fromColors(
          baseColor: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
          highlightColor: context.colorScheme.onSurfaceVariant,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final hasChanges = ref.watch(hasChangesProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ContinueButton(
        text: 'Save Changes',
        onPressed: hasChanges ? _createEventItemList : () {},
        isEnabled: hasChanges,
      ),
    );
  }

  void _createEventItemList() {
    final eventItems = ref.read(eventItemsNotifierProvider).eventItems;
    ref
        .read(eventItemsNotifierProvider.notifier)
        .addEventItems(eventItems, widget.eventId);

    widget.onSave?.call();
    ref.read(hasChangesProvider.notifier).state = false;
  }

  Widget _buildStaticList(List<EventItem> eventItems) {
    return ListView.builder(
      itemCount: eventItems.length,
      itemBuilder: (context, index) =>
          _buildEventItemTile(eventItems[index], isStatic: true),
    );
  }

  Widget _buildReordableList(List<EventItem> eventItems) {
    return ReorderableListView.builder(
      proxyDecorator: _proxyDecorator,
      itemCount: eventItems.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) => _buildEventItemTile(eventItems[index]),
      footer: ref.watch(permissionServiceProvider).hasAccessToEdit
          ? _buildAddSongsOrMomentsButton()
          : const SizedBox(height: 100),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final animValue = Curves.easeIn.transform(animation.value);
        final scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Card(
            color: context.colorScheme.surface.withOpacity(0.2),
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.2),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    ref
        .read(eventItemsNotifierProvider.notifier)
        .changeOrderCache(oldIndex, newIndex);
    ref.read(hasChangesProvider.notifier).state = true;
  }

  Widget _buildEventItemTile(EventItem eventItem, {bool isStatic = false}) {
    final hasChanges = ref.watch(hasChangesProvider);
    return EventItemTile(
      key: ValueKey(eventItem.hashCode),
      eventItem: eventItem,
      artist: eventItem.song?.artist?.name ?? '',
      songKey: eventItem.song?.key?.name ?? '',
      onDelete: isStatic
          ? null
          : () {
              ref
                  .read(eventItemsNotifierProvider.notifier)
                  .removeEventItemCache(eventItem);
              ref.read(hasChangesProvider.notifier).state = true;
            },
      onTap: hasChanges
          ? null
          : () {
              final eventItems =
                  ref.read(eventItemsNotifierProvider).eventItems;
              ref
                  .read(eventItemsNotifierProvider.notifier)
                  .setCurrentIndex(eventItems.indexOf(eventItem));

              context.pushNamed(
                AppRoute.eventItemsWithPages.name,
                queryParameters: {
                  'eventId': widget.eventId,
                },
              );
            },
      isAdmin: ref.watch(permissionServiceProvider).hasAccessToEdit,
    );
  }

  Widget _buildAddSongsOrMomentsButton() {
    return Column(
      children: [
        EventActionButton(
          onTap: () => AddItemsToEventModal.show(
            context: context,
            onItemsAdded: () =>
                ref.read(hasChangesProvider.notifier).state = true,
          ),
          text: 'Add Songs or Moments',
          icon: Icons.add,
        ),
        const SizedBox(height: 160),
      ],
    );
  }
}
