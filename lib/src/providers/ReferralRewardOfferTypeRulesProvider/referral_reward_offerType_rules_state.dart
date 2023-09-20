import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ReferralRewardOfferTypeRulesState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? storeReferralData;
  final Map<String, dynamic>? userReferralData;

  ReferralRewardOfferTypeRulesState({
    @required this.progressState,
    @required this.message,
    @required this.storeReferralData,
    @required this.userReferralData,
  });

  factory ReferralRewardOfferTypeRulesState.init() {
    return ReferralRewardOfferTypeRulesState(
      progressState: 0,
      message: "",
      storeReferralData: Map<String, dynamic>(),
      userReferralData: Map<String, dynamic>(),
    );
  }

  ReferralRewardOfferTypeRulesState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeReferralData,
    Map<String, dynamic>? userReferralData,
  }) {
    return ReferralRewardOfferTypeRulesState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      storeReferralData: storeReferralData ?? this.storeReferralData,
      userReferralData: userReferralData ?? this.userReferralData,
    );
  }

  ReferralRewardOfferTypeRulesState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeReferralData,
    Map<String, dynamic>? userReferralData,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      storeReferralData: storeReferralData,
      userReferralData: userReferralData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "storeReferralData": storeReferralData,
      "userReferralData": userReferralData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        storeReferralData!,
        userReferralData!,
      ];

  @override
  bool get stringify => true;
}
