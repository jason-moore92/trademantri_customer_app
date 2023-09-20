// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Maintenance _$$_MaintenanceFromJson(Map<String, dynamic> json) =>
    _$_Maintenance(
      message: json['message'] as String?,
      allowOperations: json['allowOperations'] as bool?,
      image: json['image'] as String?,
      email: json['email'] == null
          ? null
          : MaintenanceEmail.fromJson(json['email'] as Map<String, dynamic>),
      push: json['push'] == null
          ? null
          : MaintenancePush.fromJson(json['push'] as Map<String, dynamic>),
      createdBy: json['createdBy'] as String?,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$_MaintenanceToJson(_$_Maintenance instance) =>
    <String, dynamic>{
      'message': instance.message,
      'allowOperations': instance.allowOperations,
      'image': instance.image,
      'email': instance.email,
      'push': instance.push,
      'createdBy': instance.createdBy,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
