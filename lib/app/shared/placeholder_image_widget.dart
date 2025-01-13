import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/name_utils.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class PlaceholderImageWidget extends StatelessWidget {
  const PlaceholderImageWidget({
    required this.name,
    this.isLargeTitle = false,
    this.textColor,
    super.key,
  });

  final String name;
  final bool isLargeTitle;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: name.isNotNullEmptyOrWhitespace
          ? Padding(
              padding: const EdgeInsets.all(2),
              child: AutoSizeText(
                NameUtils.getInitials(name) ?? '',
                textAlign: TextAlign.center,
                style: isLargeTitle
                    ? context.textTheme.titleLarge?.copyWith(
                        color: textColor ?? context.colorScheme.onSurface,
                      )
                    : context.textTheme.titleSmall?.copyWith(
                        color: textColor ?? context.colorScheme.onSurface,
                      ),
              ),
            )
          : Icon(
              Icons.person,
              color: textColor ?? context.colorScheme.onSurface,
            ),
    );
  }
}
