import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_push.freezed.dart';
part 'maintenance_push.g.dart';

@freezed
class MaintenancePush with _$MaintenancePush {
  factory MaintenancePush({
    String? title,
    String? body,
  }) = _MaintenancePush;
  factory MaintenancePush.fromJson(Map<String, dynamic> json) => _$MaintenancePushFromJson(json);
}
