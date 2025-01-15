import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/date_time_text_field.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CreateRehearsalModal extends ConsumerStatefulWidget {
  const CreateRehearsalModal({
    this.rehearsal,
    this.onRehearsalCreated,
    this.enabled = true,
    super.key,
  });

  final void Function(RehearsalModel)? onRehearsalCreated;
  final RehearsalModel? rehearsal;
  final bool enabled;

  @override
  CreateRehearsalModalState createState() => CreateRehearsalModalState();

  static void show({
    required BuildContext context,
    RehearsalModel? rehearsal,
    void Function(RehearsalModel)? onRehearsalCreated,
    bool enabled = true,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Rehearsal'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: CreateRehearsalModal(
              onRehearsalCreated: onRehearsalCreated,
              rehearsal: rehearsal,
              enabled: enabled,
            ),
          ),
        ),
      ),
    );
  }
}

class CreateRehearsalModalState extends ConsumerState<CreateRehearsalModal> {
  List<int> selectedReminders = [0];
  final TextEditingController _rehearsalNameController =
      TextEditingController();
  final FocusNode _rehearsalNameFocus = FocusNode();
  DateTime? _selectedDateTime;

  final _formKey = GlobalKey<FormState>();
  String? _dateTimeError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initControllers();
      FocusScope.of(context).requestFocus(_rehearsalNameFocus);
    });
  }

  void _initControllers() {
    setState(() {
      _rehearsalNameController.text = widget.rehearsal?.name ?? '';
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
              label: 'Rehearsal Name',
              hint: 'Sunday Morning',
              icon: null,
              focusNode: _rehearsalNameFocus,
              controller: _rehearsalNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a rehearsal name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            DateTimeTextFieldWidget(
              enabled: widget.enabled,
              initialDateTime: widget.rehearsal?.dateTime,
              dateErrorText: _dateTimeError,
              onDateTimeChanged: (dateTime) {
                _selectedDateTime = dateTime;
              },
            ),
            const SizedBox(height: 32),
            if (widget.enabled) ...[
              ContinueButton(
                isEnabled: true,
                hasShadow: false,
                text: widget.rehearsal != null ? 'Update' : 'Create',
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
    final currentEvent = ref.watch(eventNotifierProvider).event;
    setState(() {
      _dateTimeError = null;
    });
    if (_isDateTimeInvalid()) {
      setState(() {
        _dateTimeError = 'Please select a valid date and time';
      });
    }
    if (!_formKey.currentState!.validate() ||
        _dateTimeError != null ||
        currentEvent?.id == null) {
      return;
    }

    FocusScope.of(context).unfocus();

    final rehearsal = RehearsalModel(
      id: widget.rehearsal?.id,
      name: _rehearsalNameController.text,
      dateTime: _selectedDateTime,
      eventId: currentEvent!.id,
      location: '',
    );

    widget.onRehearsalCreated?.call(rehearsal);
    context.popDialog();
  }

  bool _isDateTimeInvalid() {
    return _selectedDateTime == null ||
        _selectedDateTime!.isBefore(DateTime.now());
  }
}
