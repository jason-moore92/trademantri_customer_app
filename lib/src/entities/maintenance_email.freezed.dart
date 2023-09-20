// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'maintenance_email.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MaintenanceEmail _$MaintenanceEmailFromJson(Map<String, dynamic> json) {
  return _MaintenanceEmail.fromJson(json);
}

/// @nodoc
class _$MaintenanceEmailTearOff {
  const _$MaintenanceEmailTearOff();

  _MaintenanceEmail call({String? subject, String? body}) {
    return _MaintenanceEmail(
      subject: subject,
      body: body,
    );
  }

  MaintenanceEmail fromJson(Map<String, Object?> json) {
    return MaintenanceEmail.fromJson(json);
  }
}

/// @nodoc
const $MaintenanceEmail = _$MaintenanceEmailTearOff();

/// @nodoc
mixin _$MaintenanceEmail {
  String? get subject => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MaintenanceEmailCopyWith<MaintenanceEmail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceEmailCopyWith<$Res> {
  factory $MaintenanceEmailCopyWith(
          MaintenanceEmail value, $Res Function(MaintenanceEmail) then) =
      _$MaintenanceEmailCopyWithImpl<$Res>;
  $Res call({String? subject, String? body});
}

/// @nodoc
class _$MaintenanceEmailCopyWithImpl<$Res>
    implements $MaintenanceEmailCopyWith<$Res> {
  _$MaintenanceEmailCopyWithImpl(this._value, this._then);

  final MaintenanceEmail _value;
  // ignore: unused_field
  final $Res Function(MaintenanceEmail) _then;

  @override
  $Res call({
    Object? subject = freezed,
    Object? body = freezed,
  }) {
    return _then(_value.copyWith(
      subject: subject == freezed
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String?,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$MaintenanceEmailCopyWith<$Res>
    implements $MaintenanceEmailCopyWith<$Res> {
  factory _$MaintenanceEmailCopyWith(
          _MaintenanceEmail value, $Res Function(_MaintenanceEmail) then) =
      __$MaintenanceEmailCopyWithImpl<$Res>;
  @override
  $Res call({String? subject, String? body});
}

/// @nodoc
class __$MaintenanceEmailCopyWithImpl<$Res>
    extends _$MaintenanceEmailCopyWithImpl<$Res>
    implements _$MaintenanceEmailCopyWith<$Res> {
  __$MaintenanceEmailCopyWithImpl(
      _MaintenanceEmail _value, $Res Function(_MaintenanceEmail) _then)
      : super(_value, (v) => _then(v as _MaintenanceEmail));

  @override
  _MaintenanceEmail get _value => super._value as _MaintenanceEmail;

  @override
  $Res call({
    Object? subject = freezed,
    Object? body = freezed,
  }) {
    return _then(_MaintenanceEmail(
      subject: subject == freezed
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
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
class _$_MaintenanceEmail implements _MaintenanceEmail {
  _$_MaintenanceEmail({this.subject, this.body});

  factory _$_MaintenanceEmail.fromJson(Map<String, dynamic> json) =>
      _$$_MaintenanceEmailFromJson(json);

  @override
  final String? subject;
  @override
  final String? body;

  @override
  String toString() {
    return 'MaintenanceEmail(subject: $subject, body: $body)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MaintenanceEmail &&
            const DeepCollectionEquality().equals(other.subject, subject) &&
            const DeepCollectionEquality().equals(other.body, body));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(subject),
      const DeepCollectionEquality().hash(body));

  @JsonKey(ignore: true)
  @override
  _$MaintenanceEmailCopyWith<_MaintenanceEmail> get copyWith =>
      __$MaintenanceEmailCopyWithImpl<_MaintenanceEmail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MaintenanceEmailToJson(this);
  }
}

abstract class _MaintenanceEmail implements MaintenanceEmail {
  factory _MaintenanceEmail({String? subject, String? body}) =
      _$_MaintenanceEmail;

  factory _MaintenanceEmail.fromJson(Map<String, dynamic> json) =
      _$_MaintenanceEmail.fromJson;

  @override
  String? get subject;
  @override
  String? get body;
  @override
  @JsonKey(ignore: true)
  _$MaintenanceEmailCopyWith<_MaintenanceEmail> get copyWith =>
      throw _privateConstructorUsedError;
}
