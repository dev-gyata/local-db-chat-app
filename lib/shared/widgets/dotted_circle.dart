import 'dart:math';
import 'package:flutter/material.dart';
import 'package:local_db_chat_app/shared/shared.dart';

class DottedCircle extends StatelessWidget {
  const DottedCircle({
    super.key,
    this.size = 48,
    this.color = AppColors.ufoGreen,
    this.strokeWidth = 2,
    this.dashWidth = 4,
    this.dashSpace = 5,
    this.child,
  });
  final double size;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: DottedCirclePainter(
        color: color,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
      ),
      child: SizedBox(height: size, width: size, child: child),
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  DottedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * pi * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (var i = 0; i < dashCount; i++) {
      final angle = (2 * pi / dashCount) * i;
      final startAngle = angle;
      final sweepAngle = (dashWidth / circumference) * 2 * pi;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
