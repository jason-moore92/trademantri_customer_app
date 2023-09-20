import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class RewardPointState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? rewardPointData;

  RewardPointState({
    @required this.message,
    @required this.progressState,
    @required this.rewardPointData,
  });

  factory RewardPointState.init() {
    return RewardPointState(
      progressState: 0,
      message: "",
      rewardPointData: Map<String, dynamic>(),
    );
  }

  RewardPointState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? rewardPointData,
  }) {
    return RewardPointState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      rewardPointData: rewardPointData ?? this.rewardPointData,
    );
  }

  RewardPointState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? rewardPointData,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      rewardPointData: rewardPointData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "rewardPointData": rewardPointData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        rewardPointData!,
      ];

  @override
  bool get stringify => true;
}
