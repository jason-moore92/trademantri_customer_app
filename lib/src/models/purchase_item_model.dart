import "package:equatable/equatable.dart";
import 'package:trapp/config/config.dart';

import 'index.dart';

class PurchaseItemModel extends Equatable {
  String? category;
  String? name;
  List<dynamic>? images;
  double? quantity;
  // double? buyingPrice;
  double? itemPrice;
  double? price;
  double? discount;
  bool? acceptBulkOrder;
  double? minQuantityForBulkOrder;
  double? orderPrice;
  double? taxPrice;
  int? taxPercentage;
  String? taxType;
  String? productId;
  String? status;
  DateTime? updateAt;

  PurchaseItemModel({
    this.category = "",
    this.name = "",
    this.images = const [],
    this.quantity = 0,
    // this.buyingPrice = 0,
    this.itemPrice = 0,
    this.price = 0,
    this.discount = 0,
    this.acceptBulkOrder = false,
    this.minQuantityForBulkOrder = 0,
    this.orderPrice = 0,
    this.taxPrice = 0,
    this.taxPercentage = 0,
    this.taxType = null,
    this.productId = "",
    this.status = "",
    this.updateAt,
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> map) {
    return PurchaseItemModel(
      category: map["category"] ?? "",
      name: map["name"] ?? "",
      images: map["images"] ?? [],
      quantity: map["quantity"] != null ? double.parse(map["quantity"].toString()) : 0,
      // buyingPrice: map["buyingPrice"] != null ? double.parse(map["buyingPrice"].toString()) : 0,
      itemPrice: map["itemPrice"] != null ? double.parse(map["itemPrice"].toString()) : 0,
      price: map["price"] != null ? double.parse(map["price"].toString()) : 0,
      discount: map["discount"] != null ? double.parse(map["discount"].toString()) : 0,
      acceptBulkOrder: map["acceptBulkOrder"] ?? false,
      minQuantityForBulkOrder: map["minQuantityForBulkOrder"] != null ? double.parse(map["minQuantityForBulkOrder"].toString()) : 0,
      orderPrice: map["orderPrice"] != null ? double.parse(map["orderPrice"].toString()) : 0,
      taxPrice: map["taxPrice"] != null ? double.parse(map["taxPrice"].toString()) : 0,
      taxPercentage: map["taxPercentage"] != null ? double.parse(map["taxPercentage"].toString()).toInt() : 0,
      taxType: map["taxType"] ?? null,
      productId: map["productId"] ?? "",
      status: map["status"] ?? "",
      updateAt: map["updateAt"] != null ? DateTime.tryParse(map["updateAt"])!.toLocal() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category": category != null ? category : "",
      "name": name != null ? name : "",
      "images": images != null ? images : [],
      "quantity": quantity != null ? quantity : 0,
      // "buyingPrice": buyingPrice != null ? buyingPrice : 0,
      "itemPrice": itemPrice != null ? itemPrice : 0,
      "price": price != null ? price : 0,
      "discount": discount != null ? discount : 0,
      "acceptBulkOrder": acceptBulkOrder != null ? acceptBulkOrder : false,
      "minQuantityForBulkOrder": minQuantityForBulkOrder != null ? minQuantityForBulkOrder : 0,
      "orderPrice": orderPrice != null ? orderPrice : 0,
      "taxPrice": taxPrice != null ? taxPrice : 0,
      "taxPercentage": taxPercentage != null ? taxPercentage : 0,
      "taxType": taxType != null ? taxType : null,
      "productId": productId != null ? productId : "",
      "status": status != null ? status : "",
      "updateAt": updateAt != null ? updateAt!.toUtc().toIso8601String() : null,
    };
  }

  factory PurchaseItemModel.copy(PurchaseItemModel model) {
    return PurchaseItemModel(
      category: model.category,
      name: model.name,
      images: model.images,
      quantity: model.quantity,
      // buyingPrice: model.buyingPrice,
      itemPrice: model.itemPrice,
      price: model.price,
      discount: model.discount,
      acceptBulkOrder: model.acceptBulkOrder,
      minQuantityForBulkOrder: model.minQuantityForBulkOrder,
      orderPrice: model.orderPrice,
      taxPrice: model.taxPrice,
      taxPercentage: model.taxPercentage,
      taxType: model.taxType,
      productId: model.productId,
      status: model.status,
      updateAt: model.updateAt,
    );
  }

  @override
  List<Object> get props => [
        category!,
        name!,
        images!,
        quantity!,
        // buyingPrice!,
        itemPrice!,
        price!,
        discount!,
        acceptBulkOrder!,
        minQuantityForBulkOrder!,
        orderPrice!,
        taxPrice!,
        taxPercentage!,
        taxType!,
        productId!,
        status!,
        updateAt!,
      ];

  @override
  bool get stringify => true;
}
