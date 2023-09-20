import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class StoreJobPostingsApiProvider {
  static getStoreJobPostingsData({
    String storeId = "",
    @required String? userId,
    @required String? status,
    double? latitude,
    double? longitude,
    int? distance,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'store_job_posings/getAll/';
    apiUrl += "?storeId=$storeId";
    apiUrl += "&userId=$userId";
    apiUrl += "&status=$status";
    apiUrl += "&latitude=$latitude";
    apiUrl += "&longitude=$longitude";
    apiUrl += "&distance=$distance";
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

  static getStoreJob({@required String? jobId, @required String? storeId}) async {
    String apiUrl = 'store_job_posings/get?jobId=$jobId&storeId=$storeId';
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
