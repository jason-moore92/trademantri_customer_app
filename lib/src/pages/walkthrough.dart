import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:notification_permissions/notification_permissions.dart' as NotiPermission;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/global.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/entities/maintenance.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ChangeLocationPage/index.dart';
import 'package:trapp/src/pages/app_update.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/pages/maintenance.dart';
import 'package:trapp/src/pages/signup.dart';
import 'package:trapp/src/providers/index.dart';

/// Responsive design variables
double deviceWidth = 0;
double deviceHeight = 0;
double statusbarHeight = 0;
double bottomBarHeight = 0;
double appbarHeight = 0;
double widthDp = 0;
// double heightDp;
double heightDp1 = 0;
double fontSp = 0;

///////////////////////////////
///
enum WalkthroughStep {
  Welcome,
  AppUpdate,
  Maintenance,
  Walkthrough,
}

class Walkthrough extends StatefulWidget {
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  AuthProvider? _authProvider;

  bool isFirst = true;

  WalkthroughStep _step = WalkthroughStep.Welcome;

  String updateResult = "";
  Maintenance? _activeMaintenance;

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
    // heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    ///////////////////////////////

    _authProvider = AuthProvider.of(context);

    _step = WalkthroughStep.Welcome;

    AppDataProvider.of(context).init();
    CategoryProvider.of(context).getCategoryAll(isNotifiable: false);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      //Note:: This is kept because, users need to view logo
      await Future.delayed(
        Duration(
          seconds: 2,
        ),
      );
      Maintenance? maintenanceConfig = await AppDataProvider.of(context).checkForMaintenance();

      if (maintenanceConfig != null) {
        setState(() {
          _activeMaintenance = maintenanceConfig;
          _step = WalkthroughStep.Maintenance;
        });
      } else {
        await checkUpdates();
      }

      _authProvider!.init();
      GlobalVariables.prefs ??= await SharedPreferences.getInstance();

      isFirst = GlobalVariables.prefs!.getBool("isFirst") ?? true;

      if (isFirst) {
        GlobalVariables.prefs!.setBool("isFirst", false);
        GlobalVariables.dynamicLinkService.retrieveDynamicLink(context, isFirst: true);
      }
    });
  }

  startWalkthrough() {
    setState(() {
      _step = WalkthroughStep.Walkthrough;
      _initPermission();
    });
  }

  startAppUpdate() {
    checkUpdates();
  }

  checkUpdates() async {
    if (Environment.checkUpdates) {
      String result = await AppDataProvider.of(context).checkForUpdates(
          // forceResult: "do_flexible_update",
          // delay: 1,
          );

      FlutterLogs.logInfo(
        "walkthrough",
        "checkUpdates",
        {
          "result": result,
        }.toString(),
      );

      if (result == "navigate_walkthrough") {
        startWalkthrough();
      }

      if (result == "do_immediate_update" || result == "do_flexible_update") {
        setState(() {
          updateResult = result;
          _step = WalkthroughStep.AppUpdate;
        });
      }
    } else {
      startWalkthrough();
    }
  }

  /// ---- permission hadler ---- created by FlutterDev6778 ----
  Future<void> _initPermission() async {
    // var status = await Permission.location.status;
    // if (!status.isGranted) {
    //   await Permission.location.request();
    // }

    NotiPermission.PermissionStatus notificationStatus = await NotiPermission.NotificationPermissions.getNotificationPermissionStatus();
    if (notificationStatus != NotiPermission.PermissionStatus.granted) {
      await NotiPermission.NotificationPermissions.requestNotificationPermissions(
        iosSettings: NotiPermission.NotificationSettingsIos(sound: true, badge: true, alert: true),
      );
    }
  }
  //////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    if (_step == WalkthroughStep.Welcome) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                config.Colors().mainColor(1).withOpacity(0.7),
                config.Colors().mainColor(1),
                config.Colors().mainColor(1).withOpacity(0.7),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Center(
            child: Image.asset(
              "img/logo_small.png",
              height: MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.fitHeight,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (_step == WalkthroughStep.AppUpdate) {
      return AppUpdate(
        updateType: updateResult,
        onSkip: () {
          startWalkthrough();
        },
        doReload: () async {
          await checkUpdates();
        },
      );
    }

    if (_step == WalkthroughStep.Maintenance) {
      return MaintenanceWidget(
        activeMaintenance: _activeMaintenance,
        onSkip: () {
          startAppUpdate();
        },
      );
    }

    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      if (authProvider.authState.progressState == 0 || authProvider.authState.progressState == 1) {
        return Scaffold(
          body: Center(child: CupertinoActivityIndicator()),
        );
      }

      if (authProvider.authState.loginState == LoginState.IsLogin) {
        _initAppHandler();
      }

      if (!isFirst) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ChangeLocationPage()));
        });
        return Scaffold(
          body: Container(color: Colors.white),
        );
      }

      return Scaffold(
        appBar: buildAppBar(context),
        body: new WalkthroughWidget(),
      );
    });
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

  AppBar buildAppBar(context) {
    return AppBar(
      elevation: 0,
      leading: MaterialButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          var referralData =
              GlobalVariables.prefs!.getString("referralData") != null ? json.decode(GlobalVariables.prefs!.getString("referralData")!) : null;

          if (referralData != null) {
            GlobalVariables.prefs!.remove("referralData");
            Navigator.of(context!).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => SignUpWidget(
                  referralCode: referralData["referralCode"],
                  referredByUserId: referralData["referredByUserId"],
                  appliedFor: referralData["appliedFor"],
                ),
              ),
              (route) => false,
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => ChangeLocationPage(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Skip',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            var referralData =
                GlobalVariables.prefs!.getString("referralData") != null ? json.decode(GlobalVariables.prefs!.getString("referralData")!) : null;

            if (referralData != null) {
              GlobalVariables.prefs!.remove("referralData");
              Navigator.of(context!).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => SignUpWidget(
                    referralCode: referralData["referralCode"],
                    referredByUserId: referralData["referredByUserId"],
                    appliedFor: referralData["appliedFor"],
                  ),
                ),
                (route) => false,
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => SignUpWidget(),
                ),
              );
            }
          },
          child: Row(
            children: <Widget>[
              Text(
                'Sign up',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.account_circle,
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
        MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            var referralData =
                GlobalVariables.prefs!.getString("referralData") != null ? json.decode(GlobalVariables.prefs!.getString("referralData")!) : null;

            if (referralData != null) {
              GlobalVariables.prefs!.remove("referralData");
              Navigator.of(context!).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => SignUpWidget(
                    referralCode: referralData["referralCode"],
                    referredByUserId: referralData["referredByUserId"],
                    appliedFor: referralData["appliedFor"],
                  ),
                ),
                (route) => false,
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginWidget(),
                ),
              );
            }
          },
          child: Row(
            children: <Widget>[
              Text(
                'Log In',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.account_circle,
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WalkthroughWidget extends StatelessWidget {
  RestaurantsList _restaurantsList = new RestaurantsList();
  WalkthroughWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight - statusbarHeight - appbarHeight,
      child: Swiper(
        itemCount: 5,
        pagination: SwiperPagination(
          margin: EdgeInsets.only(bottom: heightDp1 * 30),
          builder: DotSwiperPaginationBuilder(
            activeColor: Theme.of(context).accentColor,
            color: Theme.of(context).accentColor.withOpacity(0.2),
          ),
        ),
        loop: false,
        itemBuilder: (context, index) {
          return new WalkthroughItemWidget(_restaurantsList.popularRestaurantsList!.elementAt(index));
        },
      ),
    );
  }
}

class WalkthroughItemWidget extends StatelessWidget {
  final Restaurant restaurant;

  WalkthroughItemWidget(this.restaurant, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: deviceWidth,
          height: deviceHeight - heightDp1 * 120,
          margin: EdgeInsets.only(left: widthDp * 40, right: widthDp * 40, top: heightDp1 * 100, bottom: heightDp1 * 150),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(3)), boxShadow: [
            BoxShadow(
              blurRadius: 50,
              color: Theme.of(context).hintColor.withOpacity(0.2),
            )
          ]),
          child: Column(
            children: <Widget>[
              SizedBox(height: heightDp1 * 60),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: heightDp1 * 50),
                    Text(
                      restaurant.name,
                      style: TextStyle(fontSize: fontSp * 17, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      restaurant.description,
                      style: TextStyle(fontSize: fontSp * 15),
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: heightDp1 * 170 / 276 * 450,
          height: heightDp1 * 170,
          margin: EdgeInsets.symmetric(horizontal: (deviceWidth - (heightDp1 * 170 / 276 * 450)) / 2, vertical: heightDp1 * 40),
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.fill, image: AssetImage(restaurant.image)),
            borderRadius: BorderRadius.all(Radius.circular(heightDp1 * 10)),
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                blurRadius: 30,
                color: Theme.of(context).hintColor.withOpacity(0.2),
              )
            ],
          ),
        ),
      ],
    );
  }
}
