import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ScratchCardApiProvider {
  static scratch({@required String? scratchCardId}) async {
    String apiUrl = 'scratch_card/scratch/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + scratchCardId!;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static sumRewardPoints() async {
    String apiUrl = 'scratch_card/sumRewardPoints/';
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
