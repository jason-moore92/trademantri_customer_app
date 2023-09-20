import 'dart:convert';

import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class LuckyDrawApiProvider {
  static getLatestWinners() async {
    String apiUrl = 'luckyDraw/latestWinners/';
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

  static getActive() async {
    String apiUrl = 'luckyDraw/active/';

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
