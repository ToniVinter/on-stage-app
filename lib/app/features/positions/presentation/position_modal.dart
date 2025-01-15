import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_template/application/group_template_notifier.dart';
import 'package:on_stage_app/app/features/positions/application/position_notifier.dart';
import 'package:on_stage_app/app/features/positions/application/position_state.dart';
import 'package:on_stage_app/app/features/positions/presentation/widgets/create_position_modal.dart';
import 'package:on_stage_app/app/features/positions/presentation/widgets/position_card.dart';
import 'package:on_stage_app/app/features/positions/presentation/widgets/position_tile_shimmer.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PositionModal extends ConsumerStatefulWidget {
  const PositionModal({
    required this.groupId,
    super.key,
  });

  final String groupId;

  static Future<void> show({
    required BuildContext context,
    required String groupId,
  }) async {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.95,
        minHeight: MediaQuery.of(context).size.height * 0.95,
        maxWidth: context.isLargeScreen
            ? context.screenSize.width * 0.5
            : double.infinity,
      ),
      context: context,
      builder: (context) => PositionModal(groupId: groupId),
    );
  }

  @override
  ConsumerState<PositionModal> createState() => _PositionModalState();
}

class _PositionModalState extends ConsumerState<PositionModal> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(positionNotifierProvider.notifier).getPositions(widget.groupId);
    });
  }

  void _setupErrorListener() {
    ref.listen<PositionState>(
      positionNotifierProvider,
      (previous, next) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (next.error != null && mounted) {
            TopFlushBar.show(
              context,
              next.error ?? 'Error inviting team member',
              isError: true,
            );
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _setupErrorListener();

    return NestedScrollModal(
      buildHeader: () => _buildHeader(context),
      headerHeight: () => 64,
      footerHeight: () => 64,
      buildContent: () => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final positionState = ref.watch(positionNotifierProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Positions',
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          _getContent(positionState),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _getContent(PositionState positionState) {
    if (positionState.isLoading) {
      return const PositionTileShimmer();
    } else {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: positionState.positions.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: EventActionButton(
                onTap: () {
                  CreatePositionModal.show(
                    context: context,
                    groupId: widget.groupId,
                  );
                },
                text: 'New Position',
                icon: Icons.add,
              ),
            );
          }
          final position = positionState.positions[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PositionCard(
              positionId: position.id,
              onTap: () {},
            ),
          );
        },
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    final group = ref.watch(groupTemplateNotifierProvider).groups.firstWhere(
          (group) => group.id == widget.groupId,
        );
    return ModalHeader(
      title: group.name,
    );
  }
}
