import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class StoreReviewApiProvider {
  static getStoreReview({@required String? userId, @required String? storeId}) async {
    String apiUrl = 'store_review/getStoreReview';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + "?userId=$userId" + "&storeId=$storeId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static createStoreReview({@required Map<String, dynamic>? storeReview}) async {
    String apiUrl = 'store_review/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(storeReview),
      );
      return json.decode(response.body);
    });
  }

  static updateStoreReview({@required Map<String, dynamic>? storeReview}) async {
    String apiUrl = 'store_review/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + storeReview!["_id"];

      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(storeReview),
      );
      return json.decode(response.body);
    });
  }

  static getAverageRating({@required String? storeId}) async {
    String apiUrl = 'store_review/getAverageRating/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + storeId!;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getReviewList({
    @required String? storeId,
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'store_review/getReviewList';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
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
}
