import 'package:can_ui/generated/rpc_schema.pb.dart';
import 'package:can_ui/widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:can_ui/api.dart';

class MessagePane extends HookWidget {
  final double width;
  final double height;
  final MessagePaneWidget defn;
  const MessagePane(
      {super.key,
      required this.width,
      required this.height,
      required this.defn});

  @override
  Widget build(BuildContext context) {
    var state = useState(TextValue(
        backgroundColor: '#000000',
        flash: false,
        textColor: '#ffffff',
        value: 'No Message',
        textSize: 'medium'));

    useEffect(() {
      API.updateBaseURI();

      // needs to match VehicleMetaChannel
      final stream = API.streamText();

      stream.listen(
        (data) {
          state.value = data;
        },
        onError: (error) => {},
        onDone: () => {},
      );

      return () {
        stream.cancel();
      };
    }, const []);

    var fontSize = 32.0;
    switch (state.value.textSize) {
      case 'small':
        fontSize = 16.0;
      case 'medium':
        fontSize = 24.0;
      case 'large':
        fontSize = 32.0;
      case 'x-large':
        fontSize = 48.0;
    }

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 850),
      reverseDuration: const Duration(milliseconds: 150),
    );
    final flashAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.linear,
        ),
      ),
    );

    useEffect(() {
      if (state.value.flash) {
        animationController.repeat();
      } else {
        animationController.reset();
        animationController.stop();
      }
    }, [state.value.flash]);

    return Container(
        width: width,
        height: height,
        color:
            hexToColor(state.value.backgroundColor).withOpacity(flashAnimation),
        child: Text(
          state.value.value,
          style: TextStyle(
              color: hexToColor(state.value.textColor), fontSize: fontSize),
        ));
  }
}
