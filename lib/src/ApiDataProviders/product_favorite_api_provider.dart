import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ProductFavoriteApiProvider {
  static getProductFavorite({@required String? userId}) async {
    String apiUrl = 'productFavorite/getProductFavorite/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + userId!;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getProductFavoriteData({
    @required String? userId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'productFavorite/getProductFavoriteData';
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

  static setProductFavorite({@required String? userId, @required String? id, @required String? storeId, @required bool? isFavorite}) async {
    String apiUrl = 'productFavorite/setProductFavorite/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"userId": userId, "id": id, "storeId": storeId, "isFavorite": isFavorite}),
      );
      return json.decode(response.body);
    });
  }
}
