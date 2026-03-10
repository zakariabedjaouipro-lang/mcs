/// Medical Logo with Crescent Symbol
/// Islamic/Arabic medical symbol used by many healthcare organizations
library;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mcs/core/theme/medical_colors.dart';

class MedicalCrescentLogo extends StatelessWidget {
  const MedicalCrescentLogo({
    super.key,
    this.size = 120,
    this.color = MedicalColors.primary,
    this.withStar = true,
  });
  final double size;
  final Color color;
  final bool withStar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CrescentLogoPainter(
          color: color,
          withStar: withStar,
        ),
      ),
    );
  }
}

class _CrescentLogoPainter extends CustomPainter {
  _CrescentLogoPainter({
    required this.color,
    required this.withStar,
  });
  final Color color;
  final bool withStar;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw crescent (moon shape)
    // Outer circle
    canvas.drawCircle(center, radius, paint);

    // Inner circle (cutout) - slightly offset to create crescent
    final innerCircleOffset = Offset(center.dx + radius * 0.3, center.dy);
    final innerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      innerCircleOffset,
      radius,
      innerCirclePaint,
    );

    // Draw stethoscope overlay if requested
    _drawStethoscopeOverlay(canvas, center, radius, strokePaint);

    // Draw medical star if requested
    if (withStar) {
      _drawMedicalStar(canvas, center, radius * 0.5, paint);
    }
  }

  void _drawStethoscopeOverlay(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path();

    // Top circle (earpieces joined)
    final topCircleY = center.dy - radius * 0.3;
    paint.style = PaintingStyle.stroke;
    canvas
      ..drawCircle(
        Offset(center.dx - radius * 0.15, topCircleY),
        radius * 0.15,
        paint,
      )
      ..drawCircle(
        Offset(center.dx + radius * 0.15, topCircleY),
        radius * 0.15,
        paint,
      );

    // Curved tube connecting to center
    path
      ..moveTo(center.dx - radius * 0.15, topCircleY + radius * 0.15)
      ..quadraticBezierTo(
        center.dx - radius * 0.1,
        center.dy,
        center.dx,
        center.dy + radius * 0.2,
      )
      ..moveTo(center.dx + radius * 0.15, topCircleY + radius * 0.15)
      ..quadraticBezierTo(
        center.dx + radius * 0.1,
        center.dy,
        center.dx,
        center.dy + radius * 0.2,
      );

    canvas
      ..drawPath(path, paint)
      ..drawCircle(
        Offset(center.dx, center.dy + radius * 0.4),
        radius * 0.25,
        paint,
      );
  }

  void _drawMedicalStar(
    Canvas canvas,
    Offset center,
    double size,
    Paint paint,
  ) {
    final path = Path();
    const pointCount = 5;

    for (var i = 0; i < pointCount * 2; i++) {
      final angle = (i * pi / pointCount) - pi / 2;
      final radius = i.isEven ? size : size * 0.4;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    paint
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CrescentLogoPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.withStar != withStar;
  }
}
