import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/environment.dart';

class CategoryApiProvider {
  static int testCount = 0;

  static getCategoryList({
    @required Map<String, dynamic>? location,
    @required int? distance,
    String searchKey = "",
  }) async {
    String apiUrl = 'category/getCategories';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + "?lat=${location!["lat"]}" + "&lng=${location["lng"]}";
      url += "&type=${AppConfig.storeType}";
      url += "&distance=$distance";
      url += "&searchKey=$searchKey";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getCategoryAll() async {
    String apiUrl = 'category/getAll';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return json.decode(response.body);
    });
  }
}
