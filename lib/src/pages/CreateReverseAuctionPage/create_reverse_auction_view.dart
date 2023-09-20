import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
import 'package:trapp/src/elements/search_address_widget.dart';
import 'package:trapp/src/elements/service_item_for_selection_widget.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/google_api_helper.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/SearchCategoryPage/index.dart';
import 'package:trapp/src/pages/SearchLocationPage/Styles/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/elements/product_item_bottom_sheet.dart';
import 'package:trapp/environment.dart';

class CreateReverseAuctionView extends StatefulWidget {
  final bool haveAppBar;

  CreateReverseAuctionView({Key? key, this.haveAppBar = true}) : super(key: key);

  @override
  _CreateReverseAuctionViewState createState() => _CreateReverseAuctionViewState();
}

class _CreateReverseAuctionViewState extends State<CreateReverseAuctionView> {
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

  TextEditingController _quantityController = TextEditingController();
  TextEditingController _biddingPriceController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  FocusNode _quantityFocusNode = FocusNode();
  FocusNode _biddingPriceFocusNode = FocusNode();
  FocusNode _messageFocusNode = FocusNode();

  Map<String, dynamic> _reverseAuctionData = Map<String, dynamic>();
  Map<String, dynamic>? _locationData;
  List<dynamic>? _storeList;
  int? _distance;

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

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _reverseAuctionData = Map<String, dynamic>();

    _distance = AppConfig.distances[0]["value"];

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (CategoryProvider.of(context).categoryState.progressState != 2) {
        CategoryProvider.of(context).getCategoryAll();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _bidNowHandler() async {
    await _keicyProgressDialog!.show();
    _reverseAuctionData["userId"] = AuthProvider.of(context).authState.userModel!.id;
    _reverseAuctionData["status"] = AppConfig.reverseAuctionStatusData[1]["id"];
    _reverseAuctionData["isEnabled"] = true;
    _reverseAuctionData["storeBiddingPriceList"] = {};
    _reverseAuctionData["storeIds"] = [];
    for (var i = 0; i < _storeList!.length; i++) {
      _reverseAuctionData["storeIds"].add(_storeList![i]["_id"]);
    }

    if (_messageController.text.trim().isNotEmpty) {
      _reverseAuctionData["messages"] = [
        {
          "text": _messageController.text.trim(),
          "senderId": _reverseAuctionData["userId"],
          "date": DateTime.now().toUtc().toIso8601String(),
        }
      ];
    }

    List<String> storePhoneNumbers = [];
    for (var i = 0; i < _storeList!.length; i++) {
      storePhoneNumbers.add(_storeList![i]["mobile"]);
    }

    Map<String, dynamic> result = await ReverseAuctionProvider.of(context).addReverseAuctionData(
      reverseAuctionData: _reverseAuctionData,
      storePhoneNumbers: storePhoneNumbers,
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        callBack: () {
          Navigator.of(context).pop(true);
        },
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: _bidNowHandler,
      );
    }
  }

  void _getStoreList() async {
    if (_reverseAuctionData["categoryId"] == null || _locationData == null || _distance == null) return;

    Map<String, dynamic> tmp = Map<String, dynamic>();
    tmp["categoryId"] = _reverseAuctionData["categoryId"];
    tmp["categoryDesc"] = _reverseAuctionData["categoryDesc"];
    tmp["businessType"] = _reverseAuctionData["catgeorybusinessType"];

    _reverseAuctionData = tmp;

    await _keicyProgressDialog!.show();
    _storeList = null;
    var result = await StoreApiProvider.getStoreList(
      categoryId: _reverseAuctionData["categoryId"],
      location: _locationData!["location"],
      distance: _distance,
      isPaginated: false,
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      if (result["data"].length == 0) {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "We are striving hard to get to your area. We don’t have any stores in this location and radius currently. "
              "Please use another location or increase radius",
          isTryButton: false,
          callBack: () {},
        );
      } else {
        _storeList = result["data"];
      }
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {},
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _keicyProgressDialog = KeicyProgressDialog.of(context);
    return Scaffold(
      appBar: widget.haveAppBar
          ? AppBar(
              centerTitle: true,
              title: Text("Reverse Auction", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
              elevation: 0,
            )
          : null,
      body: Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
        if (categoryProvider.categoryState.progressState == 0 || categoryProvider.categoryState.progressState == 1) {
          return Center(child: CupertinoActivityIndicator());
        }

        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            child: Container(
              width: deviceWidth,
              // height: deviceHeight - statusbarHeight - appbarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                    child: Image.asset(
                      "img/ReverseAuction.png",
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(height: heightDp * 10),
                  _categoryPanel(),
                  Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
                  _locationPanel(),
                  (_storeList == null)
                      ? SizedBox(height: heightDp * 300)
                      : Column(
                          children: [
                            Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
                            _productPanel(),
                            _selectedItemPanel(),
                            Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
                            _biddingDatePanel(),
                            Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
                            _messagePanel(),
                            Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
                            _bidNowBtton(),
                            SizedBox(height: heightDp * 20),
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _categoryPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Category",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: heightDp * 10),
          GestureDetector(
            onTap: () async {
              var result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => SearchCategoryPage()),
              );

              if (result != null) {
                _reverseAuctionData = Map<String, dynamic>();
                _reverseAuctionData["categoryId"] = result["categoryId"];
                _reverseAuctionData["categoryDesc"] = result["categoryDesc"];
                _reverseAuctionData["businessType"] = result["catgeorybusinessType"];
                setState(() {});
                _getStoreList();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
              decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _reverseAuctionData["categoryDesc"] ?? "Please choose category",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: _reverseAuctionData["categoryDesc"] == null ? Colors.black.withOpacity(0.5) : Colors.black,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: heightDp * 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose location",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              KeicyDropDownFormField(
                width: widthDp * 120,
                height: heightDp * 35,
                menuItems: AppConfig.distances,
                value: _distance,
                border: Border.all(color: Colors.transparent),
                borderRadius: heightDp * 8,
                fillColor: Color(0xFFECECEC),
                contentHorizontalPadding: widthDp * 15,
                selectedItemStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                onChangeHandler: (value) {
                  _distance = value;
                  _getStoreList();
                },
              ),
            ],
          ),
          SizedBox(height: heightDp * 10),
          SearchAddressWidget(
            googleApiKey: Environment.googleApiKey,
            height: heightDp * 50,
            borderRadius: heightDp * 4,
            contentHorizontalPadding: widthDp * 15,
            fillColor: Color(0xFFECECEC),
            label: SearchLocationPageString.searchLabel,
            labelSpacing: heightDp * 5,
            hint: SearchLocationPageString.searchHint,
            labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Color(0xFFC0C0C2)),
            suggestTextStyle: TextStyle(fontSize: fontSp * 11, color: Colors.black, fontWeight: FontWeight.normal),
            prefixIcon: Icon(Icons.search, size: heightDp * 25, color: Color(0xFF9095A2)),
            suffixIcon: Icon(Icons.close, size: heightDp * 20, color: Colors.black),
            initValue: _locationData == null ? "" : _locationData!["name"] + ", " + _locationData!["address"],
            isEmpty: _locationData == null,
            initHandler: () {
              _locationData = null;
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
                  _locationData = result;
                });
                _getStoreList();
              }
            },
          ),
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
          Container(
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
                    _locationData = result;
                  });
                  _getStoreList();
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
          )
        ],
      ),
    );
  }

  Widget _productPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
            child: Text(
              "Which Product/Service Are You Looking For",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: heightDp * 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ((_reverseAuctionData["products"] == null || _reverseAuctionData["products"].isEmpty) &&
                        (_reverseAuctionData["services"] == null || _reverseAuctionData["services"].isEmpty))
                    ? "Please choose Product/Service"
                    : "Want to change Product/Service",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black.withOpacity(0.7)),
              ),
              KeicyRaisedButton(
                width: widthDp * 100,
                height: heightDp * 35,
                color: (_storeList == null) ? Color(0xFFECECEC) : config.Colors().mainColor(1),
                borderRadius: heightDp * 8,
                child: Text("Select", style: TextStyle(fontSize: fontSp * 16, color: (_storeList == null) ? Colors.black : Colors.white)),
                onPressed: (_storeList == null)
                    ? null
                    : () {
                        List<String> storeIds = [];

                        for (var i = 0; i < _storeList!.length; i++) {
                          storeIds.add(_storeList![i]["_id"]);
                        }

                        ProductItemBottomSheet.show(
                          context,
                          storeIds: storeIds,
                          callback: (String type, Map<String, dynamic> item) {
                            _reverseAuctionData["services"] = [];
                            _reverseAuctionData["products"] = [];
                            if (type == "products") {
                              _reverseAuctionData["products"].add({"orderQuantity": 1, "data": item});
                            } else if (type == "services") {
                              _reverseAuctionData["services"].add({"orderQuantity": 1, "data": item});
                            }
                            setState(() {});
                          },
                        );
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectedItemPanel() {
    if ((_reverseAuctionData["products"] == null || _reverseAuctionData["products"].isEmpty) &&
        (_reverseAuctionData["services"] == null || _reverseAuctionData["services"].isEmpty)) {
      return SizedBox();
    }

    String type = "";

    if (_reverseAuctionData["products"].isNotEmpty) {
      type = "products";
      _quantityController.text = _reverseAuctionData["products"][0]["orderQuantity"].toString();
    } else if (_reverseAuctionData["services"].isNotEmpty) {
      type = "services";
      _quantityController.text = _reverseAuctionData["services"][0]["orderQuantity"].toString();
    }

    double? price;
    String validateString = "";
    if (type == "products" && _reverseAuctionData["products"][0]["data"]["price"] != null) {
      price = double.parse(_reverseAuctionData["products"][0]["data"]["price"].toString());
    } else if (type == "services" && _reverseAuctionData["services"][0]["data"]["price"] != null) {
      price = double.parse(_reverseAuctionData["services"][0]["data"]["price"].toString());
    }

    if (price != null && _reverseAuctionData["biddingPrice"] != null && price < _reverseAuctionData["biddingPrice"]) {
      validateString = "Your bid price is more than the original price, please check and update your bid";
      _reverseAuctionData["biddingPrice"] = null;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        children: [
          if (_reverseAuctionData["products"].isNotEmpty)
            ProductItemForSelectionWidget(
              productModel: ProductModel.fromJson(_reverseAuctionData["products"][0]["data"]),
              isLoading: false,
            )
          else
            ServiceItemForSelectionWidget(
              serviceModel: ServiceModel.fromJson(_reverseAuctionData["services"][0]["data"]),
              isLoading: false,
            ),

          ///  Quantity
          SizedBox(height: heightDp * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quantity:",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                  SizedBox(height: heightDp * 5),
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Row(
                      children: [
                        KeicyTextFormField(
                          controller: _quantityController,
                          focusNode: _quantityFocusNode,
                          width: widthDp * 100,
                          height: heightDp * 35,
                          textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                          textAlign: TextAlign.center,
                          border: Border.all(color: Colors.transparent),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                          onChangeHandler: (input) {
                            if (input.isEmpty) return;
                            if (type == "products") {
                              _reverseAuctionData["products"][0]["orderQuantity"] = int.parse(input.trim());
                            } else if (type == "services") {
                              _reverseAuctionData["services"][0]["orderQuantity"] = int.parse(input.trim());
                            }
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                setState(() {
                                  if (type == "products") {
                                    _reverseAuctionData["products"][0]["orderQuantity"] = _reverseAuctionData["products"][0]["orderQuantity"] + 1;
                                    _quantityController.text = _reverseAuctionData["products"][0]["orderQuantity"].toString();
                                  } else if (type == "services") {
                                    _reverseAuctionData["services"][0]["orderQuantity"] = _reverseAuctionData["services"][0]["orderQuantity"] + 1;
                                    _quantityController.text = _reverseAuctionData["services"][0]["orderQuantity"].toString();
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 5, bottom: heightDp * 0),
                                color: Colors.transparent,
                                child: Transform.rotate(
                                  angle: pi / 2.0,
                                  child: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  if (type == "products") {
                                    if (_reverseAuctionData["products"][0]["orderQuantity"] == 1) return;
                                    _reverseAuctionData["products"][0]["orderQuantity"] = _reverseAuctionData["products"][0]["orderQuantity"] - 1;
                                    _quantityController.text = _reverseAuctionData["products"][0]["orderQuantity"].toString();
                                  } else if (type == "services") {
                                    if (_reverseAuctionData["services"][0]["orderQuantity"] == 1) return;
                                    _reverseAuctionData["products"][0]["orderQuantity"] = _reverseAuctionData["services"][0]["orderQuantity"] - 1;
                                    _quantityController.text = _reverseAuctionData["services"][0]["orderQuantity"].toString();
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 0, bottom: heightDp * 5),
                                color: Colors.transparent,
                                child: Transform.rotate(
                                  angle: -pi / 2.0,
                                  child: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Bid Price\nPer Quantity:",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                      Text(
                        "  *",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 5),
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Row(
                      children: [
                        KeicyTextFormField(
                          controller: _biddingPriceController,
                          focusNode: _biddingPriceFocusNode,
                          width: widthDp * 100,
                          height: heightDp * 35,
                          textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                          textAlign: TextAlign.center,
                          border: Border.all(color: Colors.transparent),
                          keyboardType: TextInputType.number,
                          onChangeHandler: (input) {
                            if (input.isEmpty) return;
                            _reverseAuctionData["biddingPrice"] = double.parse(input.trim());
                            setState(() {});
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                setState(() {
                                  _reverseAuctionData["biddingPrice"] = _reverseAuctionData["biddingPrice"] + 1;
                                  _biddingPriceController.text = _reverseAuctionData["biddingPrice"].toString();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 5, bottom: heightDp * 0),
                                color: Colors.transparent,
                                child: Transform.rotate(
                                  angle: pi / 2.0,
                                  child: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  if (_reverseAuctionData["biddingPrice"] - 1 < 0) return;
                                  _reverseAuctionData["biddingPrice"] = _reverseAuctionData["biddingPrice"] - 1;
                                  _biddingPriceController.text = _reverseAuctionData["biddingPrice"].toString();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 0, bottom: heightDp * 5),
                                color: Colors.transparent,
                                child: Transform.rotate(
                                  angle: -pi / 2.0,
                                  child: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: heightDp * 5),
          Container(
            child: Text(
              validateString,
              style: TextStyle(fontSize: fontSp * 14, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _biddingDatePanel() {
    if (_reverseAuctionData["biddingStartDateTime"] == null) {
      _reverseAuctionData["biddingStartDateTime"] = DateTime.now().toUtc().toIso8601String();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bidding Start Date:",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                  SizedBox(height: heightDp * 5),
                  GestureDetector(
                    onTap: () {
                      // _selectPickupDateTimeHandler("biddingStart");
                    },
                    child: Container(
                      width: widthDp * 180,
                      height: heightDp * 50,
                      decoration: BoxDecoration(border: Border.all()),
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _reverseAuctionData["biddingStartDateTime"] == null
                                ? "Choose Date"
                                : KeicyDateTime.convertDateTimeToDateString(
                                    dateTime: DateTime.tryParse(_reverseAuctionData["biddingStartDateTime"]),
                                    formats: "Y-m-d H:i",
                                    isUTC: false,
                                  ),
                            style: TextStyle(
                              fontSize: fontSp * 16,
                              color: Colors.black.withOpacity(_reverseAuctionData["biddingStartDateTime"] == null ? 0.4 : 1),
                            ),
                          ),
                          // Icon(Icons.arrow_forward_ios, size: heightDp * 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Bidding End Date:",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                      Text(
                        "  *",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 5),
                  GestureDetector(
                    onTap: () {
                      _selectPickupDateTimeHandler("biddingEnd");
                    },
                    child: Container(
                      width: widthDp * 180,
                      height: heightDp * 50,
                      decoration: BoxDecoration(border: Border.all()),
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _reverseAuctionData["biddingEndDateTime"] == null
                                ? "Choose Date"
                                : KeicyDateTime.convertDateTimeToDateString(
                                    dateTime: DateTime.tryParse(_reverseAuctionData["biddingEndDateTime"]),
                                    formats: "Y-m-d H:i",
                                    isUTC: false,
                                  ),
                            style: TextStyle(
                              fontSize: fontSp * 16,
                              color: Colors.black.withOpacity(_reverseAuctionData["biddingEndDateTime"] == null ? 0.4 : 1),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: heightDp * 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectPickupDateTimeHandler(String type) async {
    DateTime? selecteDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
      selectableDayPredicate: (date) {
        if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
        if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
        return true;
      },
    );
    if (selecteDate == null) return;

    TimeOfDay? time = await showCustomTimePicker(
      context: context,
      onFailValidation: (context) => FlutterLogs.logWarn(
        "create_reverse_auction_view",
        "_selectPickupDateTimeHandler",
        {
          "message": "Unavailable selection",
        }.toString(),
      ),
      initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    );

    if (time == null) return;
    selecteDate = selecteDate.add(Duration(hours: time.hour, minutes: time.minute));
    setState(() {
      if (!selecteDate!.isUtc) selecteDate = selecteDate!.toUtc();

      if (type == "biddingStart") {
        _reverseAuctionData["biddingStartDateTime"] = selecteDate!.toUtc().toIso8601String();
      } else if (type == "biddingEnd") {
        _reverseAuctionData["biddingEndDateTime"] = selecteDate!.toUtc().toIso8601String();
      }
    });
  }

  Widget _messagePanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Message", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
          SizedBox(height: heightDp * 10),
          KeicyTextFormField(
            controller: _messageController,
            focusNode: _messageFocusNode,
            width: double.infinity,
            height: heightDp * 60,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            borderRadius: heightDp * 8,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: null,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            validatorHandler: (input) => input.isEmpty ? "Please enter message" : null,
            onChangeHandler: (input) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _bidNowBtton() {
    bool isEnable = true;
    if (_storeList == null) isEnable = false;
    if ((_reverseAuctionData["products"] == null || _reverseAuctionData["products"].isEmpty) &&
        (_reverseAuctionData["services"] == null || _reverseAuctionData["services"].isEmpty)) {
      isEnable = false;
    }

    if (_reverseAuctionData["biddingPrice"] == null) isEnable = false;
    if (_reverseAuctionData["biddingEndDateTime"] == null) isEnable = false;

    if (_messageController.text.isEmpty) isEnable = false;

    return Center(
      child: KeicyRaisedButton(
        width: widthDp * 150,
        height: heightDp * 35,
        color: isEnable ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
        borderRadius: heightDp * 6,
        child: Text(
          "Bid Now",
          style: TextStyle(
            fontSize: fontSp * 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: !isEnable ? null : _bidNowHandler,
      ),
    );
  }
}
