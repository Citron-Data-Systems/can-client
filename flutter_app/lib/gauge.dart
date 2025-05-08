import 'dart:math' as math;
import 'package:flutter/material.dart';

class Gauge extends StatelessWidget {
  final int value;
  final String label;
  final double maxValue;
  final double minValue;
  final double size;
  final Color arcColor;
  final Color backgroundColor;
  final Color needleColor;
  final Color textColor;
  final List<GaugeZone> zones;
  final int startAngleDegrees;
  final int sweepAngleDegrees;

  const Gauge({
    Key? key,
    required this.value,
    required this.label,
    required this.maxValue,
    required this.minValue,

    this.size = 300,
    this.arcColor = Colors.blue,
    this.backgroundColor = Colors.black87,
    this.needleColor = Colors.red,
    this.textColor = Colors.white,
    this.zones = const [],
    this.startAngleDegrees = -220,
    this.sweepAngleDegrees = 260,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
          // Gauge arc and markings
          CustomPaint(
            size: Size(size, size),
            painter: GaugePainter(
              label: label,
              value: value,
              maxValue: maxValue,
              minValue: minValue,
              arcColor: arcColor,
              textColor: textColor,
              zones: zones,
              startAngleDegrees: startAngleDegrees,
              sweepAngleDegrees: sweepAngleDegrees,
            ),
          ),
          // Needle
          CustomPaint(
            size: Size(size, size),
            painter: NeedlePainter(
              value: value,
              maxValue: maxValue,
              needleColor: needleColor,
              startAngleDegrees: startAngleDegrees,
              sweepAngleDegrees: sweepAngleDegrees,

            ),
          ),
          // Central cap
          Center(
            child: Container(
              width: size * 0.12,
              height: size * 0.12,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: size * 0.08,
                  height: size * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // value text
          Positioned(
            bottom: size * 0.18,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  '${value.toInt()}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: size * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: size * 0.05,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GaugeZone {
  final int start;
  final int end;
  final Color color;

  const GaugeZone({
    required this.start,
    required this.end,
    required this.color,
  });
}

class GaugePainter extends CustomPainter {
  final int value;
  final double maxValue;
  final double minValue;
  final String label;
  final Color arcColor;
  final Color textColor;
  final List<GaugeZone> zones;
  final int startAngleDegrees;
  final int sweepAngleDegrees;

  GaugePainter({
    required this.value,
    required this.label,
    required this.maxValue,
    required this.minValue,
    required this.arcColor,
    required this.textColor,
    required this.zones,
    required this.startAngleDegrees,
    required this.sweepAngleDegrees,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    final arcWidth = size.width * 0.08;

    // Draw main arc
    final arcPaint =
        Paint()
          ..color = arcColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = arcWidth
          ..strokeCap = StrokeCap.round;

    // Start at -150 degrees and end at 150 degrees (300 degree sweep)
    final startAngle = startAngleDegrees * (math.pi / 180);
    final sweepAngle = sweepAngleDegrees * (math.pi / 180);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    final fullRange = maxValue - minValue;
    // Draw red zone if enabled
    for (var zone in zones) {
      final zoneStart =
          startAngle + (((zone.start - minValue) / fullRange) * sweepAngle);
      final zoneSweep = ((zone.end - zone.start) / fullRange) * sweepAngle;

      final zonePaint =
          Paint()
            ..color = zone.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = arcWidth
            ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        zoneStart,
        zoneSweep,
        false,
        zonePaint,
      );
    }

    // Draw tick marks
    final tickPaint =
        Paint()
          ..color = textColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw 9 major ticks/labels (0, 1000, 2000, ..., 8000)
    for (int i = 0; i <= 8; i++) {
      final tickValue = i * (maxValue / 8);
      final angle = startAngle + (sweepAngle * (tickValue / maxValue));

      // Major tick
      final outerPoint = Offset(
        center.dx + (radius + arcWidth / 2) * math.cos(angle),
        center.dy + (radius + arcWidth / 2) * math.sin(angle),
      );

      final innerPoint = Offset(
        center.dx + (radius - arcWidth / 2) * math.cos(angle),
        center.dy + (radius - arcWidth / 2) * math.sin(angle),
      );

      // Draw tick
      canvas.drawLine(innerPoint, outerPoint, tickPaint);

      // Draw label
      if (i % 2 == 0) {
        // Show labels for even numbers (0, 2000, 4000, etc.)
        final labelRadius = radius + arcWidth + 15;
        final labelPoint = Offset(
          center.dx + labelRadius * math.cos(angle),
          center.dy + labelRadius * math.sin(angle),
        );

        textPainter.text = TextSpan(
          text: '${(tickValue).toInt()}',
          style: TextStyle(
            color: textColor,
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            labelPoint.dx - textPainter.width / 2,
            labelPoint.dy - textPainter.height / 2,
          ),
        );
      }

      // Minor ticks
      if (i < 8) {
        for (int j = 1; j < 5; j++) {
          final minorTickValue = tickValue + j * (maxValue / 8 / 5);
          final minorAngle =
              startAngle + (sweepAngle * (minorTickValue / maxValue));

          final minorOuterPoint = Offset(
            center.dx + (radius + arcWidth / 4) * math.cos(minorAngle),
            center.dy + (radius + arcWidth / 4) * math.sin(minorAngle),
          );

          final minorInnerPoint = Offset(
            center.dx + (radius - arcWidth / 4) * math.cos(minorAngle),
            center.dy + (radius - arcWidth / 4) * math.sin(minorAngle),
          );

          canvas.drawLine(
            minorInnerPoint,
            minorOuterPoint,
            tickPaint..strokeWidth = 1,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(GaugePainter prev) {
    return value != prev.value ||
        maxValue != prev.maxValue ||
        arcColor != prev.arcColor ||
        textColor != prev.textColor ||
        zones != prev.zones;
  }
}

class NeedlePainter extends CustomPainter {
  final int value;
  final double maxValue;
  final Color needleColor;
  final int startAngleDegrees;
  final int sweepAngleDegrees;

  NeedlePainter({
    required this.value,
    required this.maxValue,
    required this.needleColor,
    required this.startAngleDegrees,
    required this.sweepAngleDegrees
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    // Calculate needle angle
    final percentage = value / maxValue;
    final clampedPercentage = percentage.clamp(0.0, 1.0);

    final startAngle = startAngleDegrees * (math.pi / 180);
    final sweepAngle = sweepAngleDegrees * (math.pi / 180);

    final needleAngle = startAngle + (sweepAngle * clampedPercentage);

    // Draw needle
    final needlePaint =
        Paint()
          ..color = needleColor
          ..style = PaintingStyle.fill;

    final needleEnd = Offset(
      center.dx + radius * math.cos(needleAngle),
      center.dy + radius * math.sin(needleAngle),
    );

    final needleBase1 = Offset(
      center.dx + 8 * math.cos(needleAngle + math.pi / 2),
      center.dy + 8 * math.sin(needleAngle + math.pi / 2),
    );

    final needleBase2 = Offset(
      center.dx + 8 * math.cos(needleAngle - math.pi / 2),
      center.dy + 8 * math.sin(needleAngle - math.pi / 2),
    );

    final path =
        Path()
          ..moveTo(needleEnd.dx, needleEnd.dy)
          ..lineTo(needleBase1.dx, needleBase1.dy)
          ..lineTo(needleBase2.dx, needleBase2.dy)
          ..close();

    canvas.drawPath(path, needlePaint);

    // Draw a shadow for the needle
    final shadowPaint =
        Paint()
          ..color = Colors.black26
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(NeedlePainter oldDelegate) {
    return value != oldDelegate.value ||
        maxValue != oldDelegate.maxValue ||
        needleColor != oldDelegate.needleColor;
  }
}
