//
//  Generated code. Do not modify.
//  source: rpc_schema.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode(
    'CgVFbXB0eQ==');

@$core.Deprecated('Use echoResultDescriptor instead')
const EchoResult$json = {
  '1': 'EchoResult',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `EchoResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List echoResultDescriptor = $convert.base64Decode(
    'CgpFY2hvUmVzdWx0EhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use signalValueDescriptor instead')
const SignalValue$json = {
  '1': 'SignalValue',
  '2': [
    {'1': 'value', '3': 2, '4': 1, '5': 2, '10': 'value'},
  ],
};

/// Descriptor for `SignalValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalValueDescriptor = $convert.base64Decode(
    'CgtTaWduYWxWYWx1ZRIUCgV2YWx1ZRgCIAEoAlIFdmFsdWU=');

@$core.Deprecated('Use signalSubscriptionDescriptor instead')
const SignalSubscription$json = {
  '1': 'SignalSubscription',
  '2': [
    {'1': 'signal', '3': 1, '4': 1, '5': 9, '10': 'signal'},
  ],
};

/// Descriptor for `SignalSubscription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalSubscriptionDescriptor = $convert.base64Decode(
    'ChJTaWduYWxTdWJzY3JpcHRpb24SFgoGc2lnbmFsGAEgASgJUgZzaWduYWw=');

@$core.Deprecated('Use layoutInfoDescriptor instead')
const LayoutInfo$json = {
  '1': 'LayoutInfo',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 5, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 5, '10': 'y'},
    {'1': 'w', '3': 3, '4': 1, '5': 5, '10': 'w'},
    {'1': 'h', '3': 4, '4': 1, '5': 5, '10': 'h'},
  ],
};

/// Descriptor for `LayoutInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutInfoDescriptor = $convert.base64Decode(
    'CgpMYXlvdXRJbmZvEgwKAXgYASABKAVSAXgSDAoBeRgCIAEoBVIBeRIMCgF3GAMgASgFUgF3Eg'
    'wKAWgYBCABKAVSAWg=');

@$core.Deprecated('Use signalDescriptor instead')
const Signal$json = {
  '1': 'Signal',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'unit', '3': 2, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'range_min', '3': 3, '4': 1, '5': 1, '10': 'rangeMin'},
    {'1': 'range_max', '3': 4, '4': 1, '5': 1, '10': 'rangeMax'},
    {'1': 'id', '3': 5, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `Signal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalDescriptor = $convert.base64Decode(
    'CgZTaWduYWwSEgoEbmFtZRgBIAEoCVIEbmFtZRISCgR1bml0GAIgASgJUgR1bml0EhsKCXJhbm'
    'dlX21pbhgDIAEoAVIIcmFuZ2VNaW4SGwoJcmFuZ2VfbWF4GAQgASgBUghyYW5nZU1heBIOCgJp'
    'ZBgFIAEoCVICaWQ=');

@$core.Deprecated('Use dBCMessageDescriptor instead')
const DBCMessage$json = {
  '1': 'DBCMessage',
  '2': [
    {'1': 'can_id', '3': 2, '4': 1, '5': 3, '10': 'canId'},
    {'1': 'signals', '3': 3, '4': 3, '5': 11, '6': '.CanClient.Signal', '10': 'signals'},
  ],
};

/// Descriptor for `DBCMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dBCMessageDescriptor = $convert.base64Decode(
    'CgpEQkNNZXNzYWdlEhUKBmNhbl9pZBgCIAEoA1IFY2FuSWQSKwoHc2lnbmFscxgDIAMoCzIRLk'
    'NhbkNsaWVudC5TaWduYWxSB3NpZ25hbHM=');

@$core.Deprecated('Use dBCDefDescriptor instead')
const DBCDef$json = {
  '1': 'DBCDef',
  '2': [
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
    {'1': 'filename', '3': 3, '4': 1, '5': 9, '10': 'filename'},
    {'1': 'messages', '3': 4, '4': 3, '5': 11, '6': '.CanClient.DBCMessage', '10': 'messages'},
  ],
};

/// Descriptor for `DBCDef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dBCDefDescriptor = $convert.base64Decode(
    'CgZEQkNEZWYSGAoHY29udGVudBgCIAEoCVIHY29udGVudBIaCghmaWxlbmFtZRgDIAEoCVIIZm'
    'lsZW5hbWUSMQoIbWVzc2FnZXMYBCADKAsyFS5DYW5DbGllbnQuREJDTWVzc2FnZVIIbWVzc2Fn'
    'ZXM=');

@$core.Deprecated('Use lineChartWidgetDescriptor instead')
const LineChartWidget$json = {
  '1': 'LineChartWidget',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'title', '17': true},
    {'1': 'columns', '3': 2, '4': 3, '5': 9, '10': 'columns'},
    {'1': 'layout', '3': 3, '4': 1, '5': 11, '6': '.CanClient.LayoutInfo', '10': 'layout'},
  ],
  '8': [
    {'1': '_title'},
  ],
};

/// Descriptor for `LineChartWidget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lineChartWidgetDescriptor = $convert.base64Decode(
    'Cg9MaW5lQ2hhcnRXaWRnZXQSGQoFdGl0bGUYASABKAlIAFIFdGl0bGWIAQESGAoHY29sdW1ucx'
    'gCIAMoCVIHY29sdW1ucxItCgZsYXlvdXQYAyABKAsyFS5DYW5DbGllbnQuTGF5b3V0SW5mb1IG'
    'bGF5b3V0QggKBl90aXRsZQ==');

@$core.Deprecated('Use gaugeZoneDescriptor instead')
const GaugeZone$json = {
  '1': 'GaugeZone',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 1, '10': 'start'},
    {'1': 'end', '3': 2, '4': 1, '5': 1, '10': 'end'},
    {'1': 'color', '3': 3, '4': 1, '5': 9, '10': 'color'},
  ],
};

/// Descriptor for `GaugeZone`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gaugeZoneDescriptor = $convert.base64Decode(
    'CglHYXVnZVpvbmUSFAoFc3RhcnQYASABKAFSBXN0YXJ0EhAKA2VuZBgCIAEoAVIDZW5kEhQKBW'
    'NvbG9yGAMgASgJUgVjb2xvcg==');

@$core.Deprecated('Use gaugeStyleDescriptor instead')
const GaugeStyle$json = {
  '1': 'GaugeStyle',
  '2': [
    {'1': 'zones', '3': 4, '4': 3, '5': 11, '6': '.CanClient.GaugeZone', '10': 'zones'},
    {'1': 'style_type', '3': 5, '4': 1, '5': 9, '10': 'styleType'},
  ],
};

/// Descriptor for `GaugeStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gaugeStyleDescriptor = $convert.base64Decode(
    'CgpHYXVnZVN0eWxlEioKBXpvbmVzGAQgAygLMhQuQ2FuQ2xpZW50LkdhdWdlWm9uZVIFem9uZX'
    'MSHQoKc3R5bGVfdHlwZRgFIAEoCVIJc3R5bGVUeXBl');

@$core.Deprecated('Use gaugeWidgetDescriptor instead')
const GaugeWidget$json = {
  '1': 'GaugeWidget',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'title', '17': true},
    {'1': 'columns', '3': 2, '4': 3, '5': 9, '10': 'columns'},
    {'1': 'layout', '3': 3, '4': 1, '5': 11, '6': '.CanClient.LayoutInfo', '10': 'layout'},
    {'1': 'style', '3': 4, '4': 1, '5': 11, '6': '.CanClient.GaugeStyle', '10': 'style'},
  ],
  '8': [
    {'1': '_title'},
  ],
};

/// Descriptor for `GaugeWidget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gaugeWidgetDescriptor = $convert.base64Decode(
    'CgtHYXVnZVdpZGdldBIZCgV0aXRsZRgBIAEoCUgAUgV0aXRsZYgBARIYCgdjb2x1bW5zGAIgAy'
    'gJUgdjb2x1bW5zEi0KBmxheW91dBgDIAEoCzIVLkNhbkNsaWVudC5MYXlvdXRJbmZvUgZsYXlv'
    'dXQSKwoFc3R5bGUYBCABKAsyFS5DYW5DbGllbnQuR2F1Z2VTdHlsZVIFc3R5bGVCCAoGX3RpdG'
    'xl');

@$core.Deprecated('Use dashWidgetDescriptor instead')
const DashWidget$json = {
  '1': 'DashWidget',
  '2': [
    {'1': 'line_chart', '3': 1, '4': 1, '5': 11, '6': '.CanClient.LineChartWidget', '9': 0, '10': 'lineChart'},
    {'1': 'gauge', '3': 2, '4': 1, '5': 11, '6': '.CanClient.GaugeWidget', '9': 0, '10': 'gauge'},
  ],
  '8': [
    {'1': 'widget'},
  ],
};

/// Descriptor for `DashWidget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dashWidgetDescriptor = $convert.base64Decode(
    'CgpEYXNoV2lkZ2V0EjsKCmxpbmVfY2hhcnQYASABKAsyGi5DYW5DbGllbnQuTGluZUNoYXJ0V2'
    'lkZ2V0SABSCWxpbmVDaGFydBIuCgVnYXVnZRgCIAEoCzIWLkNhbkNsaWVudC5HYXVnZVdpZGdl'
    'dEgAUgVnYXVnZUIICgZ3aWRnZXQ=');

@$core.Deprecated('Use dashboardDescriptor instead')
const Dashboard$json = {
  '1': 'Dashboard',
  '2': [
    {'1': 'uid', '3': 1, '4': 1, '5': 9, '10': 'uid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'widgets', '3': 3, '4': 3, '5': 11, '6': '.CanClient.DashWidget', '10': 'widgets'},
  ],
};

/// Descriptor for `Dashboard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dashboardDescriptor = $convert.base64Decode(
    'CglEYXNoYm9hcmQSEAoDdWlkGAEgASgJUgN1aWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIvCgd3aW'
    'RnZXRzGAMgAygLMhUuQ2FuQ2xpZW50LkRhc2hXaWRnZXRSB3dpZGdldHM=');

@$core.Deprecated('Use vehicleDescriptor instead')
const Vehicle$json = {
  '1': 'Vehicle',
  '2': [
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'avatar', '3': 3, '4': 1, '5': 9, '10': 'avatar'},
    {'1': 'dbc_defs', '3': 4, '4': 3, '5': 11, '6': '.CanClient.DBCDef', '10': 'dbcDefs'},
    {'1': 'dashboards', '3': 5, '4': 3, '5': 11, '6': '.CanClient.Dashboard', '10': 'dashboards'},
    {'1': 'uid', '3': 6, '4': 1, '5': 9, '10': 'uid'},
  ],
};

/// Descriptor for `Vehicle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleDescriptor = $convert.base64Decode(
    'CgdWZWhpY2xlEhIKBG5hbWUYAiABKAlSBG5hbWUSFgoGYXZhdGFyGAMgASgJUgZhdmF0YXISLA'
    'oIZGJjX2RlZnMYBCADKAsyES5DYW5DbGllbnQuREJDRGVmUgdkYmNEZWZzEjQKCmRhc2hib2Fy'
    'ZHMYBSADKAsyFC5DYW5DbGllbnQuRGFzaGJvYXJkUgpkYXNoYm9hcmRzEhAKA3VpZBgGIAEoCV'
    'IDdWlk');

@$core.Deprecated('Use notFoundDescriptor instead')
const NotFound$json = {
  '1': 'NotFound',
};

/// Descriptor for `NotFound`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notFoundDescriptor = $convert.base64Decode(
    'CghOb3RGb3VuZA==');

@$core.Deprecated('Use offlineDescriptor instead')
const Offline$json = {
  '1': 'Offline',
};

/// Descriptor for `Offline`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offlineDescriptor = $convert.base64Decode(
    'CgdPZmZsaW5l');

@$core.Deprecated('Use resultErrorDescriptor instead')
const ResultError$json = {
  '1': 'ResultError',
  '2': [
    {'1': 'not_found', '3': 1, '4': 1, '5': 11, '6': '.CanClient.NotFound', '9': 0, '10': 'notFound'},
    {'1': 'offline', '3': 2, '4': 1, '5': 11, '6': '.CanClient.Offline', '9': 0, '10': 'offline'},
  ],
  '8': [
    {'1': 'error'},
  ],
};

/// Descriptor for `ResultError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resultErrorDescriptor = $convert.base64Decode(
    'CgtSZXN1bHRFcnJvchIyCglub3RfZm91bmQYASABKAsyEy5DYW5DbGllbnQuTm90Rm91bmRIAF'
    'IIbm90Rm91bmQSLgoHb2ZmbGluZRgCIAEoCzISLkNhbkNsaWVudC5PZmZsaW5lSABSB29mZmxp'
    'bmVCBwoFZXJyb3I=');

@$core.Deprecated('Use vehicleMetaResultDescriptor instead')
const VehicleMetaResult$json = {
  '1': 'VehicleMetaResult',
  '2': [
    {'1': 'vehicle', '3': 1, '4': 1, '5': 11, '6': '.CanClient.Vehicle', '9': 0, '10': 'vehicle'},
    {'1': 'error', '3': 2, '4': 1, '5': 11, '6': '.CanClient.ResultError', '9': 0, '10': 'error'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

/// Descriptor for `VehicleMetaResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleMetaResultDescriptor = $convert.base64Decode(
    'ChFWZWhpY2xlTWV0YVJlc3VsdBIuCgd2ZWhpY2xlGAEgASgLMhIuQ2FuQ2xpZW50LlZlaGljbG'
    'VIAFIHdmVoaWNsZRIuCgVlcnJvchgCIAEoCzIWLkNhbkNsaWVudC5SZXN1bHRFcnJvckgAUgVl'
    'cnJvckIICgZyZXN1bHQ=');

