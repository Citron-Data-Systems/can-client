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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Empty extends $pb.GeneratedMessage {
  factory Empty() => create();
  Empty._() : super();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Empty', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class EchoResult extends $pb.GeneratedMessage {
  factory EchoResult({
    $core.String? message,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  EchoResult._() : super();
  factory EchoResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EchoResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EchoResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EchoResult clone() => EchoResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EchoResult copyWith(void Function(EchoResult) updates) => super.copyWith((message) => updates(message as EchoResult)) as EchoResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EchoResult create() => EchoResult._();
  EchoResult createEmptyInstance() => create();
  static $pb.PbList<EchoResult> createRepeated() => $pb.PbList<EchoResult>();
  @$core.pragma('dart2js:noInline')
  static EchoResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EchoResult>(create);
  static EchoResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
}

class SignalValue extends $pb.GeneratedMessage {
  factory SignalValue({
    $core.double? value,
  }) {
    final $result = create();
    if (value != null) {
      $result.value = value;
    }
    return $result;
  }
  SignalValue._() : super();
  factory SignalValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignalValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignalValue', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignalValue clone() => SignalValue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignalValue copyWith(void Function(SignalValue) updates) => super.copyWith((message) => updates(message as SignalValue)) as SignalValue;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignalValue create() => SignalValue._();
  SignalValue createEmptyInstance() => create();
  static $pb.PbList<SignalValue> createRepeated() => $pb.PbList<SignalValue>();
  @$core.pragma('dart2js:noInline')
  static SignalValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignalValue>(create);
  static SignalValue? _defaultInstance;

  @$pb.TagNumber(2)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(2)
  set value($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class SignalSubscription extends $pb.GeneratedMessage {
  factory SignalSubscription({
    $core.String? signal,
  }) {
    final $result = create();
    if (signal != null) {
      $result.signal = signal;
    }
    return $result;
  }
  SignalSubscription._() : super();
  factory SignalSubscription.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignalSubscription.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignalSubscription', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'signal')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignalSubscription clone() => SignalSubscription()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignalSubscription copyWith(void Function(SignalSubscription) updates) => super.copyWith((message) => updates(message as SignalSubscription)) as SignalSubscription;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignalSubscription create() => SignalSubscription._();
  SignalSubscription createEmptyInstance() => create();
  static $pb.PbList<SignalSubscription> createRepeated() => $pb.PbList<SignalSubscription>();
  @$core.pragma('dart2js:noInline')
  static SignalSubscription getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignalSubscription>(create);
  static SignalSubscription? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get signal => $_getSZ(0);
  @$pb.TagNumber(1)
  set signal($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignal() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignal() => clearField(1);
}

/// LayoutInfo represents positioning information in a grid
class LayoutInfo extends $pb.GeneratedMessage {
  factory LayoutInfo({
    $core.int? x,
    $core.int? y,
    $core.int? w,
    $core.int? h,
  }) {
    final $result = create();
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    if (w != null) {
      $result.w = w;
    }
    if (h != null) {
      $result.h = h;
    }
    return $result;
  }
  LayoutInfo._() : super();
  factory LayoutInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LayoutInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LayoutInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'x', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'y', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'w', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'h', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LayoutInfo clone() => LayoutInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LayoutInfo copyWith(void Function(LayoutInfo) updates) => super.copyWith((message) => updates(message as LayoutInfo)) as LayoutInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LayoutInfo create() => LayoutInfo._();
  LayoutInfo createEmptyInstance() => create();
  static $pb.PbList<LayoutInfo> createRepeated() => $pb.PbList<LayoutInfo>();
  @$core.pragma('dart2js:noInline')
  static LayoutInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LayoutInfo>(create);
  static LayoutInfo? _defaultInstance;

  /// X position in grid units
  @$pb.TagNumber(1)
  $core.int get x => $_getIZ(0);
  @$pb.TagNumber(1)
  set x($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  /// Y position in grid units
  @$pb.TagNumber(2)
  $core.int get y => $_getIZ(1);
  @$pb.TagNumber(2)
  set y($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);

  /// Width in grid units
  @$pb.TagNumber(3)
  $core.int get w => $_getIZ(2);
  @$pb.TagNumber(3)
  set w($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasW() => $_has(2);
  @$pb.TagNumber(3)
  void clearW() => clearField(3);

  /// Height in grid units
  @$pb.TagNumber(4)
  $core.int get h => $_getIZ(3);
  @$pb.TagNumber(4)
  set h($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasH() => $_has(3);
  @$pb.TagNumber(4)
  void clearH() => clearField(4);
}

/// Signal represents a data signal
class Signal extends $pb.GeneratedMessage {
  factory Signal({
    $core.String? name,
    $core.String? unit,
    $core.double? rangeMin,
    $core.double? rangeMax,
    $core.String? id,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (unit != null) {
      $result.unit = unit;
    }
    if (rangeMin != null) {
      $result.rangeMin = rangeMin;
    }
    if (rangeMax != null) {
      $result.rangeMax = rangeMax;
    }
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  Signal._() : super();
  factory Signal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Signal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Signal', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'unit')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'rangeMin', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'rangeMax', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Signal clone() => Signal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Signal copyWith(void Function(Signal) updates) => super.copyWith((message) => updates(message as Signal)) as Signal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Signal create() => Signal._();
  Signal createEmptyInstance() => create();
  static $pb.PbList<Signal> createRepeated() => $pb.PbList<Signal>();
  @$core.pragma('dart2js:noInline')
  static Signal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Signal>(create);
  static Signal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get unit => $_getSZ(1);
  @$pb.TagNumber(2)
  set unit($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnit() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get rangeMin => $_getN(2);
  @$pb.TagNumber(3)
  set rangeMin($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRangeMin() => $_has(2);
  @$pb.TagNumber(3)
  void clearRangeMin() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get rangeMax => $_getN(3);
  @$pb.TagNumber(4)
  set rangeMax($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRangeMax() => $_has(3);
  @$pb.TagNumber(4)
  void clearRangeMax() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get id => $_getSZ(4);
  @$pb.TagNumber(5)
  set id($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasId() => $_has(4);
  @$pb.TagNumber(5)
  void clearId() => clearField(5);
}

/// DBCMessage represents a CAN message
class DBCMessage extends $pb.GeneratedMessage {
  factory DBCMessage({
    $fixnum.Int64? canId,
    $core.Iterable<Signal>? signals,
  }) {
    final $result = create();
    if (canId != null) {
      $result.canId = canId;
    }
    if (signals != null) {
      $result.signals.addAll(signals);
    }
    return $result;
  }
  DBCMessage._() : super();
  factory DBCMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DBCMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DBCMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..aInt64(2, _omitFieldNames ? '' : 'canId')
    ..pc<Signal>(3, _omitFieldNames ? '' : 'signals', $pb.PbFieldType.PM, subBuilder: Signal.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DBCMessage clone() => DBCMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DBCMessage copyWith(void Function(DBCMessage) updates) => super.copyWith((message) => updates(message as DBCMessage)) as DBCMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DBCMessage create() => DBCMessage._();
  DBCMessage createEmptyInstance() => create();
  static $pb.PbList<DBCMessage> createRepeated() => $pb.PbList<DBCMessage>();
  @$core.pragma('dart2js:noInline')
  static DBCMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DBCMessage>(create);
  static DBCMessage? _defaultInstance;

  @$pb.TagNumber(2)
  $fixnum.Int64 get canId => $_getI64(0);
  @$pb.TagNumber(2)
  set canId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasCanId() => $_has(0);
  @$pb.TagNumber(2)
  void clearCanId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<Signal> get signals => $_getList(1);
}

/// DBCDef represents a DBC definition
class DBCDef extends $pb.GeneratedMessage {
  factory DBCDef({
    $core.String? content,
    $core.String? filename,
    $core.Iterable<DBCMessage>? messages,
  }) {
    final $result = create();
    if (content != null) {
      $result.content = content;
    }
    if (filename != null) {
      $result.filename = filename;
    }
    if (messages != null) {
      $result.messages.addAll(messages);
    }
    return $result;
  }
  DBCDef._() : super();
  factory DBCDef.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DBCDef.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DBCDef', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..aOS(3, _omitFieldNames ? '' : 'filename')
    ..pc<DBCMessage>(4, _omitFieldNames ? '' : 'messages', $pb.PbFieldType.PM, subBuilder: DBCMessage.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DBCDef clone() => DBCDef()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DBCDef copyWith(void Function(DBCDef) updates) => super.copyWith((message) => updates(message as DBCDef)) as DBCDef;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DBCDef create() => DBCDef._();
  DBCDef createEmptyInstance() => create();
  static $pb.PbList<DBCDef> createRepeated() => $pb.PbList<DBCDef>();
  @$core.pragma('dart2js:noInline')
  static DBCDef getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DBCDef>(create);
  static DBCDef? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(2)
  set content($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(2)
  void clearContent() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get filename => $_getSZ(1);
  @$pb.TagNumber(3)
  set filename($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasFilename() => $_has(1);
  @$pb.TagNumber(3)
  void clearFilename() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<DBCMessage> get messages => $_getList(2);
}

/// LineChartWidget specific fields
class LineChartWidget extends $pb.GeneratedMessage {
  factory LineChartWidget({
    $core.String? title,
    $core.Iterable<$core.String>? columns,
    LayoutInfo? layout,
  }) {
    final $result = create();
    if (title != null) {
      $result.title = title;
    }
    if (columns != null) {
      $result.columns.addAll(columns);
    }
    if (layout != null) {
      $result.layout = layout;
    }
    return $result;
  }
  LineChartWidget._() : super();
  factory LineChartWidget.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LineChartWidget.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LineChartWidget', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPS(2, _omitFieldNames ? '' : 'columns')
    ..aOM<LayoutInfo>(3, _omitFieldNames ? '' : 'layout', subBuilder: LayoutInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LineChartWidget clone() => LineChartWidget()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LineChartWidget copyWith(void Function(LineChartWidget) updates) => super.copyWith((message) => updates(message as LineChartWidget)) as LineChartWidget;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LineChartWidget create() => LineChartWidget._();
  LineChartWidget createEmptyInstance() => create();
  static $pb.PbList<LineChartWidget> createRepeated() => $pb.PbList<LineChartWidget>();
  @$core.pragma('dart2js:noInline')
  static LineChartWidget getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LineChartWidget>(create);
  static LineChartWidget? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get columns => $_getList(1);

  @$pb.TagNumber(3)
  LayoutInfo get layout => $_getN(2);
  @$pb.TagNumber(3)
  set layout(LayoutInfo v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLayout() => $_has(2);
  @$pb.TagNumber(3)
  void clearLayout() => clearField(3);
  @$pb.TagNumber(3)
  LayoutInfo ensureLayout() => $_ensure(2);
}

class GaugeZone extends $pb.GeneratedMessage {
  factory GaugeZone({
    $core.double? start,
    $core.double? end,
    $core.String? color,
  }) {
    final $result = create();
    if (start != null) {
      $result.start = start;
    }
    if (end != null) {
      $result.end = end;
    }
    if (color != null) {
      $result.color = color;
    }
    return $result;
  }
  GaugeZone._() : super();
  factory GaugeZone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GaugeZone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GaugeZone', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'start', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'end', $pb.PbFieldType.OD)
    ..aOS(3, _omitFieldNames ? '' : 'color')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GaugeZone clone() => GaugeZone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GaugeZone copyWith(void Function(GaugeZone) updates) => super.copyWith((message) => updates(message as GaugeZone)) as GaugeZone;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GaugeZone create() => GaugeZone._();
  GaugeZone createEmptyInstance() => create();
  static $pb.PbList<GaugeZone> createRepeated() => $pb.PbList<GaugeZone>();
  @$core.pragma('dart2js:noInline')
  static GaugeZone getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GaugeZone>(create);
  static GaugeZone? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get start => $_getN(0);
  @$pb.TagNumber(1)
  set start($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get end => $_getN(1);
  @$pb.TagNumber(2)
  set end($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get color => $_getSZ(2);
  @$pb.TagNumber(3)
  set color($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => clearField(3);
}

class GaugeStyle extends $pb.GeneratedMessage {
  factory GaugeStyle({
    $core.Iterable<GaugeZone>? zones,
    $core.String? styleType,
  }) {
    final $result = create();
    if (zones != null) {
      $result.zones.addAll(zones);
    }
    if (styleType != null) {
      $result.styleType = styleType;
    }
    return $result;
  }
  GaugeStyle._() : super();
  factory GaugeStyle.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GaugeStyle.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GaugeStyle', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..pc<GaugeZone>(4, _omitFieldNames ? '' : 'zones', $pb.PbFieldType.PM, subBuilder: GaugeZone.create)
    ..aOS(5, _omitFieldNames ? '' : 'styleType')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GaugeStyle clone() => GaugeStyle()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GaugeStyle copyWith(void Function(GaugeStyle) updates) => super.copyWith((message) => updates(message as GaugeStyle)) as GaugeStyle;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GaugeStyle create() => GaugeStyle._();
  GaugeStyle createEmptyInstance() => create();
  static $pb.PbList<GaugeStyle> createRepeated() => $pb.PbList<GaugeStyle>();
  @$core.pragma('dart2js:noInline')
  static GaugeStyle getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GaugeStyle>(create);
  static GaugeStyle? _defaultInstance;

  @$pb.TagNumber(4)
  $core.List<GaugeZone> get zones => $_getList(0);

  @$pb.TagNumber(5)
  $core.String get styleType => $_getSZ(1);
  @$pb.TagNumber(5)
  set styleType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(5)
  $core.bool hasStyleType() => $_has(1);
  @$pb.TagNumber(5)
  void clearStyleType() => clearField(5);
}

class GaugeWidget extends $pb.GeneratedMessage {
  factory GaugeWidget({
    $core.String? title,
    $core.Iterable<$core.String>? columns,
    LayoutInfo? layout,
    GaugeStyle? style,
  }) {
    final $result = create();
    if (title != null) {
      $result.title = title;
    }
    if (columns != null) {
      $result.columns.addAll(columns);
    }
    if (layout != null) {
      $result.layout = layout;
    }
    if (style != null) {
      $result.style = style;
    }
    return $result;
  }
  GaugeWidget._() : super();
  factory GaugeWidget.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GaugeWidget.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GaugeWidget', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPS(2, _omitFieldNames ? '' : 'columns')
    ..aOM<LayoutInfo>(3, _omitFieldNames ? '' : 'layout', subBuilder: LayoutInfo.create)
    ..aOM<GaugeStyle>(4, _omitFieldNames ? '' : 'style', subBuilder: GaugeStyle.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GaugeWidget clone() => GaugeWidget()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GaugeWidget copyWith(void Function(GaugeWidget) updates) => super.copyWith((message) => updates(message as GaugeWidget)) as GaugeWidget;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GaugeWidget create() => GaugeWidget._();
  GaugeWidget createEmptyInstance() => create();
  static $pb.PbList<GaugeWidget> createRepeated() => $pb.PbList<GaugeWidget>();
  @$core.pragma('dart2js:noInline')
  static GaugeWidget getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GaugeWidget>(create);
  static GaugeWidget? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get columns => $_getList(1);

  @$pb.TagNumber(3)
  LayoutInfo get layout => $_getN(2);
  @$pb.TagNumber(3)
  set layout(LayoutInfo v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLayout() => $_has(2);
  @$pb.TagNumber(3)
  void clearLayout() => clearField(3);
  @$pb.TagNumber(3)
  LayoutInfo ensureLayout() => $_ensure(2);

  @$pb.TagNumber(4)
  GaugeStyle get style => $_getN(3);
  @$pb.TagNumber(4)
  set style(GaugeStyle v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearStyle() => clearField(4);
  @$pb.TagNumber(4)
  GaugeStyle ensureStyle() => $_ensure(3);
}

enum DashWidget_Widget {
  lineChart, 
  gauge, 
  notSet
}

/// Unified widget message with oneof field
class DashWidget extends $pb.GeneratedMessage {
  factory DashWidget({
    LineChartWidget? lineChart,
    GaugeWidget? gauge,
  }) {
    final $result = create();
    if (lineChart != null) {
      $result.lineChart = lineChart;
    }
    if (gauge != null) {
      $result.gauge = gauge;
    }
    return $result;
  }
  DashWidget._() : super();
  factory DashWidget.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DashWidget.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, DashWidget_Widget> _DashWidget_WidgetByTag = {
    1 : DashWidget_Widget.lineChart,
    2 : DashWidget_Widget.gauge,
    0 : DashWidget_Widget.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DashWidget', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<LineChartWidget>(1, _omitFieldNames ? '' : 'lineChart', subBuilder: LineChartWidget.create)
    ..aOM<GaugeWidget>(2, _omitFieldNames ? '' : 'gauge', subBuilder: GaugeWidget.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DashWidget clone() => DashWidget()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DashWidget copyWith(void Function(DashWidget) updates) => super.copyWith((message) => updates(message as DashWidget)) as DashWidget;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DashWidget create() => DashWidget._();
  DashWidget createEmptyInstance() => create();
  static $pb.PbList<DashWidget> createRepeated() => $pb.PbList<DashWidget>();
  @$core.pragma('dart2js:noInline')
  static DashWidget getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DashWidget>(create);
  static DashWidget? _defaultInstance;

  DashWidget_Widget whichWidget() => _DashWidget_WidgetByTag[$_whichOneof(0)]!;
  void clearWidget() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  LineChartWidget get lineChart => $_getN(0);
  @$pb.TagNumber(1)
  set lineChart(LineChartWidget v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLineChart() => $_has(0);
  @$pb.TagNumber(1)
  void clearLineChart() => clearField(1);
  @$pb.TagNumber(1)
  LineChartWidget ensureLineChart() => $_ensure(0);

  @$pb.TagNumber(2)
  GaugeWidget get gauge => $_getN(1);
  @$pb.TagNumber(2)
  set gauge(GaugeWidget v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasGauge() => $_has(1);
  @$pb.TagNumber(2)
  void clearGauge() => clearField(2);
  @$pb.TagNumber(2)
  GaugeWidget ensureGauge() => $_ensure(1);
}

/// // Dashboard contains multiple widgets
class Dashboard extends $pb.GeneratedMessage {
  factory Dashboard({
    $core.String? uid,
    $core.String? name,
    $core.Iterable<DashWidget>? widgets,
  }) {
    final $result = create();
    if (uid != null) {
      $result.uid = uid;
    }
    if (name != null) {
      $result.name = name;
    }
    if (widgets != null) {
      $result.widgets.addAll(widgets);
    }
    return $result;
  }
  Dashboard._() : super();
  factory Dashboard.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Dashboard.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Dashboard', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..pc<DashWidget>(3, _omitFieldNames ? '' : 'widgets', $pb.PbFieldType.PM, subBuilder: DashWidget.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Dashboard clone() => Dashboard()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Dashboard copyWith(void Function(Dashboard) updates) => super.copyWith((message) => updates(message as Dashboard)) as Dashboard;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Dashboard create() => Dashboard._();
  Dashboard createEmptyInstance() => create();
  static $pb.PbList<Dashboard> createRepeated() => $pb.PbList<Dashboard>();
  @$core.pragma('dart2js:noInline')
  static Dashboard getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dashboard>(create);
  static Dashboard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<DashWidget> get widgets => $_getList(2);
}

/// // Vehicle is the top-level entity
class Vehicle extends $pb.GeneratedMessage {
  factory Vehicle({
    $core.String? name,
    $core.String? avatar,
    $core.Iterable<DBCDef>? dbcDefs,
    $core.Iterable<Dashboard>? dashboards,
    $core.String? uid,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (avatar != null) {
      $result.avatar = avatar;
    }
    if (dbcDefs != null) {
      $result.dbcDefs.addAll(dbcDefs);
    }
    if (dashboards != null) {
      $result.dashboards.addAll(dashboards);
    }
    if (uid != null) {
      $result.uid = uid;
    }
    return $result;
  }
  Vehicle._() : super();
  factory Vehicle.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Vehicle.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Vehicle', package: const $pb.PackageName(_omitMessageNames ? '' : 'CanClient'), createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'avatar')
    ..pc<DBCDef>(4, _omitFieldNames ? '' : 'dbcDefs', $pb.PbFieldType.PM, subBuilder: DBCDef.create)
    ..pc<Dashboard>(5, _omitFieldNames ? '' : 'dashboards', $pb.PbFieldType.PM, subBuilder: Dashboard.create)
    ..aOS(6, _omitFieldNames ? '' : 'uid')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Vehicle clone() => Vehicle()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Vehicle copyWith(void Function(Vehicle) updates) => super.copyWith((message) => updates(message as Vehicle)) as Vehicle;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Vehicle create() => Vehicle._();
  Vehicle createEmptyInstance() => create();
  static $pb.PbList<Vehicle> createRepeated() => $pb.PbList<Vehicle>();
  @$core.pragma('dart2js:noInline')
  static Vehicle getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Vehicle>(create);
  static Vehicle? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get avatar => $_getSZ(1);
  @$pb.TagNumber(3)
  set avatar($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(1);
  @$pb.TagNumber(3)
  void clearAvatar() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<DBCDef> get dbcDefs => $_getList(2);

  @$pb.TagNumber(5)
  $core.List<Dashboard> get dashboards => $_getList(3);

  @$pb.TagNumber(6)
  $core.String get uid => $_getSZ(4);
  @$pb.TagNumber(6)
  set uid($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasUid() => $_has(4);
  @$pb.TagNumber(6)
  void clearUid() => clearField(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
