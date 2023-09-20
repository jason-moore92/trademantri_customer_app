import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ProductItemReviewApiProvider {
  static getProductItemReview({
    @required String? userId,
    @required String? itemId,
    @required String? type,
  }) async {
    String apiUrl = 'product_item_review/getProductItemReview';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + "?userId=$userId" + "&itemId=$itemId" + "&type=$type";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static createProductItemReview({@required Map<String, dynamic>? itemReview}) async {
    String apiUrl = 'product_item_review/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(itemReview),
      );
      return json.decode(response.body);
    });
  }

  static updateProductItemReview({@required Map<String, dynamic>? itemReview}) async {
    String apiUrl = 'product_item_review/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + itemReview!["_id"];

      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(itemReview),
      );
      return json.decode(response.body);
    });
  }

  static getAverageRating({@required String? itemId, @required String? type}) async {
    String apiUrl = 'product_item_review/getAverageRating';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?itemId=" + itemId!;
      url += "&type=" + type!;

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
    @required String? itemId,
    @required String? type,
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'product_item_review/getReviewList';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?itemId=$itemId";
      url += "&type=$type";
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
