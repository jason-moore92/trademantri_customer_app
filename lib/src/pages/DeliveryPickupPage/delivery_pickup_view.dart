import 'dart:async';
import 'dart:convert';
import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/search_address_widget.dart';
import 'package:trapp/src/helpers/google_api_helper.dart';
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/SearchLocationPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/generated/l10n.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';
import 'package:trapp/environment.dart';

class DeliveryPickupView extends StatefulWidget {
  final OrderModel? orderModel;
  final Map<String, dynamic>? deliveryAddress;
  final bool? forEdit;

  DeliveryPickupView({
    Key? key,
    this.orderModel,
    this.deliveryAddress,
    this.forEdit,
  }) : super(key: key);

  @override
  _DeliveryPickupViewState createState() => _DeliveryPickupViewState();
}

class _DeliveryPickupViewState extends State<DeliveryPickupView> with SingleTickerProviderStateMixin {
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

  AuthProvider? _authProvider;
  DeliveryAddressProvider? _deliveryAddressProvider;
  LocationProvider? _locationProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  Completer<GoogleMapController> _mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  MarkerId? storeMarkerId;
  MarkerId? deliveryMarkerId;

  TextEditingController _addressTypeController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _homeToReachController = TextEditingController();
  TextEditingController _contactPhoneController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _addressTypeFocusNode = FocusNode();
  FocusNode _buildingFocusNode = FocusNode();
  FocusNode _homeToReachFocusNode = FocusNode();
  FocusNode _contactPhoneFocusNode = FocusNode();

  String addressType = AppConfig.deliveryAddressType.last;

  double? _maxDeliveryDistance;
  String? _selectedPlaceId;

  Position? currentPosition;

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

    _deliveryAddressProvider = DeliveryAddressProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _locationProvider = LocationProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _maxDeliveryDistance = _deliveryAddressProvider!.deliveryAddressState.maxDeliveryDistance;

    _deliveryAddressProvider!.setDeliveryAddressState(
      _deliveryAddressProvider!.deliveryAddressState.update(progressState: 0),
    );

    _deliveryAddressProvider!.init(userId: _authProvider!.authState.userModel!.id);

    /// store marker mark
    if (widget.orderModel != null) {
      storeMarkerId = MarkerId("store_marker_id");
      Marker storeMarker = Marker(
        markerId: storeMarkerId!,
        position: widget.orderModel!.storeModel!.location!,
        // infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
        onTap: () {
          // _onMarkerTapped(markerId);
        },
        onDragEnd: (LatLng position) {
          // _onMarkerDragEnd(markerId, position);
        },
      );
      markers[storeMarkerId!] = storeMarker;
      //////////////////////////////////////

      /// store radius
      CircleId circleId = CircleId("store_circle_id");
      Circle circle = Circle(
        circleId: circleId,
        consumeTapEvents: true,
        strokeColor: config.Colors().mainColor(1),
        fillColor: Colors.green.withOpacity(0.15),
        strokeWidth: 1,
        center: widget.orderModel!.storeModel!.location!,
        radius: (_maxDeliveryDistance! * 1000).toDouble(),
        onTap: () {
          // _onCircleTapped(circleId);
        },
      );

      circles[circleId] = circle;
      ////////////////////////////////
    }

    if (widget.forEdit! && widget.deliveryAddress != null) {
      _buildingController.text = widget.deliveryAddress!["building"];
      _homeToReachController.text = widget.deliveryAddress!["howToReach"];
      _contactPhoneController.text = widget.deliveryAddress!["contactPhone"];
      addressType = widget.deliveryAddress!["addressType"];
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _deliveryAddressProvider!.addListener(_deliveryAddressProviderListener);
      _locationProvider!.addListener(_locationProviderListener);

      currentPosition = await Geolocator.getCurrentPosition();

      if (!widget.forEdit! && widget.deliveryAddress == null) {
        _moveToCurrentLocation(
          LatLng(currentPosition!.latitude, currentPosition!.longitude),
          zoom: 18,
        );
      } else if (widget.forEdit! && widget.deliveryAddress != null) {
        _moveToCurrentLocation(
          LatLng(
            widget.deliveryAddress!["address"]["location"]["lat"],
            widget.deliveryAddress!["address"]["location"]["lng"],
          ),
          zoom: 18,
        );
      }
    });
  }

  @override
  void dispose() {
    _deliveryAddressProvider!.removeListener(_deliveryAddressProviderListener);
    _locationProvider!.removeListener(_locationProviderListener);
    super.dispose();
  }

  void _deliveryAddressProviderListener() async {
    if (_deliveryAddressProvider!.deliveryAddressState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      _keicyProgressDialog!.hide();
    }

    if (_deliveryAddressProvider!.deliveryAddressState.progressState == 2) {
      Navigator.of(context).pop();
    } else if (_deliveryAddressProvider!.deliveryAddressState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _deliveryAddressProvider!.deliveryAddressState.message!,
        callBack: _saveHandler,
      );
    }
  }

  void _locationProviderListener() async {
    if (_locationProvider!.progressStatus == 3 && _locationProvider!.statusString != "") {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _locationProvider!.statusString,
      );
    }
  }

  double getZoomLevel() {
    double zoomLevel = 11;
    double radius = _maxDeliveryDistance! * 1000 + _maxDeliveryDistance! * 1000 / 2;
    double scale = radius / 500;
    zoomLevel = (16 - Math.log(scale) / Math.log(2));
    return zoomLevel;
  }

  Future _moveToCurrentLocation(LatLng location, {double? zoom}) async {
    var controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: location,
        zoom: zoom ?? getZoomLevel(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(builder: (context, locationProvider, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: MediaQuery.of(context).viewInsets.bottom != 0 ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                Container(width: deviceWidth, height: statusbarHeight, color: Colors.white),
                Container(
                  width: deviceWidth,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                    child: SearchAddressWidget(
                      googleApiKey: Environment.googleApiKey,
                      height: heightDp * 40,
                      borderRadius: heightDp * 50,
                      border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6))),
                      errorBorder: Border(bottom: BorderSide(color: Colors.red.withOpacity(0.6))),
                      contentHorizontalPadding: widthDp * 10,
                      fillColor: Colors.transparent,
                      hint: SearchLocationPageString.searchHint,
                      textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Color(0xFFC0C0C2)),
                      suggestTextStyle: TextStyle(fontSize: fontSp * 13, color: Colors.black, fontWeight: FontWeight.normal),
                      prefixIcon: Icon(Icons.search, size: heightDp * 25, color: Color(0xFF9095A2)),
                      suffixIcon: Icon(Icons.close, size: heightDp * 20, color: Colors.black),
                      initValue: locationProvider.progressStatus == 1
                          ? "Loding ..."
                          : locationProvider.progressStatus == 2
                              ? locationProvider.lastDeliveryAddress!["address"]
                              : locationProvider.progressStatus == 3
                                  ? locationProvider.statusString
                                  : "",
                      isEmpty: locationProvider.lastDeliveryAddress == null || markers[deliveryMarkerId] == null,
                      initHandler: () {
                        markers.remove(deliveryMarkerId);
                        locationProvider.setProgressStatus(0);

                        if (widget.orderModel != null) {
                          _moveToCurrentLocation(widget.orderModel!.storeModel!.location!);
                        } else {
                          _moveToCurrentLocation(
                            LatLng(currentPosition!.latitude, currentPosition!.longitude),
                            zoom: 18,
                          );
                        }
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
                          _selectedPlaceId = placeID;
                          _moveToCurrentLocation(LatLng(result["location"]["lat"], result["location"]["lng"]), zoom: 18);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMap(
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(31.1975844, 29.9598339),
                          zoom: getZoomLevel(),
                        ),
                        // initialCameraPosition:
                        //  !widget.forEdit! && widget.orderModel != null
                        //     ? CameraPosition(
                        //         target: widget.orderModel!.storeModel!.location!,
                        //         zoom: getZoomLevel(),
                        //       )
                        //     : widget.forEdit! && widget.deliveryAddress != null
                        //         ? CameraPosition(
                        //             target: LatLng(
                        //               widget.deliveryAddress!["address"]["location"]["lat"],
                        //               widget.deliveryAddress!["address"]["location"]["lng"],
                        //             ),
                        //             zoom: getZoomLevel(),
                        //           )
                        //         :
                        //         CameraPosition(
                        //             target: LatLng(31.1975844, 29.9598339),
                        //             zoom: getZoomLevel(),
                        //           ),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController.complete(controller);
                        },
                        onCameraMove: (CameraPosition position) {
                          _deliveryMarkerHandler(position);
                        },
                        onCameraIdle: _deliveryAddressHandler,
                        onCameraMoveStarted: () {},
                        onTap: (latLng) {},
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        markers: Set<Marker>.of(markers.values),
                        circles: Set<Circle>.of(circles.values),
                      ),
                      Container(
                        width: deviceWidth,
                        alignment: Alignment.topRight,
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(heightDp * 5),
                          color: Colors.white,
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.my_location_outlined, size: heightDp * 25, color: Colors.black),
                            onPressed: () async {
                              Position? currentPosition = await AppDataProvider.of(context).getCurrentPositionWithReq();
                              if (currentPosition != null) {
                                _moveToCurrentLocation(LatLng(currentPosition.latitude, currentPosition.longitude), zoom: 18);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightDp * 10),
                _deliveryPanel(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _deliveryPanel() {
    double distance = 0;
    if (widget.orderModel != null && markers[deliveryMarkerId] != null) {
      distance = Geolocator.distanceBetween(
        widget.orderModel!.storeModel!.location!.latitude,
        widget.orderModel!.storeModel!.location!.longitude,
        markers[deliveryMarkerId]!.position.latitude,
        markers[deliveryMarkerId]!.position.longitude,
      );
    }

    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KeicyTextFormField(
                  controller: _buildingController,
                  focusNode: _buildingFocusNode,
                  width: null,
                  height: heightDp * 30,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
                  hintText: "Flat, Floor, Building Number",
                  border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6))),
                  errorBorder: Border(bottom: BorderSide(color: Colors.red.withOpacity(0.6))),
                  contentHorizontalPadding: widthDp * 10,
                  prefixIcons: [Icon(Icons.home, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
                  onFieldSubmittedHandler: (input) {
                    FocusScope.of(context).requestFocus(_homeToReachFocusNode);
                  },
                ),
                SizedBox(height: heightDp * 15),
                KeicyTextFormField(
                  controller: _homeToReachController,
                  focusNode: _homeToReachFocusNode,
                  width: null,
                  height: heightDp * 30,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
                  hintText: "How to reach",
                  border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6))),
                  errorBorder: Border(bottom: BorderSide(color: Colors.red.withOpacity(0.6))),
                  contentHorizontalPadding: widthDp * 10,
                  prefixIcons: [Icon(Icons.directions, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
                  onFieldSubmittedHandler: (input) {
                    FocusScope.of(context).requestFocus(_contactPhoneFocusNode);
                  },
                ),
                SizedBox(height: heightDp * 15),
                KeicyTextFormField(
                  controller: _contactPhoneController,
                  focusNode: _contactPhoneFocusNode,
                  width: null,
                  height: heightDp * 30,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
                  hintText: "Contact Phone Number",
                  border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6))),
                  errorBorder: Border(bottom: BorderSide(color: Colors.red.withOpacity(0.6))),
                  contentHorizontalPadding: widthDp * 10,
                  prefixIcons: [Icon(Icons.phone, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
                  keyboardType: TextInputType.phone,
                  onFieldSubmittedHandler: (input) {
                    FocusScope.of(context).requestFocus(_addressTypeFocusNode);
                  },
                  validatorHandler: (input) => (input.length != 10 || !isNumbers(input)) ? S.of(context).not_a_valid_phone : null,
                ),
                SizedBox(height: heightDp * 15),
                Row(
                  children: [
                    Icon(Icons.save, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
                    SizedBox(width: widthDp * 10),
                    Text(
                      "Save as",
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 10),
                _addressTypePanel(),
              ],
            ),
          ),
          _locationProvider!.lastDeliveryAddress != null &&
                  _locationProvider!.lastDeliveryAddress!.isNotEmpty &&
                  _locationProvider!.lastDeliveryAddress!["zipCode"] == ""
              ? Padding(
                  padding: EdgeInsets.only(bottom: heightDp * 10),
                  child: Text(
                    "Address specified is too generic. Please choose more accurate location",
                    style: TextStyle(fontSize: fontSp * 12, color: Colors.red),
                  ),
                )
              : SizedBox(),
          KeicyRaisedButton(
            width: widthDp * 200,
            height: heightDp * 40,
            color: _locationProvider!.lastDeliveryAddress == null ||
                    _locationProvider!.lastDeliveryAddress!.isEmpty ||
                    _locationProvider!.lastDeliveryAddress!["zipCode"] == ""
                ? Colors.grey.withOpacity(0.3)
                : config.Colors().mainColor(1),
            borderRadius: heightDp * 6,
            disabledColor: Colors.grey.withOpacity(0.3),
            child: Text(
              "Save",
              style: TextStyle(
                  fontSize: fontSp * 18,
                  color: _locationProvider!.lastDeliveryAddress == null ||
                          _locationProvider!.lastDeliveryAddress!.isEmpty ||
                          _locationProvider!.lastDeliveryAddress!["zipCode"] == ""
                      ? Colors.grey
                      : Colors.white),
            ),
            onPressed: _locationProvider!.lastDeliveryAddress == null ||
                    _locationProvider!.lastDeliveryAddress!.isEmpty ||
                    _locationProvider!.lastDeliveryAddress!["zipCode"] == ""
                ? null
                : _saveHandler,
          ),
          SizedBox(height: heightDp * 10),
        ],
      ),
    );
  }

  Widget _addressTypePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: widthDp * 15,
          runSpacing: heightDp * 10,
          children: List.generate(
            AppConfig.deliveryAddressType.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    addressType = AppConfig.deliveryAddressType[index];
                  });
                },
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(heightDp * 6),
                    side: addressType == AppConfig.deliveryAddressType[index]
                        ? BorderSide(width: 2, color: config.Colors().mainColor(1))
                        : BorderSide(width: 1, color: Colors.grey),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                    child: Text(
                      AppConfig.deliveryAddressType[index],
                      style: TextStyle(
                        fontSize: fontSp * 14,
                        color: addressType == AppConfig.deliveryAddressType[index] ? config.Colors().mainColor(1) : Colors.black,
                        fontWeight: addressType == AppConfig.deliveryAddressType[index] ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: heightDp * 15),
        addressType != "Others"
            ? SizedBox()
            : KeicyTextFormField(
                controller: _addressTypeController,
                focusNode: _addressTypeFocusNode,
                width: null,
                height: heightDp * 30,
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
                hintText: "Address Type",
                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6))),
                errorBorder: Border(bottom: BorderSide(color: Colors.red.withOpacity(0.6))),
                contentHorizontalPadding: widthDp * 10,
                prefixIcons: [Icon(Icons.location_city, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
                onFieldSubmittedHandler: (input) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                validatorHandler: (input) => addressType == "Others" && input.length < 1 ? "Should be a address type" : null,
              ),
        addressType != "Others" ? SizedBox() : SizedBox(height: heightDp * 15),
      ],
    );
  }

  void _deliveryMarkerHandler(CameraPosition position) {
    if (widget.orderModel != null) {
      double distance = Geolocator.distanceBetween(
        widget.orderModel!.storeModel!.location!.latitude,
        widget.orderModel!.storeModel!.location!.longitude,
        position.target.latitude,
        position.target.longitude,
      );
      if (distance < 1) {
        markers.remove(deliveryMarkerId);
        setState(() {});
        return;
      }
    }

    deliveryMarkerId = MarkerId("delivery_marker_id");
    Marker storeMarker = Marker(
      markerId: deliveryMarkerId!,
      position: LatLng(position.target.latitude, position.target.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      // infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        // _onMarkerDragEnd(markerId, position);
      },
    );
    markers[deliveryMarkerId!] = storeMarker;
    setState(() {});
    //////////////////////////////////////
  }

  Future<void> _deliveryAddressHandler({Map<String, dynamic>? address}) async {
    try {
      _locationProvider!.setlastDeliveryAddress(Map<String, dynamic>(), isNotifable: false);
      if (_locationProvider!.progressStatus == 1) return;
      if (markers[deliveryMarkerId] == null) return;
      if (address == null) {
        if (widget.orderModel != null) {
          double distance = Geolocator.distanceBetween(
            widget.orderModel!.storeModel!.location!.latitude,
            widget.orderModel!.storeModel!.location!.longitude,
            markers[deliveryMarkerId]!.position.latitude,
            markers[deliveryMarkerId]!.position.longitude,
          );
          if (distance < 1) {
            markers.remove(deliveryMarkerId);
            _locationProvider!.setProgressStatus(0);
            return;
          }

          if (distance > (_maxDeliveryDistance! * 1000)) {
            _locationProvider!.setStatusString("Your address is over the delivery zone of ${_maxDeliveryDistance} Kms");
            _locationProvider!.setProgressStatus(3);
            return;
          }
        }

        _locationProvider!.setProgressStatus(1);
        // _locationProvider!.setLastIdleLocation(markers[deliveryMarkerId]!.position);
        var result = await GoogleApiHelper.getAddressFromPosition(
          googleApiKey: Environment.googleApiKey,
          lat: markers[deliveryMarkerId]!.position.latitude,
          lng: markers[deliveryMarkerId]!.position.longitude,
          selectedPlacedId: _selectedPlaceId,
        );
        address = result;
      }

      if (address.isNotEmpty) {
        if (widget.orderModel != null) {
          double distance = Geolocator.distanceBetween(
            widget.orderModel!.storeModel!.location!.latitude,
            widget.orderModel!.storeModel!.location!.longitude,
            address["location"]["lat"],
            address["location"]["lng"],
          );
          if (distance > (_maxDeliveryDistance! * 1000)) {
            _locationProvider!.setStatusString("Your address is over the delivery zone of ${_maxDeliveryDistance} Kms", isNotifable: false);
            _locationProvider!.setProgressStatus(3);
          } else {
            _locationProvider!.setlastDeliveryAddress(address, isNotifable: false);
            _selectedPlaceId = "";
            _locationProvider!.setProgressStatus(2);
          }
        } else {
          _locationProvider!.setlastDeliveryAddress(address, isNotifable: false);
          _selectedPlaceId = "";
          _locationProvider!.setProgressStatus(2);
        }
      } else {
        _locationProvider!.setStatusString("Can't delivery address", isNotifable: false);
        _locationProvider!.setProgressStatus(4);
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "delivery_pckup_view",
        level: LogLevel.ERROR,
        subTag: "_deliveryAddressHandler",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  void _saveHandler() async {
    if (!_formKey.currentState!.validate()) return;

    Map<String, dynamic> _deliveryAddressData = json.decode(json.encode(widget.deliveryAddress ?? {}));
    _deliveryAddressData["userId"] = _authProvider!.authState.userModel!.id;
    _deliveryAddressData["address"] = _locationProvider!.lastDeliveryAddress;
    _deliveryAddressData["addressType"] = addressType != "Others" ? addressType : _addressTypeController.text.trim();
    _deliveryAddressData["building"] = _buildingController.text.trim();
    _deliveryAddressData["howToReach"] = _homeToReachController.text.trim();
    _deliveryAddressData["contactPhone"] = _contactPhoneController.text.trim();
    if (widget.orderModel != null) {
      double distance = Geolocator.distanceBetween(
        widget.orderModel!.storeModel!.location!.latitude,
        widget.orderModel!.storeModel!.location!.longitude,
        _locationProvider!.lastDeliveryAddress!["location"]["lat"],
        _locationProvider!.lastDeliveryAddress!["location"]["lng"],
      );
      _deliveryAddressData["distance"] = double.parse(distance.toStringAsFixed(3));
    }

    if (widget.forEdit!) {
      Navigator.of(context).pop(_deliveryAddressData);
    } else {
      await _keicyProgressDialog!.show();
      widget.orderModel!.deliveryPartnerDetails = Map<String, dynamic>();
      _deliveryAddressProvider!.addDeliveryAddressData(address: _deliveryAddressData);
    }
  }
}
