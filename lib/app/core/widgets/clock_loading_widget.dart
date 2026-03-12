import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/app_constants.dart';

/// A professional clock-style loading indicator that can be used throughout the app.
/// This replaces the simple CircularProgressIndicator with a custom animated clock.
class ClockLoadingWidget extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const ClockLoadingWidget({
    super.key,
    this.size = 40,
    this.color,
    this.strokeWidth = 2.5,
  });

  @override
  State<ClockLoadingWidget> createState() => _ClockLoadingWidgetState();
}

class _ClockLoadingWidgetState extends State<ClockLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _ClockPainter(
              progress: _controller.value,
              color: color,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        );
      },
    );
  }
}

class _ClockPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _ClockPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw outer circle
    final circlePaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth, circlePaint);

    // Draw progress arc
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      -math.pi / 2,
      progress * 2 * math.pi,
      false,
      arcPaint,
    );

    // Draw clock hand
    final handPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.8
      ..strokeCap = StrokeCap.round;

    final angle = -math.pi / 2 + progress * 2 * math.pi;
    final handLength = radius * 0.5;
    final handEnd = Offset(
      center.dx + handLength * math.cos(angle),
      center.dy + handLength * math.sin(angle),
    );

    canvas.drawLine(center, handEnd, handPaint);

    // Draw center dot
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, strokeWidth * 1.2, dotPaint);

    // Draw hour markers (only for larger sizes)
    if (size.width >= 30) {
      final markerPaint = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      for (int i = 0; i < 12; i++) {
        final markerAngle = -math.pi / 2 + (i * math.pi / 6);
        final markerDistance = radius - strokeWidth - 4;
        final markerPos = Offset(
          center.dx + markerDistance * math.cos(markerAngle),
          center.dy + markerDistance * math.sin(markerAngle),
        );
        final markerSize = i % 3 == 0 ? strokeWidth * 0.6 : strokeWidth * 0.4;
        canvas.drawCircle(markerPos, markerSize, markerPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
