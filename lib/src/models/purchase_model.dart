import 'dart:convert';

import "package:equatable/equatable.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'index.dart';

class PurchaseModel extends Equatable {
  String? id;
  String? purchaseOrderId;
  // String? qrcodeImgUrl;
  String? qrCodeData;
  String? pdfUrl;
  StoreModel? businessStoreModel;
  StoreModel? myStoreModel;
  List<dynamic>? additionalMails; // Cart, Assistant, Reverse Auction, Bargain,
  String? mailingAddress;
  LatLng? mailingLocation;
  String? shipTo;
  AddressModel? shippingAddress;
  String? shipVia;
  String? salesRep;
  DateTime? purchaseDate;
  DateTime? dueDate;
  Map<String, ProductModel>? productsData;
  Map<String, ServiceModel>? servicesData;
  List<PurchaseItemModel>? purchaseProducts;
  List<PurchaseItemModel>? purchaseServices;
  String? message;
  String? attachFile;
  String? status;

  PurchaseModel({
    String? id,
    String? purchaseOrderId,
    // String? qrcodeImgUrl,
    String? qrCodeData,
    String? pdfUrl,
    StoreModel? businessStoreModel,
    StoreModel? myStoreModel,
    List<dynamic>? additionalMails,
    String? mailingAddress,
    LatLng? mailingLocation,
    String? shipTo,
    AddressModel? shippingAddress,
    String? shipVia,
    String? salesRep,
    DateTime? purchaseDate,
    DateTime? dueDate,
    Map<String, ProductModel>? productsData,
    Map<String, ServiceModel>? servicesData,
    List<PurchaseItemModel>? purchaseProducts,
    List<PurchaseItemModel>? purchaseServices,
    String? message,
    String? attachFile,
    String? status,
  }) {
    this.id = id ?? null;
    this.purchaseOrderId = purchaseOrderId ?? "";
    // this.qrcodeImgUrl = qrcodeImgUrl ?? "";
    this.qrCodeData = qrCodeData ?? "";
    this.pdfUrl = pdfUrl ?? "";
    this.businessStoreModel = businessStoreModel ?? null;
    this.myStoreModel = myStoreModel ?? null;
    this.additionalMails = additionalMails ?? [];
    this.mailingAddress = mailingAddress ?? "";
    this.mailingLocation = mailingLocation ?? null;
    this.shipTo = shipTo ?? "";
    this.shippingAddress = shippingAddress ?? null;
    this.shipVia = shipVia ?? "";
    this.salesRep = salesRep ?? "";
    this.purchaseDate = purchaseDate ?? null;
    this.dueDate = dueDate ?? null;
    this.productsData = productsData ?? Map<String, ProductModel>();
    this.servicesData = servicesData ?? Map<String, ServiceModel>();
    this.purchaseProducts = purchaseProducts ?? [];
    this.purchaseServices = purchaseServices ?? [];
    this.message = message ?? "";
    this.attachFile = attachFile ?? "";
    this.status = status ?? "";
  }

  factory PurchaseModel.fromJson(Map<String, dynamic> map) {
    map = json.decode(json.encode(map));

    //////////////////////////////////////////////
    map["purchaseProducts"] = map["purchaseProducts"] ?? [];
    map["purchaseServices"] = map["purchaseServices"] ?? [];

    List<PurchaseItemModel> purchaseProducts = [];
    List<PurchaseItemModel> purchaseServices = [];

    for (var i = 0; i < map["purchaseProducts"].length; i++) {
      purchaseProducts.add(PurchaseItemModel.fromJson(map["purchaseProducts"][i]));
    }

    for (var i = 0; i < map["purchaseServices"].length; i++) {
      purchaseServices.add(PurchaseItemModel.fromJson(map["purchaseServices"][i]));
    }
    //////////////////////////////////////////////

    //////////////////////////////////////////////
    Map<String, ProductModel> productsData = Map<String, ProductModel>();
    Map<String, ServiceModel> servicesData = Map<String, ServiceModel>();

    map["productsData"] = map["productsData"] ?? Map<String, ProductModel>();
    map["servicesData"] = map["servicesData"] ?? Map<String, ServiceModel>();

    map["productsData"].forEach((id, data) {
      productsData[id] = ProductModel.fromJson(data);
    });

    map["servicesData"].forEach((id, data) {
      servicesData[id] = ServiceModel.fromJson(data);
    });
    //////////////////////////////////////////////

    //////////////////////////////////////////////
    if (map["myStore"] != null && map["myStore"].runtimeType.toString().contains("Map<String, dynamic>")) {
      map["myStore"] = StoreModel.fromJson(map["myStore"]);
    }

    if (map["businessStore"] != null && map["businessStore"].runtimeType.toString().contains("Map<String, dynamic>")) {
      map["businessStore"] = StoreModel.fromJson(map["businessStore"]);
    }
    //////////////////////////////////////////////

    return PurchaseModel(
      id: map["_id"] ?? null,
      purchaseOrderId: map["purchaseOrderId"] ?? "",
      // qrcodeImgUrl: map["qrcodeImgUrl"] ?? "",
      qrCodeData: map["qrCodeData"] ?? "",

      pdfUrl: map["pdfUrl"] ?? "",
      businessStoreModel: map["businessStore"] ?? null,
      myStoreModel: map["myStore"] ?? null,
      additionalMails: map["additionalMails"] ?? [],
      mailingAddress: map["mailingAddress"] ?? "",
      mailingLocation:
          map["mailingLocation"] != null ? LatLng(map["mailingLocation"]["coordinates"][1], map["mailingLocation"]["coordinates"][0]) : null,
      shipTo: map["shipTo"] ?? "",
      shippingAddress: map["shippingAddress"] != null ? AddressModel.fromJson(map["shippingAddress"]) : null,
      shipVia: map["shipVia"] ?? "",
      salesRep: map["salesRep"] ?? "",
      purchaseDate: map["purchaseDate"] != null ? DateTime.tryParse(map["purchaseDate"])!.toLocal() : null,
      dueDate: map["dueDate"] != null ? DateTime.tryParse(map["dueDate"])!.toLocal() : null,
      productsData: productsData,
      servicesData: servicesData,
      purchaseProducts: purchaseProducts,
      purchaseServices: purchaseServices,
      message: map["message"] ?? "",
      attachFile: map["attachFile"] ?? "",
      status: map["status"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    List<dynamic> purchaseProductsJson = [];
    List<dynamic> purchaseServicesJson = [];

    for (var i = 0; i < purchaseProducts!.length; i++) {
      purchaseProductsJson.add(purchaseProducts![i].toJson());
    }

    for (var i = 0; i < purchaseServices!.length; i++) {
      purchaseServicesJson.add(purchaseServices![i].toJson());
    }

    Map<String, dynamic> productsDataJson = Map<String, dynamic>();
    Map<String, dynamic> servicesDataJson = Map<String, dynamic>();

    productsData!.forEach((id, data) {
      productsDataJson[id] = data.toJson();
    });

    servicesData!.forEach((id, data) {
      servicesDataJson[id] = data.toJson();
    });

    return {
      "_id": id ?? null,
      "purchaseOrderId": purchaseOrderId ?? "",
      // "qrcodeImgUrl": qrcodeImgUrl ?? "",
      "qrCodeData": qrCodeData ?? "",
      "pdfUrl": pdfUrl ?? "",
      "businessStoreId": businessStoreModel!.id ?? "",
      "myStoreId": myStoreModel!.id ?? "",
      "additionalMails": additionalMails ?? [],
      "mailingAddress": mailingAddress ?? "",
      "mailingLocation": mailingLocation != null
          ? {
              "type": "Point",
              "coordinates": [mailingLocation!.longitude, mailingLocation!.latitude]
            }
          : null,
      "shipTo": shipTo ?? "",
      "shippingAddress": shippingAddress != null ? shippingAddress!.toJson() : null,
      "shipVia": shipVia ?? "",
      "salesRep": salesRep ?? "",
      "purchaseDate": purchaseDate != null ? purchaseDate!.toUtc().toIso8601String() : null,
      "dueDate": dueDate != null ? dueDate!.toUtc().toIso8601String() : null,
      "productsData": productsDataJson,
      "servicesData": servicesDataJson,
      "purchaseProducts": purchaseProductsJson,
      "purchaseServices": purchaseServicesJson,
      "message": message ?? "",
      "attachFile": attachFile ?? "",
      "status": status ?? "",
    };
  }

  factory PurchaseModel.copy(PurchaseModel model) {
    List<PurchaseItemModel> purchaseProducts = [];
    List<PurchaseItemModel> purchaseServices = [];

    for (var i = 0; i < model.purchaseProducts!.length; i++) {
      purchaseProducts.add(PurchaseItemModel.fromJson(model.purchaseProducts![i].toJson()));
    }

    for (var i = 0; i < model.purchaseServices!.length; i++) {
      purchaseServices.add(PurchaseItemModel.fromJson(model.purchaseServices![i].toJson()));
    }

    Map<String, ProductModel> productsData = Map<String, ProductModel>();
    Map<String, ServiceModel> servicesData = Map<String, ServiceModel>();

    model.productsData!.forEach((id, data) {
      productsData[id] = ProductModel.fromJson(data.toJson());
    });

    model.servicesData!.forEach((id, data) {
      servicesData[id] = ServiceModel.fromJson(data.toJson());
    });

    return PurchaseModel(
      id: model.id,
      purchaseOrderId: model.purchaseOrderId,
      // qrcodeImgUrl: model.qrcodeImgUrl,
      qrCodeData: model.qrCodeData,
      pdfUrl: model.pdfUrl,
      businessStoreModel: model.businessStoreModel != null ? StoreModel.copy(model.businessStoreModel!) : null,
      myStoreModel: model.myStoreModel != null ? StoreModel.copy(model.myStoreModel!) : null,
      additionalMails: List.from(model.additionalMails!),
      mailingAddress: model.mailingAddress,
      mailingLocation: model.mailingLocation != null ? LatLng.fromJson(model.mailingLocation!.toJson()) : null,
      shipTo: model.shipTo,
      shippingAddress: model.shippingAddress != null ? AddressModel.copy(model.shippingAddress!) : null,
      shipVia: model.shipVia,
      salesRep: model.salesRep,
      purchaseDate: model.purchaseDate,
      dueDate: model.dueDate,
      productsData: productsData,
      servicesData: servicesData,
      purchaseProducts: purchaseProducts,
      purchaseServices: purchaseServices,
      message: model.message,
      attachFile: model.attachFile,
      status: model.status,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        purchaseOrderId!,
        // qrcodeImgUrl!,
        // qrCodeData!,
        pdfUrl!,
        businessStoreModel ?? Object(),
        myStoreModel ?? Object(),
        additionalMails!,
        mailingAddress!,
        mailingLocation ?? Object(),
        shipTo!,
        shippingAddress ?? Object(),
        shipVia!,
        salesRep!,
        purchaseDate ?? Object(),
        dueDate ?? Object(),
        productsData!,
        servicesData!,
        purchaseProducts!,
        purchaseServices!,
        message!,
        attachFile!,
        status!,
      ];

  @override
  bool get stringify => true;
}
