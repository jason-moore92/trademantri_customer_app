import 'dart:convert';
import 'dart:io';

import "package:equatable/equatable.dart";
import 'package:flutter/cupertino.dart';

class ProductModel extends Equatable {
  String? id;
  String? name;
  String? description;
  String? category;
  String? brand;
  double? quantity;
  String? quantityType;
  String? storeId;
  double? price;
  bool? isAvailable;
  String? racklocation;
  double? stockavailable;
  double? taxPercentage;
  String? taxType;
  double? discount;
  bool? showPriceToUsers;
  String? productIdentificationCode;
  List<dynamic>? images;
  bool? bargainAvailable;
  bool? acceptBulkOrder;
  bool? realBulkOrder;
  double? minQuantityForBulkOrder;
  bool? isDeleted;
  bool? listonline;
  dynamic variant;
  Map<String, dynamic>? priceAttributes;
  double? margin;
  Map<String, dynamic>? bargainAttributes;
  Map<String, dynamic>? extraCharges;
  List<dynamic>? attributes;
  File? imageFile;
  String? b2bPriceType;
  double? b2bPriceFrom;
  double? b2bPriceTo;
  String? b2bDiscountType;
  double? b2bDiscountValue;
  double? b2bDiscount;
  bool? b2bAcceptBulkOrder;
  double? b2bMinQuantityForBulkOrder;
  double? b2bTaxPercentage;
  String? b2bTaxType;

  ProductModel({
    String? id,
    String? name,
    String? description,
    String? category,
    String? brand,
    double? quantity,
    String? quantityType,
    String? storeId,
    double? price,
    bool? isAvailable,
    String? racklocation,
    double? stockavailable,
    double? taxPercentage,
    String? taxType,
    double? discount,
    bool? showPriceToUsers,
    String? productIdentificationCode,
    List<dynamic>? images,
    bool? bargainAvailable,
    bool? acceptBulkOrder,
    bool? realBulkOrder,
    double? minQuantityForBulkOrder,
    bool? isDeleted,
    bool? listonline,
    dynamic variant,
    Map<String, dynamic>? priceAttributes,
    double? margin,
    Map<String, dynamic>? bargainAttributes,
    Map<String, dynamic>? extraCharges,
    List<dynamic>? attributes,
    File? imageFile,
    String? b2bPriceType,
    double? b2bPriceFrom,
    double? b2bPriceTo,
    String? b2bDiscountType,
    double? b2bDiscountValue,
    double? b2bDiscount,
    bool? b2bAcceptBulkOrder,
    double? b2bMinQuantityForBulkOrder,
    double? b2bTaxPercentage,
    String? b2bTaxType,
  }) {
    this.id = id ?? null;
    this.name = name ?? "";
    this.description = description ?? "";
    this.category = category ?? "";
    this.brand = brand ?? "";
    this.quantity = quantity ?? null;
    this.quantityType = quantityType ?? null;
    this.storeId = storeId ?? "";
    this.price = price ?? 0;
    this.isAvailable = isAvailable ?? false;
    this.racklocation = racklocation ?? "";
    this.stockavailable = stockavailable ?? 0;
    this.taxPercentage = taxPercentage ?? 0;
    this.taxType = taxType ?? "Inclusive";
    this.discount = discount ?? 0;
    this.showPriceToUsers = showPriceToUsers ?? false;
    this.productIdentificationCode = productIdentificationCode ?? "";
    this.images = images ?? [];
    this.bargainAvailable = bargainAvailable ?? false;
    this.acceptBulkOrder = acceptBulkOrder ?? false;
    this.realBulkOrder = realBulkOrder ?? false;
    this.minQuantityForBulkOrder = minQuantityForBulkOrder ?? 0;
    this.isDeleted = isDeleted ?? false;
    this.listonline = listonline ?? false;
    this.variant = variant ?? null;
    this.priceAttributes = priceAttributes ?? Map<String, dynamic>();
    this.margin = margin ?? 0;
    this.bargainAttributes = bargainAttributes ?? Map<String, dynamic>();
    this.extraCharges = extraCharges ?? Map<String, dynamic>();
    this.attributes = attributes ?? [];
    this.imageFile = imageFile ?? null;
    this.b2bPriceType = b2bPriceType ?? "Fixed";
    this.b2bPriceFrom = b2bPriceFrom ?? 0;
    this.b2bPriceTo = b2bPriceTo ?? 0;
    this.b2bDiscountType = b2bDiscountType ?? "Amount";
    this.b2bDiscountValue = b2bDiscountValue ?? 0;
    this.b2bDiscount = b2bDiscount ?? 0;
    this.b2bAcceptBulkOrder = b2bAcceptBulkOrder ?? false;
    this.b2bMinQuantityForBulkOrder = b2bMinQuantityForBulkOrder ?? 0;
    this.b2bTaxPercentage = b2bTaxPercentage ?? 0;
    this.b2bTaxType = b2bTaxType ?? null;
  }

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      id: map["_id"] ?? map["id"] ?? null,
      name: map["name"] ?? "",
      description: map["description"] ?? "",
      category: map["category"] ?? "",
      brand: map["brand"] ?? "",
      quantity: map["quantity"] != null ? double.parse(map["quantity"].toString()) : null,
      quantityType: map["quantityType"] ?? null,
      storeId: map["storeId"] ?? "",
      price: map["price"] != null ? double.parse(map["price"].toString()) : 0,
      isAvailable: map["isAvailable"] != null ? json.decode(map["isAvailable"].toString()) : false,
      racklocation: map["racklocation"] ?? "",
      stockavailable: map["stockavailable"] != null ? double.parse(map["stockavailable"].toString()) : 0,
      taxPercentage: map["taxPercentage"] != null ? double.parse(map["taxPercentage"].toString()) : 0,
      taxType: map["taxType"] ?? "Inclusive",
      discount: map["discount"] != null ? double.parse(map["discount"].toString()) : 0,
      showPriceToUsers: map["showPriceToUsers"] != null ? json.decode(map["showPriceToUsers"].toString()) : false,
      productIdentificationCode: map["productIdentificationCode"] ?? "",
      images: map["images"] != null
          ? map["images"].runtimeType.toString() == "String"
              ? json.decode(map["images"].toString())
              : map["images"]
          : [],
      bargainAvailable: map["bargainAvailable"] ?? false,
      acceptBulkOrder: map["acceptBulkOrder"] ?? false,
      realBulkOrder: map["realBulkOrder"] ?? false,
      minQuantityForBulkOrder: map["minQuantityForBulkOrder"] != null ? double.parse(map["minQuantityForBulkOrder"].toString()) : 0,
      isDeleted: map["isDeleted"] ?? false,
      listonline: map["listonline"] ?? true,
      variant: map["variant"],
      priceAttributes: map["priceAttributes"] ?? Map<String, dynamic>(),
      margin: map["margin"] != null ? double.parse(map["margin"].toString()) : 0,
      bargainAttributes: map["bargainAttributes"] ?? Map<String, dynamic>(),
      extraCharges: map["extraCharges"] ?? Map<String, dynamic>(),
      attributes: map["attributes"] ?? [],
      imageFile: map["imageFile"] ?? null,
      b2bPriceType: map["b2bPriceType"] ?? "Fixed",
      b2bPriceFrom: map["b2bPriceFrom"] != null ? double.parse(map["b2bPriceFrom"].toString()) : 0,
      b2bPriceTo: map["b2bPriceTo"] != null ? double.parse(map["b2bPriceTo"].toString()) : 0,
      b2bDiscountType: map["b2bDiscountType"] ?? "Amount",
      b2bDiscountValue: map["b2bDiscountValue"] != null ? double.parse(map["b2bDiscountValue"].toString()) : 0,
      b2bDiscount: map["b2bDiscount"] != null ? double.parse(map["b2bDiscount"].toString()) : 0,
      b2bAcceptBulkOrder: map["b2bAcceptBulkOrder"] ?? false,
      b2bMinQuantityForBulkOrder: map["b2bMinQuantityForBulkOrder"] != null ? double.parse(map["b2bMinQuantityForBulkOrder"].toString()) : 0,
      b2bTaxPercentage: map["b2bTaxPercentage"] != null ? double.parse(map["b2bTaxPercentage"].toString()) : 0,
      b2bTaxType: map["b2bTaxType"] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "id": id ?? null,
      "name": name ?? "",
      "description": description ?? "",
      "category": category ?? "",
      "brand": brand ?? "",
      "quantity": quantity != null ? quantity : null,
      "quantityType": quantityType ?? null,
      "storeId": storeId ?? "",
      "price": price != null ? price : 0,
      "isAvailable": isAvailable ?? false,
      "racklocation": racklocation ?? "",
      "stockavailable": stockavailable != null ? stockavailable : 0,
      "taxPercentage": taxPercentage != null ? taxPercentage : 0,
      "taxType": taxType ?? "Inclusive",
      "discount": discount != null ? discount : 0,
      "showPriceToUsers": showPriceToUsers ?? false,
      "productIdentificationCode": productIdentificationCode ?? "",
      "images": images ?? [],
      "bargainAvailable": bargainAvailable ?? false,
      "acceptBulkOrder": acceptBulkOrder ?? false,
      "realBulkOrder": realBulkOrder ?? false,
      "minQuantityForBulkOrder": minQuantityForBulkOrder != null ? minQuantityForBulkOrder : 0,
      "isDeleted": isDeleted ?? false,
      "listonline": listonline ?? true,
      "variant": variant,
      "priceAttributes": priceAttributes ?? Map<String, dynamic>(),
      "margin": margin != null ? margin! : 0,
      "bargainAttributes": bargainAttributes ?? Map<String, dynamic>(),
      "extraCharges": extraCharges ?? Map<String, dynamic>(),
      "attributes": attributes ?? [],
      "b2bPriceType": b2bPriceType ?? "Fixed",
      "b2bPriceFrom": b2bPriceFrom ?? 0,
      "b2bPriceTo": b2bPriceTo ?? 0,
      "b2bDiscountType": b2bDiscountType ?? "Amount",
      "b2bDiscountValue": b2bDiscountValue ?? 0,
      "b2bDiscount": b2bDiscount ?? 0,
      "b2bAcceptBulkOrder": b2bAcceptBulkOrder ?? false,
      "b2bMinQuantityForBulkOrder": b2bMinQuantityForBulkOrder ?? 0,
      "b2bTaxPercentage": b2bTaxPercentage ?? 0,
      "b2bTaxType": b2bTaxType ?? null,
    };
  }

  factory ProductModel.copy(ProductModel model) {
    return ProductModel(
      id: model.id,
      name: model.name,
      description: model.description,
      category: model.category,
      brand: model.brand,
      quantity: model.quantity,
      quantityType: model.quantityType,
      storeId: model.storeId,
      price: model.price,
      isAvailable: model.isAvailable,
      racklocation: model.racklocation,
      stockavailable: model.stockavailable,
      taxPercentage: model.taxPercentage,
      taxType: model.taxType,
      discount: model.discount,
      showPriceToUsers: model.showPriceToUsers,
      productIdentificationCode: model.productIdentificationCode,
      images: List.from(model.images!),
      bargainAvailable: model.bargainAvailable,
      acceptBulkOrder: model.acceptBulkOrder,
      realBulkOrder: model.realBulkOrder,
      minQuantityForBulkOrder: model.minQuantityForBulkOrder,
      isDeleted: model.isDeleted,
      listonline: model.listonline,
      variant: model.variant,
      priceAttributes: json.decode(json.encode(model.priceAttributes!)),
      margin: model.margin,
      bargainAttributes: json.decode(json.encode(model.bargainAttributes!)),
      extraCharges: json.decode(json.encode(model.extraCharges!)),
      attributes: List.from(model.attributes!),
      imageFile: model.imageFile,
      b2bPriceType: model.b2bPriceType,
      b2bPriceFrom: model.b2bPriceFrom,
      b2bPriceTo: model.b2bPriceTo,
      b2bDiscountType: model.b2bDiscountType,
      b2bDiscountValue: model.b2bDiscountValue,
      b2bDiscount: model.b2bDiscount,
      b2bAcceptBulkOrder: model.b2bAcceptBulkOrder,
      b2bMinQuantityForBulkOrder: model.b2bMinQuantityForBulkOrder,
      b2bTaxPercentage: model.b2bTaxPercentage,
      b2bTaxType: model.b2bTaxType,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        name!,
        description!,
        category!,
        brand!,
        quantity ?? Object(),
        quantityType ?? Object(),
        storeId!,
        price!,
        isAvailable!,
        racklocation!,
        stockavailable!,
        taxPercentage!,
        taxType ?? Object(),
        discount!,
        showPriceToUsers!,
        productIdentificationCode!,
        images!,
        bargainAvailable!,
        acceptBulkOrder!,
        realBulkOrder!,
        minQuantityForBulkOrder!,
        isDeleted!,
        listonline!,
        variant ?? Object(),
        priceAttributes!,
        margin!,
        bargainAttributes!,
        extraCharges!,
        attributes!,
        imageFile ?? Object(),
        b2bPriceType!,
        b2bPriceFrom!,
        b2bPriceTo!,
        b2bDiscountType!,
        b2bDiscountValue!,
        b2bDiscount!,
        b2bAcceptBulkOrder!,
        b2bMinQuantityForBulkOrder!,
        b2bTaxPercentage!,
        b2bTaxType ?? Object(),
      ];

  @override
  bool get stringify => true;
}
