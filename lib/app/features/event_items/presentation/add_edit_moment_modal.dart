import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/shared/adaptive_duration_picker.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class AddEditMomentModal extends ConsumerStatefulWidget {
  const AddEditMomentModal({
    this.eventItem,
    this.onMomentAdded,
    this.enabled = true,
    super.key,
  });

  final void Function(EventItem)? onMomentAdded;
  final EventItem? eventItem;
  final bool enabled;

  @override
  AddEditMomentModalState createState() => AddEditMomentModalState();

  static void show({
    required BuildContext context,
    EventItem? eventItem,
    void Function(EventItem)? onMomentAdded,
    bool enabled = true,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Moment name'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: AddEditMomentModal(
              onMomentAdded: onMomentAdded,
              eventItem: eventItem,
              enabled: enabled,
            ),
          ),
        ),
      ),
    );
  }
}

class AddEditMomentModalState extends ConsumerState<AddEditMomentModal> {
  List<int> selectedReminders = [0];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  Duration? _selectedTime;
  DateTime? _selectedDateTime;

  final _formKey = GlobalKey<FormState>();

  bool get isNewMoment {
    return widget.eventItem?.id == null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initControllers();
      FocusScope.of(context).requestFocus(_titleFocus);
    });
  }

  void _initControllers() {
    setState(() {
      // _rehearsalNameController.text = widget.rehearsal?.name ?? '';
    });
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNewMoment) ...[
              CustomTextField(
                enabled: widget.enabled,
                label: 'Title',
                hint: 'Enter a title',
                icon: null,
                focusNode: _titleFocus,
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rehearsal name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                enabled: widget.enabled,
                label: 'Description',
                hint: 'Enter a description',
                icon: null,
                controller: _descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rehearsal name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
            Text('Duration', style: context.textTheme.titleSmall),
            const SizedBox(height: 12),
            _EditDuration(
              selectedTime: _selectedTime,
              onTimeChanged: (v) {},
            ),
            const SizedBox(height: 16),
            Text(
              'Person',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (widget.eventItem?.leadVocals.isNullOrEmpty ?? true)
              EventActionButton(
                onTap: () {
                  // _showAssignPersonDialog();
                },
                text: 'Assign Person',
                icon: Icons.add,
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ParticipantListingItem(
                  userId: '',
                  name: 'Ionescu Pop',
                  photo: null,
                  onDelete: () {},
                ),
              ),
            const SizedBox(height: 32),
            if (widget.enabled) ...[
              ContinueButton(
                isEnabled: true,
                hasShadow: false,
                text: isNewMoment ? 'Create' : 'Save',
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
    context.popDialog();
  }

  bool _isDateTimeInvalid() {
    return _selectedDateTime == null ||
        _selectedDateTime!.isBefore(DateTime.now());
  }
}

class _EditDuration extends StatefulWidget {
  const _EditDuration({
    super.key,
    required this.selectedTime,
    required this.onTimeChanged,
  });

  final Duration? selectedTime;
  final Function(Duration) onTimeChanged;

  @override
  State<_EditDuration> createState() => _EditDurationState();
}

class _EditDurationState extends State<_EditDuration> {
  final GlobalKey _timePickerKey = GlobalKey();
  Duration? _currentDuration;

  @override
  void initState() {
    super.initState();
    _currentDuration = widget.selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _timePickerKey,
      onTap: _showDurationPicker,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 16),
            Text(
              TimeUtils().formatDuration(_currentDuration),
              style: context.textTheme.titleMedium!.copyWith(
                color: _currentDuration != null
                    ? context.colorScheme.onSurface
                    : context.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.access_time,
                color: context.colorScheme.outline,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDurationPicker() async {
    final initialDuration = _currentDuration ?? Duration.zero;

    final result = await AdaptiveDurationPicker.show(
      context: context,
      initialDuration: initialDuration,
    );

    if (result != null) {
      setState(() => _currentDuration = result);
      widget.onTimeChanged(result);
    }
  }
}
