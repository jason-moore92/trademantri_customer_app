import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/src/providers/BridgeProvider/bridge_provider.dart';
import 'package:trapp/src/providers/BridgeProvider/bridge_state.dart';
import 'package:trapp/environment.dart';

class AuthInterceptor implements InterceptorContract {
  //Note:: URLs for which should not send token in any case.
  List<String> blacklist = [
    "user/login",
    "user/register",

    "user/forgot",
    "user/forgot_verify",

    "user/initiateEmailVerification",
    "user/confirmEmailVerification",
    "user/initiateMobileVerification",
    "user/confirmEmailVerification",

    //Deprecated
    "user/resend_verify_link",
    "user/verify_otp",
  ];

  @override
  Future<RequestData> interceptRequest({RequestData? data}) async {
    String currentRoute = data!.url.replaceAll(Environment.apiBaseUrl!, "");
    if (!blacklist.contains(currentRoute)) {
      String authToken = await getAuthToken();
      if (authToken != "") {
        data.headers["Authorization"] = "Bearer " + authToken;
      }
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData? data}) async {
    if (data!.statusCode == 401 || data.statusCode == 408) {
      var responseData = json.decode(data.body!);
      if (responseData['message'] == "jwt expired" || responseData['message'] == "Invalid jwtToken") {
        BridgeProvider().update(
          BridgeState(
            event: "log_out",
            data: {
              "message": "Invalid token",
            },
          ),
        );
      }
    }
    return data;
  }
}
