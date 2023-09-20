import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ServiceApiProvider {
  static getServiceCategories({
    @required List<String>? storeIds,
  }) async {
    String apiUrl = 'service/getServiceCategories/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + storeIds!.join(',');

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getService({@required String? id}) async {
    String apiUrl = 'service/getService/';
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

  static getServiceList({
    @required List<String>? storeIds,
    List<String> categories = const [],
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'service/getServices';
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
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getServiceListByStoreCategory({
    @required String? categoryId,
    @required Map<String, dynamic>? location,
    @required int? distance,
    String searchKey = "",
    @required int? limit,
    int page = 1,
    bool listonline = true,
    bool isDeleted = false,
  }) async {
    String apiUrl = 'service/getServicesByStoreCategory';
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

  static checkServicesAvaialbe({
    @required String? storeId,
    @required List<dynamic>? serviceIds,
  }) async {
    String apiUrl = 'service/checkServicesAvaialbe';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "serviceIds": serviceIds,
        }),
      );
      return json.decode(response.body);
    });
  }
}
