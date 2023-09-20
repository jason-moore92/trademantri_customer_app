import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ReverseAuctionApiProvider {
  static addReverseAuction({@required Map<String, dynamic>? reverseAuctionData, @required List<String>? storePhoneNumbers}) async {
    String apiUrl = 'reverse_auction/add/';
    reverseAuctionData!["storePhoneNumbers"] = storePhoneNumbers;
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(reverseAuctionData),
      );
      return json.decode(response.body);
    });
  }

  static getReverseAuctionDataByUser({
    @required String? userId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'reverse_auction/getReverseAuctionDataByUser';
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

  static getAuctionStoreData({
    @required String? reverseAuctionId,
    @required String? storeIdList,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'reverse_auction/getAuctionStoreData';
    if (storeIdList == "") return {"success": true, "data": null};
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?reverseAuctionId=$reverseAuctionId";
      url += "&storeIdList=$storeIdList";
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

  static updateReverseAuctionData({
    @required Map<String, dynamic>? reverseAuctionData,
    @required String? status,
    @required String? storeName,
    @required String? userName,
    String toWhome = "store",
  }) async {
    String apiUrl = 'reverse_auction/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "reverseAuctionData": reverseAuctionData,
          "status": status,
          "storeName": storeName,
          "userName": userName,
          "toWhome": toWhome,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getTotalReverseAuctionByUser({@required String? userId}) async {
    String apiUrl = 'reverse_auction/getTotalReverseAuctionByUser';
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

  static getReverseAuction({
    @required String? reverseAuctionId,
    @required String? userId,
    @required String? storeId,
  }) async {
    String apiUrl = 'reverse_auction/get';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?reverseAuctionId=$reverseAuctionId";
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
}
