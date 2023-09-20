import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ReverseAuctionState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? reverseAuctionListData;
  final Map<String, dynamic>? reverseAuctionMetaData;
  final bool? isRefresh;

  ReverseAuctionState({
    @required this.progressState,
    @required this.message,
    @required this.reverseAuctionListData,
    @required this.reverseAuctionMetaData,
    @required this.isRefresh,
  });

  factory ReverseAuctionState.init() {
    return ReverseAuctionState(
      progressState: 0,
      message: "",
      reverseAuctionListData: Map<String, dynamic>(),
      reverseAuctionMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  ReverseAuctionState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? reverseAuctionListData,
    Map<String, dynamic>? reverseAuctionMetaData,
    bool? isRefresh,
  }) {
    return ReverseAuctionState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      reverseAuctionListData: reverseAuctionListData ?? this.reverseAuctionListData,
      reverseAuctionMetaData: reverseAuctionMetaData ?? this.reverseAuctionMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  ReverseAuctionState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? reverseAuctionListData,
    Map<String, dynamic>? reverseAuctionMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      reverseAuctionListData: reverseAuctionListData,
      reverseAuctionMetaData: reverseAuctionMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "reverseAuctionListData": reverseAuctionListData,
      "reverseAuctionMetaData": reverseAuctionMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        reverseAuctionListData!,
        reverseAuctionMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
