import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event/presentation/widgets/group_event_card.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class GroupsEventGrid extends ConsumerWidget {
  const GroupsEventGrid({
    required this.eventId,
    super.key,
  });

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(groupEventNotifierProvider);

    return LayoutBuilder(
      builder: (_, constraints) {
        print('maxWidth: ${constraints.maxWidth}');
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getGridCount(constraints.maxWidth),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemCount: groupState.isLoading ? 2 : groupState.groupEvents.length,
          itemBuilder: (_, index) {
            if (groupState.isLoading) return _buildShimmerGroupCard(context);
            final group = groupState.groupEvents.elementAt(index);
            return GroupEventCard(
              groupId: group.id,
              eventId: eventId,
            );
          },
        );
      },
    );
  }
}

int getGridCount(double maxWidth) {
  if (maxWidth > 800) return 4;
  if (maxWidth > 600) return 3;
  return 2;
}

Widget _buildShimmerGroupCard(BuildContext context) {
  return SizedBox(
    height: 200,
    width: 200,
    child: Shimmer.fromColors(
      baseColor: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
      highlightColor: context.colorScheme.onSurfaceVariant,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
