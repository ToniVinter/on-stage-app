import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_type.dart';
import 'package:on_stage_app/app/shared/scrolling_play_effect.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.controller,
    required this.items,
    super.key,
  });

  final PageController controller;
  final List<EventItem> items;

  List<int> _getMomentIndexes() => List.generate(items.length, (i) => i)
      .where((i) => items[i].eventType == EventItemType.other)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: Center(
        child: IntrinsicWidth(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: context.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SmoothPageIndicator(
              controller: controller,
              count: items.length,
              effect: ScrollingPlayEffect(
                activeDotColor: Colors.blue,
                activeDotScale: 1.2,
                secondColorIndexes: _getMomentIndexes(),
                secondColor: context.colorScheme.onPrimaryFixedVariant,
                dotHeight: 15,
                dotWidth: 15,
                maxVisibleDots: 9,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
