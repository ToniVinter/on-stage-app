import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.backgroundColor,
    this.color,
  });

  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Colors.black.withOpacity(0.3),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: CircularProgressIndicator(
              color: color ?? context.colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}
