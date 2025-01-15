import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/groups/group_template/application/group_template_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class CreateGroupModal extends ConsumerStatefulWidget {
  const CreateGroupModal({
    this.enabled = true,
    super.key,
  });

  final bool enabled;

  @override
  CreateGroupModalState createState() => CreateGroupModalState();

  static void show({
    required BuildContext context,
    RehearsalModel? rehearsal,
    bool enabled = true,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'New Group'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: CreateGroupModal(
              enabled: enabled,
            ),
          ),
        ),
      ),
    );
  }
}

class CreateGroupModalState extends ConsumerState<CreateGroupModal> {
  final TextEditingController _groupNameController = TextEditingController();
  final FocusNode _rehearsalNameFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_rehearsalNameFocus);
    });
  }

  @override
  void dispose() {
    _rehearsalNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              enabled: widget.enabled,
              label: 'Group Name',
              hint: 'eg. Vocals',
              icon: null,
              focusNode: _rehearsalNameFocus,
              controller: _groupNameController,
              validator: (value) {
                if (value.isNullEmptyOrWhitespace) {
                  return 'Please enter a group name';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            if (widget.enabled) ...[
              ContinueButton(
                isEnabled: true,
                hasShadow: false,
                text: 'Create',
                onPressed: _createRehearsal,
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  void _createRehearsal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ref.read(groupTemplateNotifierProvider.notifier).createGroup(
          _groupNameController.text,
        );
    context.popDialog();
  }
}
