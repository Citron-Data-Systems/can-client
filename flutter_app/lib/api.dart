import 'dart:io';

import 'package:can_ui/generated/rpc_schema.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class API {
  static String _baseHostname = "127.0.0.1";
  static ClientChannel? _channel;
  static RPCClient? _client;
  // static final Empty _empty = Empty.create();

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
      _channel!
    );
  }

  static ResponseStream<SignalValue> streamSignals(String signal) {
    return _client!.streamSignal(
      SignalSubscription(signal: signal),
    );
  }

  static ResponseStream<VehicleMetaResult> vehicleMeta() {
    return _client!.vehicleMeta(Empty());
  }

  static ResponseStream<EventValue> streamEvent() {
    return _client!.streamEvent(Empty());
  }

}
