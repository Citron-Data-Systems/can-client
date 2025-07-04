import 'package:can_ui/generated/rpc_schema.pb.dart';
import 'package:can_ui/widgets/gauge/gauge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math';

class SimpleLineChart extends HookWidget {
  final String signalName;
  final String label;
  final double maxValue;
  final double minValue;
  final double width;
  final double height;
  final double value;
  final Color lineColor;
  final Color backgroundColor;
  final List<GaugeZone> zones;
  final int maxDataPoints;

  const SimpleLineChart({
    super.key,
    required this.label,
    required this.maxValue,
    required this.minValue,
    required this.signalName,
    required this.width,
    required this.height,
    required this.value,
    this.lineColor = Colors.blueAccent,
    this.backgroundColor = Colors.black87,
    this.zones = const [],
    this.maxDataPoints = 200,
  });

  @override
  Widget build(BuildContext context) {
    final dataPoints = useState<List<double>>([]);

    useEffect(() {
      final newDataPoints = List<double>.from(dataPoints.value);
      newDataPoints.add(value);

      if (newDataPoints.length > maxDataPoints) {
        newDataPoints.removeAt(0);
      }

      dataPoints.value = newDataPoints;
      return null;
    }, [value]);

    final fontSize = height * 0.09;
    final labelLen = (width / fontSize) * 0.8;
    final sigFigs = max(0, 3 - value.toInt().toString().length);

    final textColor = getValueColorForZone(value, zones, lineColor);

    return Container(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with label and current value
          Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label.substring(0, min(label.length, labelLen.floor())),
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    value.toStringAsFixed(sigFigs),
                    style: TextStyle(
                      color: textColor,
                      fontSize: height * 0.09,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Graph area with labels
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(width, height),
                    painter: SimpleLineChartPainter(
                      dataPoints: dataPoints.value,
                      maxValue: maxValue,
                      minValue: minValue,
                      lineColor: lineColor,
                      zones: zones,
                    ),
                  ),
                  // Max value label - top right
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Text(
                      maxValue.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.07,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Min value label - bottom right
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      minValue.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.07,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleLineChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final double maxValue;
  final double minValue;
  final Color lineColor;
  final List<GaugeZone> zones;

  SimpleLineChartPainter({
    required this.dataPoints,
    required this.maxValue,
    required this.minValue,
    required this.lineColor,
    required this.zones,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Draw background zones
    for (var zone in zones) {
      final zoneStartY = size.height - ((zone.start - minValue) / (maxValue - minValue)) * size.height;
      final zoneEndY = size.height - ((zone.end - minValue) / (maxValue - minValue)) * size.height;

      final zonePaint = Paint()
        ..color = getValueColorForZone((zone.start + zone.end) / 2, zones, lineColor).withOpacity(0.1)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTRB(0, zoneEndY, size.width, zoneStartY),
        zonePaint,
      );
    }

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Vertical grid lines
    for (int i = 0; i <= 4; i++) {
      final x = (size.width / 4) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw the timeseries line
    final stepX = size.width / (dataPoints.length - 1);

    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * stepX;
      final normalizedValue = (dataPoints[i] - minValue) / (maxValue - minValue);
      final y = size.height - (normalizedValue.clamp(0.0, 1.0) * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw current value point
    if (dataPoints.isNotEmpty) {
      final currentValue = dataPoints.last;
      final currentX = size.width;
      final normalizedValue = (currentValue - minValue) / (maxValue - minValue);
      final currentY = size.height - (normalizedValue.clamp(0.0, 1.0) * size.height);

      final pointPaint = Paint()
        ..color = getValueColorForZone(currentValue, zones, lineColor)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(currentX - 2, currentY), 4, pointPaint);

      // Add glow effect
      final glowPaint = Paint()
        ..color = getValueColorForZone(currentValue, zones, lineColor).withOpacity(0.6)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawCircle(Offset(currentX - 2, currentY), 4, glowPaint);
    }
  }

  @override
  bool shouldRepaint(SimpleLineChartPainter oldDelegate) {
    return dataPoints != oldDelegate.dataPoints ||
        maxValue != oldDelegate.maxValue ||
        minValue != oldDelegate.minValue ||
        lineColor != oldDelegate.lineColor ||
        zones != oldDelegate.zones;
  }
}

