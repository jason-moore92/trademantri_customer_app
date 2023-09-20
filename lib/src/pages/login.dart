import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/BlockButtonWidget.dart';
import 'package:trapp/generated/l10n.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/pages/account_initiate.dart';
import 'package:trapp/src/pages/forgot_page.dart';
import 'package:trapp/src/pages/login_otp.dart';
import 'package:trapp/src/pages/signup.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/environment.dart';
import 'SearchLocationPage/index.dart';

class LoginWidget extends StatefulWidget {
  final Function? callback;

  LoginWidget({this.callback});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final identityController = TextEditingController();
  final passwordController = TextEditingController();

  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  KeicyProgressDialog? _keicyProgressDialog;
  AuthProvider? _authProvider;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    _keicyProgressDialog = KeicyProgressDialog(
      context,
      message: "Hang on!\nAwesomeness is Loading...",
    );
    _authProvider = AuthProvider.of(context);

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
      isNotifiable: false,
    );

    obscureText = true;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _authProvider!.addListener(_authProviderListener);
    });

    // if (Environment.enableFBEvents!) {
    //   getFBAppEvents().logViewContent(
    //     type: "page",
    //     id: "login",
    //     content: {},
    //     currency: "INR",
    //     price: 0,
    //   );
    // }

    // if (Environment.enableFreshChatEvents!) {
    //   Freshchat.trackEvent(
    //     "navigation",
    //     properties: {
    //       "page": "login",
    //     },
    //   );
    // }
  }

  @override
  void dispose() {
    _authProvider!.removeListener(_authProviderListener);
    super.dispose();
  }

  void _authProviderListener() async {
    if (_authProvider!.authState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_authProvider!.authState.progressState == 2 && _authProvider!.authState.loginState == LoginState.IsLogin) {
      _initAppHandler();
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        callBack: () async {
          if (widget.callback != null) {
            Navigator.of(context).pop();
            widget.callback!();
          } else {
            if (AppDataProvider.of(context).appDataState.currentLocation!.isEmpty) {
              _authProvider!.removeListener(_authProviderListener);
              await Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchLocationPage(
                    isPopup: false,
                  ),
                ),
                ModalRoute.withName('/'),
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/Pages',
                ModalRoute.withName('/'),
                arguments: {"currentTab": 2},
              );
            }
          }
        },
      );
    } else if (_authProvider!.authState.progressState == 5) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginOTPPage(
            identity: identityController.text.trim(),
          ),
        ),
      );
    }
    if (_authProvider!.authState.progressState == -1) {
      if (_authProvider!.authState.errorCode == 402) {
        VerifyFailedDialog.show(
          context,
          heightDp: heightDp,
          fontSp: fontSp,
          text: _authProvider!.authState.message!,
          callBack: () async {
            await _keicyProgressDialog!.show();
            _authProvider!.resendVerifyLink(
              email: identityController.text.trim(),
            );
          },
        );
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: _authProvider!.authState.message!,
          callBack: _authProvider!.authState.callback,
          cancelCallback: () {
            _authProvider!.setAuthState(
              _authProvider!.authState.update(callback: () {}),
              isNotifiable: false,
            );
          },
        );
      }
    }
  }

  void _initAppHandler() {
    AuthProvider.of(context).listenForFreshChatRestoreId();
    CartProvider.of(context).init(
      userId: AuthProvider.of(context).authState.userModel!.id,
      lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
    );
    DeliveryAddressProvider.of(context).init(userId: AuthProvider.of(context).authState.userModel!.id);
    FavoriteProvider.of(context).getFavorite(userId: AuthProvider.of(context).authState.userModel!.id);
  }

  @override
  Widget build(BuildContext context) {
    ///////////////////////////////
    return Scaffold(
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
                  height: heightDp * 250,
                  decoration: BoxDecoration(color: Theme.of(context).accentColor),
                ),
              ),
              Positioned(
                top: 0,
                child: Column(
                  children: [
                    SizedBox(height: statusbarHeight),
                    SizedBox(height: heightDp * 20),
                    Image.asset("img/logo_small.png", height: heightDp * 50, fit: BoxFit.fitHeight, color: Colors.white),
                    SizedBox(height: heightDp * 20),
                    Text(
                      'Let\'s Start with Login!',
                      style: Theme.of(context).textTheme.headline2!.merge(TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                    SizedBox(height: heightDp * 20),
                    Container(
                      width: deviceWidth * 0.88,
                      margin: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      padding: EdgeInsets.symmetric(vertical: heightDp * 30, horizontal: widthDp * 20),
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
                            TextFormField(
                              controller: identityController,
                              // onSaved: (input) =>  authService.user.email  = input,
                              validator: (input) =>
                                  !((double.tryParse(input!.trim()) != null && input.trim().length == 10) || KeicyValidators.isValidEmail(input))
                                      ? S.of(context).should_be_a_valid_email_phone
                                      : null,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email / Mobile",
                                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                contentPadding: EdgeInsets.all(12),
                                hintText: '',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                errorMaxLines: 2,
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: passwordController,
                              // onSaved: (input) {
                              //   authService.user.password = input;
                              // },
                              validator: (input) => !passwordValidation(input!) || input.length < 8 ? S.of(context).should_password_input : null,
                              obscureText: obscureText,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                contentPadding: EdgeInsets.all(12),
                                hintText: '••••••••••••',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: widthDp * 10),
                                    child: Image.asset(
                                      obscureText ? "img/show_password.png" : "img/hide-password.png",
                                      width: heightDp * 20 / 3 * 4,
                                      height: heightDp * 20,
                                      fit: BoxFit.cover,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                suffixIconConstraints: BoxConstraints(
                                  maxWidth: heightDp * 20 / 3 * 4 + widthDp * 10,
                                  maxHeight: heightDp * 20,
                                ),
                                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                errorMaxLines: 2,
                              ),
                            ),
                            SizedBox(height: 30),
                            BlockButtonWidget(
                              text: Text(
                                'Login',
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                _onLoginButtonPressed();
                              },
                            ),
                            SizedBox(height: 16),
                            BlockButtonWidget(
                              text: Text(
                                'Login with OTP',
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                _onLoginOTPButtonPressed();
                              },
                            ),
                            SizedBox(height: 25),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ForgotPage(callback: widget.callback),
                                  ),
                                );
                              },
                              textColor: Theme.of(context).hintColor,
                              child: Text('I forgot password ?'),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => SignUpWidget(callback: widget.callback),
                                  ),
                                );
                              },
                              textColor: Theme.of(context).hintColor,
                              child: Text('Create an account'),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => AccountInitiatePage(
                                      callback: widget.callback,
                                    ),
                                  ),
                                );
                              },
                              textColor: Theme.of(context).hintColor,
                              child: Text('Verify account'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onLoginButtonPressed() async {
    if (!loginFormKey.currentState!.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 1, callback: _onLoginButtonPressed),
      isNotifiable: false,
    );
    _authProvider!.signInWithEmailAndPassword(email: identityController.text.trim(), password: passwordController.text.trim());
  }

  _onLoginOTPButtonPressed() async {
    if (identityController.text == "") {
      Fluttertoast.showToast(
        msg: "Please enter Email or Phone.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 13.0,
      );
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 1, callback: _onLoginOTPButtonPressed),
      isNotifiable: false,
    );
    _authProvider!.loginOTPInitiate(
      identity: identityController.text.trim(),
    );
  }
}
