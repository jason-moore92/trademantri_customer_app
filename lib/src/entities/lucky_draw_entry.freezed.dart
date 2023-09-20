// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'lucky_draw_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LuckyDrawEntry _$LuckyDrawEntryFromJson(Map<String, dynamic> json) {
  return _LuckyDrawEntry.fromJson(json);
}

/// @nodoc
class _$LuckyDrawEntryTearOff {
  const _$LuckyDrawEntryTearOff();

  _LuckyDrawEntry call(
      {@JsonKey(name: "_id") String? id,
      String? userId,
      String? storeId,
      String? orderId,
      String? configId,
      bool? winner,
      int? winnerPosition,
      double? rewardPoints,
      double? rewardAmount,
      UserModel? user,
      DateTime? createdAt,
      DateTime? updatedAt}) {
    return _LuckyDrawEntry(
      id: id,
      userId: userId,
      storeId: storeId,
      orderId: orderId,
      configId: configId,
      winner: winner,
      winnerPosition: winnerPosition,
      rewardPoints: rewardPoints,
      rewardAmount: rewardAmount,
      user: user,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  LuckyDrawEntry fromJson(Map<String, Object?> json) {
    return LuckyDrawEntry.fromJson(json);
  }
}

/// @nodoc
const $LuckyDrawEntry = _$LuckyDrawEntryTearOff();

/// @nodoc
mixin _$LuckyDrawEntry {
  @JsonKey(name: "_id")
  String? get id => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get orderId => throw _privateConstructorUsedError;
  String? get configId => throw _privateConstructorUsedError;
  bool? get winner => throw _privateConstructorUsedError;
  int? get winnerPosition => throw _privateConstructorUsedError;
  double? get rewardPoints => throw _privateConstructorUsedError;
  double? get rewardAmount => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LuckyDrawEntryCopyWith<LuckyDrawEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LuckyDrawEntryCopyWith<$Res> {
  factory $LuckyDrawEntryCopyWith(
          LuckyDrawEntry value, $Res Function(LuckyDrawEntry) then) =
      _$LuckyDrawEntryCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: "_id") String? id,
      String? userId,
      String? storeId,
      String? orderId,
      String? configId,
      bool? winner,
      int? winnerPosition,
      double? rewardPoints,
      double? rewardAmount,
      UserModel? user,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$LuckyDrawEntryCopyWithImpl<$Res>
    implements $LuckyDrawEntryCopyWith<$Res> {
  _$LuckyDrawEntryCopyWithImpl(this._value, this._then);

  final LuckyDrawEntry _value;
  // ignore: unused_field
  final $Res Function(LuckyDrawEntry) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? storeId = freezed,
    Object? orderId = freezed,
    Object? configId = freezed,
    Object? winner = freezed,
    Object? winnerPosition = freezed,
    Object? rewardPoints = freezed,
    Object? rewardAmount = freezed,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: storeId == freezed
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: orderId == freezed
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      configId: configId == freezed
          ? _value.configId
          : configId // ignore: cast_nullable_to_non_nullable
              as String?,
      winner: winner == freezed
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as bool?,
      winnerPosition: winnerPosition == freezed
          ? _value.winnerPosition
          : winnerPosition // ignore: cast_nullable_to_non_nullable
              as int?,
      rewardPoints: rewardPoints == freezed
          ? _value.rewardPoints
          : rewardPoints // ignore: cast_nullable_to_non_nullable
              as double?,
      rewardAmount: rewardAmount == freezed
          ? _value.rewardAmount
          : rewardAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
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
abstract class _$LuckyDrawEntryCopyWith<$Res>
    implements $LuckyDrawEntryCopyWith<$Res> {
  factory _$LuckyDrawEntryCopyWith(
          _LuckyDrawEntry value, $Res Function(_LuckyDrawEntry) then) =
      __$LuckyDrawEntryCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: "_id") String? id,
      String? userId,
      String? storeId,
      String? orderId,
      String? configId,
      bool? winner,
      int? winnerPosition,
      double? rewardPoints,
      double? rewardAmount,
      UserModel? user,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$LuckyDrawEntryCopyWithImpl<$Res>
    extends _$LuckyDrawEntryCopyWithImpl<$Res>
    implements _$LuckyDrawEntryCopyWith<$Res> {
  __$LuckyDrawEntryCopyWithImpl(
      _LuckyDrawEntry _value, $Res Function(_LuckyDrawEntry) _then)
      : super(_value, (v) => _then(v as _LuckyDrawEntry));

  @override
  _LuckyDrawEntry get _value => super._value as _LuckyDrawEntry;

  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? storeId = freezed,
    Object? orderId = freezed,
    Object? configId = freezed,
    Object? winner = freezed,
    Object? winnerPosition = freezed,
    Object? rewardPoints = freezed,
    Object? rewardAmount = freezed,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_LuckyDrawEntry(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: storeId == freezed
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: orderId == freezed
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      configId: configId == freezed
          ? _value.configId
          : configId // ignore: cast_nullable_to_non_nullable
              as String?,
      winner: winner == freezed
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as bool?,
      winnerPosition: winnerPosition == freezed
          ? _value.winnerPosition
          : winnerPosition // ignore: cast_nullable_to_non_nullable
              as int?,
      rewardPoints: rewardPoints == freezed
          ? _value.rewardPoints
          : rewardPoints // ignore: cast_nullable_to_non_nullable
              as double?,
      rewardAmount: rewardAmount == freezed
          ? _value.rewardAmount
          : rewardAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
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
class _$_LuckyDrawEntry implements _LuckyDrawEntry {
  _$_LuckyDrawEntry(
      {@JsonKey(name: "_id") this.id,
      this.userId,
      this.storeId,
      this.orderId,
      this.configId,
      this.winner,
      this.winnerPosition,
      this.rewardPoints,
      this.rewardAmount,
      this.user,
      this.createdAt,
      this.updatedAt});

  factory _$_LuckyDrawEntry.fromJson(Map<String, dynamic> json) =>
      _$$_LuckyDrawEntryFromJson(json);

  @override
  @JsonKey(name: "_id")
  final String? id;
  @override
  final String? userId;
  @override
  final String? storeId;
  @override
  final String? orderId;
  @override
  final String? configId;
  @override
  final bool? winner;
  @override
  final int? winnerPosition;
  @override
  final double? rewardPoints;
  @override
  final double? rewardAmount;
  @override
  final UserModel? user;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'LuckyDrawEntry(id: $id, userId: $userId, storeId: $storeId, orderId: $orderId, configId: $configId, winner: $winner, winnerPosition: $winnerPosition, rewardPoints: $rewardPoints, rewardAmount: $rewardAmount, user: $user, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LuckyDrawEntry &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            const DeepCollectionEquality().equals(other.storeId, storeId) &&
            const DeepCollectionEquality().equals(other.orderId, orderId) &&
            const DeepCollectionEquality().equals(other.configId, configId) &&
            const DeepCollectionEquality().equals(other.winner, winner) &&
            const DeepCollectionEquality()
                .equals(other.winnerPosition, winnerPosition) &&
            const DeepCollectionEquality()
                .equals(other.rewardPoints, rewardPoints) &&
            const DeepCollectionEquality()
                .equals(other.rewardAmount, rewardAmount) &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(userId),
      const DeepCollectionEquality().hash(storeId),
      const DeepCollectionEquality().hash(orderId),
      const DeepCollectionEquality().hash(configId),
      const DeepCollectionEquality().hash(winner),
      const DeepCollectionEquality().hash(winnerPosition),
      const DeepCollectionEquality().hash(rewardPoints),
      const DeepCollectionEquality().hash(rewardAmount),
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(updatedAt));

  @JsonKey(ignore: true)
  @override
  _$LuckyDrawEntryCopyWith<_LuckyDrawEntry> get copyWith =>
      __$LuckyDrawEntryCopyWithImpl<_LuckyDrawEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LuckyDrawEntryToJson(this);
  }
}

abstract class _LuckyDrawEntry implements LuckyDrawEntry {
  factory _LuckyDrawEntry(
      {@JsonKey(name: "_id") String? id,
      String? userId,
      String? storeId,
      String? orderId,
      String? configId,
      bool? winner,
      int? winnerPosition,
      double? rewardPoints,
      double? rewardAmount,
      UserModel? user,
      DateTime? createdAt,
      DateTime? updatedAt}) = _$_LuckyDrawEntry;

  factory _LuckyDrawEntry.fromJson(Map<String, dynamic> json) =
      _$_LuckyDrawEntry.fromJson;

  @override
  @JsonKey(name: "_id")
  String? get id;
  @override
  String? get userId;
  @override
  String? get storeId;
  @override
  String? get orderId;
  @override
  String? get configId;
  @override
  bool? get winner;
  @override
  int? get winnerPosition;
  @override
  double? get rewardPoints;
  @override
  double? get rewardAmount;
  @override
  UserModel? get user;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$LuckyDrawEntryCopyWith<_LuckyDrawEntry> get copyWith =>
      throw _privateConstructorUsedError;
}
