import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/entities/maintenance_email.dart';
import 'package:trapp/src/entities/maintenance_push.dart';

part 'maintenance.freezed.dart';
part 'maintenance.g.dart';

@freezed
class Maintenance with _$Maintenance {
  factory Maintenance({
    String? message,
    bool? allowOperations,
    String? image,
    MaintenanceEmail? email,
    MaintenancePush? push,
    String? createdBy,
    DateTime? start,
    DateTime? end,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Maintenance;
  factory Maintenance.fromJson(Map<String, dynamic> json) => _$MaintenanceFromJson(json);
}
