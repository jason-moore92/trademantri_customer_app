import "package:equatable/equatable.dart";

class PaymentDetailModel extends Equatable {
  double? totalQuantity;
  double? totalOriginPrice;
  double? totalPrice;
  double? totalPromocodeDiscount;
  double? totalCouponDiscount;
  double? deliveryChargeBeforeDiscount;
  double? deliveryChargeAfterDiscount;
  double? deliveryDiscount;
  double? distance;
  int? tip;
  double? totalTaxBeforeDiscount;
  double? totalTaxAfterCouponDiscount;
  double? totalTaxAfterDiscount;
  double? redeemRewardValue;
  double? redeemRewardPoint;
  double? toPay;
  String? taxType;
  List<dynamic>? taxBreakdown;
  double? rewardPointsEarnedPerOrder;

  PaymentDetailModel({
    double? totalQuantity,
    double? totalOriginPrice,
    double? totalPrice,
    double? totalPromocodeDiscount,
    double? totalCouponDiscount,
    double? deliveryChargeBeforeDiscount,
    double? deliveryChargeAfterDiscount,
    double? deliveryDiscount,
    double? distance,
    int? tip,
    double? totalTaxBeforeDiscount,
    double? totalTaxAfterCouponDiscount,
    double? totalTaxAfterDiscount,
    double? redeemRewardValue,
    double? redeemRewardPoint,
    double? toPay,
    String? taxType,
    List<dynamic>? taxBreakdown,
    double? rewardPointsEarnedPerOrder,
  }) {
    this.totalQuantity = totalQuantity ?? 0;
    this.totalOriginPrice = totalOriginPrice ?? 0;
    this.totalPrice = totalPrice ?? 0;
    this.totalPromocodeDiscount = totalPromocodeDiscount ?? 0;
    this.totalCouponDiscount = totalCouponDiscount ?? 0;
    this.deliveryChargeBeforeDiscount = deliveryChargeBeforeDiscount ?? 0;
    this.deliveryChargeAfterDiscount = deliveryChargeAfterDiscount ?? 0;
    this.deliveryDiscount = deliveryDiscount ?? 0;
    this.distance = distance ?? 0;
    this.tip = tip ?? 0;
    this.totalTaxBeforeDiscount = totalTaxBeforeDiscount ?? 0;
    this.totalTaxAfterCouponDiscount = totalTaxAfterCouponDiscount ?? 0;
    this.totalTaxAfterDiscount = totalTaxAfterDiscount ?? 0;
    this.redeemRewardValue = redeemRewardValue ?? 0;
    this.redeemRewardPoint = redeemRewardPoint ?? 0;
    this.toPay = toPay ?? 0;
    this.taxType = taxType ?? "";
    this.taxBreakdown = taxBreakdown ?? [];
    this.rewardPointsEarnedPerOrder = rewardPointsEarnedPerOrder ?? 0;
  }

  factory PaymentDetailModel.fromJson(Map<String, dynamic> map) {
    return PaymentDetailModel(
      totalQuantity: map["totalQuantity"] != null ? double.parse(map["totalQuantity"].toString()) : 0,
      totalOriginPrice: map["totalOriginPrice"] != null ? double.parse(map["totalOriginPrice"].toString()) : 0,
      totalPrice: map["totalPrice"] != null ? double.parse(map["totalPrice"].toString()) : 0,
      totalPromocodeDiscount: map["totalPromocodeDiscount"] != null ? double.parse(map["totalPromocodeDiscount"].toString()) : 0,
      totalCouponDiscount: map["totalCouponDiscount"] != null ? double.parse(map["totalCouponDiscount"].toString()) : 0,
      deliveryChargeBeforeDiscount: map["deliveryChargeBeforeDiscount"] != null ? double.parse(map["deliveryChargeBeforeDiscount"].toString()) : 0,
      deliveryChargeAfterDiscount: map["deliveryChargeAfterDiscount"] != null ? double.parse(map["deliveryChargeAfterDiscount"].toString()) : 0,
      deliveryDiscount: map["deliveryDiscount"] != null ? double.parse(map["deliveryDiscount"].toString()) : 0,
      distance: map["distance"] != null ? double.parse(map["distance"].toString()) : 0,
      tip: map["tip"] != null ? int.parse(map["tip"].toString()) : 0,
      totalTaxBeforeDiscount: map["totalTaxBeforeDiscount"] != null ? double.parse(map["totalTaxBeforeDiscount"].toString()) : 0,
      totalTaxAfterCouponDiscount: map["totalTaxAfterCouponDiscount"] != null ? double.parse(map["totalTaxAfterCouponDiscount"].toString()) : 0,
      totalTaxAfterDiscount: map["totalTaxAfterDiscount"] != null ? double.parse(map["totalTaxAfterDiscount"].toString()) : 0,
      redeemRewardValue: map["redeemRewardValue"] != null ? double.parse(map["redeemRewardValue"].toString()) : 0,
      redeemRewardPoint: map["redeemRewardPoint"] != null ? double.parse(map["redeemRewardPoint"].toString()) : 0,
      toPay: map["toPay"] != null ? double.parse(map["toPay"].toString()) : 0,
      taxType: map["taxType"] ?? "",
      taxBreakdown: map["taxBreakdown"] ?? [],
      rewardPointsEarnedPerOrder: map["rewardPointsEarnedPerOrder"] != null ? double.parse(map["rewardPointsEarnedPerOrder"].toString()) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalQuantity": totalQuantity ?? 0,
      "totalOriginPrice": totalOriginPrice ?? 0,
      "totalPrice": totalPrice ?? 0,
      "totalPromocodeDiscount": totalPromocodeDiscount ?? 0,
      "totalCouponDiscount": totalCouponDiscount ?? 0,
      "deliveryChargeBeforeDiscount": deliveryChargeBeforeDiscount ?? 0,
      "deliveryChargeAfterDiscount": deliveryChargeAfterDiscount ?? 0,
      "deliveryDiscount": deliveryDiscount ?? 0,
      "distance": distance ?? 0,
      "tip": tip ?? 0,
      "totalTaxBeforeDiscount": totalTaxBeforeDiscount ?? 0,
      "totalTaxAfterCouponDiscount": totalTaxAfterCouponDiscount ?? 0,
      "totalTaxAfterDiscount": totalTaxAfterDiscount ?? 0,
      "redeemRewardValue": redeemRewardValue ?? 0,
      "redeemRewardPoint": redeemRewardPoint ?? 0,
      "toPay": toPay ?? 0,
      "taxType": taxType ?? "",
      "taxBreakdown": taxBreakdown ?? [],
      "rewardPointsEarnedPerOrder": rewardPointsEarnedPerOrder ?? 0,
    };
  }

  factory PaymentDetailModel.copy(PaymentDetailModel model) {
    return PaymentDetailModel(
      totalQuantity: model.totalQuantity,
      totalOriginPrice: model.totalOriginPrice,
      totalPrice: model.totalPrice,
      totalPromocodeDiscount: model.totalPromocodeDiscount,
      totalCouponDiscount: model.totalCouponDiscount,
      deliveryChargeBeforeDiscount: model.deliveryChargeBeforeDiscount,
      deliveryChargeAfterDiscount: model.deliveryChargeAfterDiscount,
      deliveryDiscount: model.deliveryDiscount,
      distance: model.distance,
      tip: model.tip,
      totalTaxBeforeDiscount: model.totalTaxBeforeDiscount,
      totalTaxAfterCouponDiscount: model.totalTaxAfterCouponDiscount,
      totalTaxAfterDiscount: model.totalTaxAfterDiscount,
      redeemRewardValue: model.redeemRewardValue,
      redeemRewardPoint: model.redeemRewardPoint,
      toPay: model.toPay,
      taxType: model.taxType,
      taxBreakdown: List.from(model.taxBreakdown!),
      rewardPointsEarnedPerOrder: model.rewardPointsEarnedPerOrder,
    );
  }

  @override
  List<Object> get props => [
        totalQuantity!,
        totalOriginPrice!,
        totalPrice!,
        totalPromocodeDiscount!,
        totalCouponDiscount!,
        deliveryChargeBeforeDiscount!,
        deliveryChargeAfterDiscount!,
        deliveryDiscount!,
        distance!,
        tip!,
        totalTaxBeforeDiscount!,
        totalTaxAfterCouponDiscount!,
        totalTaxAfterDiscount!,
        redeemRewardValue!,
        redeemRewardPoint!,
        toPay!,
        taxType!,
        taxBreakdown!,
        rewardPointsEarnedPerOrder!,
      ];

  @override
  bool get stringify => true;
}
