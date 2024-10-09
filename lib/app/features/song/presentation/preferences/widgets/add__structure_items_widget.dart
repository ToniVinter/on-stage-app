import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddStructureItemsWidget extends ConsumerStatefulWidget {
  const AddStructureItemsWidget({super.key});

  @override
  AddStructureItemsWidgetState createState() => AddStructureItemsWidgetState();
}

class AddStructureItemsWidgetState
    extends ConsumerState<AddStructureItemsWidget> {
  List<StructureItem> _originalStructureItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _originalStructureItems =
            ref.read(songNotifierProvider).song.availableStructureItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _originalStructureItems.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (_isItemChecked(index)) {
                      ref
                          .read(songPreferencesControllerProvider.notifier)
                          .removeStructureItem(
                            _originalStructureItems[index],
                          );
                    } else {
                      ref
                          .read(songPreferencesControllerProvider.notifier)
                          .addStructureItem(
                            _originalStructureItems[index],
                          );
                    }
                  });
                },
                child: Container(
                  height: 52,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: context.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isItemChecked(index)
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurfaceVariant,
                      width: 1.6,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        key: ValueKey(
                          _originalStructureItems[index].index,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.onSurfaceVariant,
                          border: Border.all(
                            color: Color(
                              _originalStructureItems[index].color,
                            ),
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          _originalStructureItems[index].shortName,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          _originalStructureItems[index].name,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          _isItemChecked(index)
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          size: 20,
                          color: _isItemChecked(index)
                              ? context.colorScheme.primary
                              : context.colorScheme.surfaceBright,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isItemChecked(int index) =>
      ref.watch(songPreferencesControllerProvider).structureItems.contains(
            _originalStructureItems[index],
          );
}
