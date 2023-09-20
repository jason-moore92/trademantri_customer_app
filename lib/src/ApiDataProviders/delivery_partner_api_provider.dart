import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class DeliveryPartnerApiProvider {
  static getDeliveryPartners({@required String? zipCode}) async {
    String apiUrl = 'delivery_partners/get/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + zipCode!;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getDeliveryPartner({@required String? id}) async {
    String apiUrl = 'delivery_partners/getById/';
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
}
