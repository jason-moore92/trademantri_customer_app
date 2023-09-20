import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ReferralRewardU2SOffersApiProvider {
  static addRewardPoint({
    @required String? referredByUserId,
    String referralStoreId = "",
    @required String? referredBy,
    @required String? appliedFor,
    @required String? storeName,
    @required String? storeMobile,
    @required String? storeAddress,
  }) async {
    String apiUrl = 'referralRewardUserToStoreOffers/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "referredByUserId": referredByUserId,
          "referralStoreId": referralStoreId,
          "referredBy": referredBy,
          "appliedFor": appliedFor,
          "storeName": storeName,
          "storeMobile": storeMobile,
          "storeAddress": storeAddress,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getReferralRewardOffersData({
    @required String? referredByUserId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'referralRewardUserToStoreOffers/getList/';
    apiUrl += "?referredByUserId=$referredByUserId";
    apiUrl += "&searchKey=$searchKey";
    apiUrl += "&page=$page";
    apiUrl += "&limit=$limit";
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
