import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class PaymentLinkState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? paymentLinkListData;
  final Map<String, dynamic>? paymentLinkMetaData;
  final bool? isRefresh;

  PaymentLinkState({
    @required this.progressState,
    @required this.message,
    @required this.paymentLinkListData,
    @required this.paymentLinkMetaData,
    @required this.isRefresh,
  });

  factory PaymentLinkState.init() {
    return PaymentLinkState(
      progressState: 0,
      message: "",
      paymentLinkListData: [],
      paymentLinkMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  PaymentLinkState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? paymentLinkListData,
    Map<String, dynamic>? paymentLinkMetaData,
    bool? isRefresh,
  }) {
    return PaymentLinkState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      paymentLinkListData: paymentLinkListData ?? this.paymentLinkListData,
      paymentLinkMetaData: paymentLinkMetaData ?? this.paymentLinkMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  PaymentLinkState update({
    int? progressState,
    String? message,
    List<dynamic>? paymentLinkListData,
    Map<String, dynamic>? paymentLinkMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      paymentLinkListData: paymentLinkListData,
      paymentLinkMetaData: paymentLinkMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "paymentLinkListData": paymentLinkListData,
      "paymentLinkMetaData": paymentLinkMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        paymentLinkListData!,
        paymentLinkMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
