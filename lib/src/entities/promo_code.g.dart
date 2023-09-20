// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PromoCode _$$_PromoCodeFromJson(Map<String, dynamic> json) => _$_PromoCode(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      code: json['promocodeCode'] as String?,
      description: json['description'] as String?,
      value: const String2DoubleConverter()
          .fromJson(json['promocodeValue'] as String?),
      type: json['promocodeType'] as String?,
      noOfTimesAppliedByUser: json['noOfTimesAppliedByUser'] as int?,
      noOfTimesCanApply: json['noOfTimesCanApply'] as int?,
      orderNumberAppliedTo: json['orderNumberAppliedTo'] as int?,
      validityStartDate: json['validityStartDate'] == null
          ? null
          : DateTime.parse(json['validityStartDate'] as String),
      validityEndDate: json['validityEndDate'] == null
          ? null
          : DateTime.parse(json['validityEndDate'] as String),
      termscondition: json['termscondition'] as String?,
      minimumorder: const String2DoubleConverter()
          .fromJson(json['minimumorder'] as String?),
      maximumDiscount: const String2DoubleConverter()
          .fromJson(json['maximumDiscount'] as String?),
      categoriesAppliedFor: json['categoriesAppliedFor'] as List<dynamic>?,
      images: json['images'] as List<dynamic>?,
      loadedImages: json['loadedImages'] as List<dynamic>?,
      userIds:
          (json['userIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      storeIds: (json['storeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$_PromoCodeToJson(_$_PromoCode instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'promocodeCode': instance.code,
      'description': instance.description,
      'promocodeValue': const String2DoubleConverter().toJson(instance.value),
      'promocodeType': instance.type,
      'noOfTimesAppliedByUser': instance.noOfTimesAppliedByUser,
      'noOfTimesCanApply': instance.noOfTimesCanApply,
      'orderNumberAppliedTo': instance.orderNumberAppliedTo,
      'validityStartDate': instance.validityStartDate?.toIso8601String(),
      'validityEndDate': instance.validityEndDate?.toIso8601String(),
      'termscondition': instance.termscondition,
      'minimumorder':
          const String2DoubleConverter().toJson(instance.minimumorder),
      'maximumDiscount':
          const String2DoubleConverter().toJson(instance.maximumDiscount),
      'categoriesAppliedFor': instance.categoriesAppliedFor,
      'images': instance.images,
      'loadedImages': instance.loadedImages,
      'userIds': instance.userIds,
      'storeIds': instance.storeIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
