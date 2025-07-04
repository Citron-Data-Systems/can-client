import 'package:can_ui/generated/rpc_schema.pb.dart';
import 'package:can_ui/widgets/gauge/gauge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

String formatTickLabel(num number) {
  if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}k';
  } else {
    return number.toString();
  }
}

class RetroLinearGauge extends HookWidget {
  final String signalName;
  final String label;
  final double maxValue;
  final double minValue;
  final double width;
  final double height;
  final double value;

  final Color barColor;
  final Color backgroundColor;
  final Color needleColor;
  final Color textColor;
  final List<GaugeZone> zones;
  final bool isHorizontal;
  final int numSegments;
  final double segmentSpacing;
  final double segmentBorderRadius;
  final double arcAngle;
  final bool showDigitalValue;
  final Color accentColor;

  const RetroLinearGauge({
    Key? key,
    required this.label,
    required this.maxValue,
    required this.minValue,
    required this.signalName,
    required this.width,
    required this.height,
    required this.value,
    this.barColor = Colors.green,
    this.backgroundColor = Colors.black,
    this.needleColor = Colors.amber,
    this.textColor = Colors.amber,
    this.zones = const [],
    this.isHorizontal = true,
    this.numSegments = 16,
    this.segmentSpacing = 2.0,
    this.segmentBorderRadius = 2.0,
    this.arcAngle = 180,
    this.showDigitalValue = true,
    this.accentColor = Colors.amber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle =
        GoogleFonts.vt323(color: accentColor, fontWeight: FontWeight.bold);

    final fontSize = max(22.0, height * 0.09);
    final labelLen = (width / fontSize);
    final sigFigs = max(0, 3 - value.toInt().toString().length);
    final textColor = getValueColorForZone(value, zones, Colors.white);

    return Container(
      width: width,
      height: height,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with label
          Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label.substring(0, min(label.length, labelLen.floor())),
                  style:
                      textStyle.copyWith(fontSize: fontSize, color: textColor),
                ),
                if (showDigitalValue)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    alignment: Alignment.centerLeft,
                    child: Text(value.toStringAsFixed(sigFigs).padLeft(5),
                        style: textStyle.copyWith(
                            fontSize: fontSize * 1.1, color: textColor)),
                  ),
              ],
            ),
          ),

          // Main gauge area
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(2, fontSize * 0.8, 2, 2),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: RetroGaugePainter(
                        value: value,
                        maxValue: maxValue,
                        minValue: minValue,
                        barColor: barColor,
                        textStyle: textStyle,
                        zones: zones,
                        isHorizontal: isHorizontal,
                        numSegments: numSegments,
                        segmentSpacing: segmentSpacing,
                        arcAngle: arcAngle,
                        accentColor: accentColor,
                        segmentBorderRadius: segmentBorderRadius),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RetroGaugePainter extends CustomPainter {
  final double value;
  final double maxValue;
  final double minValue;
  final Color barColor;
  final List<GaugeZone> zones;
  final bool isHorizontal;
  final int numSegments;
  final double segmentSpacing;
  final double arcAngle;
  final Color accentColor;
  final double segmentBorderRadius;
  final TextStyle textStyle;

  RetroGaugePainter(
      {required this.value,
      required this.maxValue,
      required this.minValue,
      required this.barColor,
      required this.zones,
      required this.isHorizontal,
      required this.numSegments,
      required this.segmentSpacing,
      required this.arcAngle,
      required this.textStyle,
      required this.accentColor,
      required this.segmentBorderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate normalized value between 0 and 1
    final valuePercentage =
        ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);

    _drawHorizontalArcGauge(canvas, size, valuePercentage);
  }

  void _drawHorizontalArcGauge(
      Canvas canvas, Size size, double valuePercentage) {
    final width = size.width;
    final height = size.height;
    // final tickCount = max(2, (size.height / 80).floor());
    // TODO: do we want ticks?
    final tickCount = 0;
    final segmentWidth =
        (width - ((numSegments - 1) * segmentSpacing)) / numSegments;
    final activeSegments = (valuePercentage * numSegments).floor();

    // Logarithmic curve parameters
    final startY = height; // Start from bottom
    final maxHeight = height; // Maximum height for segments

    // Function to calculate logarithmic height for a segment position (0-1)
    double logHeight(double position) {
      // Logarithmic function that starts small and grows faster
      // Using log base 10 with an offset to make sure it's visible at the beginning
      const double base = 10;
      const double offset = 0.1; // So that the first segment isn't too short

      return maxHeight *
          (log((position + offset) * (base - 1) + 1) / log(base));
    }

    // Draw background segments
    for (int i = 0; i < numSegments; i++) {
      final segmentX = i * (segmentWidth + segmentSpacing);
      final segmentHeight = logHeight((i + 1) / numSegments);
      final segmentY = startY - segmentHeight;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(segmentX, segmentY, segmentWidth, segmentHeight),
        Radius.circular(segmentBorderRadius),
      );

      // Draw background segment
      final bgPaint = Paint()
        ..color = Colors.grey.shade900
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rect, bgPaint);

      // Draw segment border
      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawRRect(rect, borderPaint);
    }

    // Draw active segments
    for (int i = 0; i < activeSegments; i++) {
      final segmentX = i * (segmentWidth + segmentSpacing);
      final segmentHeight = logHeight((i + 1) / numSegments);
      final segmentY = startY - segmentHeight;

      // Calculate color based on segment position
      final segmentColor = getValueColorForZone(value, zones, barColor);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(segmentX, segmentY, segmentWidth, segmentHeight),
        Radius.circular(segmentBorderRadius),
      );

      // Draw active segment
      final paint = Paint()
        ..color = segmentColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rect, paint);

      // Add glow effect
      final glowPaint = Paint()
        ..color = segmentColor.withOpacity(0.8)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawRRect(rect, glowPaint);
    }

    // Draw tick marks
    final tickPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw tick marks on the left side
    for (int i = 0; i < tickCount; i++) {
      final position = i / (tickCount - 1);
      final tickHeight = logHeight(position);
      final tickY = startY - tickHeight;

      // Draw tick and label
      canvas.drawLine(
        Offset(0, tickY),
        Offset(width * 0.05, tickY),
        tickPaint,
      );

      // Draw tick value label
      final tickValue = minValue + position * (maxValue - minValue);
      final textPainter = TextPainter(
        text: TextSpan(
            text: formatTickLabel(tickValue.toInt()), style: textStyle),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(width * 0.06, tickY - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(RetroGaugePainter oldDelegate) {
    return value != oldDelegate.value ||
        maxValue != oldDelegate.maxValue ||
        barColor != oldDelegate.barColor ||
        zones != oldDelegate.zones ||
        numSegments != oldDelegate.numSegments;
  }
}

class RetroGaugeTicksPainter extends CustomPainter {
  final double maxValue;
  final double minValue;
  final TextStyle textColor;

  RetroGaugeTicksPainter({
    required this.maxValue,
    required this.minValue,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // No need to add ticks here since they're already drawn in the gauge painter
    // This is kept for compatibility with the original interface
  }

  @override
  bool shouldRepaint(RetroGaugeTicksPainter oldDelegate) {
    return maxValue != oldDelegate.maxValue ||
        minValue != oldDelegate.minValue ||
        textColor != oldDelegate.textColor;
  }
}
