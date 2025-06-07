import 'package:can_ui/generated/rpc_schema.pb.dart';
import 'package:can_ui/widgets/gauge/gauge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math';

const fontFamily = 'digital-7';

String formatTickLabel(num number) {
  if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}k';
  } else {
    return number.toString();
  }
}

class LinearGauge extends HookWidget {
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
  final List<GaugeZone> zones;
  final bool isHorizontal;
  final int numSegments;
  final double segmentSpacing;
  final double segmentBorderRadius;

  const LinearGauge({
    super.key,
    required this.label,
    required this.maxValue,
    required this.minValue,
    required this.signalName,
    required this.width,
    required this.height,
    required this.value,
    this.barColor = Colors.blueAccent,
    this.backgroundColor = Colors.black87,
    this.needleColor = Colors.red,
    this.zones = const [],
    this.isHorizontal = true,
    this.numSegments = 16,
    this.segmentSpacing = 2.0,
    this.segmentBorderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = height * 0.09;
    final labelLen = (width / fontSize) * 0.8;
    final sigFigs = max(0, 3 - value.toInt().toString().length);

    final textColor = getValueColorForZone(value, zones, barColor);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade800, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with label
          Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label.substring(0, min(label.length, labelLen.floor())),
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade700, width: 1),
                  ),
                  child: Text(
                    value.toStringAsFixed(sigFigs),
                    style: TextStyle(
                      color: textColor,
                      fontSize: height * 0.09,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Segment meter
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: SegmentGaugePainter(
                      value: value,
                      maxValue: maxValue,
                      minValue: minValue,
                      barColor: barColor,
                      textColor: Colors.white,
                      zones: zones,
                      isHorizontal: isHorizontal,
                      numSegments: numSegments,
                      segmentSpacing: segmentSpacing,
                      segmentBorderRadius: segmentBorderRadius,
                    ),
                  );
                },
              ),
            ),
          ),

          // Tick marks and labels
          SizedBox(
            height: height * 0.15,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: CustomPaint(
                painter: GaugeTicksPainter(
                  maxValue: maxValue,
                  minValue: minValue,
                  textColor: Colors.white,
                  isHorizontal: isHorizontal,
                  numSegments: numSegments,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SegmentGaugePainter extends CustomPainter {
  final double value;
  final double maxValue;
  final double minValue;
  final Color barColor;
  final Color textColor;
  final List<GaugeZone> zones;
  final bool isHorizontal;
  final int numSegments;
  final double segmentSpacing;
  final double segmentBorderRadius;

  SegmentGaugePainter({
    required this.value,
    required this.maxValue,
    required this.minValue,
    required this.barColor,
    required this.textColor,
    required this.zones,
    required this.isHorizontal,
    required this.numSegments,
    required this.segmentSpacing,
    required this.segmentBorderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the active segments based on the value
    final valuePercentage = ((value - minValue) / (maxValue - minValue)).clamp(
      0.0,
      1.0,
    );
    final activeSegments = (valuePercentage * numSegments).floor();

    // Segment size calculations
    final totalSpacingSize = segmentSpacing * (numSegments - 1);

    final segmentWidth = (size.width - totalSpacingSize) / numSegments;
    final segmentHeight = size.height;

    // Draw each segment
    for (int i = 0; i < numSegments; i++) {
      final segmentX = i * (segmentWidth + segmentSpacing);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(segmentX, 0, segmentWidth, segmentHeight),
        Radius.circular(segmentBorderRadius),
      );

      // Determine if segment is active (should be lit)
      final isActive = i < activeSegments;

      // Determine the color based on zones and segment position
      Color segmentColor;
      if (isActive) {
        segmentColor = getValueColorForZone(value, zones, barColor);
      } else {
        segmentColor = Colors.grey.shade800;
      }

      // Draw segment
      final paint = Paint()
        ..color = isActive ? segmentColor : segmentColor.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rect, paint);

      // Draw segment border
      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawRRect(rect, borderPaint);

      // For active segments, add a glow effect
      if (isActive) {
        final glowPaint = Paint()
          ..color = segmentColor.withOpacity(0.6)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

        canvas.drawRRect(rect, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(SegmentGaugePainter oldDelegate) {
    return value != oldDelegate.value ||
        maxValue != oldDelegate.maxValue ||
        barColor != oldDelegate.barColor ||
        textColor != oldDelegate.textColor ||
        zones != oldDelegate.zones ||
        numSegments != oldDelegate.numSegments;
  }
}

class GaugeTicksPainter extends CustomPainter {
  final double maxValue;
  final double minValue;
  final Color textColor;
  final bool isHorizontal;
  final int numSegments;

  GaugeTicksPainter({
    required this.maxValue,
    required this.minValue,
    required this.textColor,
    required this.isHorizontal,
    required this.numSegments,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw tick marks and labels
    final tickPaint = Paint()
      ..color = textColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Number of major ticks (we'll use 5 evenly spaced ticks)
    const int numTicks = 3;

    for (int i = 0; i < numTicks; i++) {
      final tickValue = minValue + (i * (maxValue - minValue) / (numTicks - 1));
      final tickPosition = i / (numTicks - 1);

      if (isHorizontal) {
        // Draw tick mark
        final tickX = size.width * tickPosition;

        canvas.drawLine(
          Offset(tickX, 0),
          Offset(tickX, size.height * 0.3),
          tickPaint,
        );

        // Draw label
        textPainter.text = TextSpan(
          text: formatTickLabel(tickValue.toInt()),
          style: TextStyle(
            color: textColor,
            fontSize: size.height * 0.7,
            fontFamily: fontFamily,
          ),
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(tickX - (textPainter.width / 2), size.height * 0.4),
        );
      } else {
        // Vertical orientation - ticks on the right side
        final tickY = size.height * (1 - tickPosition);

        canvas.drawLine(
          Offset(size.width * 0.7, tickY),
          Offset(size.width, tickY),
          tickPaint,
        );

        // Draw label
        textPainter.text = TextSpan(
          text: '${tickValue.toInt()}',
          style: TextStyle(
            color: textColor,
            fontSize: size.height * 0.7,
            fontFamily: fontFamily,
          ),
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            size.width * 0.5 - textPainter.width / 2,
            tickY - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(GaugeTicksPainter oldDelegate) {
    return maxValue != oldDelegate.maxValue ||
        minValue != oldDelegate.minValue ||
        textColor != oldDelegate.textColor;
  }
}
