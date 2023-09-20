import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class StoreApiProvider {
  static getStoreList({
    String? categoryId,
    @required Map<String, dynamic>? location,
    @required int? distance,
    int page = 1,
    bool isPaginated = true,
    String searchKey = "",
  }) async {
    String apiUrl = 'store/getStores';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?lat=${location!["lat"]}" + "&lng=${location["lng"]}";
      url += "&type=${AppConfig.storeType}";
      url += "&distance=$distance";
      url += "&categoryId=$categoryId";
      url += "&page=$page";
      url += "&searchKey=$searchKey";
      url += "&limit=${AppConfig.countLimitForList}";
      url += "&isPaginated=$isPaginated";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getStoreData({@required String? id}) async {
    String apiUrl = 'store/get/' + id!;
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

  static getFCMTokenByStoreUserId({@required String? storeId}) async {
    String apiUrl = 'store/getStoreTokens/' + storeId!;
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
