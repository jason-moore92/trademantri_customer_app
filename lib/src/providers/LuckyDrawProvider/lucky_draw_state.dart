import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/entities/lucky_draw_config.dart';

class LuckyDrawState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final LuckyDrawConfig? luckyDrawConfig;
  final bool? isUpdated;

  LuckyDrawState({
    @required this.progressState,
    @required this.message,
    @required this.luckyDrawConfig,
    @required this.isUpdated,
  });

  factory LuckyDrawState.init() {
    return LuckyDrawState(
      progressState: 0,
      message: "",
      luckyDrawConfig: LuckyDrawConfig.fromJson({}),
      isUpdated: false,
    );
  }

  LuckyDrawState copyWith({
    int? progressState,
    String? message,
    LuckyDrawConfig? luckyDrawConfig,
    bool? isUpdated,
  }) {
    return LuckyDrawState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      luckyDrawConfig: luckyDrawConfig ?? this.luckyDrawConfig,
      isUpdated: isUpdated ?? this.isUpdated,
    );
  }

  LuckyDrawState update({
    int? progressState,
    String? message,
    LuckyDrawConfig? luckyDrawConfig,
    bool? isUpdated,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      luckyDrawConfig: luckyDrawConfig,
      isUpdated: isUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "luckyDrawConfig": luckyDrawConfig,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        luckyDrawConfig!,
        isUpdated!,
      ];

  @override
  bool get stringify => true;
}
