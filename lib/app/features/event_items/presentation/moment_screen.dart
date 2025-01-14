import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event_items/presentation/controllers/moment_controller.dart';
import 'package:on_stage_app/app/features/event_items/presentation/controllers/moment_state.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class MomentScreen extends ConsumerStatefulWidget {
  const MomentScreen(this.eventItem, {super.key});

  final EventItem eventItem;

  @override
  ConsumerState<MomentScreen> createState() => _MomentScreenState();
}

class _MomentScreenState extends ConsumerState<MomentScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.eventItem.name);
    _descriptionController = TextEditingController(text: widget.eventItem.name);
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Stager? get assignedStager {
    if (widget.eventItem.leadVocals!.isNullOrEmpty) {
      return null;
    }
    return widget.eventItem.leadVocals!.first;
  }

  bool get _isEditingEnabled =>
      ref.watch(permissionServiceProvider).hasAccessToEdit &&
      ref.watch(momentControllerProvider(widget.eventItem)).isEditing;

  void _updateControllers(String title, String description) {
    if (_titleController.text != title) {
      _titleController.text = title;
    }
    if (_descriptionController.text != description) {
      _descriptionController.text = description;
    }
  }

  Widget _buildEditableDescription(BuildContext context) {
    ref.listen<MomentState>(
      momentControllerProvider(widget.eventItem),
      (previous, next) {
        final wasEditing = previous?.isEditing ?? false;
        final isEditing = next.isEditing;

        if (!wasEditing && isEditing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _descriptionFocusNode.requestFocus();
          });
        }
      },
    );

    return TextField(
      controller: _descriptionController,
      focusNode: _descriptionFocusNode,
      enabled: _isEditingEnabled,
      style: context.textTheme.bodyMedium!.copyWith(
        color: context.colorScheme.outline,
      ),
      minLines: 5,
      maxLines: 10,
      onChanged: (value) {
        ref
            .read(momentControllerProvider(widget.eventItem).notifier)
            .updateContent(_titleController.text, value);
      },
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        isDense: true,
        border: InputBorder.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(momentControllerProvider(widget.eventItem));
    final event = ref.watch(eventNotifierProvider).event;
    _updateControllers(state.title, state.description);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (assignedStager != null) ...[
              Center(
                child: ProfileImageWidget(
                  name: assignedStager!.name!,
                  size: 64,
                  photo: assignedStager!.profilePicture,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  assignedStager!.name!,
                  style: context.textTheme.titleMedium,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: assignedStager != null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Badge(
                  backgroundColor: context.colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  label: Text(
                    event?.dateTime != null
                        ? widget.eventItem.getTime(event!.dateTime!)
                        : '',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Badge(
                  backgroundColor: context.colorScheme.surface,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  label: Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        color: context.colorScheme.outline,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        TimeUtils().formatDuration(widget.eventItem.duration),
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            DashedLineDivider(
              color: context.colorScheme.primaryContainer,
              dashWidth: 1,
              dashSpace: 8,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              style: context.textTheme.headlineLarge,
              enabled: _isEditingEnabled,
              onChanged: (value) {
                ref
                    .read(momentControllerProvider(widget.eventItem).notifier)
                    .updateContent(value, _descriptionController.text);
              },
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 12),
            _buildEditableDescription(context),
          ],
        ),
      ),
    );
  }
}
