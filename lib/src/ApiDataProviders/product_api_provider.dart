import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ProductApiProvider {
  static getProductCategories({@required List<String>? storeIds}) async {
    String apiUrl = 'product/getProductCategories/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + storeIds!.join(',');

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      );
      return json.decode(response.body);
    });
  }

  static getProduct({@required String? id}) async {
    String apiUrl = 'product/getProduct/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + id!;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getProductList({
    @required List<String>? storeIds,
    List<String> categories = const [],
    String searchKey = "",
    bool? bargainAvailable,
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'product/getProducts';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeIds": storeIds,
          "categories": categories,
          "searchKey": searchKey,
          "bargainAvailable": bargainAvailable,
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getProductListByStoreCategory({
    @required String? categoryId,
    @required Map<String, dynamic>? location,
    @required int? distance,
    String searchKey = "",
    @required int? limit,
    int page = 1,
    bool listonline = true,
    bool isDeleted = false,
  }) async {
    String apiUrl = 'product/getProductsByStoreCategory';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "categoryId": categoryId,
          "lat": location!["lat"],
          "lng": location["lng"],
          "distance": distance,
          "type": AppConfig.storeType,
          "searchKey": searchKey,
          "page": page,
          "limit": limit,
          "listonline": listonline,
          "isDeleted": isDeleted,
        }),
      );
      return json.decode(response.body);
    });
  }

  static checkProductsAvaialbe({
    @required String? storeId,
    @required List<dynamic>? productIds,
  }) async {
    String apiUrl = 'product/checkProductsAvaialbe';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "productIds": productIds,
        }),
      );
      return json.decode(response.body);
    });
  }
}
