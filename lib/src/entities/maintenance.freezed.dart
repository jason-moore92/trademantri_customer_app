// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'maintenance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Maintenance _$MaintenanceFromJson(Map<String, dynamic> json) {
  return _Maintenance.fromJson(json);
}

/// @nodoc
class _$MaintenanceTearOff {
  const _$MaintenanceTearOff();

  _Maintenance call(
      {String? message,
      bool? allowOperations,
      String? image,
      MaintenanceEmail? email,
      MaintenancePush? push,
      String? createdBy,
      DateTime? start,
      DateTime? end,
      DateTime? createdAt,
      DateTime? updatedAt}) {
    return _Maintenance(
      message: message,
      allowOperations: allowOperations,
      image: image,
      email: email,
      push: push,
      createdBy: createdBy,
      start: start,
      end: end,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Maintenance fromJson(Map<String, Object?> json) {
    return Maintenance.fromJson(json);
  }
}

/// @nodoc
const $Maintenance = _$MaintenanceTearOff();

/// @nodoc
mixin _$Maintenance {
  String? get message => throw _privateConstructorUsedError;
  bool? get allowOperations => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  MaintenanceEmail? get email => throw _privateConstructorUsedError;
  MaintenancePush? get push => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get start => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MaintenanceCopyWith<Maintenance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceCopyWith<$Res> {
  factory $MaintenanceCopyWith(
          Maintenance value, $Res Function(Maintenance) then) =
      _$MaintenanceCopyWithImpl<$Res>;
  $Res call(
      {String? message,
      bool? allowOperations,
      String? image,
      MaintenanceEmail? email,
      MaintenancePush? push,
      String? createdBy,
      DateTime? start,
      DateTime? end,
      DateTime? createdAt,
      DateTime? updatedAt});

  $MaintenanceEmailCopyWith<$Res>? get email;
  $MaintenancePushCopyWith<$Res>? get push;
}

/// @nodoc
class _$MaintenanceCopyWithImpl<$Res> implements $MaintenanceCopyWith<$Res> {
  _$MaintenanceCopyWithImpl(this._value, this._then);

  final Maintenance _value;
  // ignore: unused_field
  final $Res Function(Maintenance) _then;

  @override
  $Res call({
    Object? message = freezed,
    Object? allowOperations = freezed,
    Object? image = freezed,
    Object? email = freezed,
    Object? push = freezed,
    Object? createdBy = freezed,
    Object? start = freezed,
    Object? end = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      allowOperations: allowOperations == freezed
          ? _value.allowOperations
          : allowOperations // ignore: cast_nullable_to_non_nullable
              as bool?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as MaintenanceEmail?,
      push: push == freezed
          ? _value.push
          : push // ignore: cast_nullable_to_non_nullable
              as MaintenancePush?,
      createdBy: createdBy == freezed
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      start: start == freezed
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: end == freezed
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  @override
  $MaintenanceEmailCopyWith<$Res>? get email {
    if (_value.email == null) {
      return null;
    }

    return $MaintenanceEmailCopyWith<$Res>(_value.email!, (value) {
      return _then(_value.copyWith(email: value));
    });
  }

  @override
  $MaintenancePushCopyWith<$Res>? get push {
    if (_value.push == null) {
      return null;
    }

    return $MaintenancePushCopyWith<$Res>(_value.push!, (value) {
      return _then(_value.copyWith(push: value));
    });
  }
}

/// @nodoc
abstract class _$MaintenanceCopyWith<$Res>
    implements $MaintenanceCopyWith<$Res> {
  factory _$MaintenanceCopyWith(
          _Maintenance value, $Res Function(_Maintenance) then) =
      __$MaintenanceCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? message,
      bool? allowOperations,
      String? image,
      MaintenanceEmail? email,
      MaintenancePush? push,
      String? createdBy,
      DateTime? start,
      DateTime? end,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $MaintenanceEmailCopyWith<$Res>? get email;
  @override
  $MaintenancePushCopyWith<$Res>? get push;
}

/// @nodoc
class __$MaintenanceCopyWithImpl<$Res> extends _$MaintenanceCopyWithImpl<$Res>
    implements _$MaintenanceCopyWith<$Res> {
  __$MaintenanceCopyWithImpl(
      _Maintenance _value, $Res Function(_Maintenance) _then)
      : super(_value, (v) => _then(v as _Maintenance));

  @override
  _Maintenance get _value => super._value as _Maintenance;

  @override
  $Res call({
    Object? message = freezed,
    Object? allowOperations = freezed,
    Object? image = freezed,
    Object? email = freezed,
    Object? push = freezed,
    Object? createdBy = freezed,
    Object? start = freezed,
    Object? end = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_Maintenance(
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      allowOperations: allowOperations == freezed
          ? _value.allowOperations
          : allowOperations // ignore: cast_nullable_to_non_nullable
              as bool?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as MaintenanceEmail?,
      push: push == freezed
          ? _value.push
          : push // ignore: cast_nullable_to_non_nullable
              as MaintenancePush?,
      createdBy: createdBy == freezed
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      start: start == freezed
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: end == freezed
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Maintenance implements _Maintenance {
  _$_Maintenance(
      {this.message,
      this.allowOperations,
      this.image,
      this.email,
      this.push,
      this.createdBy,
      this.start,
      this.end,
      this.createdAt,
      this.updatedAt});

  factory _$_Maintenance.fromJson(Map<String, dynamic> json) =>
      _$$_MaintenanceFromJson(json);

  @override
  final String? message;
  @override
  final bool? allowOperations;
  @override
  final String? image;
  @override
  final MaintenanceEmail? email;
  @override
  final MaintenancePush? push;
  @override
  final String? createdBy;
  @override
  final DateTime? start;
  @override
  final DateTime? end;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Maintenance(message: $message, allowOperations: $allowOperations, image: $image, email: $email, push: $push, createdBy: $createdBy, start: $start, end: $end, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Maintenance &&
            const DeepCollectionEquality().equals(other.message, message) &&
            const DeepCollectionEquality()
                .equals(other.allowOperations, allowOperations) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.push, push) &&
            const DeepCollectionEquality().equals(other.createdBy, createdBy) &&
            const DeepCollectionEquality().equals(other.start, start) &&
            const DeepCollectionEquality().equals(other.end, end) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(message),
      const DeepCollectionEquality().hash(allowOperations),
      const DeepCollectionEquality().hash(image),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(push),
      const DeepCollectionEquality().hash(createdBy),
      const DeepCollectionEquality().hash(start),
      const DeepCollectionEquality().hash(end),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(updatedAt));

  @JsonKey(ignore: true)
  @override
  _$MaintenanceCopyWith<_Maintenance> get copyWith =>
      __$MaintenanceCopyWithImpl<_Maintenance>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MaintenanceToJson(this);
  }
}

abstract class _Maintenance implements Maintenance {
  factory _Maintenance(
      {String? message,
      bool? allowOperations,
      String? image,
      MaintenanceEmail? email,
      MaintenancePush? push,
      String? createdBy,
      DateTime? start,
      DateTime? end,
      DateTime? createdAt,
      DateTime? updatedAt}) = _$_Maintenance;

  factory _Maintenance.fromJson(Map<String, dynamic> json) =
      _$_Maintenance.fromJson;

  @override
  String? get message;
  @override
  bool? get allowOperations;
  @override
  String? get image;
  @override
  MaintenanceEmail? get email;
  @override
  MaintenancePush? get push;
  @override
  String? get createdBy;
  @override
  DateTime? get start;
  @override
  DateTime? get end;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$MaintenanceCopyWith<_Maintenance> get copyWith =>
      throw _privateConstructorUsedError;
}
