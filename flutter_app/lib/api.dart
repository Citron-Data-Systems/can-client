import 'dart:io';

import 'package:can_ui/generated/rpc_schema.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class API {
  static String _baseHostname = "127.0.0.1";
  static ClientChannel? _channel;
  static RPCClient? _client;
  static final Empty _empty = Empty.create();

  static updateBaseURI() {
    final env = Platform.environment;
    if (env.keys.contains("BASE_RPC_HOSTNAME")) {
      _baseHostname = env["BASE_RPC_HOSTNAME"]!;
    }

    // Create the gRPC channel and stub
    _channel = ClientChannel(
      _baseHostname,
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    _client = RPCClient(
      _channel!,
      options: CallOptions(timeout: const Duration(seconds: 30)),
    );
  }

  static Future<EchoResult> echo() async {
    return await _client!.echo(Empty());
  }
}
