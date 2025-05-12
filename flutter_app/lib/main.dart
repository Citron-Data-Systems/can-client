import 'package:can_ui/api.dart';
import 'package:can_ui/generated/rpc_schema.pb.dart';
import 'package:flutter/material.dart';
import 'package:can_ui/gauge.dart';

import 'package:window_manager/window_manager.dart';

const screenSize = Size(840, 430);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: screenSize,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: true,

    // IRL we probably want:
    // skipTaskbar: true,
    // titleBarStyle: TitleBarStyle.hidden,
    // windowButtonVisibility: false, // TODO
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.dark(),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _Home();
}

class _Home extends State<MyHomePage> {
  Vehicle? _vehicle;
  List<Widget> _widgets = [];

  @override
  void initState() {
    super.initState();
    _getVehicle();
  }

  _getVehicle() async {
    API.updateBaseURI();
    final vehicle = await API.vehicleMeta();

    List<Widget> working = [];
    for (var w in vehicle.dashboards.first.widgets) {
      if (w.hasGauge()) {
        working.add(_createGaugeWidget(vehicle, w.gauge));
      } else if (w.hasLineChart()) {
        working.add(_createLineWidget(vehicle, w.lineChart));
      }
    }
    setState(() {
      _vehicle = vehicle;
      _widgets = working;
    });
  }

  Widget _createGaugeWidget(Vehicle vehicle, GaugeWidget defn) {
    final signalName = defn.columns.first;

    final unitW = (screenSize.width / 12.0);
    final size = defn.layout.w * unitW;
    // final size = 300.0;

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

    return Gauge(
      label: defn.title,
      signalName: signalName,
      maxValue: maxValue!,
      minValue: minValue!,
      size: size,
      arcColor: Theme.of(context).splashColor,
      backgroundColor: Theme.of(context).canvasColor,
      needleColor: Theme.of(context).primaryColorLight,
      textColor:
          Theme.of(context).textTheme.bodySmall?.color ??
          Theme.of(context).splashColor,
      zones: defn.style.zones,
    );
  }

  Widget _createLineWidget(Vehicle vehicle, LineChartWidget defn) {
    throw UnimplementedError('nope');
  }

  @override
  Widget build(BuildContext context) {
    // var widgets = [
    //   Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Gauge(
    //         label: "RPM",
    //         signalName: "RPM",
    //         maxValue: 8000,
    //         minValue: 0,
    //         size: 300,
    //         arcColor: Theme.of(context).splashColor,
    //         backgroundColor: Theme.of(context).canvasColor,
    //         needleColor: Theme.of(context).primaryColorLight,
    //         textColor:
    //             Theme.of(context).textTheme.bodySmall?.color ??
    //             Theme.of(context).splashColor,
    //         zones: [
    //           GaugeZone(start: 6000, end: 7000, color: 'ff0000'),
    //           // GaugeZone(start: 7000, end: 9000, color: Colors.red),
    //         ],
    //       ),
    //     ],
    //   ),
    //   Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Gauge(
    //         label: "CoolantTemp",
    //         signalName: "CoolantTemp",
    //         maxValue: 130,
    //         minValue: 0,
    //         size: 300,
    //         arcColor: Theme.of(context).splashColor,
    //         backgroundColor: Theme.of(context).canvasColor,
    //         needleColor: Theme.of(context).primaryColorLight,
    //         textColor:
    //             Theme.of(context).textTheme.bodySmall?.color ??
    //             Theme.of(context).splashColor,
    //         zones: [
    //           GaugeZone(start: 85, end: 105, color: '00ff00'),

    //           GaugeZone(start: 110, end: 130, color: 'ff0000'),
    //         ],
    //       ),
    //     ],
    //   ),
    //   Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Gauge(
    //         label: "OilPress",
    //         signalName: "OilPress",
    //         maxValue: 120,
    //         minValue: 0,
    //         size: 300,
    //         arcColor: Theme.of(context).splashColor,
    //         backgroundColor: Theme.of(context).canvasColor,
    //         needleColor: Theme.of(context).primaryColorLight,
    //         textColor:
    //             Theme.of(context).textTheme.bodySmall?.color ??
    //             Theme.of(context).splashColor,
    //         zones: [
    //           GaugeZone(start: 0, end: 10, color: Colors.red),
    //           // GaugeZone(start: 10, end: 100, color: Colors.green),
    //           GaugeZone(start: 100, end: 120, color: Colors.orange),
    //         ],
    //       ),
    //     ],
    //   ),
    // ];

    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GridView.count(
          crossAxisCount: 3, // Number of columns in the grid
          mainAxisSpacing: 0.0, // Spacing between rows
          crossAxisSpacing: 5.0, // Spacing between columns
          padding: EdgeInsets.all(5.0), // Padding around the grid
          shrinkWrap: true, // Use the minimum space needed
          children: _widgets,
        ),
      ),
    );
  }
}
