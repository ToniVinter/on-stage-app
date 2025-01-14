import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AdaptiveDurationPicker {
  static Future<Duration?> show({
    required BuildContext context,
    required Duration initialDuration,
  }) async {
    if (Platform.isIOS) {
      return _showCupertinoPicker(context, initialDuration);
    } else {
      return _showMaterialPicker(context, initialDuration);
    }
  }

  static Future<Duration?> _showCupertinoPicker(
    BuildContext context,
    Duration initialDuration,
  ) async {
    Duration? selectedDuration;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 320,
        padding: const EdgeInsets.only(top: 6),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Material(
                child: Text(
                  'Set Duration',
                  style: context.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 12),
              CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: initialDuration,
                onTimerDurationChanged: (Duration newDuration) {
                  selectedDuration = newDuration;
                },
              ),
            ],
          ),
        ),
      ),
    );

    return selectedDuration;
  }

  static Future<Duration?> _showMaterialPicker(
    BuildContext context,
    Duration initialDuration,
  ) async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: initialDuration.inHours,
        minute: initialDuration.inMinutes % 60,
      ),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Material(
              child: Text(
                'Set Duration',
                style: context.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!,
            ),
          ],
        );
      },
    );

    if (result != null) {
      return Duration(
        hours: result.hour,
        minutes: result.minute,
      );
    }
    return null;
  }
}
