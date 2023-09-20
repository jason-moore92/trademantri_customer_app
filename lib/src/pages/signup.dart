import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trapp/generated/l10n.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/success_dialog.dart';
import 'package:trapp/src/elements/BlockButtonWidget.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/account_ask.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/keicy_fcm_for_mobile.dart';
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/environment.dart';

class SignUpWidget extends StatefulWidget {
  final String? referralCode;
  final String? referredByUserId;
  final String? appliedFor;
  final Function? callback;

  SignUpWidget({
    this.callback,
    this.referralCode,
    this.referredByUserId,
    this.appliedFor,
  });

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
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

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> navigatorKey = GlobalKey<ScaffoldState>();

  final firstNameController = TextEditingController(text: Environment.envName == "development" ? "Pavan" : null);
  final lastNameController = TextEditingController(text: Environment.envName == "development" ? "Kumar" : null);
  final emailController = TextEditingController(text: Environment.envName == "development" ? "pavan+@trademantri.com" : null);
  final mobileController = TextEditingController(text: Environment.envName == "development" ? "99999000" : null);
  final dobController = TextEditingController(text: Environment.envName == "development" ? "1992-05-12" : null);
  final passwordController = TextEditingController(text: Environment.envName == "development" ? "Simple@123" : null);
  final confirmPasswordController = TextEditingController(text: Environment.envName == "development" ? "Simple@123" : null);

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  UserModel _userModel = UserModel();
  KeicyProgressDialog? _keicyProgressDialog;
  AuthProvider? _authProvider;
  bool passwordObscureText = true;
  bool confirmObscureText = true;

  @override
  void initState() {
    super.initState();

    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _authProvider = AuthProvider.of(context);

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
      isNotifiable: false,
    );

    passwordObscureText = true;
    confirmObscureText = true;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _authProvider!.addListener(_authProviderListener);
    });

    // if (Environment.enableFBEvents!) {
    //   getFBAppEvents().logViewContent(
    //     type: "page",
    //     id: "register",
    //     content: {},
    //     currency: "INR",
    //     price: 0,
    //   );
    // }

    // if (Environment.enableFreshChatEvents!) {
    //   Freshchat.trackEvent(
    //     "navigation",
    //     properties: {
    //       "page": "register",
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

    if (_authProvider!.authState.progressState == 2 && _authProvider!.authState.loginState == LoginState.IsNotLogin) {
      // SuccessDialog.show(
      //   context,
      //   heightDp: heightDp,
      //   fontSp: fontSp,
      //   text: "Signup Success!\nPlease Verify your email or mobile to Login",
      //   callBack: () {
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(
      //         builder: (BuildContext context) => LoginWidget(callback: widget.callback),
      //       ),
      //     );
      //   },
      // );

      Fluttertoast.showToast(
        msg: "Your account registered successfully.\nPlease Verify your email or mobile to Login.",
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_LONG,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => AccountAskPage(
            callback: widget.callback,
            email: emailController.text.trim(),
            mobile: mobileController.text.trim(),
          ),
        ),
      );
    } else if (_authProvider!.authState.progressState == -1) {
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

    return Scaffold(
      key: navigatorKey,
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
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
                child: Container(
                  width: deviceWidth,
                  height: deviceHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: statusbarHeight),
                        SizedBox(height: heightDp1 * 20),
                        Image.asset("img/logo_small.png", height: heightDp1 * 50, fit: BoxFit.fitHeight, color: Colors.white),
                        SizedBox(height: heightDp1 * 20),
                        Text(
                          'Let\'s Start with register!',
                          style: Theme.of(context).textTheme.headline2!.merge(TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                        SizedBox(height: heightDp1 * 20),
                        Container(
                          width: deviceWidth * 0.88,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [BoxShadow(blurRadius: 50, color: Theme.of(context).hintColor.withOpacity(0.2))],
                          ),
                          margin: EdgeInsets.symmetric(horizontal: widthDp * 20),
                          padding: EdgeInsets.symmetric(vertical: heightDp1 * 20, horizontal: widthDp * 20),
                          child: Form(
                            key: signUpFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: firstNameController,
                                  focusNode: _firstNameFocusNode,
                                  validator: (input) => input!.length < 1 ? S.of(context).input_first_name : null,
                                  decoration: InputDecoration(
                                    labelText: "First Name",
                                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.person_rounded, color: Theme.of(context).accentColor),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                  ),
                                  onSaved: (input) => _userModel.firstName = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_lastNameFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: lastNameController,
                                  focusNode: _lastNameFocusNode,
                                  validator: (input) => input!.length < 1 ? S.of(context).input_last_name : null,
                                  decoration: InputDecoration(
                                    labelText: "Last Name",
                                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                  ),
                                  onSaved: (input) => _userModel.lastName = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_emailFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  focusNode: _emailFocusNode,
                                  validator: (input) => !KeicyValidators.isValidEmail(input!) ? S.of(context).should_be_a_valid_email : null,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                  ),
                                  onSaved: (input) => _userModel.email = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_mobileFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: mobileController,
                                  focusNode: _mobileFocusNode,
                                  validator: (input) => (input!.length != 10 || !isNumbers(input)) ? S.of(context).not_a_valid_phone : null,
                                  decoration: InputDecoration(
                                    labelText: "Mobile Number",
                                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.phone_android_outlined, color: Theme.of(context).accentColor),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                  ),
                                  onSaved: (input) => _userModel.mobile = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: dobController,
                                  focusNode: _dobFocusNode,
                                  // validator: (input) => (input!.length != 10 || !isNumbers(input)) ? S.of(context).not_a_valid_phone : null,
                                  decoration: InputDecoration(
                                    labelText: "Date of birth",
                                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.event, color: Theme.of(context).accentColor),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? selecteDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(DateTime.now().year - 10, 12, 31),
                                      firstDate: DateTime(DateTime.now().year - 100, 1, 1),
                                      lastDate: DateTime(DateTime.now().year - 10, 12, 31),
                                    );

                                    if (selecteDate == null) return;

                                    dobController.text = KeicyDateTime.convertDateTimeToDateString(
                                      dateTime: selecteDate,
                                      isUTC: false,
                                    );

                                    _userModel.dob = dobController.text;

                                    setState(() {});
                                  },
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: passwordController,
                                  focusNode: _passwordFocusNode,
                                  validator: (input) => !passwordValidation(input!) || input.length < 8
                                      ? S.of(context).should_password_input
                                      : passwordController.text.trim() != confirmPasswordController.text.trim()
                                          ? S.of(context).should_password_match
                                          : null,
                                  obscureText: passwordObscureText,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '••••••••••••',
                                    errorMaxLines: 2,
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          passwordObscureText = !passwordObscureText;
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: widthDp * 10),
                                        child: Image.asset(
                                          passwordObscureText ? "img/show_password.png" : "img/hide-password.png",
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
                                  ),
                                  onSaved: (input) => _userModel.password = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: confirmPasswordController,
                                  focusNode: _confirmPasswordFocusNode,
                                  validator: (input) => !passwordValidation(input!) || input.length < 8
                                      ? S.of(context).should_password_input
                                      : passwordController.text.trim() != confirmPasswordController.text.trim()
                                          ? S.of(context).should_password_match
                                          : null,
                                  obscureText: confirmObscureText,
                                  decoration: InputDecoration(
                                    labelText: "Confirm Password",
                                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '••••••••••••',
                                    errorMaxLines: 2,
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          confirmObscureText = !confirmObscureText;
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: widthDp * 10),
                                        child: Image.asset(
                                          confirmObscureText ? "img/show_password.png" : "img/hide-password.png",
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
                                  ),
                                  onSaved: (input) => _userModel.password = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  },
                                ),
                                SizedBox(height: 30),
                                BlockButtonWidget(
                                  text: Text(
                                    S.of(context).register,
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    _onSignUpButtonPressed();
                                  },
                                ),
                                SizedBox(height: 10),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => LoginWidget(callback: widget.callback),
                                      ),
                                    );
                                  },
                                  textColor: Theme.of(context).hintColor,
                                  child: Text('I have account? Back to login'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 10,
              //   child: FlatButton(
              //     onPressed: () {
              //       Navigator.of(context).pushReplacement(
              //         MaterialPageRoute(
              //           builder: (BuildContext context) => LoginWidget(callback: widget.callback),
              //         ),
              //       );
              //     },
              //     textColor: Theme.of(context).hintColor,
              //     child: Text('I have account? Back to login'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  _onSignUpButtonPressed() async {
    if (!signUpFormKey.currentState!.validate()) return;

    signUpFormKey.currentState!.save();

    Position? position = await AppDataProvider.of(context).getCurrentPositionWithReq();

    if (position != null) {
      _userModel.location = {
        "type": "Point",
        "coordinates": [position.longitude, position.latitude],
      };
    }

    await _keicyProgressDialog!.show();

    _userModel.fcmToken = KeicyFCMForMobile.token;

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 1, callback: _onSignUpButtonPressed),
      isNotifiable: false,
    );

    _userModel.referredBy = widget.referralCode;
    _userModel.referredByUserId = widget.referredByUserId;
    _userModel.appliedFor = widget.appliedFor;

    Map<String, dynamic> userData = _userModel.toJson();

    _authProvider!.signUp(userData);
  }
}
