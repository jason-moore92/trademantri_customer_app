import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class RewardPointHistoryApiProvider {
  static sumRewardPoints({
    String userId = "",
    String storeId = "",
  }) async {
    String apiUrl = 'reward_points/sumRewardPoints';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?userId=$userId";
      url += "&storeId=$storeId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getRewardPointsByUser({
    @required String? userId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'reward_points/getRewardPointsByUser';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?userId=$userId";
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

  static getRewardPointsByStore({
    @required String? storeId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'reward_points/getRewardPointsByStore';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?userId=$storeId";
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

  static redeemRewordPoint({
    @required String? id,
    @required String? storeId,
    @required String? userId,
    @required String? orderId,
    @required int? sumRewardPoint,
    @required int? redeemRewardPoint,
    @required int? redeemValue,
    int page = 1,
  }) async {
    String apiUrl = 'reward_points/redeem';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "id": id,
          "storeId": storeId,
          "userId": userId,
          "orderId": orderId,
          "sumRewardPoint": sumRewardPoint,
          "redeemRewardPoint": redeemRewardPoint,
          "redeemValue": redeemValue,
        }),
      );
      return json.decode(response.body);
    });
  }
}
