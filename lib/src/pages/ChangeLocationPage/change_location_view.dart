import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/google_api_helper.dart';
import 'package:trapp/src/pages/SearchLocationPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/environment.dart';

import 'index.dart';

class ChangeLocationView extends StatefulWidget {
  const ChangeLocationView({
    Key? key,
  }) : super(key: key);

  @override
  _ChangeLocationViewState createState() => _ChangeLocationViewState();
}

class _ChangeLocationViewState extends State<ChangeLocationView> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;

  ///////////////////////////////

  KeicyProgressDialog? _keicyProgressDialog;
  AppDataProvider? _appDataProvider;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _appDataProvider = AppDataProvider.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      try {
        _appDataProvider!.addListener(_appDataProviderListener);

        Position? position = await AppDataProvider.of(context).getCurrentPositionWithReq();

        if (position == null) {
          _appDataProvider!.removeListener(_appDataProviderListener);
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => SearchLocationPage(isPopup: false),
            ),
          );
          _appDataProvider!.addListener(_appDataProviderListener);
          return;
        }

        if (_appDataProvider!.appDataState.recentLocationList!.isNotEmpty) {
          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            _appDataProvider!.appDataState.recentLocationList!.last["location"]["lat"],
            _appDataProvider!.appDataState.recentLocationList!.last["location"]["lng"],
          );
          if (distance / 1000 <= 5) {
            _lastLocationHandler();
          } else {
            LastLocationDialog.show(
              context,
              currentCallback: _currentLocationHandler,
              lastCallback: _lastLocationHandler,
            );
          }
        } else {
          CurrentLocationDialog.show(
            context,
            okCallback: () {
              _currentLocationHandler();
            },
            cancelCallback: () async {
              _appDataProvider!.removeListener(_appDataProviderListener);

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchLocationPage(isPopup: false),
                ),
              );
              _appDataProvider!.addListener(_appDataProviderListener);
            },
          );
        }
      } catch (e) {
        FlutterLogs.logThis(
          tag: "change_location_view",
          level: LogLevel.ERROR,
          subTag: "initState",
          exception: e is Exception ? e : null,
          error: e is Error ? e : null,
          errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
        );
      }
    });
  }

  @override
  void dispose() {
    _appDataProvider!.removeListener(_appDataProviderListener);
    super.dispose();
  }

  void _appDataProviderListener() async {
    if (_appDataProvider!.appDataState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_appDataProvider!.appDataState.progressState == 2 &&
        _appDataProvider!.appDataState.categoryList!.isNotEmpty &&
        _appDataProvider!.appDataState.isCategoryRequest) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/Pages',
        ModalRoute.withName('/'),
        arguments: {"currentTab": 2},
      );
    }
    if (_appDataProvider!.appDataState.progressState == 2 &&
        _appDataProvider!.appDataState.categoryList!.isEmpty &&
        _appDataProvider!.appDataState.isCategoryRequest) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "We are coming soon here, please search for us in a different location.",
        isTryButton: false,
        callBack: () async {
          _appDataProvider!.removeListener(_appDataProviderListener);
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => SearchLocationPage(isPopup: false),
            ),
          );
          _appDataProvider!.addListener(_appDataProviderListener);
        },
      );
    }
    if (_appDataProvider!.appDataState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _appDataProvider!.appDataState.message!,
        callBack: _currentLocationHandler,
      );
    }
  }

  void _currentLocationHandler() async {
    try {
      await _keicyProgressDialog!.show();
      Position? position = await AppDataProvider.of(context).getCurrentPositionWithReq();

      if (position == null) {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "Location service error. Please try again",
          isTryButton: false,
          callBack: () {
            Navigator.of(context).pop();
          },
        );
        return;
      }

      var result = await GoogleApiHelper.getAddressFromPosition(
        googleApiKey: Environment.googleApiKey,
        lat: position.latitude,
        lng: position.longitude,
      );
      if (result.isNotEmpty) {
        _appDataProvider!.setAppDataState(
          _appDataProvider!.appDataState.update(
            currentLocation: result,
            distance: _appDataProvider!.appDataState.distance ?? AppConfig.distances[0]["value"],
            progressState: 1,
          ),
        );

        _appDataProvider!.getCategoryList(
          distance: _appDataProvider!.appDataState.distance ?? AppConfig.distances[0]["value"],
          currentLocation: result,
        );
        _appDataProvider!.getCouponsInArea(
          distance: _appDataProvider!.appDataState.distance ?? AppConfig.distances[0]["value"],
          currentLocation: result,
        );

        _appDataProvider!.getActiveLuckyDraw();

        _appDataProvider!.getActivePromoCodes();
      } else {
        _appDataProvider!.setAppDataState(
          _appDataProvider!.appDataState.update(
            message: "current location error",
            progressState: -1,
          ),
        );
      }
    } catch (e) {
      _appDataProvider!.setAppDataState(
        _appDataProvider!.appDataState.update(
          message: "current location error",
          progressState: -1,
        ),
      );
    }
  }

  void _lastLocationHandler() async {
    try {
      await _keicyProgressDialog!.show();

      _appDataProvider!.setAppDataState(
        _appDataProvider!.appDataState.update(
          currentLocation: _appDataProvider!.appDataState.recentLocationList!.last,
          distance: _appDataProvider!.appDataState.distance ?? AppConfig.distances[0]["value"],
          progressState: 1,
        ),
      );

      _appDataProvider!.getCategoryList(
        distance: _appDataProvider!.appDataState.distance ?? AppConfig.distances[0]["value"],
        currentLocation: _appDataProvider!.appDataState.recentLocationList!.last,
      );
      _appDataProvider!.getCouponsInArea(
        distance: _appDataProvider!.appDataState.distance ?? AppConfig.distances[0]["value"],
        currentLocation: _appDataProvider!.appDataState.recentLocationList!.last,
      );
      _appDataProvider!.getActiveLuckyDraw();
      _appDataProvider!.getActivePromoCodes();
    } catch (e) {
      _appDataProvider!.setAppDataState(
        _appDataProvider!.appDataState.update(
          message: "current location error",
          progressState: -1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
        stream: Geolocator.getPositionStream(),
        builder: (context, snapshot) {
          return Scaffold(
            body: Container(
              width: deviceWidth,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                child: Consumer<AppDataProvider>(builder: (context, appDataProvider, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: deviceWidth * 0.8,
                        height: deviceWidth * 0.8 * 1037 / 1783,
                        child: Image.asset(
                          "img/earth.png",
                          width: deviceWidth * 0.8,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: heightDp * 30),
                      Text(
                        ChangeLocationPageString.description,
                        style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: heightDp * 30),
                      KeicyRaisedButton(
                        width: widthDp * 220,
                        height: heightDp * 40,
                        borderRadius: heightDp * 50,
                        color: Color(0xFF06D7A0),
                        child: Text(
                          ChangeLocationPageString.locationButton,
                          style: TextStyle(fontSize: fontSp * 15, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        onPressed: _changeLocationHandler,
                      ),
                    ],
                  );
                }),
              ),
            ),
          );
        });
  }

  void _changeLocationHandler() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      var permission = await Permission.location.request();
      if (permission.isGranted) {}
    }
    _appDataProvider!.removeListener(_appDataProviderListener);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => SearchLocationPage(isPopup: false),
      ),
    );
    _appDataProvider!.addListener(_appDataProviderListener);
  }
}
