import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/entities/lucky_draw_config.dart';
import 'package:trapp/src/entities/promo_code.dart';
import 'package:trapp/src/models/coupon_model.dart';

class AppDataState extends Equatable {
  final int? progressState;
  final String? message;
  final int? distance;
  final Map<String, dynamic>? currentLocation;
  final List<dynamic>? savedLocationList;
  final List<dynamic>? recentLocationList;
  final List<dynamic>? categoryList;
  final bool isCategoryRequest;
  final List<CouponModel>? couponsList;
  final LuckyDrawConfig? activeLuckyDraw;
  final String appUpdateResult;
  final List<PromoCode>? promoCodes;

  AppDataState({
    @required this.message,
    @required this.progressState,
    @required this.distance,
    @required this.currentLocation,
    @required this.savedLocationList,
    @required this.recentLocationList,
    @required this.categoryList,
    @required this.couponsList,
    @required this.promoCodes,
    this.activeLuckyDraw,
    this.appUpdateResult = "checking",
    this.isCategoryRequest = false,
  });

  factory AppDataState.init() {
    return AppDataState(
      progressState: 0,
      message: "",
      distance: AppConfig.distances[0]["value"],
      currentLocation: Map<String, dynamic>(),
      savedLocationList: [],
      recentLocationList: [],
      categoryList: [],
      couponsList: [],
      promoCodes: [],
      appUpdateResult: "checking",
      isCategoryRequest: false,
    );
  }

  AppDataState copyWith({
    int? progressState,
    String? message,
    int? distance,
    Map<String, dynamic>? currentLocation,
    List<dynamic>? savedLocationList,
    List<dynamic>? recentLocationList,
    List<dynamic>? categoryList,
    List<CouponModel>? couponsList,
    List<PromoCode>? promoCodes,
    LuckyDrawConfig? activeLuckyDraw,
    String? appUpdateResult,
    bool? isCategoryRequest,
  }) {
    return AppDataState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      distance: distance ?? this.distance,
      currentLocation: currentLocation ?? this.currentLocation,
      savedLocationList: savedLocationList ?? this.savedLocationList,
      recentLocationList: recentLocationList ?? this.recentLocationList,
      categoryList: categoryList ?? this.categoryList,
      couponsList: couponsList ?? this.couponsList,
      promoCodes: promoCodes ?? this.promoCodes,
      appUpdateResult: appUpdateResult ?? this.appUpdateResult,
      activeLuckyDraw: activeLuckyDraw ?? this.activeLuckyDraw,
      isCategoryRequest: isCategoryRequest ?? this.isCategoryRequest,
    );
  }

  AppDataState update({
    int? progressState,
    String? message,
    int? distance,
    Map<String, dynamic>? currentLocation,
    List<dynamic>? savedLocationList,
    List<dynamic>? recentLocationList,
    List<dynamic>? categoryList,
    List<CouponModel>? couponsList,
    List<PromoCode>? promoCodes,
    String? appUpdateResult,
    LuckyDrawConfig? activeLuckyDraw,
    bool? isCategoryRequest,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      distance: distance,
      currentLocation: currentLocation,
      savedLocationList: savedLocationList,
      recentLocationList: recentLocationList,
      categoryList: categoryList,
      couponsList: couponsList,
      promoCodes: promoCodes,
      appUpdateResult: appUpdateResult,
      activeLuckyDraw: activeLuckyDraw,
      isCategoryRequest: isCategoryRequest,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "distance": distance,
      "currentLocation": currentLocation,
      "savedLocationList": savedLocationList,
      "recentLocationList": recentLocationList,
      "categoryList": categoryList,
      "couponsList": couponsList,
      "promoCodes": promoCodes,
      "appUpdateResult": appUpdateResult,
      "activeLuckyDraw": activeLuckyDraw,
      "isCategoryRequest": isCategoryRequest,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        distance!,
        currentLocation!,
        savedLocationList!,
        recentLocationList!,
        categoryList!,
        couponsList!,
        promoCodes!,
        appUpdateResult,
        // activeLuckyDraw,
        isCategoryRequest,
      ];

  @override
  bool get stringify => true;
}
