import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/BlockButtonWidget.dart';
import 'package:trapp/generated/l10n.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/pages/forgot_page.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/pages/account_initiate.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/helpers/helper.dart';

class AccountVerificationPage extends StatefulWidget {
  final String? email;
  final String? mobile;

  final Function? callback;

  AccountVerificationPage({this.email, this.mobile, this.callback});

  @override
  _AccountVerificationPageState createState() => _AccountVerificationPageState();
}

class _AccountVerificationPageState extends State<AccountVerificationPage> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordConfirmationController = TextEditingController();
  bool obscureText = true;
  bool obscureConfirmationText = true;

  KeicyProgressDialog? _keicyProgressDialog;
  AuthProvider? _authProvider;

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();

    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _authProvider = AuthProvider.of(context);

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
      isNotifiable: false,
    );

    obscureText = true;
    obscureConfirmationText = true;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _authProvider!.addListener(_authProviderListener);
      _prefs = await SharedPreferences.getInstance();
      if (widget.mobile != null) {
        await SmsAutoFill().listenForCode();
        _listenForCode();
      }
    });
  }

  _listenForCode() {
    SmsAutoFill().code.listen((code) {
      otpController.text = code;
      FlutterLogs.logInfo(
        "account_verification",
        "_listenForCode",
        {
          "code": code,
          "message": "Code auto filled.",
        }.toString(),
      );
    });
  }

  @override
  void dispose() {
    _authProvider!.removeListener(_authProviderListener);
    if (widget.mobile != null) {
      SmsAutoFill().unregisterListener();
    }
    super.dispose();
  }

  void _authProviderListener() async {
    if (_authProvider!.authState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_authProvider!.authState.progressState == 4) {
      if (widget.email != null) {
        _authProvider!.authState.userModel!.verified = true;
      }
      if (widget.mobile != null) {
        _authProvider!.authState.userModel!.phoneVerified = true;
      }
      _authProvider!.setAuthState(
        _authProvider!.authState.update(userModel: _authProvider!.authState.userModel),
      );

      _prefs!.setString("remember_me", json.encode(_authProvider!.authState.userModel!.toJson()));

      Fluttertoast.showToast(
        msg: "Account verified successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 13.0,
      );

      if (AuthProvider.of(context).authState.userModel!.id == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginWidget(),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } else if (_authProvider!.authState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _authProvider!.authState.message!,
        callBack: () {
          otpController.clear();
        },
        isTryButton: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    return WillPopScope(
      onWillPop: () async {
        if (AuthProvider.of(context).authState.userModel!.id == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => AccountInitiatePage(callback: widget.callback),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          width: deviceWidth,
          height: deviceHeight,
          child: SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Container(width: deviceWidth, height: deviceHeight),
                Positioned(
                  top: 0,
                  child: Container(
                    width: deviceWidth,
                    height: heightDp1 * 250,
                    decoration: BoxDecoration(color: Theme.of(context).accentColor),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Column(
                    children: [
                      SizedBox(height: statusbarHeight),
                      SizedBox(height: heightDp1 * 20),
                      Image.asset("img/logo_small.png", height: heightDp1 * 50, fit: BoxFit.fitHeight, color: Colors.white),
                      SizedBox(height: heightDp1 * 20),
                      if (widget.email != null)
                        Text(
                          "Verify Email",
                          style: Theme.of(context).textTheme.headline2!.merge(TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                      if (widget.mobile != null)
                        Text(
                          "Verify Mobile",
                          style: Theme.of(context).textTheme.headline2!.merge(TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                      SizedBox(height: heightDp1 * 20),
                      Container(
                        width: deviceWidth * 0.88,
                        margin: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        padding: EdgeInsets.symmetric(vertical: heightDp1 * 30, horizontal: widthDp * 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [BoxShadow(blurRadius: 50, color: Theme.of(context).hintColor.withOpacity(0.2))],
                        ),
                        child: Form(
                          key: loginFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              PinCodeTextField(
                                length: 6,
                                keyboardType: TextInputType.number,
                                textStyle: TextStyle(fontSize: fontSp * 28, color: Colors.black),
                                pastedTextStyle: TextStyle(fontSize: fontSp * 28, color: Colors.black),
                                enablePinAutofill: false,
                                enableActiveFill: true,
                                autoDismissKeyboard: false,
                                autoFocus: true,
                                animationType: AnimationType.fade,
                                readOnly: false,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(widthDp * 10),
                                  fieldHeight: widthDp * 60,
                                  fieldWidth: widthDp * 50,
                                  activeColor: Colors.transparent,
                                  inactiveColor: Colors.transparent,
                                  selectedColor: Colors.transparent,
                                  selectedFillColor: config.Colors().mainColor(0.6),
                                  inactiveFillColor: Color(0xFFF0F2F7),
                                  activeFillColor: config.Colors().mainColor(0.6),
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                backgroundColor: Colors.transparent,
                                // errorAnimationController: errorController,
                                controller: otpController,
                                onCompleted: (v) {},
                                onChanged: (value) {},
                                beforeTextPaste: (text) {
                                  return true;
                                },
                                appContext: context,
                                validator: (value) => value!.length != 6 ? "Please enter 6 digits" : null,
                              ),
                              SizedBox(height: 30),
                              FlatButton(
                                onPressed: () {
                                  _onResendPressed();
                                },
                                textColor: Theme.of(context).hintColor,
                                child: Text(S.of(context).resend_button),
                              ),
                              BlockButtonWidget(
                                text: Text(
                                  "Verify",
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  _onVerifyPressed();
                                },
                              ),
                              SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: statusbarHeight + heightDp * 20,
                  child: GestureDetector(
                    onTap: () {
                      if (AuthProvider.of(context).authState.userModel!.id == null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => AccountInitiatePage(
                              callback: widget.callback,
                            ),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: deviceWidth,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: widthDp * 20),
                          Icon(Icons.arrow_back, size: heightDp * 30, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onResendPressed() async {
    await _keicyProgressDialog!.show();

    if (widget.email != null) {
      _authProvider!.initiateEmailVerification(
        email: widget.email,
      );
    }

    if (widget.mobile != null) {
      _authProvider!.initiateMobileVerification(
        mobile: widget.mobile,
      );
    }
  }

  _onVerifyPressed() async {
    if (!loginFormKey.currentState!.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    if (widget.email != null) {
      _authProvider!.confirmEmailVerification(
        token: int.parse(otpController.text.trim()),
        email: widget.email,
      );
    }
    if (widget.mobile != null) {
      _authProvider!.confirmMobileVerification(
        token: int.parse(otpController.text.trim()),
        mobile: widget.mobile,
      );
    }
  }
}
