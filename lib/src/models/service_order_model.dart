import "package:equatable/equatable.dart";

import 'index.dart';

class ServiceOrderModel extends Equatable {
  double? orderQuantity;
  double? couponQuantity;
  double? orderPrice;
  double? promocodeDiscount;
  double? promocodePercent;
  double? couponDiscount;
  String? taxType;
  double? taxPercentage;
  double? taxPriceBeforeDiscount;
  double? taxPriceAfterCouponDiscount;
  double? taxPriceAfterDiscount;
  ServiceModel? serviceModel;

  ServiceOrderModel({
    this.orderQuantity = 0,
    this.couponQuantity = 0,
    this.orderPrice = 0,
    this.promocodeDiscount = 0,
    this.promocodePercent = 0,
    this.couponDiscount = 0,
    this.taxType,
    this.taxPercentage = 0,
    this.taxPriceBeforeDiscount = 0,
    this.taxPriceAfterCouponDiscount = 0,
    this.taxPriceAfterDiscount = 0,
    this.serviceModel,
  });

  factory ServiceOrderModel.fromJson(Map<String, dynamic> map) {
    double orderPrice = 0;
    ServiceModel serviceModel = map["data"] != null ? ServiceModel.fromJson(map["data"]) : ServiceModel();

    if (map["orderPrice"] != null && double.parse(map["orderPrice"].toString()) != 0) {
      orderPrice = double.parse(map["orderPrice"].toString());
    } else {
      orderPrice = serviceModel.price! - serviceModel.discount!;
    }

    return ServiceOrderModel(
      orderQuantity: map["orderQuantity"] != null ? double.parse(map["orderQuantity"].toString()) : 0,
      couponQuantity: map["couponQuantity"] != null ? double.parse(map["couponQuantity"].toString()) : 0,
      orderPrice: orderPrice,
      promocodeDiscount: map["promocodeDiscount"] != null ? double.parse(map["promocodeDiscount"].toString()) : 0,
      promocodePercent: map["promocodePercent"] != null ? double.parse(map["promocodePercent"].toString()) : 0,
      couponDiscount: map["couponDiscount"] != null ? double.parse(map["couponDiscount"].toString()) : 0,
      taxType: map["taxType"] ?? null,
      taxPercentage: map["taxPercentage"] != null ? double.parse(map["taxPercentage"].toString()) : 0,
      taxPriceBeforeDiscount: map["taxPriceBeforeDiscount"] != null ? double.parse(map["taxPriceBeforeDiscount"].toString()) : 0,
      taxPriceAfterCouponDiscount: map["taxPriceAfterCouponDiscount"] != null ? double.parse(map["taxPriceAfterCouponDiscount"].toString()) : 0,
      taxPriceAfterDiscount: map["taxPriceAfterDiscount"] != null ? double.parse(map["taxPriceAfterDiscount"].toString()) : 0,
      serviceModel: serviceModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderQuantity": orderQuantity != null ? orderQuantity! : 0,
      "couponQuantity": couponQuantity != null ? couponQuantity! : 0,
      "orderPrice": orderPrice != null ? orderPrice! : 0,
      "promocodeDiscount": promocodeDiscount != null ? promocodeDiscount! : 0,
      "promocodePercent": promocodePercent != null ? promocodePercent! : 0,
      "couponDiscount": couponDiscount != null ? couponDiscount! : 0,
      "taxType": taxType != null ? taxType! : null,
      "taxPercentage": taxPercentage != null ? taxPercentage! : 0,
      "taxPriceBeforeDiscount": taxPriceBeforeDiscount != null ? taxPriceBeforeDiscount! : 0,
      "taxPriceAfterCouponDiscount": taxPriceAfterCouponDiscount != null ? taxPriceAfterCouponDiscount! : 0,
      "taxPriceAfterDiscount": taxPriceAfterDiscount != null ? taxPriceAfterDiscount! : 0,
      "data": serviceModel != null ? serviceModel!.toJson() : Map<String, dynamic>(),
    };
  }

  factory ServiceOrderModel.copy(ServiceOrderModel model) {
    return ServiceOrderModel(
      orderQuantity: model.orderQuantity,
      couponQuantity: model.couponQuantity,
      orderPrice: model.orderPrice,
      promocodeDiscount: model.promocodeDiscount,
      promocodePercent: model.promocodePercent,
      couponDiscount: model.couponDiscount,
      taxType: model.taxType,
      taxPercentage: model.taxPercentage,
      taxPriceBeforeDiscount: model.taxPriceBeforeDiscount,
      taxPriceAfterCouponDiscount: model.taxPriceAfterCouponDiscount,
      taxPriceAfterDiscount: model.taxPriceAfterDiscount,
      serviceModel: ServiceModel.copy(model.serviceModel!),
    );
  }

  @override
  List<Object> get props => [
        orderQuantity!,
        couponQuantity!,
        orderPrice!,
        promocodeDiscount!,
        promocodePercent!,
        couponDiscount!,
        taxType ?? Object(),
        taxPercentage!,
        taxPriceBeforeDiscount!,
        taxPriceAfterCouponDiscount!,
        taxPriceAfterDiscount!,
        serviceModel!,
      ];

  @override
  bool get stringify => true;
}
