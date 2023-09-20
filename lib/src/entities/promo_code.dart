import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/entities/converters/string_to_double.dart';

part 'promo_code.freezed.dart';
part 'promo_code.g.dart';

@freezed
class PromoCode with _$PromoCode {
  factory PromoCode({
    @JsonKey(name: "_id") String? id,
    String? name,
    @JsonKey(name: "promocodeCode") String? code,
    String? description,
    @JsonKey(name: "promocodeValue") @String2DoubleConverter() double? value,
    @JsonKey(name: "promocodeType") String? type,
    int? noOfTimesAppliedByUser,
    int? noOfTimesCanApply,
    int? orderNumberAppliedTo,
    DateTime? validityStartDate,
    DateTime? validityEndDate,
    String? termscondition,
    @String2DoubleConverter() double? minimumorder,
    @String2DoubleConverter() double? maximumDiscount,
    List<dynamic>? categoriesAppliedFor,
    List<dynamic>? images,
    List<dynamic>? loadedImages,
    List<String>? userIds,
    List<String>? storeIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PromoCode;
  factory PromoCode.fromJson(Map<String, dynamic> json) => _$PromoCodeFromJson(json);
}
