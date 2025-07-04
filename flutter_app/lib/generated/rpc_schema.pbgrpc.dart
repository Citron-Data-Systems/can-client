//
//  Generated code. Do not modify.
//  source: rpc_schema.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'rpc_schema.pb.dart' as $0;

export 'rpc_schema.pb.dart';

@$pb.GrpcServiceName('CanClient.RPC')
class RPCClient extends $grpc.Client {
  static final _$echo = $grpc.ClientMethod<$0.Empty, $0.EchoResult>(
      '/CanClient.RPC/Echo',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EchoResult.fromBuffer(value));
  static final _$streamEcho = $grpc.ClientMethod<$0.Empty, $0.EchoResult>(
      '/CanClient.RPC/StreamEcho',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EchoResult.fromBuffer(value));
  static final _$streamSignal = $grpc.ClientMethod<$0.SignalSubscription, $0.SignalValue>(
      '/CanClient.RPC/StreamSignal',
      ($0.SignalSubscription value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SignalValue.fromBuffer(value));
  static final _$streamText = $grpc.ClientMethod<$0.Empty, $0.TextValue>(
      '/CanClient.RPC/StreamText',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.TextValue.fromBuffer(value));
  static final _$vehicleMeta = $grpc.ClientMethod<$0.Empty, $0.VehicleMetaResult>(
      '/CanClient.RPC/VehicleMeta',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.VehicleMetaResult.fromBuffer(value));

  RPCClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.EchoResult> echo($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$echo, request, options: options);
  }

  $grpc.ResponseStream<$0.EchoResult> streamEcho($0.Empty request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$streamEcho, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$0.SignalValue> streamSignal($0.SignalSubscription request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$streamSignal, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$0.TextValue> streamText($0.Empty request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$streamText, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$0.VehicleMetaResult> vehicleMeta($0.Empty request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$vehicleMeta, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('CanClient.RPC')
abstract class RPCServiceBase extends $grpc.Service {
  $core.String get $name => 'CanClient.RPC';

  RPCServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.EchoResult>(
        'Echo',
        echo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.EchoResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.EchoResult>(
        'StreamEcho',
        streamEcho_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.EchoResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SignalSubscription, $0.SignalValue>(
        'StreamSignal',
        streamSignal_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SignalSubscription.fromBuffer(value),
        ($0.SignalValue value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.TextValue>(
        'StreamText',
        streamText_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.TextValue value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.VehicleMetaResult>(
        'VehicleMeta',
        vehicleMeta_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.VehicleMetaResult value) => value.writeToBuffer()));
  }

  $async.Future<$0.EchoResult> echo_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return echo(call, await request);
  }

  $async.Stream<$0.EchoResult> streamEcho_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* streamEcho(call, await request);
  }

  $async.Stream<$0.SignalValue> streamSignal_Pre($grpc.ServiceCall call, $async.Future<$0.SignalSubscription> request) async* {
    yield* streamSignal(call, await request);
  }

  $async.Stream<$0.TextValue> streamText_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* streamText(call, await request);
  }

  $async.Stream<$0.VehicleMetaResult> vehicleMeta_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* vehicleMeta(call, await request);
  }

  $async.Future<$0.EchoResult> echo($grpc.ServiceCall call, $0.Empty request);
  $async.Stream<$0.EchoResult> streamEcho($grpc.ServiceCall call, $0.Empty request);
  $async.Stream<$0.SignalValue> streamSignal($grpc.ServiceCall call, $0.SignalSubscription request);
  $async.Stream<$0.TextValue> streamText($grpc.ServiceCall call, $0.Empty request);
  $async.Stream<$0.VehicleMetaResult> vehicleMeta($grpc.ServiceCall call, $0.Empty request);
}
