import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_email.freezed.dart';
part 'maintenance_email.g.dart';

@freezed
class MaintenanceEmail with _$MaintenanceEmail {
  factory MaintenanceEmail({
    String? subject,
    String? body,
  }) = _MaintenanceEmail;
  factory MaintenanceEmail.fromJson(Map<String, dynamic> json) => _$MaintenanceEmailFromJson(json);
}
