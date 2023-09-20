import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/environment.dart';
import 'package:trapp/src/ApiDataProviders/release_history_firestore_provider.dart';
import 'package:trapp/src/pages/walkthrough.dart';
import 'package:in_app_update/in_app_update.dart';

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

/**
 * @deprecated Using AlertUpdate
 */
class CheckUpdate extends StatefulWidget {
  @override
  _CheckUpdateState createState() => _CheckUpdateState();
}

class _CheckUpdateState extends State<CheckUpdate> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
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
  }

  Future<String> checkForUpdates() async {
    try {
      AppUpdateInfo info = await InAppUpdate.checkForUpdate();
      FlutterLogs.logInfo(
        "check_update",
        "checkForUpdates",
        info.toString(),
      );

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        int latestNumber = info.availableVersionCode!;
        Map<String, dynamic>? releaseData = await ReleaseHistoryFirestoreProvider.getReleaseByNumber(
          number: latestNumber,
        );
        FlutterLogs.logInfo(
          "check_update",
          "onupdateAvailable",
          releaseData.toString(),
        );
        bool forceupdate = true;
        if (releaseData != null) {
          forceupdate = releaseData["forceUpdate"];
        }

        if (forceupdate) {
          return "do_immediate_update";
        } else {
          return "do_flexible_update";
        }
      }

      if (info.updateAvailability == UpdateAvailability.developerTriggeredUpdateInProgress) {
        if (info.immediateUpdateAllowed) {
          return "do_immediate_update";
        } else {
          return "complete_flexible_update";
        }
      }

      return "navigate_walkthrough";
    } catch (e) {
      return "navigate_walkthrough";
    }
  }

  void showToast(
    String msg, {
    Color color = Colors.green,
    Toast length = Toast.LENGTH_LONG,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: color,
      toastLength: length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        child: FutureBuilder<String>(
          future: checkForUpdates(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String state = snapshot.data!;
              if (state == "navigate_walkthrough") {
                _goToWalkthrough();
              }
              if (state == "do_immediate_update") {
                InAppUpdate.performImmediateUpdate().then(
                  (value) {
                    showToast("App updated successfully.");
                  },
                ).catchError(
                  (e) {
                    if (Environment.debug) {
                      showToast(
                        e.toString(),
                        color: Colors.red,
                      );
                    }
                    Phoenix.rebirth(context);
                  },
                );
              }

              if (state == "do_flexible_update") {
                InAppUpdate.startFlexibleUpdate().then(
                  (value) {
                    showToast("App is downloading in background.");
                    InAppUpdate.completeFlexibleUpdate().then(
                      (value) {
                        showToast("App updated successfully.");
                      },
                    ).catchError(
                      (e) {
                        if (Environment.debug) {
                          showToast(
                            e.toString(),
                            color: Colors.red,
                          );
                        }
                      },
                    );
                  },
                ).catchError(
                  (e) {
                    if (Environment.debug) {
                      showToast(
                        e.toString(),
                        color: Colors.red,
                      );
                    }
                  },
                );
                _goToWalkthrough();
              }

              if (state == "complete_flexible_update") {
                InAppUpdate.completeFlexibleUpdate().then(
                  (value) {
                    showToast("App updated successfully.");
                    _goToWalkthrough();
                  },
                ).catchError(
                  (e) {
                    if (Environment.debug) {
                      showToast(
                        e.toString(),
                        color: Colors.red,
                      );
                    }
                  },
                );
              }
            }
            return Center(
              child: Image.asset(
                "img/logo_small.png",
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.fitHeight,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  _goToWalkthrough() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => Walkthrough(),
        ),
      );
    });
  }
}
