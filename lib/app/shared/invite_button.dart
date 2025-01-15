import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class InviteButton extends StatelessWidget {
  const InviteButton({
    required this.text,
    required this.isConfirm,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  final String text;
  final void Function()? onPressed;
  final bool isConfirm;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        splashFactory: InkRipple.splashFactory,
        elevation: WidgetStateProperty.all(4),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ??
              (isConfirm ? Colors.green : context.colorScheme.surface),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return context.colorScheme.primary.withOpacity(0.1);
            }
            return null;
          },
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isConfirm ? LucideIcons.circle_check : Icons.cancel,
            size: 20,
            color: textColor ??
                (isConfirm ? Colors.white : context.colorScheme.error),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: context.textTheme.titleMedium!.copyWith(
              color: textColor ??
                  (isConfirm ? Colors.white : context.colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
