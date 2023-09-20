import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ReferralRewardU2SOffersState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? newReferralRewardU2SOffersData;
  final Map<String, dynamic>? referralRewardOffersListData;
  final Map<String, dynamic>? referralRewardOffersMetaData;
  final bool? isRefresh;

  ReferralRewardU2SOffersState({
    @required this.progressState,
    @required this.message,
    @required this.newReferralRewardU2SOffersData,
    @required this.referralRewardOffersListData,
    @required this.referralRewardOffersMetaData,
    @required this.isRefresh,
  });

  factory ReferralRewardU2SOffersState.init() {
    return ReferralRewardU2SOffersState(
      progressState: 0,
      message: "",
      newReferralRewardU2SOffersData: Map<String, dynamic>(),
      referralRewardOffersListData: Map<String, dynamic>(),
      referralRewardOffersMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  ReferralRewardU2SOffersState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? newReferralRewardU2SOffersData,
    Map<String, dynamic>? referralRewardOffersListData,
    Map<String, dynamic>? referralRewardOffersMetaData,
    bool? isRefresh,
  }) {
    return ReferralRewardU2SOffersState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      newReferralRewardU2SOffersData: newReferralRewardU2SOffersData ?? this.newReferralRewardU2SOffersData,
      referralRewardOffersListData: referralRewardOffersListData ?? this.referralRewardOffersListData,
      referralRewardOffersMetaData: referralRewardOffersMetaData ?? this.referralRewardOffersMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  ReferralRewardU2SOffersState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? newReferralRewardU2SOffersData,
    Map<String, dynamic>? referralRewardOffersListData,
    Map<String, dynamic>? referralRewardOffersMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      newReferralRewardU2SOffersData: newReferralRewardU2SOffersData,
      referralRewardOffersListData: referralRewardOffersListData,
      referralRewardOffersMetaData: referralRewardOffersMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "newReferralRewardU2SOffersData": newReferralRewardU2SOffersData,
      "referralRewardOffersListData": referralRewardOffersListData,
      "referralRewardOffersMetaData": referralRewardOffersMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        newReferralRewardU2SOffersData!,
        referralRewardOffersListData!,
        referralRewardOffersMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
