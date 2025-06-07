import 'package:can_ui/generated/rpc_schema.pb.dart';
import 'package:can_ui/widgets/gauge/gauge.dart';
import 'package:can_ui/widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math';

const fontFamily = 'digital-7';

class ShiftLights extends HookWidget {
  final String signalName;
  final String label;
  final double maxValue;
  final double minValue;
  final double width;
  final double height;
  final double value;
  final Color backgroundColor;
  final List<GaugeZone> zones;
  final int numSegments;
  final double segmentSpacing;
  final double segmentBorderRadius;
  final Color flashColor;

  const ShiftLights(
      {super.key,
      required this.label,
      required this.maxValue,
      required this.minValue,
      required this.signalName,
      required this.width,
      required this.height,
      required this.value,
      this.backgroundColor = Colors.black87,
      this.zones = const [],
      this.numSegments = 12,
      this.segmentSpacing = 12.0,
      this.segmentBorderRadius = 12.0,
      this.flashColor = Colors.cyanAccent});

  List<GaugeZone> _getDefaultZones() {
    return [
      GaugeZone()
        ..start = 2000
        ..end = 4000
        ..color = '#2196F3', // Blue
      GaugeZone()
        ..start = 4000
        ..end = 5000
        ..color = '#4CAF50', // Green
      GaugeZone()
        ..start = 5000
        ..end = 6000
        ..color = '#FF9800', // Orange
      GaugeZone()
        ..start = 6000
        ..end = maxValue
        ..color = '#F44336', // Red
    ];
  }

  @override
  Widget build(BuildContext context) {
    final effectiveZones = zones.isEmpty ? _getDefaultZones() : zones;
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 180),
      reverseDuration: const Duration(milliseconds: 150),
    );
    animationController.repeat();

    final flashAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.linear,
        ),
      ),
    );

    useEffect(() {
      effectiveZones.sort((a, b) => a.start.compareTo(b.start));
      return null;
    }, [effectiveZones]);


    final shouldFlash = value >= effectiveZones.last.start;
    useEffect(() {
      if (shouldFlash) {
        animationController.repeat();
      } else {
        animationController.stop();
        animationController.reset();
      }

      return null;
    }, [shouldFlash]);

    return Container(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Shift lights
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: ShiftLightsPainter(
                        value: value,
                        maxValue: maxValue,
                        minValue: minValue,
                        zones: effectiveZones,
                        numSegments: numSegments,
                        segmentSpacing: segmentSpacing,
                        segmentBorderRadius: segmentBorderRadius,
                        opacity: flashAnimation,
                        isFlashing: shouldFlash,
                        flashColor: flashColor),
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

class ShiftLightsPainter extends CustomPainter {
  final double value;
  final double maxValue;
  final double minValue;
  final List<GaugeZone> zones;
  final int numSegments;
  final double segmentSpacing;
  final double segmentBorderRadius;
  final double opacity;
  final Color flashColor;
  final bool isFlashing;

  ShiftLightsPainter(
      {required this.value,
      required this.maxValue,
      required this.minValue,
      required this.zones,
      required this.numSegments,
      required this.segmentSpacing,
      required this.segmentBorderRadius,
      required this.opacity,
      required this.flashColor,
      required this.isFlashing});

  Color _getSegmentColor(int segmentIndex) {
    if (isFlashing) {
      return flashColor;
    }
    final segmentValue =
        minValue + (segmentIndex / (numSegments - 1)) * (maxValue - minValue);

    for (var zone in zones) {
      if (segmentValue >= zone.start && segmentValue <= zone.end) {
        return hexToColor(zone.color);
      }
    }

    return Colors.blue; // Default fallback
  }

  @override
  void paint(Canvas canvas, Size size) {
    final valuePercentage =
        ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
    final activeSegments = (valuePercentage * numSegments).floor();

    final totalSpacingSize = segmentSpacing * (numSegments - 1);
    final segmentWidth = (size.width - totalSpacingSize) / numSegments;
    final segmentHeight = size.height;

    for (int i = 0; i < numSegments; i++) {
      final segmentX = i * (segmentWidth + segmentSpacing);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(segmentX, 0, segmentWidth, segmentHeight),
        Radius.circular(segmentBorderRadius),
      );

      final isActive = i < activeSegments;
      final segmentColor = _getSegmentColor(i);

      Color finalColor;

      if (isActive) {
        finalColor = segmentColor.withOpacity(opacity);
      } else {
        finalColor = Colors.grey.shade800.withOpacity(0.3);
      }

      final paint = Paint()
        ..color = finalColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rect, paint);

      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawRRect(rect, borderPaint);

      if (isActive) {
        final glowPaint = Paint()
          ..color = segmentColor.withOpacity(opacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

        canvas.drawRRect(rect, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(ShiftLightsPainter oldDelegate) {
    return value != oldDelegate.value ||
        maxValue != oldDelegate.maxValue ||
        zones != oldDelegate.zones ||
        numSegments != oldDelegate.numSegments ||
        opacity != oldDelegate.opacity;
  }
}
