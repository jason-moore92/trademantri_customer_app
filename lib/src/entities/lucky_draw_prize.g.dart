// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lucky_draw_prize.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LuckyDrawPrize _$$_LuckyDrawPrizeFromJson(Map<String, dynamic> json) =>
    _$_LuckyDrawPrize(
      id: json['_id'] as String?,
      rewardType: json['rewardType'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      maxAmount: (json['maxAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$_LuckyDrawPrizeToJson(_$_LuckyDrawPrize instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'rewardType': instance.rewardType,
      'amount': instance.amount,
      'maxAmount': instance.maxAmount,
    };
