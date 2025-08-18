//
//  Generated code. Do not modify.
//  source: rpc_schema.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AlertLevel extends $pb.ProtobufEnum {
  static const AlertLevel INFO = AlertLevel._(0, _omitEnumNames ? '' : 'INFO');
  static const AlertLevel WARN = AlertLevel._(1, _omitEnumNames ? '' : 'WARN');
  static const AlertLevel ERROR = AlertLevel._(2, _omitEnumNames ? '' : 'ERROR');

  static const $core.List<AlertLevel> values = <AlertLevel> [
    INFO,
    WARN,
    ERROR,
  ];

  static final $core.Map<$core.int, AlertLevel> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AlertLevel? valueOf($core.int value) => _byValue[value];

  const AlertLevel._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
