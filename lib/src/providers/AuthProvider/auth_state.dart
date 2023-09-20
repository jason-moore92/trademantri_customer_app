import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/models/index.dart';

enum LoginState {
  IsLogin,
  IsNotLogin,
}

class AuthState extends Equatable {
  /**
   * 0 => 
   * 1 => 
   * 2 => Login State
   * 3 => Forgotpassword and Initiate email and mobile verification
   * 4 => ConfirmEmail/Mobile Verification
   * 5 => LoginOTP
   */
  final int? progressState;
  final String? message;
  final String? traceId;
  final int? errorCode;
  final LoginState? loginState;
  final UserModel? userModel;
  final FeedbackModel? feedbackModel;
  final Function? callback;
  final String? accountVerifyMode;

  AuthState({
    @required this.message,
    @required this.traceId,
    @required this.errorCode,
    @required this.progressState,
    @required this.loginState,
    @required this.userModel,
    @required this.feedbackModel,
    @required this.callback,
    @required this.accountVerifyMode,
  });

  factory AuthState.init() {
    return AuthState(
      errorCode: 0,
      progressState: 0,
      message: "",
      traceId: "",
      loginState: LoginState.IsNotLogin,
      userModel: UserModel(),
      feedbackModel: FeedbackModel(),
      callback: () {},
      accountVerifyMode: "email",
    );
  }

  AuthState copyWith({
    int? progressState,
    int? errorCode,
    String? message,
    String? traceId,
    LoginState? loginState,
    UserModel? userModel,
    FeedbackModel? feedbackModel,
    Function? callback,
    String? accountVerifyMode,
  }) {
    return AuthState(
        progressState: progressState ?? this.progressState,
        errorCode: errorCode ?? this.errorCode,
        message: message ?? this.message,
        traceId: traceId ?? this.traceId,
        loginState: loginState ?? this.loginState,
        userModel: userModel ?? this.userModel,
        feedbackModel: feedbackModel ?? this.feedbackModel,
        callback: callback ?? this.callback,
        accountVerifyMode: accountVerifyMode ?? this.accountVerifyMode);
  }

  AuthState update({
    int? progressState,
    int? errorCode,
    String? message,
    String? traceId,
    LoginState? loginState,
    UserModel? userModel,
    FeedbackModel? feedbackModel,
    Function? callback,
    String? accountVerifyMode,
  }) {
    return copyWith(
      progressState: progressState,
      errorCode: errorCode,
      message: message,
      traceId: traceId,
      loginState: loginState,
      userModel: userModel,
      feedbackModel: feedbackModel,
      callback: callback,
      accountVerifyMode: accountVerifyMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "errorCode": errorCode,
      "message": message,
      "traceId": traceId,
      "loginState": loginState,
      "userModel": userModel,
      "feedbackModel": feedbackModel,
      "callback": callback,
      "accountVerifyMode": accountVerifyMode,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        errorCode!,
        message!,
        traceId!,
        loginState!,
        userModel!,
        feedbackModel!,
        callback!,
        accountVerifyMode!,
      ];

  @override
  bool get stringify => true;
}
