import 'package:can_ui/generated/rpc_schema.pb.dart';
import 'package:can_ui/widgets/gauge/circular_gauge.dart';
import 'package:can_ui/widgets/gauge/linear_gauge.dart';
import 'package:can_ui/widgets/retro_linear_gauge.dart';
import 'package:can_ui/widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:can_ui/api.dart';

  // Helper method to determine segment color based on zones
  Color getValueColorForZone(double value, List<GaugeZone> zones, Color defaultColor) {
    if (zones.isEmpty) {
      return defaultColor;
    }

    for (var zone in zones) {
      if (value >= zone.start && value <= zone.end) {
        return hexToColor(zone.color);
      }
    }

    return defaultColor; // Default color if no zones match
  }

class Gauge extends HookWidget {
  final String signalName;
  final String label;
  final double maxValue;
  final double minValue;
  final double width;
  final double height;
  final GaugeWidget gaugeDefn;
  const Gauge(
      {super.key,
      required this.label,
      required this.maxValue,
      required this.minValue,
      required this.signalName,
      required this.width,
      required this.height,
      required this.gaugeDefn});

  @override
  Widget build(BuildContext context) {
    var state = useState(0.0);

    useEffect(() {
      API.updateBaseURI();
      final stream = API.streamSignals(signalName);

      stream.listen(
        (data) {
          state.value = data.value;
        },
        onError: (error) => {},
        onDone: () => {},
      );

      return () {
        stream.cancel();
      };
    }, const []);

    if (gaugeDefn.style.styleType == 'linear_retro') {
      return RetroLinearGauge(
          label: label,
          signalName: signalName,
          maxValue: maxValue,
          minValue: minValue,
          width: width,
          height: height,
          zones: gaugeDefn.style.zones,
          value: state.value);
    }
    if (gaugeDefn.style.styleType == 'linear') {
      return LinearGauge(
          label: label,
          signalName: signalName,
          maxValue: maxValue,
          minValue: minValue,
          width: width,
          height: height,
          zones: gaugeDefn.style.zones,
          value: state.value);
    }

    return CircularGauge(
        label: label,
        signalName: signalName,
        maxValue: maxValue,
        minValue: minValue,
        width: width,
        height: height,
        zones: gaugeDefn.style.zones,
        value: state.value);
  }
}
