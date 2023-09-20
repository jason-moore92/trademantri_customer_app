import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/helpers/http_plus.dart';

class BargainRequestApiProvider {
  static addBargainRequest({
    @required Map<String, dynamic>? bargainRequestData,
  }) async {
    String apiUrl = 'bargain_request/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode(bargainRequestData),
      );
      return json.decode(response.body);
    });
  }

  static getBargainRequestData({
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'bargain_request/getBargainRequestData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
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

  static updateBargainRequestData({
    @required Map<String, dynamic>? bargainRequestData,
    @required String? status,
    @required String? subStatus,
    String toWhome = "store",
  }) async {
    String apiUrl = 'bargain_request/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "bargainRequestData": bargainRequestData,
          "status": status,
          "subStatus": subStatus,
          "toWhome": toWhome,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getTotalBargainByUser({@required String? userId}) async {
    String apiUrl = 'bargain_request/getTotalBargainByUser';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      // url += "?userId=$userId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getBargainRequest({
    @required String? storeId,
    @required String? userId,
    @required String? bargainRequestId,
  }) async {
    String apiUrl = 'bargain_request/get';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
      // url += "&userId=$userId";
      url += "&bargainRequestId=$bargainRequestId";
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
