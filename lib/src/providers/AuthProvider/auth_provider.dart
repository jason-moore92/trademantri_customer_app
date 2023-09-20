import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/models/feedback_model.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/user_model.dart';
import 'package:trapp/src/providers/BridgeProvider/bridge_provider.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import 'package:trapp/src/providers/firebase_analytics.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/keicy_fcm_for_mobile.dart';
import 'package:trapp/src/services/keicy_firebase_auth.dart';
import 'package:trapp/environment.dart';

import 'index.dart';

class AuthProvider extends ChangeNotifier {
  static AuthProvider of(BuildContext context, {bool listen = false}) => Provider.of<AuthProvider>(context, listen: listen);

  AuthState _authState = AuthState.init();
  AuthState get authState => _authState;

  String _rememberUserKey = "remember_me";
  String _otherCreds = "other_creds";

  void setAuthState(AuthState authState, {bool isNotifiable = true}) {
    if (_authState != authState) {
      _authState = authState;
      if (isNotifiable) notifyListeners();
    }
  }

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void init() async {
    try {
      await KeicyFCMForMobile.init();
      _prefs = await SharedPreferences.getInstance();

      var rememberUserData = _prefs!.getString(_rememberUserKey) == null ? null : json.decode(_prefs!.getString(_rememberUserKey)!);
      if (rememberUserData != null) {
        // signInWithEmailAndPassword(
        //     email: rememberUserData["email"],
        //     password: rememberUserData["password"]);
        signInWithToken(rememberUserData);
      } else {
        _authState = _authState.update(
          progressState: 2,
          message: "",
          loginState: LoginState.IsNotLogin,
        );

        notifyListeners();
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "auth_provider",
        level: LogLevel.ERROR,
        subTag: "init",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }

    // listenBridge();
  }

  listenBridge() {
    BridgeProvider().getStream().listen((event) {
      if (event.event == "log_out") {
        clearAuthState();
      }
    });
  }

  void signUp(Map<String, dynamic> userData) async {
    try {
      var result = await UserApiProvider.registerUser(userData);
      if (result["success"]) {
        if (Environment.enableFBEvents!) {
          getFBAppEvents().logCompletedRegistration(
            registrationMethod: "email_password",
          );
        }
        if (Environment.enableFirebaseEvents!) {
          getFirebaseAnalytics().logSignUp(signUpMethod: "email_password");
        }
        _authState = _authState.update(
          progressState: 2,
          // userModel: UserModel.fromJson(
          //     result["data"]), //TODO:: Revisit this, because we are keeping token and all but at the same time telling notLoggedIn.
          message: "",
          loginState: LoginState.IsNotLogin,
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
          loginState: LoginState.IsNotLogin,
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
        loginState: LoginState.IsNotLogin,
      );
    }

    notifyListeners();
  }

  void signInWithEmailAndPassword({@required String? email, @required String? password}) async {
    try {
      var result = await UserApiProvider.signInWithEmailAndPassword(email!, password!, KeicyFCMForMobile.token!);
      if (result["success"]) {
        for (var i = 0; i < result["data"]["status"].length; i++) {
          if (result["data"]["status"][i]["fcmToken"] == KeicyFCMForMobile.token) {
            result["data"]["fcmToken"] = result["data"]["status"][i]["fcmToken"];
            result["data"]["jwtToken"] = result["data"]["status"][i]["jwtToken"];
          }
        }
        _prefs!.setString(_rememberUserKey, json.encode(result["data"]));

        var firebaseResult = await setUpAfterLogin(result["data"]);

        if (firebaseResult["success"]) {
          if (Environment.enableFBEvents!) {
            getFBAppEvents().logEvent(name: "loggedin");
          }

          if (Environment.enableFirebaseEvents!) {
            getFirebaseAnalytics().logLogin(loginMethod: "email_password");
          }

          if (Environment.enableFreshChatEvents!) {
            Freshchat.trackEvent("loggedin");
          }

          FeedbackModel feedbackModel = await getFeedback();

          _authState = _authState.update(
            progressState: 2,
            userModel: UserModel.fromJson(result["data"]),
            feedbackModel: feedbackModel,
            message: "",
            loginState: LoginState.IsLogin,
          );
          // result["data"]["password"] = password;

          updateChatRoomInfo(result["data"]);
        } else {
          _authState = _authState.update(
            progressState: -1,
            message: "Something was wrong",
            errorCode: 500,
            loginState: LoginState.IsNotLogin,
          );
        }
      } else {
        // if (result["errorCode"] == 401) {
        //   _prefs.setString(_rememberUserKey, json.encode(null));
        // }
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
          errorCode: result["errorCode"],
          loginState: LoginState.IsNotLogin,
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
        loginState: LoginState.IsNotLogin,
      );
    }

    notifyListeners();
  }

  Future<Map<String, dynamic>> setUpAfterLogin(Map<String, dynamic> userData) async {
    try {
      Map<String, dynamic> otherCreds = await UserApiProvider.getOtherCreds();
      await _prefs!.setString(_otherCreds, json.encode(otherCreds["data"]));
      Map<String, dynamic> firebaseResult = await KeicyAuthentication.instance.signInWithCustomToken(token: otherCreds["data"]["firebase"]["token"]);

      getFBAppEvents().setUserID(userData["_id"]);
      getFBAppEvents().setUserData(
        email: userData["email"],
        firstName: userData["firstName"],
        lastName: userData["lastName"],
      );

      getFirebaseAnalytics().setUserId(userData["_id"]);
      getFirebaseAnalytics().setUserProperty(name: "role", value: "customer");

      Freshchat.setPushRegistrationToken(KeicyFCMForMobile.token!);
      Freshchat.identifyUser(
        externalId: userData["_id"],
        restoreId: userData["freshChat"] != null ? userData["freshChat"]["restoreId"] : null,
      );
      FreshchatUser freshchatUser = FreshchatUser(
        userData["_id"],
        userData["freshChat"] != null ? userData["freshChat"]["restoreId"] : null,
      );
      freshchatUser.setFirstName(userData["firstName"]);
      freshchatUser.setLastName(userData["lastName"]);
      freshchatUser.setEmail(userData["email"]);
      freshchatUser.setPhone("+91", userData["mobile"]);
      Freshchat.setUser(freshchatUser);
      Freshchat.setUserProperties({"role": "customer"});

      return firebaseResult;
    } catch (e) {
      return {"success": false};
    }
  }

  void listenForFreshChatRestoreId() {
    var restoreStream = Freshchat.onRestoreIdGenerated;
    restoreStream.listen((event) async {
      FreshchatUser user = await Freshchat.getUser;
      var restoreId = user.getRestoreId();
      String? previousRestoreId = _authState.userModel!.freshChat != null ? _authState.userModel!.freshChat!["restoreId"] : null;
      if (restoreId != previousRestoreId) {
        await UserApiProvider.updateFreshChatRestoreId(restoreId: restoreId);
      }
    });
  }

  void signInWithToken(rememberUserData) async {
    var firebaseResult = await setUpAfterLogin(rememberUserData);

    if (firebaseResult["success"]) {
      FeedbackModel feedbackModel = await getFeedback();

      _authState = _authState.update(
        progressState: 2,
        userModel: UserModel.fromJson(rememberUserData),
        feedbackModel: feedbackModel,
        message: "",
        loginState: LoginState.IsLogin,
      );

      updateChatRoomInfo(rememberUserData);
    } else {
      _authState = _authState.update(
        progressState: -1,
        message: "Something was wrong",
        errorCode: 500,
        loginState: LoginState.IsNotLogin,
      );
    }
    notifyListeners();
  }

  void loginOTPInitiate({
    @required String? identity,
  }) async {
    try {
      var result = await UserApiProvider.loginOTPInitiate(
        identity: identity,
      );
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 5,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      // _authState = _authState.update(
      //   progressState: -1,
      //   message: e.toString(),
      // );
    }

    notifyListeners();
  }

  void loginOTPConfirm({
    @required String? identity,
    required String? otp,
  }) async {
    try {
      var result = await UserApiProvider.loginOTPConfirm(
        identity: identity,
        otp: otp,
        fcmToken: KeicyFCMForMobile.token!,
      );
      if (result["success"]) {
        for (var i = 0; i < result["data"]["status"].length; i++) {
          if (result["data"]["status"][i]["fcmToken"] == KeicyFCMForMobile.token) {
            result["data"]["fcmToken"] = result["data"]["status"][i]["fcmToken"];
            result["data"]["jwtToken"] = result["data"]["status"][i]["jwtToken"];
          }
        }
        _prefs!.setString(_rememberUserKey, json.encode(result["data"]));

        var firebaseResult = await setUpAfterLogin(result["data"]);

        if (firebaseResult["success"]) {
          if (Environment.enableFBEvents!) {
            getFBAppEvents().logEvent(name: "loggedin");
          }

          if (Environment.enableFirebaseEvents!) {
            getFirebaseAnalytics().logLogin(loginMethod: "email_password");
          }

          if (Environment.enableFreshChatEvents!) {
            Freshchat.trackEvent("loggedin");
          }

          FeedbackModel feedbackModel = await getFeedback();

          _authState = _authState.update(
            progressState: 2,
            userModel: UserModel.fromJson(result["data"]),
            feedbackModel: feedbackModel,
            message: "",
            loginState: LoginState.IsLogin,
          );
          // result["data"]["password"] = password;

          updateChatRoomInfo(result["data"]);
        } else {
          _authState = _authState.update(
            progressState: -1,
            message: "Something was wrong",
            errorCode: 500,
            loginState: LoginState.IsNotLogin,
          );
        }
      } else {
        // if (result["errorCode"] == 401) {
        //   _prefs.setString(_rememberUserKey, json.encode(null));
        // }
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
          errorCode: result["errorCode"],
          loginState: LoginState.IsNotLogin,
        );
      }
    } catch (e) {
      // _authState = _authState.update(
      //   progressState: -1,
      //   message: e.toString(),
      // );
    }

    notifyListeners();
  }

  void updateChatRoomInfo(Map<String, dynamic> customerData) async {
    try {
      var result = await ChatRoomFirestoreProvider.getChatRoomsData(
        chatRoomType: ChatRoomTypes.b2c,
        wheres: [
          {"key": "ids", "cond": "arrayContains", "val": "Customer-${customerData["_id"]}"}
        ],
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"].length; i++) {
          if (result["data"][i]["firstUserData"]["_id"] == customerData["_id"]) {
            result["data"][i]["firstUserName"] = ChatProvider.getChatUserName(
              userType: result["data"][i]["firstUserType"],
              userData: customerData,
            );
            result["data"][i]["firstUserData"] = await ChatProvider.convertChatUserData(
              userType: result["data"][i]["firstUserType"],
              userData: customerData,
            );
          } else {
            result["data"][i]["secondUserName"] = ChatProvider.getChatUserName(
              userType: result["data"][i]["secondUserType"],
              userData: customerData,
            );
            result["data"][i]["secondUserData"] = await ChatProvider.convertChatUserData(
              userType: result["data"][i]["secondUserType"],
              userData: customerData,
            );
          }

          ChatRoomFirestoreProvider.updateChatRoom(
            chatRoomType: result["data"][i]["type"],
            id: result["data"][i]["id"],
            data: result["data"][i],
            changeUpdateAt: false,
          );
        }
      }

      result = await ChatRoomFirestoreProvider.getChatRoomsData(
        chatRoomType: ChatRoomTypes.d2c,
        wheres: [
          {"key": "ids", "cond": "arrayContains", "val": "Customer-${customerData["_id"]}"}
        ],
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"].length; i++) {
          if (result["data"][i]["firstUserData"]["_id"] == customerData["_id"]) {
            result["data"][i]["firstUserName"] = ChatProvider.getChatUserName(
              userType: result["data"][i]["firstUserType"],
              userData: customerData,
            );
            result["data"][i]["firstUserData"] = await ChatProvider.convertChatUserData(
              userType: result["data"][i]["firstUserType"],
              userData: customerData,
            );
          } else {
            result["data"][i]["secondUserName"] = ChatProvider.getChatUserName(
              userType: result["data"][i]["secondUserType"],
              userData: customerData,
            );
            result["data"][i]["secondUserData"] = await ChatProvider.convertChatUserData(
              userType: result["data"][i]["secondUserType"],
              userData: customerData,
            );
          }

          ChatRoomFirestoreProvider.updateChatRoom(
            chatRoomType: result["data"][i]["type"],
            id: result["data"][i]["id"],
            data: result["data"][i],
            changeUpdateAt: false,
          );
        }
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "auth_provider",
        subTag: "updateChatRoomInfo",
        level: LogLevel.ERROR,
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  void resendVerifyLink({@required String? email}) async {
    try {
      var result = await UserApiProvider.resendVerifyLink(
        email!,
      );
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 2,
          message: "",
          loginState: LoginState.IsNotLogin,
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
          errorCode: result["errorCode"],
          loginState: LoginState.IsNotLogin,
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
        loginState: LoginState.IsNotLogin,
      );
    }

    notifyListeners();
  }

  Future<void> updateUser(UserModel userModel, {File? imageFile}) async {
    try {
      var result = await UserApiProvider.updateUser(userModel, imageFile: imageFile);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 2,
          userModel: UserModel.fromJson(result["data"]),
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  void forgotPassword({@required String? identity}) async {
    try {
      var result = await UserApiProvider.forgotPassword(
        identity: identity,
      );
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 3,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  void forgotVerifyOTP({
    @required int? otp,
    @required String? identity,
    @required String? newPassword,
    @required String? newPasswordConfirmation,
  }) async {
    try {
      var result = await UserApiProvider.forgotVerifyOTP(
        otp: otp,
        identity: identity,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 4,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  void initiateMobileVerification({
    @required String? mobile,
  }) async {
    try {
      var result = await UserApiProvider.initiateMobileVerification(
        mobile: mobile,
      );
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 3,
          accountVerifyMode: "mobile",
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      // _authState = _authState.update(
      //   progressState: -1,
      //   message: e.toString(),
      // );
    }

    notifyListeners();
  }

  void confirmMobileVerification({
    @required int? token,
    @required String? mobile,
  }) async {
    try {
      var result = await UserApiProvider.confirmMobileVerification(
        mobile: mobile,
        token: token,
      );
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 4,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      // _authState = _authState.update(
      //   progressState: -1,
      //   message: e.toString(),
      // );
    }

    notifyListeners();
  }

  void initiateEmailVerification({
    @required String? email,
  }) async {
    try {
      var result = await UserApiProvider.initiateEmailVerification(
        email: email,
      );
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 3,
          accountVerifyMode: "email",
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      // _authState = _authState.update(
      //   progressState: -1,
      //   message: e.toString(),
      // );
    }

    notifyListeners();
  }

  void confirmEmailVerification({
    @required int? token,
    @required String? email,
  }) async {
    try {
      var result = await UserApiProvider.confirmEmailVerification(
        email: email,
        token: token,
      );
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 4,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      // _authState = _authState.update(
      //   progressState: -1,
      //   message: e.toString(),
      // );
    }

    notifyListeners();
  }

  void changePassword({@required String? email, String? oldPassword, @required String? newPassword}) async {
    try {
      var result = await UserApiProvider.changePassword(email: email, oldPassword: oldPassword, newPassword: newPassword);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 5,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  // void uploadAvatarImage(File imageFile) async {
  //   var result = await UploadFileApiProvider.uploadFile(file: imageFile);
  // }

  Future<FeedbackModel> getFeedback() async {
    try {
      var result = await FeedbackApiProvider.getFeedback();
      if (result["success"] && result["data"] != null) {
        return FeedbackModel.fromJson(result["data"]);
      } else {
        return FeedbackModel();
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "auth_provider",
        subTag: "getFeedback",
        level: LogLevel.ERROR,
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
      return FeedbackModel();
    }
  }

  void createFeedback({@required FeedbackModel? feedbackModel}) async {
    try {
      var result = await FeedbackApiProvider.createFeedback(feedbackModel: feedbackModel);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 2,
          message: "",
          feedbackModel: FeedbackModel.fromJson(result["data"]),
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  void updateFeedback({@required FeedbackModel? feedbackModel}) async {
    try {
      var result = await FeedbackApiProvider.updateFeedback(feedbackModel: feedbackModel);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 2,
          message: "",
          feedbackModel: feedbackModel,
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  Future<bool> addContact({@required ContactModel? contactModel}) async {
    try {
      var result = await ContactApiProvider.createContact(contactModel: contactModel);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 2,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
    return _authState.progressState == 2;
  }

  Future<bool> logout({@required String? fcmToken}) async {
    try {
      var result = await UserApiProvider.logout(fcmToken: fcmToken);
      if (result["success"]) {
        // _prefs.setString(_rememberUserKey, json.encode(null));
        // _authState = _authState.update(
        //   progressState: 2,
        //   message: "",
        //   loginState: LoginState.IsNotLogin,
        //   userModel: UserModel(),
        //   feedbackModel: FeedbackModel(),
        // );
        await clearAuthState();
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    return _authState.loginState == LoginState.IsNotLogin;
  }

  clearAuthState() async {
    await KeicyAuthentication.instance.signOut();
    Freshchat.resetUser();
    if (Environment.enableFBEvents!) {
      getFBAppEvents().logEvent(name: "loggedout");

      getFBAppEvents().clearUserData();
      getFBAppEvents().clearUserID();
    }
    if (Environment.enableFreshChatEvents!) {
      Freshchat.trackEvent("loggedout");
    }
    if (Environment.enableFirebaseEvents!) {
      getFirebaseAnalytics().logEvent(name: "logout");
      getFirebaseAnalytics().resetAnalyticsData();
    }
    await _prefs!.setString(_rememberUserKey, json.encode(null));
    await _prefs!.setString(_otherCreds, json.encode(null));
    _authState = _authState.update(
      progressState: 2,
      message: "",
      loginState: LoginState.IsNotLogin,
      userModel: UserModel(),
      feedbackModel: FeedbackModel(),
    );
    notifyListeners();
  }
}
