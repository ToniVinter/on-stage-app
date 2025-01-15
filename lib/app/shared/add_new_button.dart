import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddNewButton extends StatelessWidget {
  const AddNewButton({
    this.onPressed,
    this.text = 'New',
    super.key,
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        overlayColor: WidgetStateProperty.all(
          context.colorScheme.primary.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Icon(
                LucideIcons.plus,
                color: context.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: context.textTheme.titleMedium!
                    .copyWith(color: context.colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
