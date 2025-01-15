import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AdaptiveEventPopDialog extends ConsumerWidget {
  const AdaptiveEventPopDialog({
    required this.title,
    required this.description,
    required this.actionText,
    super.key,
  });

  final String title;
  final String description;
  final String actionText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Platform.isAndroid
        ? AlertDialog(
            title: Text(title),
            content: Text(
              description,
            ),
            actions: [
              TextButton(
                onPressed: () => context.popDialog(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(eventNotifierProvider.notifier).deleteEvent();
                  context.popDialog(true);
                },
                style: TextButton.styleFrom(
                  foregroundColor: context.colorScheme.error,
                ),
                child: Text(actionText),
              ),
            ],
          )
        : CupertinoAlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              CupertinoDialogAction(
                onPressed: () => context.popDialog(false),
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  ref.read(eventNotifierProvider.notifier).deleteEvent();
                  context.popDialog(true);
                },
                isDestructiveAction: true,
                child: Text(actionText),
              ),
            ],
          );
  }

  static Future<bool?> show({
    required BuildContext context,
  }) {
    if (Platform.isAndroid) {
      return showDialog<bool>(
        context: context,
        builder: (_) => const AdaptiveEventPopDialog(
          title: 'Discard Changes',
          description: 'Are you sure you want to leave? '
              'Any unsaved changes will be lost.',
          actionText: 'Yes',
        ),
      );
    } else {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (_) => const AdaptiveEventPopDialog(
          title: 'Discard Changes',
          description: 'Are you sure you want to leave? '
              'Any unsaved changes will be lost.',
          actionText: 'Yes',
        ),
      );
    }
  }
}
