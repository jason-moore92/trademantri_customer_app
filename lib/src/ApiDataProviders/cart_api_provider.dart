import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class CartApiProvider {
  static addCart({@required Map<String, dynamic>? cartData}) async {
    String apiUrl = 'cart/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(cartData),
      );
      return json.decode(response.body);
    });
  }

  static backup({
    @required Map<String, dynamic>? cartData,
    @required String? lastDeviceToken,
    @required String? userId,
    String status = "",
  }) async {
    Map<String, dynamic> data = json.decode(json.encode(cartData));

    String apiUrl = 'cart/backup/';
    String url = Environment.apiBaseUrl! + apiUrl;
    return httpExceptionWrapper(() async {
      List<Map<String, dynamic>> cartDataList = [];

      data.forEach((storeId, data) {
        cartDataList.add(data);
        for (var i = 0; i < cartDataList.last["products"].length; i++) {
          cartDataList.last["products"][i]["id"] = cartDataList.last["products"][i]["data"]["_id"];
          cartDataList.last["products"][i].remove("data");
        }
        for (var i = 0; i < cartDataList.last["services"].length; i++) {
          cartDataList.last["services"][i]["id"] = cartDataList.last["services"][i]["data"]["_id"];
          cartDataList.last["services"][i].remove("data");
        }
        cartDataList.last.remove("store");
      });

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "cartDataList": cartDataList,
          "lastDeviceToken": lastDeviceToken,
          // "userId": userId,
          "status": status
        }),
      );
      if (response.statusCode == 200) {
        SharedPreferences _prefs;
        _prefs = await SharedPreferences.getInstance();
        _prefs.setString("cart_data_$userId", json.encode(cartData));
      }
      return json.decode(response.body);
    });
  }

  static getCartData({String status = ""}) async {
    String apiUrl = 'cart/getCartData' + "?status=$status";
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
}
