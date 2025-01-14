import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SettingsTrailingAppBarButton extends ConsumerWidget {
  const SettingsTrailingAppBarButton({
    this.onTap,
    this.iconPath,
    this.rightPadding = 6,
    super.key,
  });

  final void Function()? onTap;
  final String? iconPath;
  final double rightPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding),
      child: IconButton(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        color: context.colorScheme.onSurface,
        iconSize: 16,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor:
              WidgetStateProperty.all(context.colorScheme.onSurfaceVariant),
        ),
        icon: const Icon(LucideIcons.settings_2),
        onPressed: onTap,
      ),
    );
  }
}
