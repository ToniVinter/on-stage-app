import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AdaptiveDialog extends ConsumerWidget {
  const AdaptiveDialog({
    required this.title,
    required this.description,
    required this.actionText,
    required this.onAction,
    super.key,
  });

  final String title;
  final String description;
  final String actionText;
  final VoidCallback onAction;

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
                onPressed: () => context.popDialog(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onAction();
                  context.popDialog();
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
                onPressed: () => context.popDialog(),
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  onAction();
                  context.popDialog();
                },
                isDestructiveAction: true,
                child: Text(actionText),
              ),
            ],
          );
  }

  static void show({
    required BuildContext context,
    required String title,
    required String description,
    required String actionText,
    required VoidCallback onAction,
  }) {
    if (Platform.isAndroid) {
      showDialog<void>(
        context: context,
        builder: (_) => AdaptiveDialog(
          title: title,
          description: description,
          actionText: actionText,
          onAction: onAction,
        ),
      );
    } else {
      showCupertinoDialog<void>(
        context: context,
        builder: (_) => AdaptiveDialog(
          title: title,
          description: description,
          actionText: actionText,
          onAction: onAction,
        ),
      );
    }
  }
}
