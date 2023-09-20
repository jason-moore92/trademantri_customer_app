import 'package:flutter/material.dart';

class PriceFunctions {
  static Map<String, dynamic> getTotalPriceOfCart({@required Map<String, dynamic>? orderData}) {
    double totalQuantity = 0;
    double totalOriginPrice = 0;
    double totalPrice = 0;
    double totalTax = 0;
    double totalTaxBeforeDiscount = 0;

    if (orderData!["products"] != null) {
      for (var i = 0; i < orderData["products"].length; i++) {
        if (orderData["products"][i]["data"] == null) continue;

        Map<String, dynamic> result = getPriceDataForProduct(orderData: orderData, data: orderData["products"][i]["data"]);

        double orderQuantity = double.parse(orderData["products"][i]["orderQuantity"].toString());
        double price = result["price"];
        double discount = result["discount"];
        double promocodeDiscount = result["promocodeDiscount"];
        double taxPrice = result["taxPrice"];
        double taxPriceBeforeDiscount = result["taxPriceBeforeDiscount"];

        totalQuantity += orderQuantity;

        /// tax of product
        if (orderData["products"][i]["data"]["taxPercentage"] != null) {
          totalTax += orderQuantity * taxPrice;
          totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
        }

        totalPrice += orderQuantity * (price - discount - promocodeDiscount);
        totalOriginPrice += orderQuantity * (price - discount);
      }
    }

    if (orderData["services"] != null) {
      for (var i = 0; i < orderData["services"].length; i++) {
        if (orderData["services"][i]["data"] == null) continue;

        Map<String, dynamic> result = getPriceDataForProduct(orderData: orderData, data: orderData["services"][i]["data"]);

        double orderQuantity = double.parse(orderData["services"][i]["orderQuantity"].toString());
        double price = result["price"];
        double discount = result["discount"];
        double promocodeDiscount = result["promocodeDiscount"];
        double taxPrice = result["taxPrice"];
        double taxPriceBeforeDiscount = result["taxPriceBeforeDiscount"];

        totalQuantity += orderQuantity;

        /// tax of product
        if (orderData["services"][i]["data"]["taxPercentage"] != null) {
          totalTax += orderQuantity * taxPrice;
          totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
        }

        totalPrice += orderQuantity * (price - discount - promocodeDiscount);
        totalOriginPrice += orderQuantity * (price - discount);
      }
    }

    return {
      "totalQuantity": totalQuantity,
      "totalPrice": totalPrice,
      "totalOriginPrice": totalOriginPrice,
      "totalTax": totalTax,
      "totalTaxBeforeDiscount": totalTaxBeforeDiscount,
    };
  }

  static Map<String, dynamic> getTotalPriceOfOrder({@required Map<String, dynamic>? orderData}) {
    double totalQuantity = 0;
    double totalOriginPrice = 0;
    double totalPrice = 0;
    double totalTax = 0;
    double totalTaxBeforeDiscount = 0;

    if (orderData!["products"] != null) {
      for (var i = 0; i < orderData["products"].length; i++) {
        if (orderData["products"][i] == null) continue;

        Map<String, dynamic> result = getPriceDataForProduct(orderData: orderData, data: orderData["products"][i]);

        double orderQuantity = double.parse(orderData["products"][i]["orderQuantity"].toString());
        double price = result["price"];
        double discount = result["discount"];
        double promocodeDiscount = result["promocodeDiscount"];
        double taxPrice = result["taxPrice"];
        double taxPriceBeforeDiscount = result["taxPriceBeforeDiscount"];

        totalQuantity += orderQuantity;

        /// tax of product
        if (orderData["products"][i]["taxPercentage"] != null) {
          totalTax += orderQuantity * taxPrice;
          totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
        }

        totalPrice += orderQuantity * (price - discount - promocodeDiscount);
        totalOriginPrice += orderQuantity * (price - discount);
      }
    }

    if (orderData["services"] != null) {
      for (var i = 0; i < orderData["services"].length; i++) {
        if (orderData["services"][i] == null) continue;

        Map<String, dynamic> result = getPriceDataForProduct(orderData: orderData, data: orderData["services"][i]);

        double orderQuantity = double.parse(orderData["services"][i]["orderQuantity"].toString());
        double price = result["price"];
        double discount = result["discount"];
        double promocodeDiscount = result["promocodeDiscount"];
        double taxPrice = result["taxPrice"];
        double taxPriceBeforeDiscount = result["taxPriceBeforeDiscount"];

        totalQuantity += orderQuantity;

        /// tax of product
        if (orderData["services"][i]["taxPercentage"] != null) {
          totalTax += orderQuantity * taxPrice;
          totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
        }

        totalPrice += orderQuantity * (price - discount - promocodeDiscount);
        totalOriginPrice += orderQuantity * (price - discount);
      }
    }

    return {
      "totalQuantity": totalQuantity,
      "totalPrice": totalPrice,
      "totalOriginPrice": totalOriginPrice,
      "totalTax": totalTax,
      "totalTaxBeforeDiscount": totalTaxBeforeDiscount,
    };
  }

  static Map<String, dynamic> getPriceDataForProduct({@required Map<String, dynamic>? orderData, @required Map<String, dynamic>? data}) {
    double price = 0;

    double discount = 0;
    double promocodeDiscount = 0;
    double taxPrice = 0;
    double taxPriceBeforeDiscount = 0;
    double taxPercentage = 0;

    if (data!["price"] == null) {
      return {
        "price": price,
        "discount": discount,
        "promocodeDiscount": promocodeDiscount,
        "taxPrice": taxPrice,
        "taxPriceBeforeDiscount": taxPriceBeforeDiscount,
      };
    }

    price = double.parse(data["price"].toString());

    if (data["discount"] != null) {
      discount = double.parse(data["discount"].toString());
    }

    if (orderData!["promocode"] != null && orderData["promocode"].isNotEmpty) {
      if (orderData["promocode"]["promocodeType"] == "Percentage") {
        promocodeDiscount = (price - discount) * double.parse(orderData["promocode"]["promocodeValue"].toString()) / 100;
      }

      if (orderData["promocode"]["promocodeType"].toString().contains("INR")) {
        promocodeDiscount = (price - discount) * double.parse(orderData["promocode"]["percentageForINR"].toString()) / 100;
      }
    }

    if (data["taxPercentage"] != null) {
      taxPercentage = double.parse(data["taxPercentage"].toString());
      taxPrice = (price - discount - promocodeDiscount) * taxPercentage / (100 + taxPercentage);
      taxPriceBeforeDiscount = (price - discount) * taxPercentage / (100 + taxPercentage);
      // taxPrice = (price - discount - promocodeDiscount) * double.parse(data["taxPercentage"].toString()) / 100;
      // taxPriceBeforeDiscount = (price - discount) * double.parse(data["taxPercentage"].toString()) / 100;
    }

    return {
      "price": price,
      "discount": discount,
      "promocodeDiscount": double.parse(promocodeDiscount.toStringAsFixed(2)),
      "taxPrice": double.parse(taxPrice.toStringAsFixed(2)),
      "taxPriceBeforeDiscount": double.parse(taxPriceBeforeDiscount.toStringAsFixed(2)),
      "itemPriceBeforeDiscount": double.parse((price - discount - taxPriceBeforeDiscount).toStringAsFixed(2)),
      "itemPriceAftgerPromocode": double.parse((price - discount - promocodeDiscount - taxPrice).toStringAsFixed(2)),
    };
  }

  static Map<String, dynamic> calculateINRPromocode({@required Map<String, dynamic>? orderData}) {
    double totalPrice = 0;
    //// if promocode is "INR", calculate promocode discount percent.
    if (orderData!["promocode"] != null && orderData["promocode"].isNotEmpty && orderData["promocode"]["promocodeType"].toString().contains("INR")) {
      for (var i = 0; i < orderData["products"].length; i++) {
        double price = double.parse(orderData["products"][i]["data"]["price"].toString());
        double discount = 0;
        double orderQuantity = double.parse(orderData["products"][i]["orderQuantity"].toString());

        /// discount of product
        if (orderData["products"][i]["data"]["discount"] != null) {
          discount = double.parse(orderData["products"][i]["data"]["discount"].toString());
        }
        totalPrice += orderQuantity * (price - discount);
      }

      for (var i = 0; i < orderData["services"].length; i++) {
        double price = double.parse(orderData["services"][i]["data"]["price"].toString());
        double discount = 0;
        double orderQuantity = double.parse(orderData["services"][i]["orderQuantity"].toString());

        /// discount of product
        if (orderData["services"][i]["data"]["discount"] != null) {
          discount = double.parse(orderData["services"][i]["data"]["discount"].toString());
        }
        totalPrice += orderQuantity * (price - discount);
      }
      orderData["promocode"]["percentageForINR"] = double.parse(orderData["promocode"]["promocodeValue"].toString()) / totalPrice * 100;
    }
    return orderData;
  }

  static Map<String, dynamic> calculateINRPromocodeForOrder({@required Map<String, dynamic>? orderData}) {
    double totalPrice = 0;
    //// if promocode is "INR", calculate promocode discount percent.
    if (orderData!["promocode"] != null && orderData["promocode"].isNotEmpty && orderData["promocode"]["promocodeType"].toString().contains("INR")) {
      for (var i = 0; i < orderData["products"].length; i++) {
        double price = double.parse(orderData["products"][i]["price"].toString());
        double discount = 0;
        double orderQuantity = double.parse(orderData["products"][i]["orderQuantity"].toString());

        /// discount of product
        if (orderData["products"][i]["discount"] != null) {
          discount = double.parse(orderData["products"][i]["discount"].toString());
        }
        totalPrice += orderQuantity * (price - discount);
      }

      for (var i = 0; i < orderData["services"].length; i++) {
        double price = double.parse(orderData["services"][i]["price"].toString());
        double discount = 0;
        double orderQuantity = double.parse(orderData["services"][i]["orderQuantity"].toString());

        /// discount of product
        if (orderData["services"][i]["discount"] != null) {
          discount = double.parse(orderData["services"][i]["discount"].toString());
        }
        totalPrice += orderQuantity * (price - discount);
      }
      orderData["promocode"]["percentageForINR"] = double.parse(orderData["promocode"]["promocodeValue"].toString()) / totalPrice * 100;
    }
    return orderData;
  }
}
