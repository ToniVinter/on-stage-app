import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/constants.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class DateTimeTextFieldWidget extends StatefulWidget {
  const DateTimeTextFieldWidget({
    required this.onDateTimeChanged,
    super.key,
    this.initialDateTime,
    this.focusNode,
    this.enabled = true,
    this.dateErrorText,
  });

  final void Function(DateTime?) onDateTimeChanged;
  final DateTime? initialDateTime;
  final FocusNode? focusNode;
  final bool enabled;
  final String? dateErrorText;

  @override
  State<DateTimeTextFieldWidget> createState() =>
      _DateTimeTextFieldWidgetState();
}

class _DateTimeTextFieldWidgetState extends State<DateTimeTextFieldWidget> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late DateTime _now;
  late DateTime _minimumDateTime;
  late DateTime _maximumDateTime;

  final GlobalKey _datePickerKey = GlobalKey();
  final GlobalKey _timePickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    if (widget.initialDateTime != null) {
      final roundedTime = TimeUtils().approximateToNearestInterval(
        widget.initialDateTime!,
        UtilConstants.minuteInterval,
      );
      _selectedTime = TimeOfDay.fromDateTime(roundedTime);
      _selectedDate = widget.initialDateTime ?? _now;
    } else {
      _selectedTime = null;
    }

    _minimumDateTime = _now.subtract(const Duration(days: 40));
    _maximumDateTime = _now.add(const Duration(days: 365));
  }

  void _updateCombinedDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      final combinedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      widget.onDateTimeChanged(combinedDateTime);
    }
  }

  void _onDateChanged(DateTime newDate) {
    print('newDate: $newDate');
    setState(() {
      _selectedDate = newDate;
    });
    _updateCombinedDateTime();
  }

  void _onTimeChanged(TimeOfDay newTime) {
    print('newTime: $newTime');
    setState(() {
      _selectedTime = newTime;
    });
    _updateCombinedDateTime();
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date', style: context.textTheme.titleSmall),
                  const SizedBox(height: 12),
                  InkWell(
                    key: _datePickerKey,
                    onTap: () {
                      if (!widget.enabled) return;
                      final renderBox = _datePickerKey.currentContext
                          ?.findRenderObject() as RenderBox?;
                      setState(() {
                        _selectedDate ??= _now;
                      });
                      _onDateChanged(_now);
                      if (renderBox != null) {
                        showCupertinoCalendarPicker(
                          context,
                          widgetRenderBox: renderBox,
                          minimumDateTime: _minimumDateTime,
                          maximumDateTime: _maximumDateTime,
                          initialDateTime: _selectedDate ?? _now,
                          onDateTimeChanged: _onDateChanged,
                          minuteInterval: 10,
                          mainColor: context.colorScheme.primary,
                        );
                      }
                    },
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
                            _selectedDate != null
                                ? _formatDate(_selectedDate!)
                                : 'Select Date',
                            style: context.textTheme.titleMedium!.copyWith(
                              color: _selectedDate != null
                                  ? context.colorScheme.onSurface
                                  : context.colorScheme.onSurface
                                      .withOpacity(0.5),
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
                              Icons.calendar_today,
                              color: context.colorScheme.outline,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time', style: context.textTheme.titleSmall),
                  const SizedBox(height: 12),
                  InkWell(
                    key: _timePickerKey,
                    onTap: () {
                      if (!widget.enabled) return;
                      final renderBox = _timePickerKey.currentContext
                          ?.findRenderObject() as RenderBox?;
                      final now = TimeOfDay.fromDateTime(
                        TimeUtils().approximateToNearestInterval(
                          DateTime.now(),
                          UtilConstants.minuteInterval,
                        ),
                      );
                      if (renderBox != null) {
                        setState(() {
                          _selectedTime ??= now;
                        });

                        _onTimeChanged(_selectedTime!);

                        showCupertinoTimePicker(
                          context,
                          widgetRenderBox: renderBox,
                          initialTime: _selectedTime ??
                              TimeOfDay.fromDateTime(
                                TimeUtils().approximateToNearestInterval(
                                  DateTime.now(),
                                  UtilConstants.minuteInterval,
                                ),
                              ),
                          onTimeChanged: _onTimeChanged,
                          minuteInterval: 5,
                        );
                      }
                    },
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
                            _selectedTime?.format(context) ?? 'Select hour',
                            style: context.textTheme.titleMedium!.copyWith(
                              color: _selectedTime != null
                                  ? context.colorScheme.onSurface
                                  : context.colorScheme.onSurface
                                      .withOpacity(0.5),
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
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.dateErrorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              widget.dateErrorText!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
