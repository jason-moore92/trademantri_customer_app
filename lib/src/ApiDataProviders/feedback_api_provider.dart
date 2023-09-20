import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/src/models/feedback_model.dart';
import 'package:trapp/environment.dart';

class FeedbackApiProvider {
  static createFeedback({@required FeedbackModel? feedbackModel}) async {
    String apiUrl = 'feedback/add';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(feedbackModel!.toJson()),
      );
      return json.decode(response.body);
    });
  }

  static getFeedback() async {
    String apiUrl = 'feedback/';
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

  static updateFeedback({@required FeedbackModel? feedbackModel}) async {
    String apiUrl = 'feedback/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + feedbackModel!.id!;

      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(feedbackModel.toJson()),
      );
      return json.decode(response.body);
    });
  }
}
