// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lucky_draw_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LuckyDrawEntry _$$_LuckyDrawEntryFromJson(Map<String, dynamic> json) =>
    _$_LuckyDrawEntry(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      storeId: json['storeId'] as String?,
      orderId: json['orderId'] as String?,
      configId: json['configId'] as String?,
      winner: json['winner'] as bool?,
      winnerPosition: json['winnerPosition'] as int?,
      rewardPoints: (json['rewardPoints'] as num?)?.toDouble(),
      rewardAmount: (json['rewardAmount'] as num?)?.toDouble(),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$_LuckyDrawEntryToJson(_$_LuckyDrawEntry instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'storeId': instance.storeId,
      'orderId': instance.orderId,
      'configId': instance.configId,
      'winner': instance.winner,
      'winnerPosition': instance.winnerPosition,
      'rewardPoints': instance.rewardPoints,
      'rewardAmount': instance.rewardAmount,
      'user': instance.user,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
