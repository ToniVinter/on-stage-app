import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconSize = 20,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: IconButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(backgroundColor),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          overlayColor: WidgetStateProperty.all(
            context.colorScheme.surfaceBright,
          ),
          visualDensity: VisualDensity.compact,
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        icon: Icon(
          icon,
          color: Theme.of(context).colorScheme.outline,
          size: iconSize,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
