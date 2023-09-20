import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/models/index.dart';

class SearchState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? storeList;
  final Map<String, dynamic>? storeMetaData;
  final bool? isStoreRefresh;
  final Map<String, dynamic>? productList;
  final Map<String, dynamic>? productMetaData;
  final bool? isProductRefresh;
  final Map<String, dynamic>? serviceList;
  final Map<String, dynamic>? serviceMetaData;
  final bool? isServiceRefresh;
  final Map<String, dynamic>? couponList;
  final Map<String, dynamic>? couponMetaData;
  final bool? isCouponRefresh;

  SearchState({
    @required this.message,
    @required this.progressState,
    @required this.storeList,
    @required this.storeMetaData,
    @required this.isStoreRefresh,
    @required this.productList,
    @required this.productMetaData,
    @required this.isProductRefresh,
    @required this.serviceList,
    @required this.serviceMetaData,
    @required this.isServiceRefresh,
    @required this.couponList,
    @required this.couponMetaData,
    @required this.isCouponRefresh,
  });

  factory SearchState.init() {
    return SearchState(
      progressState: 0,
      message: "",
      storeList: Map<String, dynamic>(),
      storeMetaData: Map<String, dynamic>(),
      isStoreRefresh: false,
      productList: Map<String, dynamic>(),
      productMetaData: Map<String, dynamic>(),
      isProductRefresh: false,
      serviceList: Map<String, dynamic>(),
      serviceMetaData: Map<String, dynamic>(),
      isServiceRefresh: false,
      couponList: Map<String, dynamic>(),
      couponMetaData: Map<String, dynamic>(),
      isCouponRefresh: false,
    );
  }

  SearchState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeList,
    Map<String, dynamic>? storeMetaData,
    bool? isStoreRefresh,
    Map<String, dynamic>? productList,
    Map<String, dynamic>? productMetaData,
    bool? isProductRefresh,
    Map<String, dynamic>? serviceList,
    Map<String, dynamic>? serviceMetaData,
    bool? isServiceRefresh,
    Map<String, dynamic>? couponList,
    Map<String, dynamic>? couponMetaData,
    bool? isCouponRefresh,
  }) {
    return SearchState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      storeList: storeList ?? this.storeList,
      storeMetaData: storeMetaData ?? this.storeMetaData,
      isStoreRefresh: isStoreRefresh ?? this.isStoreRefresh,
      productList: productList ?? this.productList,
      productMetaData: productMetaData ?? this.productMetaData,
      isProductRefresh: isProductRefresh ?? this.isProductRefresh,
      serviceList: serviceList ?? this.serviceList,
      serviceMetaData: serviceMetaData ?? this.serviceMetaData,
      isServiceRefresh: isServiceRefresh ?? this.isServiceRefresh,
      couponList: couponList ?? this.couponList,
      couponMetaData: couponMetaData ?? this.couponMetaData,
      isCouponRefresh: isCouponRefresh ?? this.isCouponRefresh,
    );
  }

  SearchState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeList,
    Map<String, dynamic>? storeMetaData,
    bool? isStoreRefresh,
    Map<String, dynamic>? productList,
    Map<String, dynamic>? productMetaData,
    bool? isProductRefresh,
    Map<String, dynamic>? serviceList,
    Map<String, dynamic>? serviceMetaData,
    bool? isServiceRefresh,
    Map<String, dynamic>? couponList,
    Map<String, dynamic>? couponMetaData,
    bool? isCouponRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      storeList: storeList,
      storeMetaData: storeMetaData,
      isStoreRefresh: isStoreRefresh,
      productList: productList,
      productMetaData: productMetaData,
      isProductRefresh: isProductRefresh,
      serviceList: serviceList,
      serviceMetaData: serviceMetaData,
      isServiceRefresh: isServiceRefresh,
      couponList: couponList,
      couponMetaData: couponMetaData,
      isCouponRefresh: isCouponRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "storeList": storeList,
      "storeMetaData": storeMetaData,
      "isStoreRefresh": isStoreRefresh,
      "productList": productList,
      "productMetaData": productMetaData,
      "isProductRefresh": isProductRefresh,
      "serviceList": serviceList,
      "serviceMetaData": serviceMetaData,
      "isServiceRefresh": isServiceRefresh,
      "couponList": couponList,
      "couponMetaData": couponMetaData,
      "isCouponRefresh": isCouponRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        storeList!,
        storeMetaData!,
        isStoreRefresh!,
        productList!,
        productMetaData!,
        isProductRefresh!,
        serviceList!,
        serviceMetaData!,
        isServiceRefresh!,
        couponList!,
        couponMetaData!,
        isCouponRefresh!,
      ];

  @override
  bool get stringify => true;
}
