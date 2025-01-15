import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/date_time_text_field.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class DuplicateEventModal extends ConsumerStatefulWidget {
  const DuplicateEventModal({
    super.key,
  });

  @override
  EditDateModalState createState() => EditDateModalState();

  static void show({
    required BuildContext context,
    RehearsalModel? rehearsal,
    void Function(RehearsalModel)? onRehearsalCreated,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Duplicate Event'),
          headerHeight: () => 64,
          buildContent: () => const SingleChildScrollView(
            child: DuplicateEventModal(),
          ),
        ),
      ),
    );
  }
}

class EditDateModalState extends ConsumerState<DuplicateEventModal> {
  final FocusNode _focusNode = FocusNode();
  DateTime? _selectedDateTime;
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
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
              label: 'Name',
              hint: 'Sunday Morning Meeting',
              icon: null,
              focusNode: _focusNode,
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an event name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            DateTimeTextFieldWidget(
              onDateTimeChanged: (dateTime) {
                _selectedDateTime = dateTime;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Your event will be created and saved in draft mode. '
              'Participants will not be notified about this event'
              ' until you will publish it.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 32),
            ContinueButton(
              text: 'Duplicate',
              onPressed: _duplicateEvent,
              isEnabled: true,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _duplicateEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      FocusScope.of(context).unfocus();

      if (_selectedDateTime == null) {
        throw Exception('Please select a date and time');
      }

      await ref
          .read(eventNotifierProvider.notifier)
          .duplicateEvent(_selectedDateTime!, _nameController.text);

      final eventId = ref.read(eventNotifierProvider).event?.id;
      if (eventId == null) {
        throw Exception('Failed to get new event ID');
      }

      context
        ..popDialog()
        ..goNamed(
          AppRoute.eventDetails.name,
          queryParameters: {'eventId': eventId},
        );
    } catch (e) {
      logger.i('Failed to duplicate event: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
