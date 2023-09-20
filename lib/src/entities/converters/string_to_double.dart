import 'package:freezed_annotation/freezed_annotation.dart';

class String2DoubleConverter implements JsonConverter<double?, String?> {
  const String2DoubleConverter();

  @override
  double fromJson(String? json) {
    return json != null ? double.parse(json.toString()) : 0;
  }

  @override
  String toJson(double? data) => data.toString();
}
