import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class RazorPayApiProvider {
  static createOrder({@required int? amount, String receipt = "receipt_id", String currency = "INR"}) async {
    String apiUrl = 'razorpay/orders/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "amount": amount,
          "currency": currency,
          "receipt": receipt,
        }),
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      } else {
        return {
          "success": false,
          "data": json.decode(response.body),
        };
      }
    });
  }
}
