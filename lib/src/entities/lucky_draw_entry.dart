import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/models/index.dart';

part 'lucky_draw_entry.freezed.dart';
part 'lucky_draw_entry.g.dart';

@freezed
class LuckyDrawEntry with _$LuckyDrawEntry {
  factory LuckyDrawEntry({
    @JsonKey(name: "_id") String? id,
    String? userId,
    String? storeId,
    String? orderId,
    String? configId,
    bool? winner,
    int? winnerPosition,
    double? rewardPoints,
    double? rewardAmount,
    UserModel? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LuckyDrawEntry;
  factory LuckyDrawEntry.fromJson(Map<String, dynamic> json) => _$LuckyDrawEntryFromJson(json);
}
