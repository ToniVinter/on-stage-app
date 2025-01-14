import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event_items/presentation/add_edit_moment_modal.dart';
import 'package:on_stage_app/app/features/event_items/presentation/controllers/moment_controller.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class MomentSettings extends ConsumerWidget {
  const MomentSettings({
    required this.moment,
    super.key,
  });

  final EventItem moment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(momentControllerProvider(moment).notifier);
    final isEditing = ref.watch(momentControllerProvider(moment)).isEditing;
    final hasEditorRights =
        ref.watch(permissionServiceProvider).hasAccessToEdit;
    if (!hasEditorRights) return const SizedBox();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: controller.toggleEditing,
            overlayColor:
                WidgetStatePropertyAll(context.colorScheme.surfaceBright),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isEditing
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Icon(
                  isEditing ? LucideIcons.save : LucideIcons.pencil,
                  key: ValueKey(isEditing),
                  size: 16,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
        SettingsTrailingAppBarButton(
          onTap: () {
            AddEditMomentModal.show(
              eventItem: moment,
              context: context,
            );
          },
        )
      ],
    );
  }
}
