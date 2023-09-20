import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/models/index.dart';

part 'lucky_draw_prize.freezed.dart';
part 'lucky_draw_prize.g.dart';

@freezed
class LuckyDrawPrize with _$LuckyDrawPrize {
  factory LuckyDrawPrize({
    @JsonKey(name: "_id") String? id,
    String? rewardType,
    double? amount,
    double? maxAmount,
  }) = _LuckyDrawPrize;
  factory LuckyDrawPrize.fromJson(Map<String, dynamic> json) => _$LuckyDrawPrizeFromJson(json);
}
