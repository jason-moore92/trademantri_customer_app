import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:intl/intl.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/models/index.dart';

class PriceFunctions1 {
  static NumberFormat numFormat = NumberFormat.currency(symbol: "", name: "");

  static double getTotalOrignPrice({@required OrderModel? orderModel}) {
    double totalPrice = 0;
    for (var i = 0; i < orderModel!.products!.length; i++) {
      ProductOrderModel productOrderModel = orderModel.products![i];
      totalPrice += productOrderModel.orderQuantity! * productOrderModel.orderPrice!;
    }

    for (var i = 0; i < orderModel.services!.length; i++) {
      ServiceOrderModel serviceOrderModel = orderModel.services![i];
      totalPrice += serviceOrderModel.orderQuantity! * serviceOrderModel.orderPrice!;
    }

    return totalPrice;
  }

  static double getTotalPrice({@required OrderModel? orderModel}) {
    double totalPrice = 0;
    for (var i = 0; i < orderModel!.products!.length; i++) {
      ProductOrderModel productOrderModel = orderModel.products![i];
      totalPrice += productOrderModel.orderQuantity! *
          (productOrderModel.orderPrice! - productOrderModel.couponDiscount! - productOrderModel.promocodeDiscount!);
    }

    for (var i = 0; i < orderModel.services!.length; i++) {
      ServiceOrderModel serviceOrderModel = orderModel.services![i];
      totalPrice += serviceOrderModel.orderQuantity! *
          (serviceOrderModel.orderPrice! - serviceOrderModel.couponDiscount! - serviceOrderModel.promocodeDiscount!);
    }

    return totalPrice;
  }

  static void calculateDiscount({@required OrderModel? orderModel}) {
    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    for (var i = 0; i < orderModel!.products!.length; i++) {
      orderModel.products![i].couponQuantity = orderModel.products![i].orderQuantity;
      orderModel.products![i].promocodePercent = 0;
      orderModel.products![i].promocodeDiscount = 0;
      orderModel.products![i].couponDiscount = 0;
    }

    for (var i = 0; i < orderModel.services!.length; i++) {
      orderModel.services![i].couponQuantity = orderModel.services![i].orderQuantity;
      orderModel.services![i].promocodePercent = 0;
      orderModel.services![i].promocodeDiscount = 0;
      orderModel.services![i].couponDiscount = 0;
    }
    orderModel.bogoProducts = [];
    orderModel.bogoServices = [];

    /// calculate coupon
    if (orderModel.coupon != null) {
      /// check Applied
      var result = CouponModel.checkAppliedFor(orderModel: orderModel, couponModel: orderModel.coupon);
      String matchedProductIds = "";
      String matchedServiceIds = "";
      if (result["message"] == "") {
        for (var i = 0; i < result["matchedItems"]["products"].length; i++) {
          matchedProductIds += "," + result["matchedItems"]["products"][i].productModel.id;
        }
        for (var i = 0; i < result["matchedItems"]["services"].length; i++) {
          matchedServiceIds += "," + result["matchedItems"]["services"][i].serviceModel.id;
        }
      } else if (result["message"] == "ALL") {
        matchedProductIds = "ALL";
        matchedServiceIds = "ALL";
      }

      /// disount type is percent
      if (orderModel.coupon!.discountType == AppConfig.discountTypeForCoupon[0]["value"]) {
        double totalCouponDiscount = 0;
        double totalPrice = 0;
        for (var i = 0; i < orderModel.products!.length; i++) {
          if (matchedProductIds == "ALL" || matchedProductIds.contains(orderModel.products![i].productModel!.id!)) {
            double price = orderModel.products![i].orderPrice! - orderModel.products![i].promocodeDiscount!;
            orderModel.products![i].couponDiscount = price * double.parse(orderModel.coupon!.discountData!["discountValue"].toString()) / 100;
            // orderModel.products![i].couponDiscount = double.parse(numFormat.format(orderModel.products![i].couponDiscount));

            totalCouponDiscount += orderModel.products![i].couponDiscount! * orderModel.products![i].orderQuantity!;
            totalPrice += price * orderModel.products![i].orderQuantity!;
          }
        }

        for (var i = 0; i < orderModel.services!.length; i++) {
          if (matchedServiceIds == "ALL" || matchedServiceIds.contains(orderModel.services![i].serviceModel!.id!)) {
            double price = orderModel.services![i].orderPrice! - orderModel.services![i].promocodeDiscount!;
            orderModel.services![i].couponDiscount = price * double.parse(orderModel.coupon!.discountData!["discountValue"].toString()) / 100;
            // orderModel.services![i].couponDiscount = double.parse(numFormat.format(orderModel.services![i].couponDiscount));

            totalCouponDiscount += orderModel.services![i].couponDiscount! * orderModel.services![i].orderQuantity!;
            totalPrice += price * orderModel.services![i].orderQuantity!;
          }
        }

        if (orderModel.coupon!.discountData!["discountMaxAmount"] != null &&
            orderModel.coupon!.discountData!["discountMaxAmount"] != "" &&
            totalCouponDiscount > double.parse(orderModel.coupon!.discountData!["discountMaxAmount"].toString())) {
          double changedPercent = double.parse(orderModel.coupon!.discountData!["discountMaxAmount"].toString()) / totalPrice * 100;

          for (var i = 0; i < orderModel.products!.length; i++) {
            if (matchedProductIds == "ALL" || matchedProductIds.contains(orderModel.products![i].productModel!.id!)) {
              double price = orderModel.products![i].orderPrice! - orderModel.products![i].promocodeDiscount!;
              orderModel.products![i].couponDiscount = price * changedPercent / 100;
              // orderModel.products![i].couponDiscount = double.parse(numFormat.format(orderModel.products![i].couponDiscount));
            }
          }

          for (var i = 0; i < orderModel.services!.length; i++) {
            if (matchedServiceIds == "ALL" || matchedServiceIds.contains(orderModel.services![i].serviceModel!.id!)) {
              double price = orderModel.services![i].orderPrice! - orderModel.services![i].promocodeDiscount!;
              orderModel.services![i].couponDiscount = price * changedPercent / 100;
              // orderModel.services![i].couponDiscount = double.parse(numFormat.format(orderModel.services![i].couponDiscount));
            }
          }
        }
      }
      // disount type is fixed amount
      else if (orderModel.coupon!.discountType == AppConfig.discountTypeForCoupon[1]["value"]) {
        double totalPrice = 0;
        for (var i = 0; i < orderModel.products!.length; i++) {
          if (matchedProductIds == "ALL" || matchedProductIds.contains(orderModel.products![i].productModel!.id!)) {
            double price = orderModel.products![i].orderPrice! - orderModel.products![i].promocodeDiscount!;
            totalPrice += price * orderModel.products![i].orderQuantity!;
          }
        }

        for (var i = 0; i < orderModel.services!.length; i++) {
          if (matchedServiceIds == "ALL" || matchedServiceIds.contains(orderModel.services![i].serviceModel!.id!)) {
            double price = orderModel.services![i].orderPrice! - orderModel.services![i].promocodeDiscount!;
            totalPrice += price * orderModel.services![i].orderQuantity!;
          }
        }

        double changedPercent = double.parse(orderModel.coupon!.discountData!["discountValue"].toString()) / totalPrice * 100;

        for (var i = 0; i < orderModel.products!.length; i++) {
          if (matchedProductIds == "ALL" || matchedProductIds.contains(orderModel.products![i].productModel!.id!)) {
            double price = orderModel.products![i].orderPrice! - orderModel.products![i].promocodeDiscount!;
            orderModel.products![i].couponDiscount = price * changedPercent / 100;
            // orderModel.products![i].couponDiscount = double.parse(numFormat.format(orderModel.products![i].couponDiscount));
          }
        }

        for (var i = 0; i < orderModel.services!.length; i++) {
          if (matchedServiceIds == "ALL" || matchedServiceIds.contains(orderModel.services![i].serviceModel!.id!)) {
            double price = orderModel.services![i].orderPrice! - orderModel.services![i].promocodeDiscount!;
            orderModel.services![i].couponDiscount = price * changedPercent / 100;
            // orderModel.services![i].couponDiscount = double.parse(numFormat.format(orderModel.services![i].couponDiscount));
          }
        }
      }
      // disount type is BOGO
      else if (orderModel.coupon!.discountType == AppConfig.discountTypeForCoupon[2]["value"]) {
        var getMatchedItems = CouponModel.getBOGOGetItemsMatch(orderModel: orderModel, couponModel: orderModel.coupon);

        List<dynamic> sortedItems = [];
        for (var i = 0; i < getMatchedItems["products"].length; i++) {
          sortedItems.add({"type": "products", "item": getMatchedItems["products"][i]});
        }
        for (var i = 0; i < getMatchedItems["services"].length; i++) {
          sortedItems.add({"type": "services", "item": getMatchedItems["services"][i]});
        }

        sortedItems.sort((a, b) {
          double aPrice = a["item"].orderPrice!;
          double bPrice = b["item"].orderPrice!;

          if (aPrice > bPrice) {
            return 1;
          } else {
            return -1;
          }
        });

        double getQuantity = double.parse(orderModel.coupon!.discountData!["customerBogo"]["get"]["quantity"].toString());

        for (var i = 0; i < sortedItems.length; i++) {
          double orderQuantity = 0;
          if (getQuantity >= sortedItems[i]["item"].couponQuantity) {
            orderQuantity = sortedItems[i]["item"].couponQuantity;
          } else {
            orderQuantity = getQuantity;
          }

          getQuantity = getQuantity - sortedItems[i]["item"].couponQuantity;

          if (sortedItems[i]["type"] == "products") {
            ProductOrderModel productOrderModel = ProductOrderModel.copy(sortedItems[i]["item"]);
            productOrderModel.orderQuantity = orderQuantity;
            productOrderModel.couponQuantity = orderQuantity;

            if (orderModel.coupon!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]) {
              double price = productOrderModel.orderPrice! - productOrderModel.promocodeDiscount!;
              productOrderModel.couponDiscount = price;
            } else if (orderModel.coupon!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[1]["value"]) {
              double price = productOrderModel.orderPrice! - productOrderModel.promocodeDiscount!;
              productOrderModel.couponDiscount = price *
                  double.parse(
                    orderModel.coupon!.discountData!["customerBogo"]["get"]["percentValue"].toString(),
                  ) /
                  100;
              // productOrderModel.couponDiscount = double.parse(numFormat.format(productOrderModel.couponDiscount));
            }

            orderModel.bogoProducts!.add(productOrderModel);

            for (var i = 0; i < orderModel.products!.length; i++) {
              if (orderModel.products![i].productModel!.id == productOrderModel.productModel!.id) {
                orderModel.products![i].couponQuantity = orderModel.products![i].couponQuantity! - productOrderModel.orderQuantity!;
                // if (orderModel.products![i].couponQuantity == 0) {
                //   orderModel.products!.removeAt(i);
                // }
                break;
              }
            }
          } else if (sortedItems[i]["type"] == "services") {
            ServiceOrderModel serviceOrderModel = ServiceOrderModel.copy(sortedItems[i]["item"]);
            serviceOrderModel.orderQuantity = orderQuantity;
            serviceOrderModel.couponQuantity = orderQuantity;

            if (orderModel.coupon!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]) {
              double price = serviceOrderModel.orderPrice! - serviceOrderModel.promocodeDiscount!;
              serviceOrderModel.couponDiscount = price;
            } else if (orderModel.coupon!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[1]["value"]) {
              double price = serviceOrderModel.orderPrice! - serviceOrderModel.promocodeDiscount!;
              serviceOrderModel.couponDiscount = price *
                  double.parse(
                    orderModel.coupon!.discountData!["customerBogo"]["get"]["percentValue"].toString(),
                  ) /
                  100;
              // serviceOrderModel.couponDiscount = double.parse(numFormat.format(serviceOrderModel.couponDiscount));
            }
            orderModel.bogoServices!.add(serviceOrderModel);

            for (var i = 0; i < orderModel.services!.length; i++) {
              if (orderModel.services![i].serviceModel!.id == serviceOrderModel.serviceModel!.id) {
                orderModel.services![i].couponQuantity = orderModel.services![i].couponQuantity! - serviceOrderModel.orderQuantity!;
                // if (orderModel.services![i].couponQuantity == 0) {
                //   orderModel.services!.removeAt(i);
                // }
                break;
              }
            }
          }
          if (getQuantity <= 0) {
            FlutterLogs.logInfo("price_functions1", "calculateDiscount", "Finish");
            break;
          }
        }
      }
    }

    /// calculate promocode
    if (orderModel.promocode != null) {
      _calculatePercentPromocodeDiscount(orderModel: orderModel);
      _calculateINRPromocode(orderModel: orderModel);
    }
  }

  static void _calculatePercentPromocodeDiscount({@required OrderModel? orderModel}) {
    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    if (orderModel!.promocode != null && orderModel.promocode!.promocodeType!.toLowerCase() == "percentage") {
      double promocodePercent = 0;

      if (orderModel.promocode!.maximumDiscount != null) {
        double totalPrice = getTotalPrice(orderModel: orderModel);

        double totalPromocodeDisount = orderModel.promocode!.promocodeValue! / 100 * (totalPrice);

        if (totalPromocodeDisount > orderModel.promocode!.maximumDiscount!) {
          promocodePercent = orderModel.promocode!.maximumDiscount! / totalPrice * 100;
        } else {
          promocodePercent = orderModel.promocode!.promocodeValue!;
        }
      } else {
        promocodePercent = orderModel.promocode!.promocodeValue!;
      }

      for (var i = 0; i < orderModel.products!.length; i++) {
        orderModel.products![i].promocodePercent = promocodePercent;
        orderModel.products![i].promocodeDiscount =
            (orderModel.products![i].orderPrice! - orderModel.products![i].couponDiscount!) * promocodePercent / 100;
      }

      for (var i = 0; i < orderModel.services!.length; i++) {
        orderModel.services![i].promocodePercent = promocodePercent;
        orderModel.services![i].promocodeDiscount =
            (orderModel.services![i].orderPrice! - orderModel.services![i].couponDiscount!) * promocodePercent / 100;
      }
    }
  }

  static void _calculateINRPromocode({@required OrderModel? orderModel}) {
    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    //// if promocode is "INR", calculate promocode discount percent.
    if (orderModel!.promocode != null && orderModel.promocode!.promocodeType!.contains("INR")) {
      double totalPrice = getTotalPrice(orderModel: orderModel);

      double percentageForINR = orderModel.promocode!.promocodeValue! / totalPrice * 100;
      // percentageForINR = double.parse(numFormat.format(percentageForINR));

      for (var i = 0; i < orderModel.products!.length; i++) {
        orderModel.products![i].promocodePercent = percentageForINR;
        orderModel.products![i].promocodeDiscount = orderModel.products![i].orderPrice! * percentageForINR / 100;
        // orderModel.products![i].promocodeDiscount = double.parse(numFormat.format(orderModel.products![i].promocodeDiscount));
      }

      for (var i = 0; i < orderModel.services!.length; i++) {
        orderModel.services![i].promocodePercent = percentageForINR;
        orderModel.services![i].promocodeDiscount = orderModel.services![i].orderPrice! * percentageForINR / 100;
        // orderModel.services![i].promocodeDiscount = double.parse(numFormat.format(orderModel.services![i].promocodeDiscount));
      }
    }
  }

  static PaymentDetailModel calclatePaymentDetail({@required OrderModel? orderModel}) {
    NumberFormat numFormat = NumberFormat.currency(symbol: "", name: "");
    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
    numFormat.turnOffGrouping();

    PaymentDetailModel paymentDetailModel = orderModel!.paymentDetail ?? PaymentDetailModel();
    double totalQuantity = 0;
    double totalOriginPrice = 0;
    double totalPrice = 0;
    double totalTaxBeforeDiscount = 0;
    double totalTaxAfterCouponDiscount = 0;
    double totalTaxAfterDiscount = 0;
    double totalPromocodeDiscount = 0;
    double totalCouponDiscount = 0;
    double deliveryPrice = 0;
    double deliveryDiscount = 0;

    for (var i = 0; i < orderModel.products!.length; i++) {
      ProductOrderModel productOrderModel = orderModel.products![i];
      double orderQuantity = productOrderModel.couponQuantity!;
      double orderPrice = productOrderModel.orderPrice!;
      double promocodeDiscount = productOrderModel.promocodeDiscount!;
      double couponDiscount = productOrderModel.couponDiscount!;
      double taxPercentage = 0;
      double taxPriceBeforeDiscount = 0;
      double taxPriceAfterCouponDiscount = 0;
      double taxPriceAfterDiscount = 0;

      if (productOrderModel.productModel!.taxPercentage != 0) {
        taxPercentage = productOrderModel.productModel!.taxPercentage!;
        taxPriceBeforeDiscount = orderPrice * taxPercentage / (100 + taxPercentage);
        taxPriceAfterCouponDiscount = (orderPrice - couponDiscount) * taxPercentage / (100 + taxPercentage);
        taxPriceAfterDiscount = (orderPrice - promocodeDiscount - couponDiscount) * taxPercentage / (100 + taxPercentage);
      }
      productOrderModel.taxPercentage = taxPercentage;
      productOrderModel.taxPriceBeforeDiscount = taxPriceBeforeDiscount;
      productOrderModel.taxPriceAfterCouponDiscount = taxPriceAfterCouponDiscount;
      productOrderModel.taxPriceAfterDiscount = taxPriceAfterDiscount;

      totalQuantity += orderQuantity;
      totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
      totalTaxAfterCouponDiscount += orderQuantity * taxPriceAfterCouponDiscount;
      totalTaxAfterDiscount += orderQuantity * taxPriceAfterDiscount;
      totalPrice += orderQuantity * (orderPrice - promocodeDiscount - couponDiscount);
      totalOriginPrice += orderQuantity * orderPrice;
      totalPromocodeDiscount += orderQuantity * promocodeDiscount;
      totalCouponDiscount += orderQuantity * couponDiscount;
    }

    for (var i = 0; i < orderModel.services!.length; i++) {
      ServiceOrderModel serviceOrderModel = orderModel.services![i];
      double orderQuantity = serviceOrderModel.couponQuantity!;
      double orderPrice = serviceOrderModel.orderPrice!;
      double promocodeDiscount = serviceOrderModel.promocodeDiscount!;
      double couponDiscount = serviceOrderModel.couponDiscount!;
      double taxPercentage = 0;
      double taxPriceBeforeDiscount = 0;
      double taxPriceAfterCouponDiscount = 0;
      double taxPriceAfterDiscount = 0;
      if (serviceOrderModel.serviceModel!.taxPercentage != 0) {
        taxPercentage = serviceOrderModel.serviceModel!.taxPercentage!;
        taxPriceBeforeDiscount = orderPrice * taxPercentage / (100 + taxPercentage);
        taxPriceAfterCouponDiscount = (orderPrice - couponDiscount) * taxPercentage / (100 + taxPercentage);
        taxPriceAfterDiscount = (orderPrice - promocodeDiscount - couponDiscount) * taxPercentage / (100 + taxPercentage);

        // taxPriceBeforeDiscount = double.parse(numFormat.format(taxPriceBeforeDiscount));
        // taxPriceAfterCouponDiscount = double.parse(numFormat.format(taxPriceAfterCouponDiscount));
        // taxPriceAfterDiscount = double.parse(numFormat.format(taxPriceAfterDiscount));
      }
      serviceOrderModel.taxPercentage = taxPercentage;
      serviceOrderModel.taxPriceAfterDiscount = taxPriceAfterDiscount;
      serviceOrderModel.taxPriceAfterCouponDiscount = taxPriceAfterCouponDiscount;
      serviceOrderModel.taxPriceBeforeDiscount = taxPriceBeforeDiscount;

      totalQuantity += orderQuantity;
      totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
      totalTaxAfterCouponDiscount += orderQuantity * taxPriceAfterCouponDiscount;
      totalTaxAfterDiscount += orderQuantity * taxPriceAfterDiscount;
      totalPrice += orderQuantity * (orderPrice - promocodeDiscount - couponDiscount);
      totalOriginPrice += orderQuantity * orderPrice;
      totalPromocodeDiscount += orderQuantity * promocodeDiscount;
      totalCouponDiscount += orderQuantity * couponDiscount;
    }

    for (var i = 0; i < orderModel.bogoProducts!.length; i++) {
      ProductOrderModel productOrderModel = orderModel.bogoProducts![i];
      double orderQuantity = productOrderModel.couponQuantity!;
      double orderPrice = productOrderModel.orderPrice!;
      double promocodeDiscount = productOrderModel.promocodeDiscount!;
      double couponDiscount = productOrderModel.couponDiscount!;
      double taxPercentage = 0;
      double taxPriceBeforeDiscount = 0;
      double taxPriceAfterDiscount = 0;
      double taxPriceAfterCouponDiscount = 0;
      if (productOrderModel.productModel!.taxPercentage != 0) {
        taxPercentage = productOrderModel.productModel!.taxPercentage!;
        taxPriceAfterCouponDiscount = (orderPrice - couponDiscount) * taxPercentage / (100 + taxPercentage);
        taxPriceAfterDiscount = (orderPrice - promocodeDiscount - couponDiscount) * taxPercentage / (100 + taxPercentage);
        taxPriceBeforeDiscount = orderPrice * taxPercentage / (100 + taxPercentage);
      }
      productOrderModel.taxPercentage = taxPercentage;
      productOrderModel.taxPriceAfterCouponDiscount = taxPriceAfterCouponDiscount;
      productOrderModel.taxPriceAfterDiscount = taxPriceAfterDiscount;
      productOrderModel.taxPriceBeforeDiscount = taxPriceBeforeDiscount;

      totalQuantity += orderQuantity;
      totalTaxAfterCouponDiscount += orderQuantity * taxPriceAfterCouponDiscount;
      totalTaxAfterDiscount += orderQuantity * taxPriceAfterDiscount;
      totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
      totalPrice += orderQuantity * (orderPrice - promocodeDiscount - couponDiscount);
      totalOriginPrice += orderQuantity * orderPrice;
      totalPromocodeDiscount += orderQuantity * promocodeDiscount;
      totalCouponDiscount += orderQuantity * couponDiscount;
    }

    for (var i = 0; i < orderModel.bogoServices!.length; i++) {
      ServiceOrderModel serviceOrderModel = orderModel.bogoServices![i];
      double orderQuantity = serviceOrderModel.couponQuantity!;
      double orderPrice = serviceOrderModel.orderPrice!;
      double promocodeDiscount = serviceOrderModel.promocodeDiscount!;
      double couponDiscount = serviceOrderModel.couponDiscount!;
      double taxPercentage = 0;
      double taxPriceBeforeDiscount = 0;
      double taxPriceAfterDiscount = 0;
      double taxPriceAfterCouponDiscount = 0;
      if (serviceOrderModel.serviceModel!.taxPercentage != 0) {
        taxPercentage = serviceOrderModel.serviceModel!.taxPercentage!;
        taxPriceAfterCouponDiscount = (orderPrice - couponDiscount) * taxPercentage / (100 + taxPercentage);
        taxPriceAfterDiscount = (orderPrice - promocodeDiscount - couponDiscount) * taxPercentage / (100 + taxPercentage);
        taxPriceBeforeDiscount = orderPrice * taxPercentage / (100 + taxPercentage);
      }
      serviceOrderModel.taxPercentage = taxPercentage;
      serviceOrderModel.taxPriceAfterCouponDiscount = taxPriceAfterCouponDiscount;
      serviceOrderModel.taxPriceAfterDiscount = taxPriceAfterDiscount;
      serviceOrderModel.taxPriceBeforeDiscount = taxPriceBeforeDiscount;

      totalQuantity += orderQuantity;
      totalTaxAfterCouponDiscount += orderQuantity * taxPriceAfterCouponDiscount;
      totalTaxAfterDiscount += orderQuantity * taxPriceAfterDiscount;
      totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
      totalPrice += orderQuantity * (orderPrice - promocodeDiscount - couponDiscount);
      totalOriginPrice += orderQuantity * orderPrice;
      totalPromocodeDiscount += orderQuantity * promocodeDiscount;
      totalCouponDiscount += orderQuantity * couponDiscount;
    }

    ///
    /// delivery price
    ///
    ///
    if (orderModel.deliveryAddress != null && orderModel.deliveryPartnerDetails!.isNotEmpty) {
      deliveryPrice = double.parse(orderModel.deliveryPartnerDetails!["charge"]["deliveryPrice"].toString());

      /// discount
      if (orderModel.promocode != null && orderModel.promocode!.promocodeType == "Delivery") {
        deliveryDiscount = (orderModel.promocode!.promocodeValue! * deliveryPrice / 100);
        // deliveryDiscount = double.parse(numFormat.format(deliveryDiscount));
      }
    } else if (orderModel.deliveryAddress != null &&
        orderModel.deliveryPartnerDetails!.isEmpty &&
        orderModel.storeModel!.deliveryInfo!.mode == "DELIVERY_BY_OWN") {
      for (var i = 0; i < orderModel.storeModel!.deliveryInfo!.chargesForDeliveryOwn!.length; i++) {
        if (orderModel.deliveryAddress!.distance! / 1000 >= orderModel.storeModel!.deliveryInfo!.chargesForDeliveryOwn![i]["minKm"] &&
            orderModel.deliveryAddress!.distance! / 1000 <= orderModel.storeModel!.deliveryInfo!.chargesForDeliveryOwn![i]["maxKm"]) {
          if (orderModel.storeModel!.deliveryInfo!.chargesForDeliveryOwn![i]["chargingType"] == "PER_DELIVERY") {
            deliveryPrice = double.parse(orderModel.storeModel!.deliveryInfo!.chargesForDeliveryOwn![i]["amount"].toString());
          } else if (orderModel.storeModel!.deliveryInfo!.chargesForDeliveryOwn![i]["chargingType"] == "PER_KM") {
            deliveryPrice = double.parse(orderModel.storeModel!.deliveryInfo!.chargesForDeliveryOwn![i]["amount"].toString()) *
                orderModel.deliveryAddress!.distance! /
                1000;
          } else if (orderModel.storeModel!.deliveryInfo!.chargesForDeliveryOwn![i]["chargingType"] == "Free") {
            deliveryPrice = 0;
          }
        }
      }

      /// discount
      if (orderModel.promocode != null && orderModel.promocode!.promocodeType == "Delivery") {
        deliveryDiscount = (orderModel.promocode!.promocodeValue! * deliveryPrice / 100);
        // deliveryDiscount = double.parse(numFormat.format(deliveryDiscount));
      }
    }

    if (orderModel.rewardPointData!.isNotEmpty && totalPrice > double.parse(orderModel.rewardPointData!["minOrderAmount"].toString())) {
      double buyValue = double.parse(orderModel.rewardPointData!["buy"]["value"].toString());
      double buyRewardPoints = double.parse(orderModel.rewardPointData!["buy"]["rewardPoints"].toString());
      double rewardPointsEarnedPerOrder = totalPrice ~/ buyValue * buyRewardPoints;
      if (rewardPointsEarnedPerOrder > double.parse(orderModel.rewardPointData!["maxRewardsPerOrder"].toString())) {
        rewardPointsEarnedPerOrder = double.parse(orderModel.rewardPointData!["maxRewardsPerOrder"].toString());
      }
      paymentDetailModel.rewardPointsEarnedPerOrder = rewardPointsEarnedPerOrder;
    }

    paymentDetailModel.totalQuantity = double.parse(numFormat.format(totalQuantity));
    paymentDetailModel.totalOriginPrice = double.parse(numFormat.format(totalOriginPrice));
    paymentDetailModel.totalPrice = double.parse(numFormat.format(totalPrice));
    paymentDetailModel.totalPromocodeDiscount = double.parse(numFormat.format(totalPromocodeDiscount));
    paymentDetailModel.totalCouponDiscount = double.parse(numFormat.format(totalCouponDiscount));
    paymentDetailModel.totalTaxAfterDiscount = double.parse(numFormat.format(totalTaxAfterDiscount));
    paymentDetailModel.totalTaxAfterCouponDiscount = double.parse(numFormat.format(totalTaxAfterCouponDiscount));
    paymentDetailModel.totalTaxBeforeDiscount = double.parse(numFormat.format(totalTaxBeforeDiscount));
    paymentDetailModel.deliveryDiscount = double.parse(numFormat.format(deliveryDiscount));
    paymentDetailModel.deliveryChargeBeforeDiscount = double.parse(numFormat.format(deliveryPrice));
    paymentDetailModel.deliveryChargeAfterDiscount = double.parse(numFormat.format(deliveryPrice - deliveryDiscount));
    paymentDetailModel.distance =
        orderModel.deliveryAddress != null ? double.parse((orderModel.deliveryAddress!.distance! / 1000).toStringAsFixed(3)) : 0;
    paymentDetailModel.toPay = double.parse(numFormat.format(totalPrice + deliveryPrice - deliveryDiscount + paymentDetailModel.tip!));

    /// --- tax Tyepe
    if (orderModel.orderType == "Pickup") {
      paymentDetailModel.taxType = "SGST";
    } else if (orderModel.orderType == "Delivery" &&
        orderModel.deliveryAddress != null &&
        orderModel.deliveryAddress!.address != null &&
        orderModel.deliveryAddress!.address!.state!.toLowerCase() == orderModel.storeModel!.state!.toLowerCase()) {
      paymentDetailModel.taxType = "SGST";
    } else if (orderModel.orderType == "Delivery" &&
        orderModel.deliveryAddress != null &&
        orderModel.deliveryAddress!.address != null &&
        orderModel.deliveryAddress!.address!.state!.toLowerCase() != orderModel.storeModel!.state!.toLowerCase()) {
      paymentDetailModel.taxType = "IGST";
    }

    if (paymentDetailModel.totalTaxAfterDiscount! > 0) {
      paymentDetailModel.taxBreakdown = [
        {"type": "CGST", "value": (paymentDetailModel.totalTaxAfterDiscount! / 2).toStringAsFixed(2)},
        {"type": paymentDetailModel.taxType!, "value": (paymentDetailModel.totalTaxAfterDiscount! / 2).toStringAsFixed(2)}
      ];
    }

    if (paymentDetailModel.totalTaxAfterDiscount! > 0) {
      paymentDetailModel.taxBreakdown = [
        {"type": "CGST", "value": (paymentDetailModel.totalTaxAfterDiscount! / 2).toStringAsFixed(2)},
        {"type": paymentDetailModel.taxType!, "value": (paymentDetailModel.totalTaxAfterDiscount! / 2).toStringAsFixed(2)}
      ];
    }

    return paymentDetailModel;
  }
}
