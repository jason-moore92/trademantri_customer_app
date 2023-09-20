// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lucky_draw_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LuckyDrawConfig _$$_LuckyDrawConfigFromJson(Map<String, dynamic> json) =>
    _$_LuckyDrawConfig(
      id: json['_id'] as String?,
      createdBy: json['createdBy'] as String?,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      winnersSelected: json['winnersSelected'] as bool?,
      prizes: (json['prizes'] as List<dynamic>?)
          ?.map((e) => LuckyDrawPrize.fromJson(e as Map<String, dynamic>))
          .toList(),
      entries: (json['entries'] as List<dynamic>?)
          ?.map((e) => LuckyDrawEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: (json['notes'] as List<dynamic>?)
          ?.map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdByUser: json['createdByUser'] == null
          ? null
          : UserModel.fromJson(json['createdByUser'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      entriesCount: json['entriesCount'] as int?,
    );

Map<String, dynamic> _$$_LuckyDrawConfigToJson(_$_LuckyDrawConfig instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'createdBy': instance.createdBy,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'winnersSelected': instance.winnersSelected,
      'prizes': instance.prizes,
      'entries': instance.entries,
      'notes': instance.notes,
      'createdByUser': instance.createdByUser,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'entriesCount': instance.entriesCount,
    };
