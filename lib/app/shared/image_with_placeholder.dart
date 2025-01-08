import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/placeholder_image_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';

class ImageWithPlaceholder extends StatelessWidget {
  const ImageWithPlaceholder({
    super.key,
    this.photo,
    this.name = '',
    this.isLargeTitle = false,
    this.borderColor,
    this.backgroundColor,
    this.placeholderColor,
    this.size = 36,
    this.borderWidth = 2,
  });

  final Uint8List? photo;
  final String name;
  final bool isLargeTitle;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? placeholderColor;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final hasValidPhoto = photo?.isNotNullOrEmpty ?? false;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (context.isDarkMode
                ? context.colorScheme.secondary
                : context.colorScheme.secondary),
        border: Border.all(
          color: borderColor ?? context.colorScheme.onSurfaceVariant,
          width: borderWidth,
        ),
        shape: BoxShape.circle,
        image: hasValidPhoto
            ? DecorationImage(
                image: MemoryImage(photo!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !hasValidPhoto
          ? PlaceholderImageWidget(
              name: name,
              isLargeTitle: isLargeTitle,
              textColor: placeholderColor,
            )
          : null,
    );
  }
}
