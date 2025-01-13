import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class MomentScreen extends ConsumerStatefulWidget {
  const MomentScreen({super.key});

  @override
  ConsumerState<MomentScreen> createState() => _MomentScreenState();
}

class _MomentScreenState extends ConsumerState<MomentScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Rugaciune');
    _descriptionController = TextEditingController(
      text:
          'Descriere marturia lui X, Rugaciune pentru orfelinat si binecuvantare.',
    );
    _descriptionFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _descriptionFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildEditableDescription(BuildContext context) {
    //add a edit toggle on appbar
    final isEditingEnabled =
        ref.watch(permissionServiceProvider).hasAccessToEdit;
    return GestureDetector(
      child: isEditingEnabled
          ? TextField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.outline,
              ),
              maxLines: 10,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: InputBorder.none,
              ),
            )
          : Text(
              _descriptionController.text.isEmpty
                  ? 'Double tap to add description'
                  : _descriptionController.text,
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditingEnabled =
        ref.watch(permissionServiceProvider).hasAccessToEdit;
    return Scaffold(
      appBar: const StageAppBar(
        title: 'Moments',
        isBackButtonVisible: true,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: 100,
          ),
          //lucide ellipsis with native context menu edit tile, edit description -> focus on that textfield, ezz
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
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
              const Center(
                child: ProfileImageWidget(
                  name: 'Timotei Geroge',
                  size: 64,
                  photo: null,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Timotei George',
                  style: context.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Badge(
                    backgroundColor: context.colorScheme.secondary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    label: Text(
                      '12:10',
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
                          '5min',
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
              if (isEditingEnabled)
                TextField(
                  controller: _titleController,
                  style: context.textTheme.headlineLarge,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    border: InputBorder.none,
                  ),
                )
              else
                Text(
                  'Rugăciune',
                  style: context.textTheme.headlineLarge,
                ),
              const SizedBox(height: 12),
              _buildEditableDescription(context),
            ],
          ),
        ),
      ),
    );
  }
}
