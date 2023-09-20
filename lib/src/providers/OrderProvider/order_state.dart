import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/models/order_model.dart';

class OrderState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final OrderModel? newOrderModel;
  final Map<String, dynamic>? orderListData;
  final Map<String, dynamic>? orderMetaData;
  final bool? isRefresh;

  OrderState({
    @required this.progressState,
    @required this.message,
    @required this.newOrderModel,
    @required this.orderListData,
    @required this.orderMetaData,
    @required this.isRefresh,
  });

  factory OrderState.init() {
    return OrderState(
      progressState: 0,
      message: "",
      newOrderModel: null,
      orderListData: Map<String, dynamic>(),
      orderMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  OrderState copyWith({
    int? progressState,
    String? message,
    OrderModel? newOrderModel,
    Map<String, dynamic>? orderListData,
    Map<String, dynamic>? orderMetaData,
    bool? isRefresh,
  }) {
    return OrderState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      newOrderModel: newOrderModel ?? this.newOrderModel,
      orderListData: orderListData ?? this.orderListData,
      orderMetaData: orderMetaData ?? this.orderMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  OrderState update({
    int? progressState,
    String? message,
    OrderModel? newOrderModel,
    Map<String, dynamic>? orderListData,
    Map<String, dynamic>? orderMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      newOrderModel: newOrderModel,
      orderListData: orderListData,
      orderMetaData: orderMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "newOrderModel": newOrderModel,
      "orderListData": orderListData,
      "orderMetaData": orderMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        newOrderModel ?? Object(),
        orderListData!,
        orderMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
