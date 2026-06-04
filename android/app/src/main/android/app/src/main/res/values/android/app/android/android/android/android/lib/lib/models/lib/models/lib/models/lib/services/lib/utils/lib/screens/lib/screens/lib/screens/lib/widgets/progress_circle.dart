import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ProgressCircle extends StatelessWidget {
  final double percentage;
  final double size;
  final double strokeWidth;

  const ProgressCircle({
    super.key,
    required this.percentage,
    this.size = 200,
    this.strokeWidth = 14,
  });

  Color get _progressColor {
    if (percentage >= 90) return AppTheme.success;
    if (percentage >= 60) return AppTheme.accent;
    if (percentage >= 30) return AppTheme.warning;
    return AppTheme.danger;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CirclePainter(
          percentage: percentage,
          color: _progressColor,
          backgroundColor: AppTheme.divider,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: size * 0.165,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'today',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: size * 0.075,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CirclePainter({
    required this.percentage,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (percentage > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * pi * (percentage / 100);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) =>
      oldDelegate.percentage != percentage ||
      oldDelegate.color != color;
}
