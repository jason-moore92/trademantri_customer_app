import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class PaymentLinkApiProvider {
  static getPaymentData({@required String? id, @required String? paymentLinkId, @required String? status}) async {
    String apiUrl = 'payment_link/get';
    apiUrl += "?id=" + id!;
    apiUrl += "&status=" + status!;
    apiUrl += "&paymentLinkId=" + paymentLinkId!;

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getPaymentLinks({@required String? userId, String searchKey = "", int page = 1}) async {
    String apiUrl = 'payment_link/getPaymentLinks/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "userId": userId,
          "searchKey": searchKey,
          "limit": 5,
          "page": page,
        }),
      );
      return json.decode(response.body);
    });
  }
}
