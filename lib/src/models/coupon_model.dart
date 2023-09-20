import 'dart:convert';

import "package:equatable/equatable.dart";
import 'package:flutter/material.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/product_model.dart';

class CouponModel extends Equatable {
  String? id;
  String? name;
  String? description;
  String? discountCode;
  String? storeId;
  StoreModel? store;
  String? discountType;
  Map<String, dynamic>? discountData;
  String? appliedFor;
  Map<String, dynamic>? appliedData;
  String? minimumRequirements;
  double? minimumAmount;
  double? minimumQuantity;
  String? customerEligibility;
  String? businessEligibility;
  String? eligibility;
  List<dynamic>? specificCustomers;
  List<dynamic>? specificBusinesses;
  String? usageLimits;
  int? limitNumbers;
  DateTime? startDate;
  DateTime? endDate;
  bool? enabled;
  String? terms;
  List<dynamic>? images;

  CouponModel({
    String? id,
    String? name,
    String? description,
    String? discountCode,
    String? storeId,
    StoreModel? store,
    String? discountType,
    Map<String, dynamic>? discountData,
    String? appliedFor,
    Map<String, dynamic>? appliedData,
    String? minimumRequirements,
    double? minimumAmount,
    double? minimumQuantity,
    String? customerEligibility,
    String? businessEligibility,
    String? eligibility,
    List<dynamic>? specificCustomers,
    List<dynamic>? specificBusinesses,
    String? usageLimits,
    int? limitNumbers,
    DateTime? startDate,
    DateTime? endDate,
    bool? enabled,
    String? terms,
    List<dynamic>? images,
  }) {
    this.id = id ?? null;
    this.name = name ?? "";
    this.description = description ?? "User";
    this.discountCode = discountCode ?? "";
    this.storeId = storeId ?? "";
    this.store = store ?? StoreModel.fromJson({});
    this.discountType = discountType ?? "";
    this.discountData = discountData ??
        {
          "discountValue": "",
          "discountMaxAmount": "",
          "customerBogo": {
            "buy": {"products": [], "services": [], "quantity": ""},
            "get": {"products": [], "services": [], "quantity": "", "type": "", "percentValue": ""},
          }
        };
    this.appliedFor = appliedFor ?? "";
    this.appliedData = appliedData ??
        {
          "appliedCategories": {"productCategories": [], "serviceCategories": []},
          "appliedItems": {"products": [], "services": []}
        };
    this.minimumRequirements = minimumRequirements ?? "";
    this.minimumAmount = minimumAmount ?? null;
    this.minimumQuantity = minimumQuantity ?? null;
    this.customerEligibility = customerEligibility ?? "";
    this.businessEligibility = businessEligibility ?? "";
    this.eligibility = eligibility ?? "";
    this.specificCustomers = specificCustomers ?? [];
    this.specificBusinesses = specificBusinesses ?? [];
    this.usageLimits = usageLimits ?? "";
    this.limitNumbers = limitNumbers ?? null;
    this.startDate = startDate ?? null;
    this.endDate = endDate ?? null;
    this.enabled = enabled ?? true;
    this.terms = terms ?? "";
    this.images = images ?? [];
  }

  factory CouponModel.fromJson(Map<String, dynamic> map) {
    return CouponModel(
      id: map["_id"] ?? null,
      name: map["name"] ?? "",
      description: map["description"] ?? "User",
      discountCode: map["discountCode"] ?? "",
      storeId: map["storeId"] ?? "",
      store: map["store"] != null ? StoreModel.fromJson(map["store"]) : null,
      discountType: map["discountType"] ?? "",
      discountData: map["discountData"] ??
          {
            "discountValue": "",
            "discountMaxAmount": "",
            "customerBogo": {
              "buy": {"products": [], "services": [], "quantity": ""},
              "get": {"products": [], "services": [], "quantity": "", "type": "", "percentValue": ""},
            }
          },
      appliedFor: map["appliedFor"] ?? "",
      appliedData: map["appliedData"] ??
          {
            "appliedCategories": {"productCategories": [], "serviceCategories": []},
            "appliedItems": {"products": [], "services": []}
          },
      minimumRequirements: map["minimumRequirements"] ?? "",
      minimumAmount: map["minimumAmount"] != null ? double.parse(map["minimumAmount"].toString()) : null,
      minimumQuantity: map["minimumQuantity"] != null ? double.parse(map["minimumQuantity"].toString()) : null,
      customerEligibility: map["customerEligibility"] ?? "",
      businessEligibility: map["businessEligibility"] ?? "",
      eligibility: map["eligibility"] ?? "",
      specificCustomers: map["specificCustomers"] ?? [],
      specificBusinesses: map["specificBusinesses"] ?? [],
      usageLimits: map["usageLimits"] ?? "",
      limitNumbers: map["limitNumbers"] != null ? int.parse(map["limitNumbers"].toString()) : null,
      startDate: map["startDate"] != null && map["startDate"] != "" ? DateTime.tryParse(map["startDate"])!.toLocal() : null,
      endDate: map["endDate"] != null && map["endDate"] != "" ? DateTime.tryParse(map["endDate"])!.toLocal() : null,
      enabled: map["enabled"] ?? true,
      terms: map["terms"] ?? "",
      images: map["images"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    if (discountType == AppConfig.discountTypeForCoupon[2]['value']) {
      List<dynamic> buyProducts = [];
      for (var i = 0; i < discountData!["customerBogo"]["buy"]["products"].length; i++) {
        if (discountData!["customerBogo"]["buy"]["products"][i].runtimeType.toString() == "String") {
          buyProducts.add(discountData!["customerBogo"]["buy"]["products"][i]);
        } else if (discountData!["customerBogo"]["buy"]["products"][i].runtimeType.toString().contains("Map<String, dynamic>")) {
          buyProducts.add(discountData!["customerBogo"]["buy"]["products"][i]);
        } else {
          ProductOrderModel productOrderModel = discountData!["customerBogo"]["buy"]["products"][i];
          buyProducts.add(productOrderModel.toJson());
        }
      }
      discountData!["customerBogo"]["buy"]["products"] = buyProducts;

      List<dynamic> buyServices = [];
      for (var i = 0; i < discountData!["customerBogo"]["buy"]["services"].length; i++) {
        if (discountData!["customerBogo"]["buy"]["services"][i].runtimeType.toString() == "String") {
          buyServices.add(discountData!["customerBogo"]["buy"]["services"][i]);
        } else if (discountData!["customerBogo"]["buy"]["services"][i].runtimeType.toString().contains("Map<String, dynamic>")) {
          buyServices.add(discountData!["customerBogo"]["buy"]["services"][i]);
        } else {
          ServiceOrderModel serviceOrderModel = discountData!["customerBogo"]["buy"]["services"][i];
          buyServices.add(serviceOrderModel.toJson());
        }
      }
      discountData!["customerBogo"]["buy"]["services"] = buyServices;

      List<dynamic> getProducts = [];
      for (var i = 0; i < discountData!["customerBogo"]["get"]["products"].length; i++) {
        if (discountData!["customerBogo"]["get"]["products"][i].runtimeType.toString() == "String") {
          getProducts.add(discountData!["customerBogo"]["get"]["products"][i]);
        } else if (discountData!["customerBogo"]["get"]["products"][i].runtimeType.toString().contains("Map<String, dynamic>")) {
          buyProducts.add(discountData!["customerBogo"]["get"]["products"][i]);
        } else {
          ProductOrderModel productOrderModel = discountData!["customerBogo"]["get"]["products"][i];
          getProducts.add(productOrderModel.toJson());
        }
      }
      discountData!["customerBogo"]["get"]["products"] = getProducts;

      List<dynamic> getServices = [];
      for (var i = 0; i < discountData!["customerBogo"]["get"]["services"].length; i++) {
        if (discountData!["customerBogo"]["get"]["services"][i].runtimeType.toString() == "String") {
          getServices.add(discountData!["customerBogo"]["get"]["services"][i]);
        } else if (discountData!["customerBogo"]["get"]["services"][i].runtimeType.toString().contains("Map<String, dynamic>")) {
          buyServices.add(discountData!["customerBogo"]["get"]["services"][i]);
        } else {
          ServiceOrderModel serviceOrderModel = discountData!["customerBogo"]["get"]["services"][i];
          getServices.add(serviceOrderModel.toJson());
        }
      }
      discountData!["customerBogo"]["get"]["services"] = getServices;
    }

    return {
      "_id": id ?? null,
      "name": name ?? "",
      "description": description ?? "User",
      "discountCode": discountCode ?? "",
      "storeId": storeId ?? "",
      "discountType": discountType ?? "",
      "discountData": discountData ??
          {
            "discountValue": "",
            "discountMaxAmount": "",
            "customerBogo": {
              "buy": {"products": [], "services": [], "quantity": ""},
              "get": {"products": [], "services": [], "quantity": "", "type": "", "percentValue": ""},
            }
          },
      "appliedFor": appliedFor ?? "",
      "appliedData": appliedData ??
          {
            "appliedCategories": {"productCategories": [], "serviceCategories": []},
            "appliedItems": {"products": [], "services": []}
          },
      "minimumRequirements": minimumRequirements ?? "",
      "minimumAmount": minimumAmount ?? null,
      "minimumQuantity": minimumQuantity ?? null,
      "customerEligibility": customerEligibility ?? "",
      "businessEligibility": businessEligibility ?? "",
      "eligibility": eligibility ?? "",
      "specificCustomers": specificCustomers ?? [],
      "specificBusinesses": specificBusinesses ?? [],
      "usageLimits": usageLimits ?? "",
      "limitNumbers": limitNumbers ?? null,
      "startDate": startDate != null ? startDate!.toUtc().toIso8601String() : null,
      "endDate": endDate != null ? endDate!.toUtc().toIso8601String() : null,
      "enabled": enabled ?? true,
      "terms": terms ?? "",
      "images": images ?? [],
    };
  }

  factory CouponModel.copy(CouponModel model) {
    return CouponModel(
      id: model.id,
      name: model.name,
      description: model.description,
      discountCode: model.discountCode,
      storeId: model.storeId,
      store: model.store,
      discountType: model.discountType,
      discountData: json.decode(json.encode(model.discountData)),
      appliedFor: model.appliedFor,
      appliedData: json.decode(json.encode(model.appliedData)),
      minimumRequirements: model.minimumRequirements,
      minimumAmount: model.minimumAmount,
      minimumQuantity: model.minimumQuantity,
      customerEligibility: model.customerEligibility,
      businessEligibility: model.businessEligibility,
      eligibility: model.eligibility,
      specificCustomers: List.from(model.specificCustomers!),
      specificBusinesses: List.from(model.specificBusinesses!),
      usageLimits: model.usageLimits,
      limitNumbers: model.limitNumbers,
      startDate: model.startDate,
      endDate: model.endDate,
      enabled: model.enabled,
      terms: model.terms,
      images: List.from(model.images!),
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        name!,
        description!,
        discountCode!,
        storeId!,
        discountType!,
        discountData!,
        appliedFor!,
        appliedData!,
        minimumRequirements!,
        minimumAmount ?? Object(),
        minimumQuantity ?? Object(),
        customerEligibility!,
        businessEligibility!,
        eligibility!,
        specificCustomers!,
        specificBusinesses!,
        usageLimits!,
        limitNumbers ?? Object(),
        startDate ?? Object(),
        endDate ?? Object(),
        enabled!,
        terms!,
        images!,
      ];

  @override
  bool get stringify => true;

  ///////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////                                        ////////////////////////
  //////////////////////////                 UsageLimit              ///////////////////////
  ///////////////////////////                                        ////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////
  static Future<String> checkUsageLimit(CouponModel couponModel) async {
    if (couponModel.usageLimits != AppConfig.usageLimitsForCoupon[0]["value"]) {
      var result = await OrderApiProvider.getCouponUsage(
        storeId: couponModel.storeId,
        couponId: couponModel.id,
      );

      if (result["success"] && result["data"].isEmpty) {
        return "";
      } else if (result["success"] && result["data"][0].isNotEmpty) {
        int couponCount = result["data"][0]["couponCount"];
        if (couponModel.usageLimits == AppConfig.usageLimitsForCoupon[1]["value"] && couponCount >= int.parse(couponModel.limitNumbers.toString())) {
          return "This coupon can be used at most ${couponModel.limitNumbers} times. You already applied this to $couponCount different order. So you wont be able to use it again.";
        } else if (couponModel.usageLimits == AppConfig.usageLimitsForCoupon[2]["value"]) {
          return "This coupon can be used only once. You already applied this to a different order. So you wont be able to use it again.";
        }
      } else {
        return "Usage Limit api Error";
      }
    }
    return "";
  }

  ///////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////                                        ////////////////////////
  //////////////////////////                appliedFor              ////////////////////////
  ///////////////////////////                                        ////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////
  static Map<String, dynamic> checkAppliedFor({@required OrderModel? orderModel, @required CouponModel? couponModel}) {
    if (couponModel!.appliedFor == AppConfig.appliesToForCoupon[1]["value"]) {
      Map<String, dynamic> matchedItems = _getAppliedCategoriesMatch(orderModel: orderModel, couponModel: couponModel);

      if (matchedItems["products"].isEmpty && matchedItems["services"].isEmpty) {
        return {
          "message": "Coupon is not valid as the applicable products/services are not available in your cart.",
        };
      }

      return {
        "message": "",
        "matchedItems": matchedItems,
      };
    } else if (couponModel.appliedFor == AppConfig.appliesToForCoupon[2]["value"]) {
      Map<String, dynamic> matchedItems = _getAppliedItemsMatch(orderModel: orderModel, couponModel: couponModel);
      if (matchedItems["products"].isEmpty && matchedItems["services"].isEmpty) {
        return {
          "message": "Coupon is not valid as the applicable products/services are not available in your cart.",
        };
      }
      return {
        "message": "",
        "matchedItems": matchedItems,
      };
    }
    return {
      "message": "ALL",
    };
  }

  ///////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////                                        ////////////////////////
  //////////////////////////                Min Request              ////////////////////////
  ///////////////////////////                                        ////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////
  static String checkCouponMinRequests({@required OrderModel? orderModel, @required CouponModel? couponModel}) {
    if (couponModel!.minimumRequirements == AppConfig.minRequirementsForCoupon[1]["value"]) {
      List<ProductOrderModel> productOrdrModels = [];
      List<ServiceOrderModel> serviceOrdrModels = [];

      Map<String, dynamic> matchedItems = _getAppliedItems(orderModel: orderModel, couponModel: couponModel);
      productOrdrModels.addAll(matchedItems["products"]);
      serviceOrdrModels.addAll(matchedItems["services"]);

      if (productOrdrModels.isEmpty && serviceOrdrModels.isEmpty) {
        for (var i = 0; i < orderModel!.products!.length; i++) {
          productOrdrModels.add(orderModel.products![i]);
        }
        for (var i = 0; i < orderModel.services!.length; i++) {
          serviceOrdrModels.add(orderModel.services![i]);
        }
      }

      double totalAmount = 0;

      for (var i = 0; i < productOrdrModels.length; i++) {
        totalAmount +=
            productOrdrModels[i].orderQuantity! * (productOrdrModels[i].productModel!.price! - productOrdrModels[i].productModel!.discount!);
      }

      for (var i = 0; i < serviceOrdrModels.length; i++) {
        totalAmount +=
            serviceOrdrModels[i].orderQuantity! * (serviceOrdrModels[i].serviceModel!.price! - serviceOrdrModels[i].serviceModel!.discount!);
      }

      if (totalAmount < double.parse(couponModel.minimumAmount.toString())) {
        return "To Apply this coupon the total cost of products/services added to the cart must be at least ₹ ${couponModel.minimumAmount}";
      }
    } else if (couponModel.minimumRequirements == AppConfig.minRequirementsForCoupon[2]["value"]) {
      List<ProductOrderModel> productOrdrModels = [];
      List<ServiceOrderModel> serviceOrdrModels = [];

      Map<String, dynamic> matchedItems = _getAppliedItems(orderModel: orderModel, couponModel: couponModel);
      productOrdrModels.addAll(matchedItems["products"]);
      serviceOrdrModels.addAll(matchedItems["services"]);

      if (productOrdrModels.isEmpty && serviceOrdrModels.isEmpty) {
        for (var i = 0; i < orderModel!.products!.length; i++) {
          productOrdrModels.add(orderModel.products![i]);
        }
        for (var i = 0; i < orderModel.services!.length; i++) {
          serviceOrdrModels.add(orderModel.services![i]);
        }
      }

      double totalQuantity = 0;

      for (var i = 0; i < productOrdrModels.length; i++) {
        totalQuantity += productOrdrModels[i].orderQuantity!;
      }

      for (var i = 0; i < serviceOrdrModels.length; i++) {
        totalQuantity += serviceOrdrModels[i].orderQuantity!;
      }

      if (totalQuantity < double.parse(couponModel.minimumQuantity.toString())) {
        return "To Apply this coupon the total quantity of products/services must be at least ${couponModel.minimumQuantity}";
      }
    }
    return "";
  }

  ///////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////                                        ////////////////////////
  //////////////////////////                     BOGO                ////////////////////////
  ///////////////////////////                                        ////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////
  static String checkBOGO({@required OrderModel? orderModel, @required CouponModel? couponModel}) {
    if (couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"]) {
      //////
      List<ProductOrderModel> productOrdrModels = [];
      List<ServiceOrderModel> serviceOrdrModels = [];

      Map<String, dynamic> matchedItems = _getBOGOBuyItemsMatch(orderModel: orderModel, couponModel: couponModel);
      String productIds = "";
      String serviceIds = "";
      for (var i = 0; i < matchedItems["products"].length; i++) {
        ProductOrderModel productOrderModel = matchedItems["products"][i];
        if (!productIds.contains(productOrderModel.productModel!.id!)) {
          productOrdrModels.add(matchedItems["products"][i]);
          productIds += "," + productOrderModel.productModel!.id!;
        }
      }
      for (var i = 0; i < matchedItems["services"].length; i++) {
        ServiceOrderModel serviceOrderModel = matchedItems["services"][i];
        if (!serviceIds.contains(serviceOrderModel.serviceModel!.id!)) {
          serviceOrdrModels.add(matchedItems["services"][i]);
          serviceIds += "," + serviceOrderModel.serviceModel!.id!;
        }
      }

      matchedItems = getBOGOGetItemsMatch(orderModel: orderModel, couponModel: couponModel);
      for (var i = 0; i < matchedItems["products"].length; i++) {
        ProductOrderModel productOrderModel = matchedItems["products"][i];
        if (!productIds.contains(productOrderModel.productModel!.id!)) {
          productOrdrModels.add(matchedItems["products"][i]);
          productIds += "," + productOrderModel.productModel!.id!;
        }
      }
      for (var i = 0; i < matchedItems["services"].length; i++) {
        ServiceOrderModel serviceOrderModel = matchedItems["services"][i];
        if (!serviceIds.contains(serviceOrderModel.serviceModel!.id!)) {
          serviceOrdrModels.add(matchedItems["services"][i]);
          serviceIds += "," + serviceOrderModel.serviceModel!.id!;
        }
      }

      double totalQuantity = 0;

      for (var i = 0; i < productOrdrModels.length; i++) {
        totalQuantity += productOrdrModels[i].orderQuantity!;
      }

      for (var i = 0; i < serviceOrdrModels.length; i++) {
        totalQuantity += serviceOrdrModels[i].orderQuantity!;
      }

      if (totalQuantity <
          double.parse(couponModel.discountData!["customerBogo"]["buy"]["quantity"].toString()) +
              double.parse(couponModel.discountData!["customerBogo"]["get"]["quantity"].toString())) {
        return "To Apply Buy ${couponModel.discountData!["customerBogo"]["buy"]["quantity"]} "
            "Get ${couponModel.discountData!["customerBogo"]["get"]["quantity"]} coupon, "
            "you need to add at least ${double.parse(couponModel.discountData!["customerBogo"]["buy"]["quantity"].toString()) + double.parse(couponModel.discountData!["customerBogo"]["get"]["quantity"].toString())} quantity of "
            "products/services from applicable list to your order";
      }

      // //////
      // productOrdrModels = [];
      // serviceOrdrModels = [];

      // matchedItems = getBOGOGetItemsMatch(orderModel: orderModel, couponModel: couponModel);
      // productOrdrModels.addAll(matchedItems["products"]);
      // serviceOrdrModels.addAll(matchedItems["services"]);

      // totalQuantity = 0;

      // for (var i = 0; i < productOrdrModels.length; i++) {
      //   totalQuantity += productOrdrModels[i].orderQuantity!;
      // }

      // for (var i = 0; i < serviceOrdrModels.length; i++) {
      //   totalQuantity += serviceOrdrModels[i].orderQuantity!;
      // }

      // if (totalQuantity < double.parse(couponModel["discountData"]["customerBogo"]["get"]["quantity"].toString())) {
      //   return "To Apply Buy ${couponModel["discountData"]["customerBogo"]["buy"]["quantity"]} "
      //       "Get ${couponModel["discountData"]["customerBogo"]["get"]["quantity"]} coupon, "
      //       "you need to add at least ${couponModel["discountData"]["customerBogo"]["get"]["quantity"]} quantity of "
      //       "products/services from applicable list to your order";
      // }
    }
    return "";
  }

  static Map<String, dynamic> _getBOGOBuyItemsMatch({@required OrderModel? orderModel, @required CouponModel? couponModel}) {
    List<ProductOrderModel> producctOrderModels = [];
    List<ServiceOrderModel> serviceOrderModels = [];

    String couponProductIds = couponModel!.discountData!["customerBogo"]["buy"]["products"].join(',');
    String couponServiceIds = couponModel.discountData!["customerBogo"]["buy"]["services"].join(',');

    if (couponProductIds != "") {
      for (var i = 0; i < orderModel!.products!.length; i++) {
        if (couponProductIds.contains(orderModel.products![i].productModel!.id!)) {
          producctOrderModels.add(orderModel.products![i]);
        }
      }
    }

    if (couponServiceIds != "") {
      for (var i = 0; i < orderModel!.services!.length; i++) {
        if (couponServiceIds.contains(orderModel.services![i].serviceModel!.id!)) {
          serviceOrderModels.add(orderModel.services![i]);
        }
      }
    }

    return {"products": producctOrderModels, "services": serviceOrderModels};
  }

  static Map<String, dynamic> getBOGOGetItemsMatch({@required OrderModel? orderModel, @required CouponModel? couponModel}) {
    List<ProductOrderModel> producctOrderModels = [];
    List<ServiceOrderModel> serviceOrderModels = [];

    String couponProductIds = couponModel!.discountData!["customerBogo"]["get"]["products"].join(',');
    String couponServiceIds = couponModel.discountData!["customerBogo"]["get"]["services"].join(',');

    if (couponProductIds != "") {
      for (var i = 0; i < orderModel!.products!.length; i++) {
        if (couponProductIds.contains(orderModel.products![i].productModel!.id!)) {
          producctOrderModels.add(orderModel.products![i]);
        }
      }
    }

    if (couponServiceIds != "") {
      for (var i = 0; i < orderModel!.services!.length; i++) {
        if (couponServiceIds.contains(orderModel.services![i].serviceModel!.id!)) {
          serviceOrderModels.add(orderModel.services![i]);
        }
      }
    }

    return {"products": producctOrderModels, "services": serviceOrderModels};
  }

  ///////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////
  static Map<String, dynamic> _getAppliedItems({@required OrderModel? orderModel, @required CouponModel? couponModel}) {
    List<ProductOrderModel> productOrdrModels = [];
    List<ServiceOrderModel> serviceOrdrModels = [];
    Map<String, dynamic> matchedItems = _getAppliedItemsMatch(orderModel: orderModel, couponModel: couponModel);
    productOrdrModels.addAll(matchedItems["products"]);
    serviceOrdrModels.addAll(matchedItems["services"]);

    matchedItems = _getAppliedCategoriesMatch(orderModel: orderModel, couponModel: couponModel);
    productOrdrModels.addAll(matchedItems["products"]);
    serviceOrdrModels.addAll(matchedItems["services"]);

    return {"products": productOrdrModels, "services": serviceOrdrModels};
  }

  static Map<String, dynamic> _getAppliedItemsMatch({@required OrderModel? orderModel, @required CouponModel? couponModel}) {
    List<ProductOrderModel> producctOrderModels = [];
    List<ServiceOrderModel> serviceOrderModels = [];

    String couponProductIds = couponModel!.appliedData!["appliedItems"]["products"].join(',');
    String couponServiceIds = couponModel.appliedData!["appliedItems"]["services"].join(',');

    if (couponProductIds != "") {
      for (var i = 0; i < orderModel!.products!.length; i++) {
        if (couponProductIds.contains(orderModel.products![i].productModel!.id!)) {
          producctOrderModels.add(orderModel.products![i]);
        }
      }
    }

    if (couponServiceIds != "") {
      for (var i = 0; i < orderModel!.services!.length; i++) {
        if (couponServiceIds.contains(orderModel.services![i].serviceModel!.id!)) {
          serviceOrderModels.add(orderModel.services![i]);
        }
      }
    }

    return {"products": producctOrderModels, "services": serviceOrderModels};
  }

  static Map<String, dynamic> _getAppliedCategoriesMatch({@required OrderModel? orderModel, @required CouponModel? couponModel}) {
    List<ProductOrderModel> producctOrderModels = [];
    List<ServiceOrderModel> serviceOrderModels = [];

    String productCategories = couponModel!.appliedData!["appliedCategories"]["productCategories"].join(',');
    String serviceCategories = couponModel.appliedData!["appliedCategories"]["serviceCategories"].join(',');

    if (productCategories != "") {
      for (var i = 0; i < orderModel!.products!.length; i++) {
        if (productCategories.contains(orderModel.products![i].productModel!.category!)) {
          producctOrderModels.add(orderModel.products![i]);
        }
      }
    }

    if (serviceCategories != "") {
      for (var i = 0; i < orderModel!.services!.length; i++) {
        if (serviceCategories.contains(orderModel.services![i].serviceModel!.category!)) {
          serviceOrderModels.add(orderModel.services![i]);
        }
      }
    }

    return {"products": producctOrderModels, "services": serviceOrderModels};
  }
}
