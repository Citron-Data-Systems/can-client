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
      final stream = API.streamEcho();

      stream.listen(
        (data) => state.value = data.message,
        onError: (error) => print("oof"),
        onDone: () => print('done'),
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
