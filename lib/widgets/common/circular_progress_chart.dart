import 'package:flutter/material.dart';
import 'dart:math';
import '../../themes/app_theme.dart';

class CircularProgressChart extends StatefulWidget {
  final Map<String, double> data;
  final double size;
  final double strokeWidth;

  const CircularProgressChart({
    super.key,
    required this.data,
    this.size = 200,
    this.strokeWidth = 8,
  });

  @override
  State<CircularProgressChart> createState() => _CircularProgressChartState();
}

class _CircularProgressChartState extends State<CircularProgressChart>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: CircularProgressPainter(
            data: widget.data,
            strokeWidth: widget.strokeWidth,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final Map<String, double> data;
  final double strokeWidth;
  final double animationValue;

  CircularProgressPainter({
    required this.data,
    required this.strokeWidth,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circles
    final backgroundPaint = Paint()
      ..color = AppColors.primaryBrown.withOpacity(0.1)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final values = data.values.toList();
    final colors = [
      AppColors.primaryBrown,
      AppColors.primaryBrown.withOpacity(0.8),
      AppColors.primaryBrown.withOpacity(0.6),
      AppColors.primaryBrown.withOpacity(0.4),
    ];

    // Draw background circles
    for (int i = 0; i < values.length; i++) {
      final circleRadius = radius - (i * (strokeWidth + 4));
      canvas.drawCircle(center, circleRadius, backgroundPaint);
    }

    // Draw progress arcs
    for (int i = 0; i < values.length; i++) {
      final value = values[i] * animationValue;
      final circleRadius = radius - (i * (strokeWidth + 4));
      
      final progressPaint = Paint()
        ..color = colors[i % colors.length]
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final rect = Rect.fromCircle(center: center, radius: circleRadius);
      final sweepAngle = 2 * pi * value;
      
      canvas.drawArc(
        rect,
        -pi / 2, // Start from top
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}