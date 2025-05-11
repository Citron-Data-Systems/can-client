import 'package:flutter/material.dart';
import 'package:can_ui/gauge.dart';
import 'package:can_ui/hello_api_widget.dart';
import 'package:can_ui/hello_stream_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _message = "unknown";

  

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = _counter + 10;
      if (_counter > 120) {
        _counter = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var widgets = [
      HelloworldWidget(),
      HelloStreamWidget(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gauge(
            label: "RPM",
            value: _counter,
            maxValue: 8000,
            minValue: 0,
            size: 300,
            arcColor: Theme.of(context).splashColor,
            backgroundColor: Theme.of(context).canvasColor,
            needleColor: Theme.of(context).primaryColorLight,
            textColor:
                Theme.of(context).textTheme.bodySmall?.color ??
                Theme.of(context).splashColor,
            zones: [
              GaugeZone(start: 6000, end: 7000, color: Colors.orange),
              GaugeZone(start: 7000, end: 9000, color: Colors.red),
            ],
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gauge(
            label: "CoolantTmp",
            value: _counter,
            maxValue: 130,
            minValue: 0,
            size: 300,
            arcColor: Theme.of(context).splashColor,
            backgroundColor: Theme.of(context).canvasColor,
            needleColor: Theme.of(context).primaryColorLight,
            textColor:
                Theme.of(context).textTheme.bodySmall?.color ??
                Theme.of(context).splashColor,
            zones: [
              GaugeZone(start: 85, end: 105, color: Colors.green),

              GaugeZone(start: 105, end: 110, color: Colors.orange),
              // GaugeZone(start: 10, end: 100, color: Colors.green),
              GaugeZone(start: 110, end: 130, color: Colors.red),
            ],
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gauge(
            label: "OilPress",
            value: _counter,
            maxValue: 120,
            minValue: 0,
            size: 300,
            arcColor: Theme.of(context).splashColor,
            backgroundColor: Theme.of(context).canvasColor,
            needleColor: Theme.of(context).primaryColorLight,
            textColor:
                Theme.of(context).textTheme.bodySmall?.color ??
                Theme.of(context).splashColor,
            zones: [
              GaugeZone(start: 0, end: 10, color: Colors.red),
              // GaugeZone(start: 10, end: 100, color: Colors.green),
              GaugeZone(start: 100, end: 120, color: Colors.orange),
            ],
          ),
        ],
      ),
    ];

    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GridView.count(
          crossAxisCount: 3, // Number of columns in the grid
          mainAxisSpacing: 0.0, // Spacing between rows
          crossAxisSpacing: 10.0, // Spacing between columns
          padding: EdgeInsets.all(20.0), // Padding around the grid
          shrinkWrap: true, // Use the minimum space needed
          children: widgets, // Your list of widgets
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
