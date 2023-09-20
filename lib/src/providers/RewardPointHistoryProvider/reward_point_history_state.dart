import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class RewardPointHistoryState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final int? sumRewardPoint;
  final int? sumTradeManttriRewardPoint;
  final List<dynamic>? rewardPointListData;
  final Map<String, dynamic>? rewardPointMetaData;
  final bool? isRefresh;

  RewardPointHistoryState({
    @required this.message,
    @required this.progressState,
    @required this.sumRewardPoint,
    @required this.sumTradeManttriRewardPoint,
    @required this.rewardPointListData,
    @required this.rewardPointMetaData,
    @required this.isRefresh,
  });

  factory RewardPointHistoryState.init() {
    return RewardPointHistoryState(
      progressState: 0,
      message: "",
      sumRewardPoint: 0,
      sumTradeManttriRewardPoint: 0,
      rewardPointListData: [],
      rewardPointMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  RewardPointHistoryState copyWith({
    int? progressState,
    String? message,
    int? sumRewardPoint,
    int? sumTradeManttriRewardPoint,
    List<dynamic>? rewardPointListData,
    Map<String, dynamic>? rewardPointMetaData,
    bool? isRefresh,
  }) {
    return RewardPointHistoryState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      sumRewardPoint: sumRewardPoint ?? this.sumRewardPoint,
      sumTradeManttriRewardPoint: sumTradeManttriRewardPoint ?? this.sumTradeManttriRewardPoint,
      rewardPointListData: rewardPointListData ?? this.rewardPointListData,
      rewardPointMetaData: rewardPointMetaData ?? this.rewardPointMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  RewardPointHistoryState update({
    int? progressState,
    String? message,
    int? sumRewardPoint,
    int? sumTradeManttriRewardPoint,
    List<dynamic>? rewardPointListData,
    Map<String, dynamic>? rewardPointMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      sumRewardPoint: sumRewardPoint,
      sumTradeManttriRewardPoint: sumTradeManttriRewardPoint,
      rewardPointListData: rewardPointListData,
      rewardPointMetaData: rewardPointMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "sumRewardPoint": sumRewardPoint,
      "sumTradeManttriRewardPoint": sumTradeManttriRewardPoint,
      "rewardPointListData": rewardPointListData,
      "rewardPointMetaData": rewardPointMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        sumRewardPoint!,
        sumTradeManttriRewardPoint!,
        rewardPointListData!,
        rewardPointMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
