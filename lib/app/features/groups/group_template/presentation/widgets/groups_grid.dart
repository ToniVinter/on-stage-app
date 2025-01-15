import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_template/application/group_template_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_template/presentation/widgets/group_template_card.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class GroupsTemplateGrid extends ConsumerWidget {
  const GroupsTemplateGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupTemplateState = ref.watch(groupTemplateNotifierProvider);
    final isLoading = groupTemplateState.isLoading;
    return LayoutBuilder(
      builder: (_, constraints) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getGridCount(constraints.maxWidth),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemCount: isLoading ? 2 : groupTemplateState.groups.length,
          itemBuilder: (_, index) {
            if (isLoading) {
              return _buildShimmerGroupCard(context);
            }
            final group = groupTemplateState.groups[index];
            return GroupTemplateCard(
              groupId: group.id,
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
