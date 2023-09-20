import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/BlockButtonWidget.dart';
import 'package:trapp/generated/l10n.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/pages/account_verification.dart';
import 'package:trapp/src/pages/forgot_otp_page.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

/**
 * TODO::This should come after register page.
 * 
 */
class AccountAskPage extends StatefulWidget {
  final Function? callback;
  final String? email;
  final String? mobile;

  AccountAskPage({
    this.callback,
    this.email,
    this.mobile,
  });

  @override
  _AccountAskPageState createState() => _AccountAskPageState();
}

class _AccountAskPageState extends State<AccountAskPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final accountController = TextEditingController();

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

  KeicyProgressDialog? _keicyProgressDialog;
  AuthProvider? _authProvider;

  @override
  void initState() {
    super.initState();

    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _authProvider = AuthProvider.of(context);

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _authProvider!.addListener(_authProviderListener);
    });
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

    if (_authProvider!.authState.progressState == 3) {
      if (_authProvider!.authState.accountVerifyMode == "email") {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => AccountVerificationPage(
              email: widget.email,
              callback: widget.callback,
            ),
          ),
        );
      }

      if (_authProvider!.authState.accountVerifyMode == "mobile") {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => AccountVerificationPage(
              mobile: widget.mobile,
              callback: widget.callback,
            ),
          ),
        );
      }
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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    ///////////////////////////////

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginWidget(callback: widget.callback),
          ),
        );
        return false;
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
                      Text(
                        "Verify account",
                        style: Theme.of(context).textTheme.headline2!.merge(TextStyle(color: Theme.of(context).primaryColor)),
                      ),
                      SizedBox(height: heightDp1 * 20),
                      Container(
                        width: deviceWidth * 0.88,
                        margin: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        padding: EdgeInsets.symmetric(vertical: heightDp1 * 30, horizontal: widthDp * 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [BoxShadow(blurRadius: 50, color: Theme.of(context).hintColor.withOpacity(0.2))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "How would you like to verify account ?",
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            KeicyRaisedButton(
                              color: config.Colors().mainColor(1),
                              width: deviceWidth * 0.5,
                              height: 32.0,
                              borderRadius: 8.0,
                              onPressed: () {
                                _onModeSelected(
                                  "email",
                                );
                              },
                              child: Text(
                                "Via Email",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text("or"),
                            SizedBox(
                              height: 8,
                            ),
                            KeicyRaisedButton(
                              color: config.Colors().mainColor(1),
                              width: deviceWidth * 0.5,
                              height: 32.0,
                              borderRadius: 8.0,
                              onPressed: () {
                                _onModeSelected(
                                  "mobile",
                                );
                              },
                              child: Text(
                                "Via Mobile",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: statusbarHeight + heightDp * 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginWidget(callback: widget.callback),
                        ),
                      );
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
                ),
                Positioned(
                  bottom: statusbarHeight + heightDp * 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginWidget(callback: widget.callback),
                        ),
                      );
                    },
                    child: Container(
                      width: deviceWidth,
                      color: Colors.transparent,
                      child: Center(
                        child: Text("No, skip to login."),
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

  _onModeSelected(String selectedMode) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(
        progressState: 1,
        callback: _onModeSelected,
        accountVerifyMode: selectedMode,
      ),
      isNotifiable: false,
    );
    if (selectedMode == "email") {
      _authProvider!.initiateEmailVerification(
        email: widget.email,
      );
    }
    if (selectedMode == "mobile") {
      _authProvider!.initiateMobileVerification(
        mobile: widget.mobile,
      );
    }
  }
}
