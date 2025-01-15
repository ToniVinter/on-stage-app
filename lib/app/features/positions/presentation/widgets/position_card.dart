import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/positions/providers/position_card_provider.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PositionCard extends ConsumerStatefulWidget {
  const PositionCard({
    required this.positionId,
    required this.onTap,
    super.key,
  });

  final String positionId;
  final VoidCallback onTap;

  @override
  ConsumerState<PositionCard> createState() => _PositionCardState();
}

class _PositionCardState extends ConsumerState<PositionCard> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      final state = ref.read(positionCardProvider(widget.positionId));
      if (state.isEditing) {
        ref
            .read(positionCardProvider(widget.positionId).notifier)
            .stopEditingAndSave(_controller.text);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(positionCardProvider(widget.positionId));
    if (state.position == null) return const SizedBox();
    if (state.isEditing && _controller.text != state.position!.name) {
      _controller.text = state.position!.name;
      _focusNode.requestFocus();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: state.isEditing
                ? TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (value) => ref
                        .read(positionCardProvider(widget.positionId).notifier)
                        .stopEditingAndSave(value),
                  )
                : Text(
                    state.position!.name,
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
          ),
          AdaptiveMenuContext(
            items: [
              MenuAction(
                title: 'Rename',
                onTap: () => ref
                    .read(positionCardProvider(widget.positionId).notifier)
                    .startEditing(),
                icon: Icons.edit,
              ),
              MenuAction(
                title: 'Delete',
                onTap: () => ref
                    .read(positionCardProvider(widget.positionId).notifier)
                    .deletePosition(),
                icon: Icons.delete_outline,
                isDestructive: true,
              ),
            ],
            child: SizedBox(
              height: 30,
              width: 30,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: context.isDarkMode
                      ? const Color(0xFF43474E)
                      : context.colorScheme.surface,
                ),
                child: const Icon(
                  LucideIcons.ellipsis_vertical,
                  size: 15,
                  color: Color(0xFF8E9199),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
