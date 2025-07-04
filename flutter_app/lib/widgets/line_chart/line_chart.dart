import 'package:can_ui/generated/rpc_schema.pb.dart';
import 'package:can_ui/widgets/gauge/simple_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:can_ui/api.dart';

class LineChart extends HookWidget {
  final String signalName;
  final String label;
  final double maxValue;
  final double minValue;
  final double width;
  final double height;
  final LineChartWidget gaugeDefn;
  const LineChart(
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
    }, [signalName]);

    return SimpleLineChart(
        label: label,
        signalName: signalName,
        maxValue: maxValue,
        minValue: minValue,
        width: width,
        height: height,
        value: state.value);
  }
}
