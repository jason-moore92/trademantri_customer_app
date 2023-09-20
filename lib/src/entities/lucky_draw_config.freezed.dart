// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'lucky_draw_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LuckyDrawConfig _$LuckyDrawConfigFromJson(Map<String, dynamic> json) {
  return _LuckyDrawConfig.fromJson(json);
}

/// @nodoc
class _$LuckyDrawConfigTearOff {
  const _$LuckyDrawConfigTearOff();

  _LuckyDrawConfig call(
      {@JsonKey(name: "_id") String? id,
      String? createdBy,
      DateTime? start,
      DateTime? end,
      bool? winnersSelected,
      List<LuckyDrawPrize>? prizes,
      List<LuckyDrawEntry>? entries,
      List<Note>? notes,
      UserModel? createdByUser,
      DateTime? createdAt,
      DateTime? updatedAt,
      int? entriesCount}) {
    return _LuckyDrawConfig(
      id: id,
      createdBy: createdBy,
      start: start,
      end: end,
      winnersSelected: winnersSelected,
      prizes: prizes,
      entries: entries,
      notes: notes,
      createdByUser: createdByUser,
      createdAt: createdAt,
      updatedAt: updatedAt,
      entriesCount: entriesCount,
    );
  }

  LuckyDrawConfig fromJson(Map<String, Object?> json) {
    return LuckyDrawConfig.fromJson(json);
  }
}

/// @nodoc
const $LuckyDrawConfig = _$LuckyDrawConfigTearOff();

/// @nodoc
mixin _$LuckyDrawConfig {
  @JsonKey(name: "_id")
  String? get id => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get start => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;
  bool? get winnersSelected => throw _privateConstructorUsedError;
  List<LuckyDrawPrize>? get prizes => throw _privateConstructorUsedError;
  List<LuckyDrawEntry>? get entries => throw _privateConstructorUsedError;
  List<Note>? get notes => throw _privateConstructorUsedError;
  UserModel? get createdByUser => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int? get entriesCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LuckyDrawConfigCopyWith<LuckyDrawConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LuckyDrawConfigCopyWith<$Res> {
  factory $LuckyDrawConfigCopyWith(
          LuckyDrawConfig value, $Res Function(LuckyDrawConfig) then) =
      _$LuckyDrawConfigCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: "_id") String? id,
      String? createdBy,
      DateTime? start,
      DateTime? end,
      bool? winnersSelected,
      List<LuckyDrawPrize>? prizes,
      List<LuckyDrawEntry>? entries,
      List<Note>? notes,
      UserModel? createdByUser,
      DateTime? createdAt,
      DateTime? updatedAt,
      int? entriesCount});
}

/// @nodoc
class _$LuckyDrawConfigCopyWithImpl<$Res>
    implements $LuckyDrawConfigCopyWith<$Res> {
  _$LuckyDrawConfigCopyWithImpl(this._value, this._then);

  final LuckyDrawConfig _value;
  // ignore: unused_field
  final $Res Function(LuckyDrawConfig) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? createdBy = freezed,
    Object? start = freezed,
    Object? end = freezed,
    Object? winnersSelected = freezed,
    Object? prizes = freezed,
    Object? entries = freezed,
    Object? notes = freezed,
    Object? createdByUser = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? entriesCount = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      winnersSelected: winnersSelected == freezed
          ? _value.winnersSelected
          : winnersSelected // ignore: cast_nullable_to_non_nullable
              as bool?,
      prizes: prizes == freezed
          ? _value.prizes
          : prizes // ignore: cast_nullable_to_non_nullable
              as List<LuckyDrawPrize>?,
      entries: entries == freezed
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<LuckyDrawEntry>?,
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<Note>?,
      createdByUser: createdByUser == freezed
          ? _value.createdByUser
          : createdByUser // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      entriesCount: entriesCount == freezed
          ? _value.entriesCount
          : entriesCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$LuckyDrawConfigCopyWith<$Res>
    implements $LuckyDrawConfigCopyWith<$Res> {
  factory _$LuckyDrawConfigCopyWith(
          _LuckyDrawConfig value, $Res Function(_LuckyDrawConfig) then) =
      __$LuckyDrawConfigCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: "_id") String? id,
      String? createdBy,
      DateTime? start,
      DateTime? end,
      bool? winnersSelected,
      List<LuckyDrawPrize>? prizes,
      List<LuckyDrawEntry>? entries,
      List<Note>? notes,
      UserModel? createdByUser,
      DateTime? createdAt,
      DateTime? updatedAt,
      int? entriesCount});
}

/// @nodoc
class __$LuckyDrawConfigCopyWithImpl<$Res>
    extends _$LuckyDrawConfigCopyWithImpl<$Res>
    implements _$LuckyDrawConfigCopyWith<$Res> {
  __$LuckyDrawConfigCopyWithImpl(
      _LuckyDrawConfig _value, $Res Function(_LuckyDrawConfig) _then)
      : super(_value, (v) => _then(v as _LuckyDrawConfig));

  @override
  _LuckyDrawConfig get _value => super._value as _LuckyDrawConfig;

  @override
  $Res call({
    Object? id = freezed,
    Object? createdBy = freezed,
    Object? start = freezed,
    Object? end = freezed,
    Object? winnersSelected = freezed,
    Object? prizes = freezed,
    Object? entries = freezed,
    Object? notes = freezed,
    Object? createdByUser = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? entriesCount = freezed,
  }) {
    return _then(_LuckyDrawConfig(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      winnersSelected: winnersSelected == freezed
          ? _value.winnersSelected
          : winnersSelected // ignore: cast_nullable_to_non_nullable
              as bool?,
      prizes: prizes == freezed
          ? _value.prizes
          : prizes // ignore: cast_nullable_to_non_nullable
              as List<LuckyDrawPrize>?,
      entries: entries == freezed
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<LuckyDrawEntry>?,
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<Note>?,
      createdByUser: createdByUser == freezed
          ? _value.createdByUser
          : createdByUser // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      entriesCount: entriesCount == freezed
          ? _value.entriesCount
          : entriesCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LuckyDrawConfig implements _LuckyDrawConfig {
  _$_LuckyDrawConfig(
      {@JsonKey(name: "_id") this.id,
      this.createdBy,
      this.start,
      this.end,
      this.winnersSelected,
      this.prizes,
      this.entries,
      this.notes,
      this.createdByUser,
      this.createdAt,
      this.updatedAt,
      this.entriesCount});

  factory _$_LuckyDrawConfig.fromJson(Map<String, dynamic> json) =>
      _$$_LuckyDrawConfigFromJson(json);

  @override
  @JsonKey(name: "_id")
  final String? id;
  @override
  final String? createdBy;
  @override
  final DateTime? start;
  @override
  final DateTime? end;
  @override
  final bool? winnersSelected;
  @override
  final List<LuckyDrawPrize>? prizes;
  @override
  final List<LuckyDrawEntry>? entries;
  @override
  final List<Note>? notes;
  @override
  final UserModel? createdByUser;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final int? entriesCount;

  @override
  String toString() {
    return 'LuckyDrawConfig(id: $id, createdBy: $createdBy, start: $start, end: $end, winnersSelected: $winnersSelected, prizes: $prizes, entries: $entries, notes: $notes, createdByUser: $createdByUser, createdAt: $createdAt, updatedAt: $updatedAt, entriesCount: $entriesCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LuckyDrawConfig &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.createdBy, createdBy) &&
            const DeepCollectionEquality().equals(other.start, start) &&
            const DeepCollectionEquality().equals(other.end, end) &&
            const DeepCollectionEquality()
                .equals(other.winnersSelected, winnersSelected) &&
            const DeepCollectionEquality().equals(other.prizes, prizes) &&
            const DeepCollectionEquality().equals(other.entries, entries) &&
            const DeepCollectionEquality().equals(other.notes, notes) &&
            const DeepCollectionEquality()
                .equals(other.createdByUser, createdByUser) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            const DeepCollectionEquality()
                .equals(other.entriesCount, entriesCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(createdBy),
      const DeepCollectionEquality().hash(start),
      const DeepCollectionEquality().hash(end),
      const DeepCollectionEquality().hash(winnersSelected),
      const DeepCollectionEquality().hash(prizes),
      const DeepCollectionEquality().hash(entries),
      const DeepCollectionEquality().hash(notes),
      const DeepCollectionEquality().hash(createdByUser),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(updatedAt),
      const DeepCollectionEquality().hash(entriesCount));

  @JsonKey(ignore: true)
  @override
  _$LuckyDrawConfigCopyWith<_LuckyDrawConfig> get copyWith =>
      __$LuckyDrawConfigCopyWithImpl<_LuckyDrawConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LuckyDrawConfigToJson(this);
  }
}

abstract class _LuckyDrawConfig implements LuckyDrawConfig {
  factory _LuckyDrawConfig(
      {@JsonKey(name: "_id") String? id,
      String? createdBy,
      DateTime? start,
      DateTime? end,
      bool? winnersSelected,
      List<LuckyDrawPrize>? prizes,
      List<LuckyDrawEntry>? entries,
      List<Note>? notes,
      UserModel? createdByUser,
      DateTime? createdAt,
      DateTime? updatedAt,
      int? entriesCount}) = _$_LuckyDrawConfig;

  factory _LuckyDrawConfig.fromJson(Map<String, dynamic> json) =
      _$_LuckyDrawConfig.fromJson;

  @override
  @JsonKey(name: "_id")
  String? get id;
  @override
  String? get createdBy;
  @override
  DateTime? get start;
  @override
  DateTime? get end;
  @override
  bool? get winnersSelected;
  @override
  List<LuckyDrawPrize>? get prizes;
  @override
  List<LuckyDrawEntry>? get entries;
  @override
  List<Note>? get notes;
  @override
  UserModel? get createdByUser;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  int? get entriesCount;
  @override
  @JsonKey(ignore: true)
  _$LuckyDrawConfigCopyWith<_LuckyDrawConfig> get copyWith =>
      throw _privateConstructorUsedError;
}
