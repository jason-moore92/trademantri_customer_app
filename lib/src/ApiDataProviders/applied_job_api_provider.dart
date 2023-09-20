import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class AppliedJobApiProvider {
  static createAppliedJob({@required Map<String, dynamic>? appliedJobData}) async {
    String apiUrl = 'applied_jobs/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(appliedJobData),
      );
      return json.decode(response.body);
    });
  }

  static getAppliedJob({@required String? jobId}) async {
    String apiUrl = 'applied_jobs/get';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + "?jobId=$jobId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getAppliedJobData({
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'applied_jobs/getAll/';
    apiUrl += "?status=$status";
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

  static checkApplied({
    @required String? storeJobId,
    @required String? storeId,
    @required String? userId,
  }) async {
    String apiUrl = 'applied_jobs/checkApplied/';
    apiUrl += "?jobId=$storeJobId";
    apiUrl += "&storeId=$storeId";
    apiUrl += "&userId=$userId";
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
