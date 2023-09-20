import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/models/index.dart';

class OrderApiProvider {
  static addOrder({@required Map<String, dynamic>? orderData, @required String? qrCode}) async {
    String apiUrl = 'order/add/';

    orderData!["qrCodeData"] = qrCode;
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(orderData),
      );
      return json.decode(response.body);
    });
  }

/**
 * @deprecated
 */
  static generateUPI({@required String? orderId, @required String? storeId}) async {
    String apiUrl = 'order/generateUPI/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "orderId": orderId,
          "storeId": storeId,
        }),
      );
      return json.decode(response.body);
    });
  }

  static paymentDetails({
    @required String? provider,
    @required String? orderId,
    @required String? storeId,
  }) async {
    String apiUrl = 'order/paymentDetails/' + provider!;
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "orderId": orderId,
          "storeId": storeId,
        }),
      );
      return json.decode(response.body);
    });
  }

  static payment({
    @required String? provider,
    @required String? orderId,
    @required String? storeId,
    @required Map<String, dynamic>? upiResponse,
  }) async {
    String apiUrl = 'order/payment/' + provider!;
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "orderId": orderId,
          "storeId": storeId,
          "upiResponse": upiResponse,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getOrderData({
    @required String? userId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'order/getOrderData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      // url += "?userId=$userId";
      url += "?status=$status";
      url += "&searchKey=$searchKey";
      url += "&page=$page";
      url += "&limit=$limit";
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getStoreInvoices({
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'order/getStoreInvoices';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?searchKey=$searchKey";
      url += "&page=$page";
      url += "&limit=$limit";
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getScratchCardData({
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'order/getScratchCardData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?1=1";
      url += "&searchKey=$searchKey";
      url += "&page=$page";
      url += "&limit=$limit";
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getOrderDataByCategory({
    @required String? userId,
    @required String? storeCategoryId,
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'order/getOrderDataByCategory';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      // url += "?userId=$userId";
      url += "?storeCategoryId=$storeCategoryId";
      url += "&page=$page";
      url += "&limit=$limit";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getOrder({
    @required String? orderId,
    @required String? storeId,
    @required String? userId,
  }) async {
    String apiUrl = 'order/getOrder';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
      url += "&userId=$userId";
      url += "&orderId=$orderId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static updateOrderData({
    @required Map<String, dynamic>? orderData,
    @required String? status,
    @required bool? changedStatus,
    @required String? signature,
  }) async {
    String apiUrl = 'order/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"orderData": orderData, "status": status, "changedStatus": changedStatus, "signature": signature}),
      );
      return json.decode(response.body);
    });
  }

  static getGraphDataByUser({
    @required String? userId,
    @required String? filter,
    String storeCategoryId = "",
  }) async {
    String apiUrl = 'order/getGraphDataByUser';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?userId=$userId";
      url += "&filter=$filter";
      url += "&storeCategoryId=$storeCategoryId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getDashboardDataByUser({@required String? userId, String storeCategoryId = ""}) async {
    String apiUrl = 'order/getDashboardDataByUser';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?userId=$userId";
      url += "&storeCategoryId=$storeCategoryId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getCategoryOrderDataByUser({@required String? userId}) async {
    String apiUrl = 'order/getCategoryOrderDataByUser';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?userId=$userId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getCouponUsage({
    @required String? storeId,
    @required String? couponId,
  }) async {
    String apiUrl = 'order/getCouponUsage';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
      url += "&couponId=$couponId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getPromocodeUsage({
    @required String? promocodeId,
  }) async {
    String apiUrl = 'order/getPromocodeUsage';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?promocodeId=$promocodeId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getPromocodeUsageByUsers({
    @required String? promocodeId,
  }) async {
    String apiUrl = 'order/getPromocodeUsageByUsers';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?promocodeId=$promocodeId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }
}
