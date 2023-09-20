import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class DeliveryAddressApiProvider {
  static addDeliveryAddress({@required Map<String, dynamic>? deliveryAddressData}) async {
    String apiUrl = 'deliveryAddress/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(deliveryAddressData),
      );
      return json.decode(response.body);
    });
  }

  static updateDeliveryAddress({@required String? id, @required Map<String, dynamic>? deliveryAddressData}) async {
    String apiUrl = 'deliveryAddress/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + id!;

      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(deliveryAddressData),
      );
      return json.decode(response.body);
    });
  }

  static delete({@required String? id}) async {
    String apiUrl = 'deliveryAddress/delete/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + id!;

      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getDeliveryAddressData() async {
    String apiUrl = 'deliveryAddress/getDeliveryAddressData';
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
