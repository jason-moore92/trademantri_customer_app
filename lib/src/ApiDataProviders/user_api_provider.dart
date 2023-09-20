import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpold;
import 'package:sms_autofill/sms_autofill.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/environment.dart';

class UserApiProvider {
  static registerUser(Map<String, dynamic> userData) async {
    String apiUrl = 'user/register';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      userData["email"] = userData["email"].toString().toLowerCase();
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );
      return json.decode(response.body);
    });
  }

  static signInWithEmailAndPassword(String email, String password, String token) async {
    String apiUrl = 'user/login';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

      bool isPhoneNumber = numericRegex.hasMatch(email);

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email.toLowerCase(),
          "password": password,
          "isPhoneNumber": isPhoneNumber,
          "fcmToken": token,
        }),
      );

      var result = json.decode(response.body);
      result["errorCode"] = response.statusCode;

      return result;
    });
  }

  static loginOTPInitiate({
    required String? identity,
  }) async {
    String apiUrl = 'user/loginOTPInitiate';
    return httpExceptionWrapper(() async {
      String appSignature = await SmsAutoFill().getAppSignature;

      String url = Environment.apiBaseUrl! + apiUrl;

      String? email;
      String? mobile;
      if (identity != null) {
        email = identity.contains("@") ? identity : null;
        mobile = identity.contains("@") ? null : identity;
      }

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "mobile": mobile,
          "appSignature": appSignature,
        }),
      );

      var result = json.decode(response.body);
      result["errorCode"] = response.statusCode;

      return result;
    });
  }

  static loginOTPConfirm({
    required String? identity,
    required String? otp,
    required String? fcmToken,
  }) async {
    String apiUrl = 'user/loginOTPConfirm';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      String? email;
      String? mobile;
      if (identity != null) {
        email = identity.contains("@") ? identity : null;
        mobile = identity.contains("@") ? null : identity;
      }

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "mobile": mobile,
          "otp": otp,
          "fcmToken": fcmToken,
        }),
      );

      var result = json.decode(response.body);
      result["errorCode"] = response.statusCode;

      return result;
    });
  }

  static resendVerifyLink(String email) async {
    String apiUrl = 'user/initiateEmailVerification'; //Note:: Eventhough name is resendVerifyLink using deprecated
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
        }),
      );
      var result = json.decode(response.body);
      result["errorCode"] = response.statusCode;

      return result;
    });
  }

  static updateUser(UserModel userModel, {File? imageFile}) async {
    String apiUrl = 'user/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var request = httpold.MultipartRequest("POST", Uri.parse(url));
      request.fields.addAll({"data": json.encode(userModel.toJson())});

      var cmnHeaders = await commonHeaders();
      request.headers.addAll(cmnHeaders);

      if (imageFile != null) {
        Uint8List imageByteData = await imageFile.readAsBytes();
        request.files.add(
          httpold.MultipartFile.fromBytes(
            'image',
            imageByteData,
            filename: imageFile.path.split('/').last,
          ),
        );
      }

      var response = await request.send();
      // if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();

      return json.decode(result);
    });
  }

  static forgotPassword({
    @required String? identity,
  }) async {
    String apiUrl = 'user/forgot';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      String appSignature = await SmsAutoFill().getAppSignature;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            "identity": identity,
            "appSignature": appSignature,
          },
        ),
      );
      return json.decode(response.body);
    });
  }

  static forgotVerifyOTP({
    @required int? otp,
    @required String? identity,
    @required String? newPassword,
    @required String? newPasswordConfirmation,
  }) async {
    String apiUrl = 'user/forgot_verify/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "otp": otp,
          "identity": identity,
          "newPassword": newPassword,
          "newPasswordConfirmation": newPasswordConfirmation,
        }),
      );
      return json.decode(response.body);
    });
  }

  static initiateMobileVerification({
    @required String? mobile,
  }) async {
    String apiUrl = 'user/initiateMobileVerification/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      String appSignature = await SmsAutoFill().getAppSignature;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "mobile": mobile,
          "appSignature": appSignature,
        }),
      );
      return json.decode(response.body);
    });
  }

  static confirmMobileVerification({
    @required int? token,
    @required String? mobile,
  }) async {
    String apiUrl = 'user/confirmMobileVerification/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"token": token, "mobile": mobile}),
      );
      return json.decode(response.body);
    });
  }

  static initiateEmailVerification({
    @required String? email,
  }) async {
    String apiUrl = 'user/initiateEmailVerification/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
        }),
      );
      return json.decode(response.body);
    });
  }

  static confirmEmailVerification({
    @required int? token,
    @required String? email,
  }) async {
    String apiUrl = 'user/confirmEmailVerification/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "token": token,
          "email": email,
        }),
      );
      return json.decode(response.body);
    });
  }

  static changePassword({
    @required String? email,
    @required String? oldPassword,
    @required String? newPassword,
  }) async {
    String apiUrl = 'user/changePassword/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
          "email": email,
        }),
      );
      return json.decode(response.body);
    });
  }

  static logout({@required String? fcmToken}) async {
    String apiUrl = 'user/logout';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + "?fcmToken=$fcmToken";

      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return json.decode(response.body);
    });
  }

  static getOtherCreds() async {
    String apiUrl = 'user/otherCreds';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return {
        "success": true,
        "data": json.decode(response.body),
      };
    });
  }

  static getMaintenance() async {
    String apiUrl = 'maintenance/active';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return json.decode(response.body);
    });
  }

  static updateFreshChatRestoreId({@required String? restoreId}) async {
    String apiUrl = 'freshChat/updateRestoreId/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "restoreId": restoreId,
        }),
      );
      return json.decode(response.body);
    });
  }
}
