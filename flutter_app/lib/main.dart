import 'package:can_ui/api.dart';
import 'package:can_ui/generated/rpc_schema.pb.dart';
import 'package:can_ui/widgets/gauge/gauge.dart';
import 'package:can_ui/widgets/message_pane.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
// import 'package:window_manager/window_manager.dart';

const screenSize = Size(800, 480);

void setupLogger() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

final logger = Logger('CanClientUI');

void main() async {
  setupLogger();
  // WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();
  // WindowOptions windowOptions = const WindowOptions(
  //   size: screenSize,
  //   center: true,
  //   backgroundColor: Colors.transparent,
  //   skipTaskbar: false,
  //   titleBarStyle: TitleBarStyle.normal,
  //   windowButtonVisibility: true,

  //   // IRL we probably want:
  //   // skipTaskbar: true,
  //   // titleBarStyle: TitleBarStyle.hidden,
  //   // windowButtonVisibility: false, // TODO
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });
  logger.info("Starting app");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
      ).copyWith(textTheme: GoogleFonts.latoTextTheme()),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _Home();
}

double unitW() {
  return (screenSize.width / 12.0);
}

double unitH() {
  return (screenSize.height / 12.0);
}

class _Home extends State<MyHomePage> {
  Vehicle? _vehicle;
  List<Widget> _widgets = [];
  String? _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _getVehicle();
  }

  _position(Widget w, LayoutInfo layout) {
    final left = layout.x.toDouble() * unitW();

    return Positioned(
      left: layout.x.toDouble() * unitW(),
      top: layout.y.toDouble() * unitH(),
      width: layout.w * unitW(),
      height: layout.h * unitH(),
      child: Container(
        // useful for debugging
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.green, width: 1.0),
        // ),
        child: w,
      ),
    );
  }

  _getVehicle() {
    API.updateBaseURI();
    final vehicleStream = API.vehicleMeta();
    vehicleStream.listen(
      (result) {
        if (result.hasVehicle()) {
          final vehicle = result.vehicle;
          List<Widget> working = [];
          for (var w in vehicle.dashboards.first.widgets) {
            if (w.hasGauge()) {
              working.add(
                _position(_createGaugeWidget(vehicle, w.gauge), w.gauge.layout),
              );
            } else if (w.hasLineChart()) {
              working.add(
                _position(
                  _createLineWidget(vehicle, w.lineChart),
                  w.lineChart.layout,
                ),
              );
            } else if (w.hasMessagePane()) {
              working.add(_position(
                  _createMessagePaneWidget(vehicle, w.messagePane),
                  w.messagePane.layout));
            }
          }

          logger.info("Creating dash with ${working.length} widgets");
          setState(() {
            _errorMessage = null;
            _vehicle = vehicle;
            _widgets = working;
          });
        } else {
          setState(() {
            _errorMessage =
                "Failed to find a vehicle definition. ${result.error.toString()}";
          });
        }
      },
      onError: (error) => {
        setState(() {
          _errorMessage =
              "Fatal error connecting to CAN service. This is not recoverable.";
        })
      },
      onDone: () => {},
    );
  }

  Widget _createGaugeWidget(Vehicle vehicle, GaugeWidget defn) {
    final signalName = defn.columns.first;

    final width = defn.layout.w * unitW();
    final height = defn.layout.h * unitH();

    double? minValue;
    double? maxValue;
    for (var dbc in vehicle.dbcDefs) {
      for (var message in dbc.messages) {
        for (var sig in message.signals) {
          if (sig.name == signalName) {
            minValue = sig.rangeMin;
            maxValue = sig.rangeMax;
          }
        }
      }
    }
    logger.info("Creating gauge ${defn.title}");
    return Gauge(
      gaugeDefn: defn,
      label: defn.title,
      signalName: signalName,
      maxValue: maxValue!,
      minValue: minValue!,
      width: width,
      height: height,
    );
  }

  Widget _createLineWidget(Vehicle vehicle, LineChartWidget defn) {
    throw UnimplementedError('nope');
  }

  Widget _createMessagePaneWidget(Vehicle vehicle, MessagePaneWidget defn) {
    final width = defn.layout.w * unitW();
    final height = defn.layout.h * unitH();

    return MessagePane(width: width, height: height, defn: defn);
  }

  @override
  Widget build(BuildContext context) {
    logger.info("Building main app");
    var child;

    if (_errorMessage != null) {
      child = Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      child = Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.blueGrey,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.topLeft,
            children: [
              Positioned(
                left: 0,
                top: 0,
                // Make sure to define width and height for your positioned component
                width: screenSize.width,
                height: screenSize.height,
                child: Container(
                  // This container constrains the inner stack
                  color: Colors.black,

                  child: Stack(
                    // Important: Set fit to StackFit.expand or StackFit.passthrough
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: _widgets,
                  ),
                ),
              ),
              // Other children in the outer stack...
            ],
          ));
    }

    return Scaffold(
        body: SizedBox(
            width: screenSize.width, height: screenSize.height, child: child));
  }
}
