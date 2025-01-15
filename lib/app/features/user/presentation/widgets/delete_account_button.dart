import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/shared/adaptive_dialog.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PreferencesActionTile(
      title: 'Delete Account',
      height: 54,
      leadingWidget: Icon(
        Icons.delete_outline,
        color: context.colorScheme.error,
        size: 20,
      ),
      color: context.colorScheme.error,
      onTap: () {
        AdaptiveDialog.show(
          context: context,
          title: 'Delete Account',
          description: 'Are you sure you want to remove this account? '
              'This action cannot be undone.',
          actionText: 'Remove',
          onAction: () {
            _deleteAccount(ref);
          },
        );
      },
    );
  }

  Future<void> _deleteAccount(WidgetRef ref) async {
    await ref.read(userNotifierProvider.notifier).deleteAccount();
  }
}
