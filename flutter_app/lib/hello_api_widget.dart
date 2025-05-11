import 'package:can_ui/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HelloworldWidget extends HookWidget {
  const HelloworldWidget({Key? key}) : super(key: key);

  Future<String> fetchData() async {
    API.updateBaseURI();
    var res = await API.echo();
    return res.message;
  }

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(() => fetchData(), []);
    final snapshot = useFuture(future);

    return Center(
      child:
          snapshot.connectionState == ConnectionState.waiting
              ? const CircularProgressIndicator()
              : snapshot.hasError
              ? Text('Error: ${snapshot.error}')
              : Text(
                snapshot.data ?? 'No data',
                style: const TextStyle(fontSize: 18),
              ),
    );
  }
}
