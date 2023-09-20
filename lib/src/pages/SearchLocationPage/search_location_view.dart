import 'dart:async';

// import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/search_address_widget.dart';
import 'package:trapp/src/helpers/google_api_helper.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import '../../elements/keicy_progress_dialog.dart';
import 'package:trapp/environment.dart';

import 'index.dart';

class SearchLocationView extends StatefulWidget {
  final bool isGettingLocation;
  final bool isPopup;

  const SearchLocationView({
    Key? key,
    this.isGettingLocation = false,
    this.isPopup = true,
  }) : super(key: key);

  @override
  _SearchLocationViewState createState() => _SearchLocationViewState();
}

class _SearchLocationViewState extends State<SearchLocationView> with WidgetsBindingObserver {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  // Color? secondaryColor;
  ///////////////////////////////

  AppDataProvider? _appDataProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  Map<String, dynamic>? _selectedLocationInfo;

  int? distance;

  Timer? _timerLink;

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

    _appDataProvider = AppDataProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    distance = _appDataProvider!.appDataState.distance;

    if (_appDataProvider!.appDataState.recentLocationList!.length > 0) {
      _selectedLocationInfo = _appDataProvider!.appDataState.recentLocationList![_appDataProvider!.appDataState.recentLocationList!.length - 1];
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _appDataProvider!.addListener(_appDataProviderListener);

      WidgetsBinding.instance!.addObserver(this);
    });
    _initPermission();
  }

  Future<void> _initPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {},
      );
    }
  }

  @override
  void dispose() {
    _appDataProvider!.removeListener(_appDataProviderListener);

    WidgetsBinding.instance!.removeObserver(this);
    if (_timerLink != null) {
      _timerLink!.cancel();
    }
    super.dispose();
  }

  void _appDataProviderListener() async {
    if (_appDataProvider!.appDataState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_appDataProvider!.appDataState.progressState == 2 &&
        _appDataProvider!.appDataState.categoryList!.isNotEmpty &&
        _appDataProvider!.appDataState.isCategoryRequest) {
      if (widget.isPopup) {
        Navigator.of(context).pop(true);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/Pages',
          ModalRoute.withName('/'),
          arguments: {"currentTab": 2},
        );
      }
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
        callBack: null,
      );
    }

    if (_appDataProvider!.appDataState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _appDataProvider!.appDataState.message!,
        callBack: _getCategoryHandler,
      );
    }
  }

  void _getCategoryHandler() async {
    if (_selectedLocationInfo != null) {
      _appDataProvider!.setAppDataState(
        _appDataProvider!.appDataState.update(
          currentLocation: _selectedLocationInfo,
          distance: distance,
          progressState: 1,
        ),
      );

      await _keicyProgressDialog!.show();

      await _appDataProvider!.getCategoryList(
        distance: distance,
        currentLocation: _selectedLocationInfo,
      );
      await _appDataProvider!.getCouponsInArea(
        distance: distance,
        currentLocation: _selectedLocationInfo,
      );
      await _appDataProvider!.getActiveLuckyDraw();
      await _appDataProvider!.getActivePromoCodes();
    } else {
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (EasyDynamicTheme.of(context).themeMode == ThemeMode.light) {
    //   secondaryColor = config.Colors().secondColor(1);
    // } else {
    //   secondaryColor = config.Colors().secondDarkColor(1);
    // }

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        flexibleSpace: Column(
          children: [
            SizedBox(height: statusbarHeight),
            Container(
              height: appbarHeight,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.isPopup)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: heightDp * 20,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  if (!widget.isPopup)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (widget.isGettingLocation) {
                          _selectedLocationInfo!["distance"] = distance;
                          Navigator.of(context).pop(_selectedLocationInfo);
                        } else {
                          _getCategoryHandler();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                        decoration: BoxDecoration(
                          color: config.Colors().mainColor(1),
                          borderRadius: BorderRadius.circular(heightDp * 6),
                        ),
                        child: Text("Go", style: TextStyle(fontSize: fontSp * 18, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Consumer<AppDataProvider>(builder: (context, appDataProvider, _) {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();

            return true;
          },
          child: Container(
            width: deviceWidth,
            height: deviceHeight - statusbarHeight - appbarHeight,
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///
                  _distancePanel(),

                  ///
                  SizedBox(height: heightDp * 15),
                  _searchFieldPanel(),

                  SizedBox(height: heightDp * 10),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFFD9D9D8), height: 1, thickness: 1)),
                      SizedBox(width: widthDp * 10),
                      Text(
                        SearchLocationPageString.orLabel,
                        style: TextStyle(fontSize: fontSp * 11, color: Color(0xFFD9D9D8)),
                      ),
                      SizedBox(width: widthDp * 10),
                      Expanded(child: Divider(color: Color(0xFFD9D9D8), height: 1, thickness: 1)),
                    ],
                  ),
                  SizedBox(height: heightDp * 10),

                  _currentLocationPanel(),

                  ///
                  SizedBox(height: heightDp * 15),
                  Container(height: heightDp * 10, color: Color(0xFFF3F3F6)),

                  /// saved Address
                  _savedAddressPanel(),
                  Container(height: heightDp * 10, color: Color(0xFFF3F3F6)),

                  /// recent location
                  _recentAddressPanel(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _distancePanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            SearchLocationPageString.distanceLabel,
            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          ),
          KeicyDropDownFormField(
            width: widthDp * 150,
            height: heightDp * 50,
            menuItems: AppConfig.distances,
            value: distance,
            border: Border.all(color: Colors.transparent),
            borderRadius: heightDp * 8,
            fillColor: Color(0xFFF3F3F3),
            contentHorizontalPadding: widthDp * 15,
            selectedItemStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            onChangeHandler: (value) {
              distance = value;
              // setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _searchFieldPanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: SearchAddressWidget(
        googleApiKey: Environment.googleApiKey,
        height: heightDp * 50,
        borderRadius: heightDp * 50,
        contentHorizontalPadding: widthDp * 15,
        fillColor: Color(0xFFF3F3F3),
        label: SearchLocationPageString.searchLabel,
        labelSpacing: heightDp * 5,
        hint: SearchLocationPageString.searchHint,
        labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 14, color: Color(0xFFC0C0C2)),
        suggestTextStyle: TextStyle(fontSize: fontSp * 11, color: Colors.black, fontWeight: FontWeight.normal),
        prefixIcon: Icon(Icons.search, size: heightDp * 25, color: Color(0xFF9095A2)),
        suffixIcon: Icon(Icons.close, size: heightDp * 20, color: Colors.black),
        initValue: _selectedLocationInfo == null ? "" : _selectedLocationInfo!["name"] + ", " + _selectedLocationInfo!["address"],
        isEmpty: _selectedLocationInfo == null,
        initHandler: () {
          // _selectedLocationInfo = null;
        },
        completeHandler: (placeID) async {
          FocusScope.of(context).requestFocus(FocusNode());
          await _keicyProgressDialog!.show();
          var result = await GoogleApiHelper.getAddressFromPlaceID(
            googleApiKey: Environment.googleApiKey,
            placeID: placeID,
          );
          await _keicyProgressDialog!.hide();

          if (result != null) {
            setState(() {
              _selectedLocationInfo = result;
            });
          }
        },
      ),
    );
  }

  Widget _currentLocationPanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: GestureDetector(
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
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
          await _keicyProgressDialog!.hide();

          if (result.isNotEmpty) {
            setState(() {
              _selectedLocationInfo = result;
            });
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Icon(Icons.my_location, size: heightDp * 20, color: Color(0xFF29BB88)),
              SizedBox(width: widthDp * 15),
              Text(
                SearchLocationPageString.currentLocationLabel,
                style: TextStyle(fontSize: fontSp * 14, color: Color(0xFF29BB88)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _savedAddressPanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SearchLocationPageString.savedAddressLabel,
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
              KeicyRaisedButton(
                width: widthDp * 80,
                height: heightDp * 30,
                color: Color(0xFFE3E3E6),
                child: Text(
                  "+",
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (_selectedLocationInfo == null) {
                    _showValidateSaveAddressDialog();
                  } else {
                    _showSaveAddressDialog();
                  }
                },
              ),
            ],
          ),
          SizedBox(height: heightDp * 10),
          Column(
            children: List.generate(_appDataProvider!.appDataState.savedLocationList!.length, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        _selectedLocationInfo = _appDataProvider!.appDataState.savedLocationList![index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _appDataProvider!.appDataState.savedLocationList![index]["nickName"] ?? "NickName",
                            style: TextStyle(
                              fontSize: fontSp * 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            _appDataProvider!.appDataState.savedLocationList![index]["name"] +
                                ", " +
                                _appDataProvider!.appDataState.savedLocationList![index]["address"],
                            style: TextStyle(
                              fontSize: fontSp * 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6))
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _recentAddressPanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SearchLocationPageString.recentSearchesLabel,
            style: TextStyle(
              fontSize: fontSp * 14,
              color: Colors.black,
            ),
          ),
          SizedBox(height: heightDp * 10),
          Column(
            children: List.generate(_appDataProvider!.appDataState.recentLocationList!.length, (index) {
              var locationData =
                  _appDataProvider!.appDataState.recentLocationList![_appDataProvider!.appDataState.recentLocationList!.length - 1 - index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        _selectedLocationInfo = locationData;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                      color: Colors.transparent,
                      child: Text(
                        locationData["name"] + ", " + locationData["address"],
                        style: TextStyle(
                          fontSize: fontSp * 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showSaveAddressDialog() {
    TextEditingController _controller = TextEditingController();
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // backgroundColor: Colors.white,
          title: Text(
            SearchLocationPageString.refnameDescription,
            style: TextStyle(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formkey,
            child: TextFormField(
              controller: _controller,
              style: TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(),
                // enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                // border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                // focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              ),
              validator: (input) => input!.length < 2 ? SearchLocationPageString.savedLocationNameValidateString : null,
            ),
          ),
          actions: [
            RaisedButton(
              child: Text(
                SearchLocationPageString.okButton,
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                if (!_formkey.currentState!.validate()) return;
                Navigator.of(context).pop();

                _selectedLocationInfo!["nickName"] = _controller.text.trim();
                _appDataProvider!.saveSavedLocation(
                  currentLocation: _selectedLocationInfo,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showValidateSaveAddressDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // backgroundColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 30),
          content: Text(
            SearchLocationPageString.validateSaveLocationDescription,
            style: TextStyle(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: [
            RaisedButton(
              child: Text(
                SearchLocationPageString.okButton,
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
