import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/reordable_list_item.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ReorderListWidget extends ConsumerStatefulWidget {
  const ReorderListWidget({super.key});

  @override
  OrderStructureItemsWidgetState createState() =>
      OrderStructureItemsWidgetState();
}

class OrderStructureItemsWidgetState extends ConsumerState<ReorderListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasEditorsRight =
        ref.watch(permissionServiceProvider).hasAccessToEdit;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          if (hasEditorsRight) _buildReorderableList() else _buildList(),
          const SizedBox(height: 42),
        ],
      ),
    );
  }

  Widget _buildList() {
    final cacheStructureItems =
        ref.watch(songPreferencesControllerProvider).structureItems.toList();
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cacheStructureItems.length,
      itemBuilder: (context, index) {
        return ReordableListItem(
          canSlide: false,
          itemKey: '${cacheStructureItems[index].shortName}_$index',
          itemId: cacheStructureItems[index].index,
          color: cacheStructureItems[index].color,
          shortName: cacheStructureItems[index].shortName,
          name: cacheStructureItems[index].name,
        );
      },
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

  Widget _buildReorderableList() {
    final cacheStructureItems =
        ref.watch(songPreferencesControllerProvider).structureItems.toList();
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      onReorder: _onReorder,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cacheStructureItems.length,
      proxyDecorator: _proxyDecorator,
      itemBuilder: (context, index) {
        return MyDragStartListener(
          key: ValueKey('${cacheStructureItems[index].shortName}_$index'),
          index: index,
          child: ClipRect(
            child: ReordableListItem(
              itemKey: '${cacheStructureItems[index].shortName}_$index',
              itemId: cacheStructureItems[index].index,
              color: cacheStructureItems[index].color,
              shortName: cacheStructureItems[index].shortName,
              name: cacheStructureItems[index].name,
              onRemove: () {
                ref
                    .read(songPreferencesControllerProvider.notifier)
                    .removeStructureItem(index);
              },
              onClone: () {
                ref
                    .read(songPreferencesControllerProvider.notifier)
                    .addStructureItem(cacheStructureItems[index]);
              },
            ),
          ),
        );
      },
    );
  }

  void _onReorder(int oldIndex, int index) {
    final cacheStructureItems =
        ref.watch(songPreferencesControllerProvider).structureItems.toList();
    var newIndex = index;
    if (newIndex > oldIndex) {
      newIndex = newIndex - 1;
    }

    setState(() {
      final old = cacheStructureItems.removeAt(oldIndex);
      cacheStructureItems.insert(newIndex, old);
    });

    ref
        .read(songPreferencesControllerProvider.notifier)
        .addAllStructureItems(cacheStructureItems);
  }
}

class MyDragStartListener extends ReorderableDelayedDragStartListener {
  const MyDragStartListener({
    required super.child,
    required super.index,
    super.key,
    super.enabled,
  });

  @override
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(
      delay: const Duration(milliseconds: 250),
      debugOwner: this,
    );
  }
}
