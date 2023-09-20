import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ScratchCardListState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? scratchCardListData;
  final Map<String, dynamic>? scratchCardMetaData;
  final bool? isRefresh;
  final double? sumRewardPoints;

  ScratchCardListState({
    @required this.progressState,
    @required this.message,
    @required this.scratchCardListData,
    @required this.scratchCardMetaData,
    @required this.isRefresh,
    @required this.sumRewardPoints,
  });

  factory ScratchCardListState.init() {
    return ScratchCardListState(
      progressState: 0,
      message: "",
      scratchCardListData: Map<String, dynamic>(),
      scratchCardMetaData: Map<String, dynamic>(),
      isRefresh: false,
      sumRewardPoints: -1,
    );
  }

  ScratchCardListState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? scratchCardListData,
    Map<String, dynamic>? scratchCardMetaData,
    bool? isRefresh,
    double? sumRewardPoints,
  }) {
    return ScratchCardListState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      scratchCardListData: scratchCardListData ?? this.scratchCardListData,
      scratchCardMetaData: scratchCardMetaData ?? this.scratchCardMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
      sumRewardPoints: sumRewardPoints ?? this.sumRewardPoints,
    );
  }

  ScratchCardListState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? scratchCardListData,
    Map<String, dynamic>? scratchCardMetaData,
    bool? isRefresh,
    double? sumRewardPoints,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      scratchCardListData: scratchCardListData,
      scratchCardMetaData: scratchCardMetaData,
      isRefresh: isRefresh,
      sumRewardPoints: sumRewardPoints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "scratchCardListData": scratchCardListData,
      "scratchCardMetaData": scratchCardMetaData,
      "isRefresh": isRefresh,
      "sumRewardPoints": sumRewardPoints,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        scratchCardListData!,
        scratchCardMetaData!,
        isRefresh!,
        sumRewardPoints!,
      ];

  @override
  bool get stringify => true;
}
