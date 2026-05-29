import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SpeedDisplay extends StatelessWidget {
  final double speed;
  final String unit;
  final double size;

  const SpeedDisplay({
    super.key,
    required this.speed,
    this.unit = 'km/h',
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final displaySpeed = speed.round().toString();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: CustomPaint(
            painter: _SpeedRingPainter(speed: speed, unit: unit),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displaySpeed,
                    style: TextStyle(
                      fontSize: size * 0.35,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textPrimary,
                      letterSpacing: 1,
                      height: 0.9,
                    ),
                  ),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: size * 0.1,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpeedRingPainter extends CustomPainter {
  final double speed;
  final String unit;

  _SpeedRingPainter({required this.speed, required this.unit});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final bgPaint = Paint()
      ..color = AppColors.glassBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, bgPaint);

    final progress = (speed / 200).clamp(0.0, 1.0);
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    if (speed < 60) {
      arcPaint.color = AppColors.neonGreen;
    } else if (speed < 120) {
      arcPaint.color = AppColors.neonOrange;
    } else {
      arcPaint.color = AppColors.neonRed;
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      6.28319 * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_SpeedRingPainter oldDelegate) => oldDelegate.speed != speed;
}
