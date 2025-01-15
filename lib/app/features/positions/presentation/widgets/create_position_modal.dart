import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/positions/application/position_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class CreatePositionModal extends ConsumerStatefulWidget {
  const CreatePositionModal({
    required this.groupId,
    super.key,
  });

  final String groupId;

  @override
  CreatePositionModalState createState() => CreatePositionModalState();

  static void show({
    required BuildContext context,
    required String groupId,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'New Position'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: CreatePositionModal(
              groupId: groupId,
            ),
          ),
        ),
      ),
    );
  }
}

class CreatePositionModalState extends ConsumerState<CreatePositionModal> {
  final TextEditingController _positionNameController = TextEditingController();
  final FocusNode _positionNameFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_positionNameFocus);
    });
  }

  @override
  void dispose() {
    _positionNameFocus.dispose();
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
              enabled: true,
              label: 'Position Name',
              hint: 'eg. Acoustic Guitar',
              icon: null,
              focusNode: _positionNameFocus,
              controller: _positionNameController,
              validator: (value) {
                if (value.isNullEmptyOrWhitespace) {
                  return 'Please enter a position name';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ContinueButton(
              isEnabled: true,
              hasShadow: false,
              text: 'Create',
              onPressed: _addPosition,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _addPosition() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await ref.read(positionNotifierProvider.notifier).addPosition(
          _positionNameController.text,
          widget.groupId,
        );

    context.popDialog();
  }
}
