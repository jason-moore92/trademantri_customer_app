import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/models/index.dart';

class BookAppointmentApiProvider {
  static getAvailableSlots({
    @required String? appointmentId,
    @required String? userId,
    @required String? storeId,
    @required String? date,
  }) async {
    String apiUrl = 'book_appointment/getAvailableSlots';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "appointmentId": appointmentId,
          "userId": userId,
          "storeId": storeId,
          "date": date,
        }),
      );
      return json.decode(response.body);
    });
  }

  static creatBooking({@required BookAppointmentModel? bookAppointmentModel}) async {
    String apiUrl = 'book_appointment/add';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(bookAppointmentModel!.toJson()),
      );
      return json.decode(response.body);
    });
  }

  static getBookData({
    @required String? userId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'book_appointment/getBookData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "userId": userId,
          "status": status!.toLowerCase(),
          "searchKey": searchKey,
          "currentDate": DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toIso8601String(),
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static cancelBook({
    @required String? bookAppointmentId,
    @required String? commentForCancelled,
  }) async {
    String apiUrl = 'book_appointment/cancel';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "bookAppointmentId": bookAppointmentId,
          "commentForCancelled": commentForCancelled,
        }),
      );
      return json.decode(response.body);
    });
  }

  static get({@required String? id}) async {
    String apiUrl = 'book_appointment/get';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"id": id}),
      );
      return json.decode(response.body);
    });
  }
}
