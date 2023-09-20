import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/social_icons_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:telephony/telephony.dart';
import 'package:trapp/src/elements/support_pages_widget.dart';

import 'index.dart';

class ContactUsView extends StatefulWidget {
  ContactUsView({Key? key}) : super(key: key);

  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
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

  Completer<GoogleMapController> _mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? markerId;

  final TextEditingController controller = TextEditingController();
  final Telephony telephony = Telephony.instance;
  String initialCountry = 'IN';
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'IN');
  bool phoneValidated = false;

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

    ///////////////////////////////

    phoneValidated = false;

    /// store marker mark
    markerId = MarkerId("store_marker_id");
    Marker storeMarker = Marker(
      markerId: markerId!,
      position: LatLng(AppConfig.companyLatitude, AppConfig.companyLongitude),
      onTap: () {},
      onDragEnd: (LatLng position) {},
    );
    markers[markerId!] = storeMarker;
    //////////////////////////////////////
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF162779),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            child: Column(
              children: [
                Container(
                  width: deviceWidth,
                  color: Color(0xFF162779),
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
                  child: Column(
                    children: [
                      Image.asset("img/logo.png", width: deviceWidth * 0.5, fit: BoxFit.fitWidth),
                      SizedBox(height: heightDp * 20),
                      Text(
                        ContactUsPageString.appbarTitle,
                        style: TextStyle(fontSize: fontSp * 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 20),

                      Container(
                        width: deviceWidth - widthDp * 40,
                        height: deviceWidth - widthDp * 40,
                        child: GoogleMap(
                          myLocationButtonEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(AppConfig.companyLatitude, AppConfig.companyLongitude),
                            zoom: 18,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _mapController.complete(controller);
                          },
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          rotateGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          mapToolbarEnabled: false,
                          buildingsEnabled: true,
                          onCameraMoveStarted: () {},
                          mapType: MapType.normal,
                          myLocationEnabled: false,
                          markers: Set<Marker>.of(markers.values),
                        ),
                      ),

                      ///
                      SizedBox(height: heightDp * 30),
                      Center(
                        child: KeicyRaisedButton(
                          width: widthDp * 200,
                          height: heightDp * 40,
                          color: config.Colors().mainColor(1),
                          borderRadius: heightDp * 6,
                          child: Text(
                            ContactUsPageString.sendUsRequest,
                            style: TextStyle(fontSize: fontSp * 17, color: Colors.white),
                          ),
                          onPressed: () {
                            RequestBottomSheet.show(context);
                          },
                        ),
                      ),

                      ///
                      SizedBox(height: heightDp * 30),
                      Container(
                        width: deviceWidth,
                        child: Column(
                          children: [
                            Text(
                              AppConfig.companyName,
                              style: TextStyle(fontSize: fontSp * 21, color: Colors.black, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: heightDp * 10),
                      Container(
                        width: deviceWidth,
                        child: Column(
                          children: [
                            Text(
                              AppConfig.companyAddress,
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: heightDp * 10),
                      Container(
                        width: deviceWidth,
                        child: Column(
                          children: [
                            Text(
                              "${AppConfig.companyArea}, ${AppConfig.companyCity}",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: heightDp * 10),
                      Container(
                        width: deviceWidth,
                        child: Column(
                          children: [
                            Text(
                              "${AppConfig.companyState}, ${AppConfig.companyZip}",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      ///
                      SizedBox(height: heightDp * 40),
                      Text(
                        ContactUsPageString.adString1,
                        style: TextStyle(fontSize: fontSp * 50, color: Colors.black, fontWeight: FontWeight.w900, height: 1),
                        textAlign: TextAlign.start,
                      ),

                      SizedBox(height: heightDp * 20),

                      ///
                      Text(
                        ContactUsPageString.adString2,
                        style: TextStyle(fontSize: fontSp * 23, color: Colors.grey),
                        textAlign: TextAlign.start,
                      ),

                      SizedBox(height: heightDp * 20),

                      ///
                      Text(
                        ContactUsPageString.adString3,
                        style: TextStyle(fontSize: fontSp * 36, color: config.Colors().mainColor(1), fontWeight: FontWeight.w900, height: 1),
                        textAlign: TextAlign.start,
                      ),

                      ///
                      SizedBox(height: heightDp * 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _launchInBrowser(AppConfig.playStoreLink);
                            },
                            child: Image.asset("img/playstore.png", height: heightDp * 50, fit: BoxFit.fitHeight),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchInBrowser(AppConfig.appStoreLink);
                            },
                            child: Image.asset("img/appstore.png", height: heightDp * 50, fit: BoxFit.fitHeight),
                          ),
                        ],
                      ),

                      // ///
                      // SizedBox(height: heightDp * 30),
                      // Card(
                      //   elevation: 4,
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Expanded(
                      //           child: Container(
                      //             child: InternationalPhoneNumberInput(
                      //               onInputChanged: (PhoneNumber number) {
                      //                 phoneNumber = number;
                      //               },
                      //               onInputValidated: (bool value) {
                      //                 if (phoneValidated != value) {
                      //                   phoneValidated = value;
                      //                   setState(() {});
                      //                 }
                      //               },
                      //               selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG),
                      //               ignoreBlank: true,
                      //               autoValidateMode: AutovalidateMode.always,
                      //               selectorTextStyle: TextStyle(color: Colors.black),
                      //               spaceBetweenSelectorAndTextField: 0,
                      //               selectorButtonOnErrorPadding: 0,
                      //               scrollPadding: EdgeInsets.zero,
                      //               initialValue: phoneNumber,
                      //               textFieldController: controller,
                      //               formatInput: false,
                      //               keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      //               inputDecoration: InputDecoration(
                      //                 border: OutlineInputBorder(),
                      //                 errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      //                 contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                      //                 focusedBorder: OutlineInputBorder(),
                      //                 errorStyle: TextStyle(fontSize: 0, color: Colors.transparent, height: 0),
                      //               ),
                      //               errorMessage: "",
                      //               onSaved: (PhoneNumber number) {
                      //                 print('On Saved: $number');
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //         SizedBox(width: widthDp * 5),
                      //         GestureDetector(
                      //           onTap: () async {
                      //             if (!phoneValidated) return;
                      //             bool permissionsGranted = await telephony.requestSmsPermissions;
                      //             if (permissionsGranted) {
                      //               try {
                      //                 telephony.sendSms(
                      //                   to: phoneNumber.phoneNumber,
                      //                   message: "${ContactUsPageString.smsDescription}" +
                      //                       "\n\nPlayStore: ${AppConfig.playStoreLink}" +
                      //                       "\nAppStore: ${AppConfig.appStoreLink}",
                      //                   statusListener: (SendStatus sendStatus) {
                      //                     print(sendStatus.toString());
                      //                   },
                      //                 );
                      //               } catch (e) {
                      //                 print(e);
                      //               }
                      //             }
                      //           },
                      //           child: Container(
                      //             padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                      //             decoration: BoxDecoration(
                      //               color: phoneValidated ? config.Colors().mainColor(1) : Colors.grey,
                      //               borderRadius: BorderRadius.circular(heightDp * 6),
                      //             ),
                      //             child: Text(
                      //               "Get App Link",
                      //               style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.bold),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      ///
                      SizedBox(height: heightDp * 30),
                      Center(child: Image.asset("img/logo_small.png", height: heightDp * 70, fit: BoxFit.fitHeight)),

                      SizedBox(height: heightDp * 30),
                      Center(child: SupportPagesWidget(type: "contact_us")),

                      ///
                      SizedBox(height: heightDp * 30),
                      SocialIconsWidget(),

                      ///
                      SizedBox(height: heightDp * 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
