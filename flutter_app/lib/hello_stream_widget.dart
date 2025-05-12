import 'package:can_ui/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HelloStreamWidget extends HookWidget {
  const HelloStreamWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = useState("nothing");

    useEffect(() {
      API.updateBaseURI();
      final stream = API.streamSignals("VehicleSpeed");

      stream.listen(
        (data) {
          state.value = data.value.toString();
        },
        onError: (error) => {
          state.value = "error ${error.toString()}"
        },
        onDone: () => {
          state.value = "done"
        },
      );

      return () {
        stream.cancel();
      };
    }, const []);

    return Center(
      child: Text(
        state.value,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
