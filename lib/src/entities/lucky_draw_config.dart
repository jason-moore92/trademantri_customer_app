import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/entities/lucky_draw_entry.dart';
import 'package:trapp/src/entities/lucky_draw_prize.dart';
import 'package:trapp/src/entities/note.dart';
import 'package:trapp/src/models/index.dart';

part 'lucky_draw_config.freezed.dart';
part 'lucky_draw_config.g.dart';

@freezed
class LuckyDrawConfig with _$LuckyDrawConfig {
  factory LuckyDrawConfig({
    @JsonKey(name: "_id") String? id,
    String? createdBy,
    DateTime? start,
    DateTime? end,
    bool? winnersSelected,
    List<LuckyDrawPrize>? prizes,
    List<LuckyDrawEntry>? entries,
    List<Note>? notes,
    UserModel? createdByUser,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? entriesCount,
  }) = _LuckyDrawConfig;
  factory LuckyDrawConfig.fromJson(Map<String, dynamic> json) => _$LuckyDrawConfigFromJson(json);
}
