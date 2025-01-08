import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class DashedLineDivider extends StatelessWidget {
  const DashedLineDivider({
    this.color,
    this.dashWidth = 3,
    this.dashSpace = 5,
    super.key,
  });

  final Color? color;
  final double dashWidth;
  final double dashSpace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(
        painter: _DashedLinePainter(
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          color: color ?? context.colorScheme.surfaceContainer,
        ),
        size: const Size(double.infinity, 1),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({
    required this.dashWidth,
    required this.dashSpace,
    required this.color,
  });

  final double dashWidth;
  final double dashSpace;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
