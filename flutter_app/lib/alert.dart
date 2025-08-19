import 'dart:async';

import 'package:can_ui/generated/rpc_schema.pb.dart';
import 'package:can_ui/widgets/gauge/gauge.dart';
import 'package:can_ui/widgets/line_chart/line_chart.dart';
import 'package:can_ui/widgets/message_pane.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';
import 'package:can_ui/api.dart';

final logger = Logger('AlertUI');

class FloatingAlert extends StatefulWidget {
  const FloatingAlert({
    Key? key,
  }) : super(key: key);

  @override
  FloatingAlertState createState() => FloatingAlertState();
}

class FloatingAlertState extends State<FloatingAlert>
    with SingleTickerProviderStateMixin {
  AlertEvent? _event;
  late AnimationController _animationController;
  Timer? _autoDismissTimer;
  ResponseStream<EventValue>? _stream;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );


    API.updateBaseURI();
    _stream = API.streamEvent();
    logger.info("Subscribing to the event stream for alerts");
    _stream!.listen(
      (data) {
        if (data.hasAlertEvent()) {
          logger.info("Got an alert, displaying it");
          show(data.alertEvent);
        }
      },
      onError: (error) => {},
      onDone: () => {},
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _autoDismissTimer?.cancel();
    _stream?.cancel();
    super.dispose();
  }

  void show(AlertEvent ev) {
    setState(() {
      _event = ev;
    });
    _animationController.forward();

    // Auto dismiss if duration is provided
    _autoDismissTimer?.cancel();
    _autoDismissTimer = Timer(Duration(seconds: ev.timeSeconds), () {
      hide();
    });
  }

  void hide() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _event = null;
        });
      }
    });
    _autoDismissTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) {
      return SizedBox.shrink(); // Return empty widget when not visible
    }

    AlertEvent e = _event!;

    Color color = Colors.blue;
    switch (e.level) {
      case AlertLevel.INFO:
        color = Colors.blue;
      case AlertLevel.WARN:
        color = Colors.orange;
      case AlertLevel.ERROR:
        color = Colors.red;
    }

    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: color),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                _event!.message,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            IconButton(
              onPressed: hide,
              icon: Icon(Icons.close, color: color),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
