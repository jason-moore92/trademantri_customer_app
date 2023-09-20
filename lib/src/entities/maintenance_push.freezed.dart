// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'maintenance_push.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MaintenancePush _$MaintenancePushFromJson(Map<String, dynamic> json) {
  return _MaintenancePush.fromJson(json);
}

/// @nodoc
class _$MaintenancePushTearOff {
  const _$MaintenancePushTearOff();

  _MaintenancePush call({String? title, String? body}) {
    return _MaintenancePush(
      title: title,
      body: body,
    );
  }

  MaintenancePush fromJson(Map<String, Object?> json) {
    return MaintenancePush.fromJson(json);
  }
}

/// @nodoc
const $MaintenancePush = _$MaintenancePushTearOff();

/// @nodoc
mixin _$MaintenancePush {
  String? get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MaintenancePushCopyWith<MaintenancePush> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenancePushCopyWith<$Res> {
  factory $MaintenancePushCopyWith(
          MaintenancePush value, $Res Function(MaintenancePush) then) =
      _$MaintenancePushCopyWithImpl<$Res>;
  $Res call({String? title, String? body});
}

/// @nodoc
class _$MaintenancePushCopyWithImpl<$Res>
    implements $MaintenancePushCopyWith<$Res> {
  _$MaintenancePushCopyWithImpl(this._value, this._then);

  final MaintenancePush _value;
  // ignore: unused_field
  final $Res Function(MaintenancePush) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$MaintenancePushCopyWith<$Res>
    implements $MaintenancePushCopyWith<$Res> {
  factory _$MaintenancePushCopyWith(
          _MaintenancePush value, $Res Function(_MaintenancePush) then) =
      __$MaintenancePushCopyWithImpl<$Res>;
  @override
  $Res call({String? title, String? body});
}

/// @nodoc
class __$MaintenancePushCopyWithImpl<$Res>
    extends _$MaintenancePushCopyWithImpl<$Res>
    implements _$MaintenancePushCopyWith<$Res> {
  __$MaintenancePushCopyWithImpl(
      _MaintenancePush _value, $Res Function(_MaintenancePush) _then)
      : super(_value, (v) => _then(v as _MaintenancePush));

  @override
  _MaintenancePush get _value => super._value as _MaintenancePush;

  @override
  $Res call({
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_MaintenancePush(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MaintenancePush implements _MaintenancePush {
  _$_MaintenancePush({this.title, this.body});

  factory _$_MaintenancePush.fromJson(Map<String, dynamic> json) =>
      _$$_MaintenancePushFromJson(json);

  @override
  final String? title;
  @override
  final String? body;

  @override
  String toString() {
    return 'MaintenancePush(title: $title, body: $body)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MaintenancePush &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.body, body));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(body));

  @JsonKey(ignore: true)
  @override
  _$MaintenancePushCopyWith<_MaintenancePush> get copyWith =>
      __$MaintenancePushCopyWithImpl<_MaintenancePush>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MaintenancePushToJson(this);
  }
}

abstract class _MaintenancePush implements MaintenancePush {
  factory _MaintenancePush({String? title, String? body}) = _$_MaintenancePush;

  factory _MaintenancePush.fromJson(Map<String, dynamic> json) =
      _$_MaintenancePush.fromJson;

  @override
  String? get title;
  @override
  String? get body;
  @override
  @JsonKey(ignore: true)
  _$MaintenancePushCopyWith<_MaintenancePush> get copyWith =>
      throw _privateConstructorUsedError;
}
