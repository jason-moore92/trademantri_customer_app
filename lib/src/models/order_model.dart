import 'dart:convert';

import "package:equatable/equatable.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/ApiDataProviders/product_api_provider.dart';

import 'index.dart';

class OrderCategory {
  static String cart = "Cart";
  static String assistant = "Assistant";
  static String reverseAuction = "Reverse Auction";
  static String bargain = "Bargain";
}

class OrderType {
  static String pickup = "Pickup";
  static String delivery = "Delivery";
}

class OrderModel extends Equatable {
  String? id;
  String? orderId;
  String? invoiceId;
  String? initiatedBy;
  String? userId;
  String? storeId;
  UserModel? userModel;
  StoreModel? storeModel;
  String? category; // Cart, Assistant, Reverse Auction, Bargain,
  String? orderType;
  String? status;
  // String? qrcodeImgUrl;
  String? qrCodeData;
  String? invoicePdfUrl;
  String? invoicePdfUrlForStore;
  String? instructions;
  List<ProductOrderModel>? products;
  List<ServiceOrderModel>? services;
  List<ProductOrderModel>? bogoProducts;
  List<ServiceOrderModel>? bogoServices;
  PromocodeModel? promocode;
  String? storeCategoryId;
  String? storeCategoryDesc;
  LatLng? storeLocation;
  DateTime? completeDateTime;
  DateTime? serviceDateTime;
  // Pickup Data
  DateTime? pickupDateTime;
  bool? payAtStore;
  // Delivery Data
  bool? cashOnDelivery;
  bool? noContactDelivery;
  DeliveryAddressModel? deliveryAddress;
  Map<String, dynamic>? deliveryPartnerDetails;
  Map<String, dynamic>? deliveryDetail;
  //////
  Map<String, dynamic>? rewardPointData;
  // double? rewardPointsEarnedPerOrder;
  Map<String, dynamic>? redeemRewardData;
  PaymentDetailModel? paymentDetail;
  ///////////////////////////////////////////
  bool? pickupDeliverySatus;
  bool? payStatus;
  Map<String, dynamic>? paymentApiData;
  Map<String, dynamic>? razorPayData;
  Map<String, dynamic>? iciciUPIData;
  List<dynamic>? scratchCard;
  String? reasonForCancelOrReject;
  // invoice Data
  String? paymentFor;
  Map<String, dynamic>? notes;
  DateTime? dueDate;
  ///////////////////////////////////////////
  CouponModel? coupon;
  bool? couponVaidate;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? distance;
  List<dynamic>? orderHistorySteps;
  List<dynamic>? orderFutureSteps;

  String? walletTransactionId;
  String? walletSettledTransactionId;
  String? walletRefundTransactionId;
  bool? settled;

  OrderModel({
    String? id,
    String? orderId,
    String? invoiceId,
    String? initiatedBy,
    String? userId,
    String? storeId,
    UserModel? userModel,
    StoreModel? storeModel,
    String? category,
    String? orderType,
    String? status,
    // String? qrcodeImgUrl,
    String? qrCodeData,
    String? invoicePdfUrl,
    String? invoicePdfUrlForStore,
    String? instructions,
    List<ProductOrderModel>? products,
    List<ServiceOrderModel>? services,
    List<ProductOrderModel>? bogoProducts,
    List<ServiceOrderModel>? bogoServices,
    PromocodeModel? promocode,
    String? storeCategoryId,
    String? storeCategoryDesc,
    LatLng? storeLocation,
    DateTime? completeDateTime,
    DateTime? serviceDateTime,
    // Pickup Data
    DateTime? pickupDateTime,
    bool? payAtStore,
    // Delivery Data
    bool? cashOnDelivery,
    bool? noContactDelivery,
    DeliveryAddressModel? deliveryAddress,
    Map<String, dynamic>? deliveryPartnerDetails,
    Map<String, dynamic>? deliveryDetail,
    //////
    Map<String, dynamic>? rewardPointData,
    // double? rewardPointsEarnedPerOrder,
    Map<String, dynamic>? redeemRewardData,
    PaymentDetailModel? paymentDetail,

    ///////////////////////////////////////////
    bool? pickupDeliverySatus,
    bool? payStatus,
    Map<String, dynamic>? paymentApiData,
    Map<String, dynamic>? razorPayData,
    Map<String, dynamic>? iciciUPIData,
    List<dynamic>? scratchCard,
    String? reasonForCancelOrReject,
    // invoice Data
    String? paymentFor,
    Map<String, dynamic>? notes,
    DateTime? dueDate,
    //////////////////////
    CouponModel? coupon,
    bool? couponVaidate,
    DateTime? updatedAt,
    DateTime? createdAt,
    double? distance,
    String? walletTransactionId,
    String? walletSettledTransactionId,
    String? walletRefundTransactionId,
    bool? settled,
    List<dynamic>? orderHistorySteps,
    List<dynamic>? orderFutureSteps,
  }) {
    this.id = id ?? null;
    this.orderId = orderId ?? "";
    this.invoiceId = invoiceId ?? "";
    this.initiatedBy = initiatedBy ?? "User";
    this.userId = userId;
    this.storeId = storeId;
    this.userModel = userModel ?? null;
    this.storeModel = storeModel ?? null;
    this.category = category ?? "";
    this.orderType = orderType ?? "";
    this.status = status ?? "";
    // this.qrcodeImgUrl = qrcodeImgUrl ?? "";
    this.qrCodeData = qrCodeData ?? "";
    this.invoicePdfUrl = invoicePdfUrl ?? "";
    this.invoicePdfUrlForStore = invoicePdfUrlForStore ?? "";
    this.instructions = instructions ?? "";
    this.products = products ?? [];
    this.services = services ?? [];
    this.bogoProducts = bogoProducts ?? [];
    this.bogoServices = bogoServices ?? [];
    this.promocode = promocode ?? null;
    this.storeCategoryId = storeCategoryId ?? "";
    this.storeCategoryDesc = storeCategoryDesc ?? "";
    this.storeLocation = storeLocation ?? null;
    this.completeDateTime = completeDateTime ?? null;
    this.serviceDateTime = serviceDateTime ?? null;
    // Pickup Data
    this.pickupDateTime = pickupDateTime ?? null;
    this.payAtStore = payAtStore ?? false;
    // Delivery Data
    this.cashOnDelivery = cashOnDelivery ?? false;
    this.noContactDelivery = noContactDelivery ?? true;
    this.deliveryAddress = deliveryAddress ?? null;
    this.deliveryPartnerDetails = deliveryPartnerDetails ?? Map<String, dynamic>();
    this.deliveryDetail = deliveryDetail ?? Map<String, dynamic>();
    //////
    this.rewardPointData = rewardPointData ?? Map<String, dynamic>();
    // this.rewardPointsEarnedPerOrder = rewardPointsEarnedPerOrder ?? 0;
    this.redeemRewardData = redeemRewardData ?? Map<String, dynamic>();
    this.paymentDetail = paymentDetail ?? null;
    ///////////////////////////////////////////
    this.pickupDeliverySatus = pickupDeliverySatus ?? false;
    this.payStatus = payStatus ?? false;
    this.paymentApiData = paymentApiData ?? Map<String, dynamic>();
    this.razorPayData = razorPayData ?? Map<String, dynamic>();
    this.iciciUPIData = iciciUPIData ?? Map<String, dynamic>();
    this.scratchCard = scratchCard ?? [];
    this.reasonForCancelOrReject = reasonForCancelOrReject ?? "";
    // invoice Data
    this.paymentFor = paymentFor ?? "";
    this.notes = notes ?? Map<String, dynamic>();
    this.dueDate = dueDate ?? null;
    ///////////////////////////////////////////
    this.coupon = coupon ?? null;
    this.couponVaidate = couponVaidate ?? null;
    this.updatedAt = updatedAt ?? null;
    this.createdAt = createdAt ?? null;
    this.distance = distance ?? 0;
    this.walletTransactionId = walletTransactionId;
    this.walletSettledTransactionId = walletSettledTransactionId;
    this.walletRefundTransactionId = walletRefundTransactionId;
    this.settled = settled;
    this.orderHistorySteps = orderHistorySteps ?? [];
    this.orderFutureSteps = orderFutureSteps ?? [];
  }

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    map = json.decode(json.encode(map));

    map["products"] = map["products"] ?? [];
    map["services"] = map["services"] ?? [];
    map["bogoProducts"] = map["bogoProducts"] ?? [];
    map["bogoServices"] = map["bogoServices"] ?? [];

    List<ProductOrderModel> products = [];
    List<ServiceOrderModel> services = [];
    List<ProductOrderModel> bogoProducts = [];
    List<ServiceOrderModel> bogoServices = [];

    for (var i = 0; i < map["products"].length; i++) {
      products.add(ProductOrderModel.fromJson(map["products"][i]));
    }

    for (var i = 0; i < map["services"].length; i++) {
      services.add(ServiceOrderModel.fromJson(map["services"][i]));
    }

    for (var i = 0; i < map["bogoProducts"].length; i++) {
      bogoProducts.add(ProductOrderModel.fromJson(map["bogoProducts"][i]));
    }

    for (var i = 0; i < map["bogoServices"].length; i++) {
      bogoServices.add(ServiceOrderModel.fromJson(map["bogoServices"][i]));
    }

    if (map["store"] != null && map["store"].runtimeType.toString().contains("Map<String, dynamic>")) {
      map["store"] = StoreModel.fromJson(map["store"]);
    }

    if (map["user"] != null && map["user"].runtimeType.toString().contains("Map<String, dynamic>")) {
      map["user"] = UserModel.fromJson(map["user"]);
    }

    return OrderModel(
      id: map["_id"] ?? null,
      orderId: map["orderId"] ?? "",
      invoiceId: map["invoiceId"] ?? "",
      initiatedBy: map["initiatedBy"] ?? "User",
      userId: map["userId"] ?? "",
      storeId: map["storeId"] ?? "",
      userModel: map["user"] ?? null,
      storeModel: map["store"] ?? null,
      category: map["category"] ?? "",
      orderType: map["orderType"] ?? "",
      status: map["status"] ?? "",
      // qrcodeImgUrl: map["qrcodeImgUrl"] ?? "",
      qrCodeData: map["qrCodeData"] ?? "",
      invoicePdfUrl: map["invoicePdfUrl"] ?? "",
      invoicePdfUrlForStore: map["invoicePdfUrlForStore"] ?? "",
      instructions: map["instructions"] ?? "",
      products: products,
      services: services,
      bogoProducts: bogoProducts,
      bogoServices: bogoServices,
      promocode: map["promocode"] != null ? PromocodeModel.fromJson(map["promocode"]) : null,
      storeCategoryId: map["storeCategoryId"] ?? "",
      storeCategoryDesc: map["storeCategoryDesc"] ?? "",
      storeLocation: map["storeLocation"] != null ? LatLng(map["storeLocation"]["coordinates"][1], map["storeLocation"]["coordinates"][0]) : null,
      completeDateTime: map["completeDateTime"] != null ? DateTime.tryParse(map["completeDateTime"])!.toLocal() : null,
      serviceDateTime: map["serviceDateTime"] != null ? DateTime.tryParse(map["serviceDateTime"])!.toLocal() : null,
      // Pickup Data
      pickupDateTime: map["pickupDateTime"] != null ? DateTime.tryParse(map["pickupDateTime"])!.toLocal() : null,
      payAtStore: map["payAtStore"] ?? false,
      // Deliver Data
      cashOnDelivery: map["cashOnDelivery"] ?? false,
      deliveryAddress: map["deliveryAddress"] != null ? DeliveryAddressModel.fromJson(map["deliveryAddress"]) : null,
      noContactDelivery: map["noContactDelivery"] ?? true,
      deliveryPartnerDetails: map["deliveryPartnerDetails"] ?? Map<String, dynamic>(),
      deliveryDetail: map["deliveryDetail"] ?? Map<String, dynamic>(),
      /////
      rewardPointData: map["rewardPointData"] ?? Map<String, dynamic>(),
      // rewardPointsEarnedPerOrder: map["rewardPointsEarnedPerOrder"] != null ? double.parse(map["rewardPointsEarnedPerOrder"].toString()) : 0,
      redeemRewardData: map["redeemRewardData"] ?? Map<String, dynamic>(),
      paymentDetail: map["paymentDetail"] != null ? PaymentDetailModel.fromJson(map["paymentDetail"]) : null,

      ///////////////////////////////////////////
      pickupDeliverySatus: map["pickupDeliverySatus"] ?? false,
      payStatus: map["payStatus"] ?? false,
      paymentApiData: map["paymentApiData"] ?? Map<String, dynamic>(),
      razorPayData: map["razorPayData"] ?? Map<String, dynamic>(),
      iciciUPIData: map["iciciUPIData"] ?? Map<String, dynamic>(),
      scratchCard: map["scratchCard"] ?? [],
      reasonForCancelOrReject: map["reasonForCancelOrReject"] ?? "",
      // invoice Data
      paymentFor: map["paymentFor"] ?? "",
      notes: map["notes"] ?? Map<String, dynamic>(),
      dueDate: map["dueDate"] != null ? DateTime.tryParse(map["dueDate"])!.toLocal() : null,
      coupon: map["coupon"] != null ? CouponModel.fromJson(map["coupon"]) : null,
      couponVaidate: map["couponVaidate"] ?? null,
      updatedAt: map["updatedAt"] != null ? DateTime.tryParse(map["updatedAt"])!.toLocal() : null,
      createdAt: map["createdAt"] != null ? DateTime.tryParse(map["createdAt"])!.toLocal() : null,
      distance: map["distance"] != null ? double.parse(map["distance"].toString()) : 0,
      walletTransactionId: map["walletTransactionId"],
      walletSettledTransactionId: map["walletSettledTransactionId"],
      walletRefundTransactionId: map["walletRefundTransactionId"],
      settled: map['settled'],
      orderHistorySteps: map["orderHistorySteps"] ?? [],
      orderFutureSteps: map["orderFutureSteps"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    List<dynamic> productsJson = [];
    List<dynamic> servicesJson = [];
    List<dynamic> bogoProductsJson = [];
    List<dynamic> bogoServicesJson = [];

    for (var i = 0; i < products!.length; i++) {
      productsJson.add(products![i].toJson());
    }

    for (var i = 0; i < services!.length; i++) {
      servicesJson.add(services![i].toJson());
    }

    for (var i = 0; i < bogoProducts!.length; i++) {
      bogoProductsJson.add(bogoProducts![i].toJson());
    }

    for (var i = 0; i < bogoServices!.length; i++) {
      bogoServicesJson.add(bogoServices![i].toJson());
    }

    return {
      "_id": id ?? null,
      "orderId": orderId ?? "",
      "invoiceId": invoiceId ?? "",
      "initiatedBy": initiatedBy ?? "User",
      "user": userModel != null ? userModel!.toJson() : null,
      "store": storeModel != null ? storeModel!.toJson() : null,
      "userId": userId ?? (userModel != null ? userModel!.id : null),
      "storeId": storeId ?? (storeModel != null ? storeModel!.id : null),
      "category": category ?? "",
      "orderType": orderType ?? "",
      "status": status ?? "",
      // "qrcodeImgUrl": qrcodeImgUrl ?? "",
      "qrCodeData": qrCodeData ?? "",
      "invoicePdfUrl": invoicePdfUrl ?? "",
      "invoicePdfUrlForStore": invoicePdfUrlForStore ?? "",
      "instructions": instructions ?? "",
      "products": productsJson,
      "services": servicesJson,
      "bogoProducts": bogoProductsJson,
      "bogoServices": bogoServicesJson,
      "promocode": promocode != null ? promocode!.toJson() : null,
      "storeCategoryId": storeCategoryId ?? "",
      "storeCategoryDesc": storeCategoryDesc ?? "",
      "storeLocation": storeLocation != null
          ? {
              "type": "Point",
              "coordinates": [storeLocation!.longitude, storeLocation!.latitude]
            }
          : null,
      "completeDateTime": completeDateTime != null ? completeDateTime!.toUtc().toIso8601String() : null,
      "serviceDateTime": serviceDateTime != null ? serviceDateTime!.toUtc().toIso8601String() : null,
      // Pickup Data
      "pickupDateTime": pickupDateTime != null ? pickupDateTime!.toUtc().toIso8601String() : null,
      "payAtStore": payAtStore ?? false,
      // Delivery Data
      "cashOnDelivery": cashOnDelivery ?? false,
      "noContactDelivery": noContactDelivery ?? true,
      "deliveryAddress": deliveryAddress != null ? deliveryAddress!.toJson() : null,
      "deliveryPartnerDetails": deliveryPartnerDetails ?? Map<String, dynamic>(),
      "deliveryDetail": deliveryDetail ?? Map<String, dynamic>(),
      ////
      "rewardPointData": rewardPointData ?? Map<String, dynamic>(),
      // "rewardPointsEarnedPerOrder": rewardPointsEarnedPerOrder ?? 0,
      "redeemRewardData": redeemRewardData ?? Map<String, dynamic>(),
      "paymentDetail": paymentDetail != null ? paymentDetail!.toJson() : null,
      ///////////////////////////////////////////
      "pickupDeliverySatus": pickupDeliverySatus ?? false,
      "payStatus": payStatus ?? false,
      "paymentApiData": paymentApiData ?? Map<String, dynamic>(),
      "scratchCard": scratchCard ?? [],
      "reasonForCancelOrReject": reasonForCancelOrReject ?? "",
      // invoice Data
      "paymentFor": paymentFor ?? "",
      "notes": notes ?? Map<String, dynamic>(),
      "dueDate": dueDate != null ? dueDate!.toUtc().toIso8601String() : null,
      ///////////////////////////////////////////
      "coupon": coupon != null ? coupon!.toJson() : null,
      "couponVaidate": couponVaidate != null ? couponVaidate : null,
      "updatedAt": updatedAt != null ? updatedAt!.toUtc().toIso8601String() : null,
      "createdAt": createdAt != null ? createdAt!.toUtc().toIso8601String() : null,
      "distance": distance ?? 0,
      "walletTransactionId": walletTransactionId,
      "walletSettledTransactionId": walletSettledTransactionId,
      "walletRefundTransactionId": walletRefundTransactionId,
      "settled": settled,
      "orderHistorySteps": orderHistorySteps ?? [],
      "orderFutureSteps": orderFutureSteps ?? [],
    };
  }

  factory OrderModel.copy(OrderModel model) {
    List<ProductOrderModel> products = [];
    List<ServiceOrderModel> services = [];

    for (var i = 0; i < model.products!.length; i++) {
      products.add(ProductOrderModel.fromJson(model.products![i].toJson()));
    }

    for (var i = 0; i < model.services!.length; i++) {
      services.add(ServiceOrderModel.fromJson(model.services![i].toJson()));
    }

    List<ProductOrderModel> bogoProducts = [];
    List<ServiceOrderModel> bogoServices = [];

    for (var i = 0; i < model.bogoProducts!.length; i++) {
      bogoProducts.add(ProductOrderModel.fromJson(model.bogoProducts![i].toJson()));
    }

    for (var i = 0; i < model.bogoServices!.length; i++) {
      bogoServices.add(ServiceOrderModel.fromJson(model.bogoServices![i].toJson()));
    }

    return OrderModel(
      id: model.id,
      orderId: model.orderId,
      invoiceId: model.invoiceId,
      initiatedBy: model.initiatedBy,
      userId: model.userId,
      storeId: model.storeId,
      userModel: model.userModel != null ? UserModel.copy(model.userModel!) : null,
      storeModel: model.storeModel != null ? StoreModel.copy(model.storeModel!) : null,
      category: model.category,
      orderType: model.orderType,
      status: model.status,
      // qrcodeImgUrl: model.qrcodeImgUrl,
      qrCodeData: model.qrCodeData,
      invoicePdfUrl: model.invoicePdfUrl,
      invoicePdfUrlForStore: model.invoicePdfUrlForStore,
      instructions: model.instructions,
      products: products,
      services: services,
      bogoProducts: bogoProducts,
      bogoServices: bogoServices,
      promocode: model.promocode != null ? PromocodeModel.copy(model.promocode!) : null,
      storeCategoryId: model.storeCategoryId,
      storeCategoryDesc: model.storeCategoryDesc,
      storeLocation: model.storeLocation != null ? LatLng.fromJson(model.storeLocation!.toJson()) : null,
      completeDateTime: model.completeDateTime,
      serviceDateTime: model.serviceDateTime,
      // Pickup Data
      pickupDateTime: model.pickupDateTime,
      payAtStore: model.payAtStore,
      // Delivery Data
      cashOnDelivery: model.cashOnDelivery,
      noContactDelivery: model.noContactDelivery,
      deliveryAddress: model.deliveryAddress != null ? DeliveryAddressModel.copy(model.deliveryAddress!) : null,
      deliveryPartnerDetails: json.decode(json.encode(model.deliveryPartnerDetails!)),
      deliveryDetail: json.decode(json.encode(model.deliveryDetail!)),
      ////
      rewardPointData: json.decode(json.encode(model.rewardPointData!)),
      // rewardPointsEarnedPerOrder: model.rewardPointsEarnedPerOrder,
      redeemRewardData: json.decode(json.encode(model.redeemRewardData!)),
      paymentDetail: model.paymentDetail != null ? PaymentDetailModel.copy(model.paymentDetail!) : null,
      ///////////////////////////////////////////
      pickupDeliverySatus: model.pickupDeliverySatus,
      payStatus: model.payStatus,
      paymentApiData: json.decode(json.encode(model.paymentApiData!)),
      razorPayData: json.decode(json.encode(model.razorPayData!)),
      iciciUPIData: json.decode(json.encode(model.iciciUPIData!)),
      scratchCard: List.from(model.scratchCard!),
      reasonForCancelOrReject: model.reasonForCancelOrReject,
      // invoice Data
      paymentFor: model.paymentFor,
      notes: model.notes,
      dueDate: model.dueDate,
      ///////////////////////////////////////////
      coupon: model.coupon != null ? CouponModel.copy(model.coupon!) : null,
      couponVaidate: model.couponVaidate,
      updatedAt: model.updatedAt,
      createdAt: model.createdAt,
      distance: model.distance,
      walletTransactionId: model.walletTransactionId,
      walletSettledTransactionId: model.walletSettledTransactionId,
      walletRefundTransactionId: model.walletRefundTransactionId,
      settled: model.settled,
      orderHistorySteps: model.orderHistorySteps,
      orderFutureSteps: model.orderFutureSteps,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        orderId!,
        invoiceId!,
        initiatedBy!,
        userId ?? Object(),
        storeId ?? Object(),
        userModel ?? Object(),
        storeModel ?? Object(),
        category!,
        orderType!,
        status!,
        // qrcodeImgUrl!,
        qrCodeData!,
        invoicePdfUrl!,
        invoicePdfUrlForStore!,
        instructions!,
        products!,
        services!,
        bogoProducts!,
        bogoServices!,
        promocode ?? Object(),
        storeCategoryId!,
        storeCategoryDesc!,
        storeLocation ?? Object(),
        completeDateTime ?? Object(),
        serviceDateTime ?? Object(),
        // Pickup Data
        pickupDateTime ?? Object(),
        payAtStore!,
        // Delivery Data
        cashOnDelivery!,
        noContactDelivery!,
        deliveryAddress ?? Object(),
        deliveryPartnerDetails!,
        deliveryDetail!,
        ////
        rewardPointData!,
        // rewardPointsEarnedPerOrder!,
        redeemRewardData!,
        paymentDetail ?? Object(),
        ///////////////////////////////////////////
        pickupDeliverySatus!,
        payStatus!,
        paymentApiData!,
        scratchCard!,
        reasonForCancelOrReject!,
        // invoice Data
        paymentFor!,
        notes!,
        dueDate ?? Object(),
        ///////////////////////////////////////////
        coupon ?? Object,
        couponVaidate!,
        dueDate ?? Object(),
        distance!,
        walletTransactionId!,
        walletSettledTransactionId!,
        walletRefundTransactionId!,
        settled!,
        orderHistorySteps!,
        orderFutureSteps!,
      ];

  @override
  bool get stringify => true;

  ///
  Future<Map<String, dynamic>> checkItemsAvaialbe() async {
    List<dynamic> unAvailableProductIds = [];
    List<dynamic> productIds = [];

    for (var i = 0; i < products!.length; i++) {
      productIds.add(products![i].productModel!.id);
    }

    for (var i = 0; i < bogoProducts!.length; i++) {
      productIds.add(bogoProducts![i].productModel!.id);
    }

    if (productIds.isNotEmpty) {
      var result = await ProductApiProvider.checkProductsAvaialbe(
        storeId: storeModel!.id,
        productIds: productIds,
      );

      if (result["success"] && result["data"].isNotEmpty) {
        for (var i = 0; i < result["data"].length; i++) {
          unAvailableProductIds.add(result["data"][i]["_id"]);
        }
      }
    }

    List<dynamic> unAvailableServiceIds = [];
    List<dynamic> serviceIds = [];

    for (var i = 0; i < services!.length; i++) {
      serviceIds.add(services![i].serviceModel!.id);
    }

    for (var i = 0; i < bogoServices!.length; i++) {
      serviceIds.add(bogoServices![i].serviceModel!.id);
    }

    if (serviceIds.isNotEmpty) {
      var result = await ServiceApiProvider.checkServicesAvaialbe(
        storeId: storeModel!.id,
        serviceIds: serviceIds,
      );

      if (result["success"] && result["data"].isNotEmpty) {
        for (var i = 0; i < result["data"].length; i++) {
          unAvailableServiceIds.add(result["data"][i]["_id"]);
        }
      }
    }

    return {
      "products": unAvailableProductIds,
      "services": unAvailableServiceIds,
    };
  }
}
