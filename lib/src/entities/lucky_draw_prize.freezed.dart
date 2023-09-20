// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'lucky_draw_prize.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LuckyDrawPrize _$LuckyDrawPrizeFromJson(Map<String, dynamic> json) {
  return _LuckyDrawPrize.fromJson(json);
}

/// @nodoc
class _$LuckyDrawPrizeTearOff {
  const _$LuckyDrawPrizeTearOff();

  _LuckyDrawPrize call(
      {@JsonKey(name: "_id") String? id,
      String? rewardType,
      double? amount,
      double? maxAmount}) {
    return _LuckyDrawPrize(
      id: id,
      rewardType: rewardType,
      amount: amount,
      maxAmount: maxAmount,
    );
  }

  LuckyDrawPrize fromJson(Map<String, Object?> json) {
    return LuckyDrawPrize.fromJson(json);
  }
}

/// @nodoc
const $LuckyDrawPrize = _$LuckyDrawPrizeTearOff();

/// @nodoc
mixin _$LuckyDrawPrize {
  @JsonKey(name: "_id")
  String? get id => throw _privateConstructorUsedError;
  String? get rewardType => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  double? get maxAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LuckyDrawPrizeCopyWith<LuckyDrawPrize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LuckyDrawPrizeCopyWith<$Res> {
  factory $LuckyDrawPrizeCopyWith(
          LuckyDrawPrize value, $Res Function(LuckyDrawPrize) then) =
      _$LuckyDrawPrizeCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: "_id") String? id,
      String? rewardType,
      double? amount,
      double? maxAmount});
}

/// @nodoc
class _$LuckyDrawPrizeCopyWithImpl<$Res>
    implements $LuckyDrawPrizeCopyWith<$Res> {
  _$LuckyDrawPrizeCopyWithImpl(this._value, this._then);

  final LuckyDrawPrize _value;
  // ignore: unused_field
  final $Res Function(LuckyDrawPrize) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? rewardType = freezed,
    Object? amount = freezed,
    Object? maxAmount = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      rewardType: rewardType == freezed
          ? _value.rewardType
          : rewardType // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      maxAmount: maxAmount == freezed
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
abstract class _$LuckyDrawPrizeCopyWith<$Res>
    implements $LuckyDrawPrizeCopyWith<$Res> {
  factory _$LuckyDrawPrizeCopyWith(
          _LuckyDrawPrize value, $Res Function(_LuckyDrawPrize) then) =
      __$LuckyDrawPrizeCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: "_id") String? id,
      String? rewardType,
      double? amount,
      double? maxAmount});
}

/// @nodoc
class __$LuckyDrawPrizeCopyWithImpl<$Res>
    extends _$LuckyDrawPrizeCopyWithImpl<$Res>
    implements _$LuckyDrawPrizeCopyWith<$Res> {
  __$LuckyDrawPrizeCopyWithImpl(
      _LuckyDrawPrize _value, $Res Function(_LuckyDrawPrize) _then)
      : super(_value, (v) => _then(v as _LuckyDrawPrize));

  @override
  _LuckyDrawPrize get _value => super._value as _LuckyDrawPrize;

  @override
  $Res call({
    Object? id = freezed,
    Object? rewardType = freezed,
    Object? amount = freezed,
    Object? maxAmount = freezed,
  }) {
    return _then(_LuckyDrawPrize(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      rewardType: rewardType == freezed
          ? _value.rewardType
          : rewardType // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      maxAmount: maxAmount == freezed
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LuckyDrawPrize implements _LuckyDrawPrize {
  _$_LuckyDrawPrize(
      {@JsonKey(name: "_id") this.id,
      this.rewardType,
      this.amount,
      this.maxAmount});

  factory _$_LuckyDrawPrize.fromJson(Map<String, dynamic> json) =>
      _$$_LuckyDrawPrizeFromJson(json);

  @override
  @JsonKey(name: "_id")
  final String? id;
  @override
  final String? rewardType;
  @override
  final double? amount;
  @override
  final double? maxAmount;

  @override
  String toString() {
    return 'LuckyDrawPrize(id: $id, rewardType: $rewardType, amount: $amount, maxAmount: $maxAmount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LuckyDrawPrize &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.rewardType, rewardType) &&
            const DeepCollectionEquality().equals(other.amount, amount) &&
            const DeepCollectionEquality().equals(other.maxAmount, maxAmount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(rewardType),
      const DeepCollectionEquality().hash(amount),
      const DeepCollectionEquality().hash(maxAmount));

  @JsonKey(ignore: true)
  @override
  _$LuckyDrawPrizeCopyWith<_LuckyDrawPrize> get copyWith =>
      __$LuckyDrawPrizeCopyWithImpl<_LuckyDrawPrize>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LuckyDrawPrizeToJson(this);
  }
}

abstract class _LuckyDrawPrize implements LuckyDrawPrize {
  factory _LuckyDrawPrize(
      {@JsonKey(name: "_id") String? id,
      String? rewardType,
      double? amount,
      double? maxAmount}) = _$_LuckyDrawPrize;

  factory _LuckyDrawPrize.fromJson(Map<String, dynamic> json) =
      _$_LuckyDrawPrize.fromJson;

  @override
  @JsonKey(name: "_id")
  String? get id;
  @override
  String? get rewardType;
  @override
  double? get amount;
  @override
  double? get maxAmount;
  @override
  @JsonKey(ignore: true)
  _$LuckyDrawPrizeCopyWith<_LuckyDrawPrize> get copyWith =>
      throw _privateConstructorUsedError;
}
