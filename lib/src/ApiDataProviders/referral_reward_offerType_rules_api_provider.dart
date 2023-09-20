import 'dart:convert';

import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ReferralRewardOfferTypeRulesApiProvider {
  static getReferralRewardOfferTypeRulesData() async {
    String apiUrl = 'referralRewardOfferTypeRules/get/';
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
