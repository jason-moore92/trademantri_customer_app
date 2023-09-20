import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class RewardPointApiProvider {
  static getRewardPoint({@required String? storeId}) async {
    String apiUrl = 'rewardPoint/getRewardPoint/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + "$storeId";

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
