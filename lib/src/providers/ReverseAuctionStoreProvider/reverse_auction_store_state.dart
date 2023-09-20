import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ReverseAuctionStoreState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? reverseAuctionStoreListData;
  final Map<String, dynamic>? reverseAuctionStoreMetaData;
  final bool? isRefresh;

  ReverseAuctionStoreState({
    @required this.progressState,
    @required this.message,
    @required this.reverseAuctionStoreListData,
    @required this.reverseAuctionStoreMetaData,
    @required this.isRefresh,
  });

  factory ReverseAuctionStoreState.init() {
    return ReverseAuctionStoreState(
      progressState: 0,
      message: "",
      reverseAuctionStoreListData: [],
      reverseAuctionStoreMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  ReverseAuctionStoreState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? reverseAuctionStoreListData,
    Map<String, dynamic>? reverseAuctionStoreMetaData,
    bool? isRefresh,
  }) {
    return ReverseAuctionStoreState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      reverseAuctionStoreListData: reverseAuctionStoreListData ?? this.reverseAuctionStoreListData,
      reverseAuctionStoreMetaData: reverseAuctionStoreMetaData ?? this.reverseAuctionStoreMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  ReverseAuctionStoreState update({
    int? progressState,
    String? message,
    List<dynamic>? reverseAuctionStoreListData,
    Map<String, dynamic>? reverseAuctionStoreMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      reverseAuctionStoreListData: reverseAuctionStoreListData,
      reverseAuctionStoreMetaData: reverseAuctionStoreMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "reverseAuctionStoreListData": reverseAuctionStoreListData,
      "reverseAuctionStoreMetaData": reverseAuctionStoreMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        reverseAuctionStoreListData!,
        reverseAuctionStoreMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
