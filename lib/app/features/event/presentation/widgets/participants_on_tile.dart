import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantsOnTile extends StatelessWidget {
  const ParticipantsOnTile({
    this.participantsProfileName = const [],
    this.participantsProfileBytes = const [],
    this.width = 30,
    this.showOverlay = true,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.participantsLength,
    this.participantsName,
    this.participantsMax,
    this.useRandomColors = false,
    super.key,
  });

  final List<Uint8List?> participantsProfileBytes;
  final List<String> participantsProfileName;
  final double width;
  final bool showOverlay;
  final Color? borderColor;
  final Color? backgroundColor;
  final int? participantsLength;
  final String? participantsName;
  final Color? textColor;
  final int? participantsMax;
  final bool useRandomColors;

  List<Color> get _backgroundColors => const [
        Color(0xFFD6CACA),
        Color(0xFFFA8686),
        Color(0xFF5CF5BA),
        Color(0xFF0D5C73),
      ];

  int get _participantsMax => participantsMax ?? 2;

  int get _participantsLength => participantsLength ?? 0;

  bool get _isMoreThanMax => _participantsLength > _participantsMax;

  double get tileWidth {
    final count = _isMoreThanMax ? _participantsMax + 1 : _participantsLength;
    return (count * width) - (count - 1) * 10;
  }

  Color _getRandomBackgroundColor(BuildContext context, int index) {
    if (useRandomColors == false) {
      return backgroundColor ?? context.colorScheme.secondary;
    }
    final colorIndex = index % _backgroundColors.length;
    return _backgroundColors[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    final displayedParticipants = List.generate(
      _isMoreThanMax ? _participantsMax : _participantsLength,
      (index) => {
        'photo': participantsProfileBytes.length > index
            ? participantsProfileBytes[index]
            : null,
        'name': participantsProfileName.length > index
            ? participantsProfileName[index]
            : participantsName ?? '',
        'backgroundColor': _getRandomBackgroundColor(context, index),
      },
    );

    return SizedBox(
      height: width,
      width: tileWidth,
      child: Stack(
        children: [
          if (showOverlay)
            ...displayedParticipants.asMap().entries.map((entry) {
              final index = entry.key;
              final participant = entry.value;

              return Positioned(
                left: index * 20,
                child: SizedBox(
                  width: width,
                  height: width,
                  child: ImageWithPlaceholder(
                    photo: participant['photo'] as Uint8List?,
                    name: participant['name']! as String,
                    borderColor: borderColor,
                    backgroundColor: participant['backgroundColor'] as Color,
                    placeholderColor: textColor,
                  ),
                ),
              );
            }),
          if (_isMoreThanMax)
            Positioned(
              left: _participantsMax * (width - 10),
              child: Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? context.colorScheme.onSurfaceVariant,
                    width: 2,
                  ),
                  // Use last color from backgroundColors for overflow indicator
                  color: useRandomColors
                      ? _backgroundColors.last
                      : (backgroundColor ?? context.colorScheme.secondary),
                ),
                child: Center(
                  child: Text(
                    '+${_participantsLength - _participantsMax}',
                    style: TextStyle(
                      color: textColor ?? context.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
