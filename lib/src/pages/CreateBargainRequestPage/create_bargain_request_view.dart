import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
import 'package:trapp/src/elements/service_item_for_selection_widget.dart';
import 'package:trapp/src/elements/product_item_bottom_sheet.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/OrderAssistantPage/index.dart';
import 'package:trapp/src/pages/SearchPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class CreateBargainRequestView extends StatefulWidget {
  final Map<String, dynamic> storeData;
  final bool haveAppBar;

  CreateBargainRequestView({
    Key? key,
    this.haveAppBar = true,
    this.storeData = const {},
  }) : super(key: key);

  @override
  _CreateBargainRequestViewState createState() => _CreateBargainRequestViewState();
}

class _CreateBargainRequestViewState extends State<CreateBargainRequestView> {
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

  CategoryProvider? _categoryProvider;
  AppDataProvider? _appDataProvider;
  BargainRequestProvider? _bargainRequestProvider;

  KeicyProgressDialog? _keicyProgressDialog;

  Map<String, dynamic> _bargainRequestData = Map<String, dynamic>();

  TextEditingController _offerPriceController = TextEditingController();
  FocusNode _offerPriceFocusNode = FocusNode();

  TextEditingController _messageController = TextEditingController();
  FocusNode _messageFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _isValidated = false;

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  double bargainOfferPricePercent = 0;

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

    _categoryProvider = CategoryProvider.of(context);
    _appDataProvider = AppDataProvider.of(context);
    _bargainRequestProvider = BargainRequestProvider.of(context);

    _bargainRequestData = Map<String, dynamic>();
    if (widget.storeData.isNotEmpty) {
      _bargainRequestData["categoryId"] = widget.storeData["subType"];
      _bargainRequestData["businessType"] = widget.storeData["businessType"];
      _bargainRequestData["storeId"] = widget.storeData["_id"];
      _bargainRequestData["storeData"] = widget.storeData;
      _bargainRequestData["products"] = [];
      _bargainRequestData["services"] = [];
      _bargainRequestData["isBulkOrder"] = false;

      if (widget.storeData["settings"] == null) {
        widget.storeData["settings"] = AppConfig.initialSettings;
      }

      if (widget.storeData["settings"]["bargainOfferPricePercent"] == null) {
        widget.storeData["settings"]["bargainOfferPricePercent"] = AppConfig.initialSettings["bargainOfferPricePercent"];
      }

      if (widget.storeData["settings"]["bargainOfferPrice"] != null && widget.storeData["settings"]["bargainOfferPricePercent"] == null) {
        widget.storeData["settings"]["bargainOfferPricePercent"] = widget.storeData["settings"]["bargainOfferPrice"].toDouble();
      }

      bargainOfferPricePercent = widget.storeData["settings"]["bargainOfferPricePercent"].toDouble();
    }

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _bargainRequestProvider!.addListener(_bargainRequestProviderListener);
      if (_categoryProvider!.categoryState.progressState != 2) {
        _categoryProvider!.getCategoryAll();
      }
    });
  }

  @override
  void dispose() {
    _bargainRequestProvider!.removeListener(_bargainRequestProviderListener);

    super.dispose();
  }

  void _bargainRequestProviderListener() async {
    if (_bargainRequestProvider!.bargainRequestState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_bargainRequestProvider!.bargainRequestState.progressState == 2) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        callBack: () {
          Navigator.of(context).pop(true);
        },
      );
    } else if (_bargainRequestProvider!.bargainRequestState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _bargainRequestProvider!.bargainRequestState.message!,
        callBack: _requestOrerHandler,
      );
    }
  }

  void _requestOrerHandler() async {
    if (!_formkey.currentState!.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());

    _bargainRequestProvider!.setBargainRequestState(_bargainRequestProvider!.bargainRequestState.update(progressState: 1), isNotifiable: false);

    await _keicyProgressDialog!.show();
    _bargainRequestData["userId"] = AuthProvider.of(context).authState.userModel!.id;
    _bargainRequestData["status"] = AppConfig.bargainRequestStatusData[1]["id"];
    _bargainRequestData["subStatus"] = AppConfig.bargainSubStatusData[0]["id"];
    _bargainRequestData["isEnabled"] = true;
    _bargainRequestData["userOfferPriceList"] = [_bargainRequestData["offerPrice"]];
    _bargainRequestData["storeOfferPriceList"] = [];
    if (_messageController.text.trim().isNotEmpty) {
      _bargainRequestData["messages"] = [
        {
          "text": _messageController.text.trim(),
          "senderId": _bargainRequestData["userId"],
          "date": DateTime.now().toUtc().toIso8601String(),
        }
      ];
    }

    double initialPrice = 0;

    if (_bargainRequestData["products"].isNotEmpty && _bargainRequestData["products"][0]["data"]["price"] != null) {
      initialPrice = double.parse(_bargainRequestData["products"][0]["data"]["price"].toString()) -
          (_bargainRequestData["products"][0]["data"]["discount"] != null
              ? double.parse(_bargainRequestData["products"][0]["data"]["discount"].toString())
              : 0);
    }

    if (_bargainRequestData["services"].isNotEmpty && _bargainRequestData["services"][0]["data"]["price"] != null) {
      initialPrice = double.parse(_bargainRequestData["services"][0]["data"]["price"].toString()) -
          (_bargainRequestData["services"][0]["data"]["discount"] != null
              ? double.parse(_bargainRequestData["services"][0]["data"]["discount"].toString())
              : 0);
    }
    _bargainRequestData["history"] = [
      {
        "title": AppConfig.bargainHistoryData[AppConfig.bargainRequestStatusData[1]["id"]]["title"],
        "text": AppConfig.bargainHistoryData[AppConfig.bargainRequestStatusData[1]["id"]]["text"],
        "bargainType": AppConfig.bargainRequestStatusData[1]["id"],
        "date": DateTime.now().toUtc().toIso8601String(),
        "initialPrice": initialPrice,
        "offerPrice": _bargainRequestData["offerPrice"],
      }
    ];

    _bargainRequestProvider!.addBargainRequestData(bargainRequestData: _bargainRequestData);
  }

  @override
  Widget build(BuildContext context) {
    _keicyProgressDialog = KeicyProgressDialog.of(context);
    return Scaffold(
      appBar: widget.haveAppBar
          ? AppBar(
              centerTitle: true,
              title: Text("Bargain Request", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
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
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                      child: Image.asset(
                        "img/BargainRequest.png",
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(height: heightDp * 10),
                    _categoryPanel(),
                    Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
                    _storePanel(),
                    Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
                    _chooseItemPanel(),
                    _productsPanel(),
                    Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
                    _messagePanel(),
                    Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
                      child: Center(
                        child: KeicyRaisedButton(
                          width: widthDp * 180,
                          height: heightDp * 40,
                          color: _bargainRequestData["bargainDateTime"] != null && _isValidated
                              ? config.Colors().mainColor(1)
                              : Colors.grey.withOpacity(0.6),
                          borderRadius: heightDp * 8,
                          child: Text(
                            "Request Bargain",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                          ),
                          onPressed: _bargainRequestData["bargainDateTime"] == null || !_isValidated ? null : _requestOrerHandler,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _categoryPanel() {
    List<dynamic> _categories;

    String categoryDesc = "";
    _categories = _bargainRequestData["businessType"] == "store"
        ? _categoryProvider!.categoryState.categoryData!["store"]
        : _categoryProvider!.categoryState.categoryData!["services"];

    for (var i = 0; i < _categories.length; i++) {
      if (_categories[i]["categoryId"] == _bargainRequestData["categoryId"]) {
        categoryDesc = _categories[i]["categoryDesc"];
        break;
      }
    }

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
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.zero,
                    titlePadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    elevation: 0,
                    children: [
                      CategoryBottomSheet(
                        categoryId: _bargainRequestData["categoryId"],
                        callback: (categoryId, businessType) {
                          if (_bargainRequestData["categoryId"] != categoryId) {
                            setState(() {
                              _bargainRequestData = Map<String, dynamic>();
                              _bargainRequestData["categoryId"] = categoryId;
                              _bargainRequestData["businessType"] = businessType;
                            });
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
              decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _bargainRequestData["categoryId"] == null ? "Please choose category" : categoryDesc,
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: _bargainRequestData["categoryId"] == null ? Colors.black.withOpacity(0.5) : Colors.black,
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

  Widget _storePanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Store/Pickup Address",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: heightDp * 10),
          GestureDetector(
            onTap: () async {
              if (_bargainRequestData["categoryId"] == null) return;
              Map<String, dynamic> categoryData = Map<String, dynamic>();
              for (var i = 0; i < _appDataProvider!.appDataState.categoryList!.length; i++) {
                if (_appDataProvider!.appDataState.categoryList![i]["categoryId"] == _bargainRequestData["categoryId"]) {
                  categoryData = _appDataProvider!.appDataState.categoryList![i];
                }
              }
              var result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchPage(
                    categoryData: categoryData,
                    forSelection: true,
                    onlyStore: true,
                  ),
                ),
              );

              if (result != null) {
                if (_bargainRequestData["storeData"] != null && _bargainRequestData["storeData"]["_id"] == result["_id"]) return;

                _bargainRequestData = Map<String, dynamic>();
                _bargainRequestData["categoryId"] = result["subType"];
                _bargainRequestData["businessType"] = result["businessType"];
                _bargainRequestData["storeId"] = result["_id"];
                _bargainRequestData["storeData"] = result;
                _bargainRequestData["products"] = [];
                _bargainRequestData["services"] = [];
                _bargainRequestData["isBulkOrder"] = false;

                if (result["settings"] == null) {
                  result["settings"] = AppConfig.initialSettings;
                }

                if (result["settings"]["bargainOfferPricePercent"] == null) {
                  result["settings"]["bargainOfferPricePercent"] = AppConfig.initialSettings["bargainOfferPricePercent"];
                }

                if (result["settings"]["bargainOfferPrice"] != null && result["settings"]["bargainOfferPricePercent"] == null) {
                  result["settings"]["bargainOfferPricePercent"] = result["settings"]["bargainOfferPrice"].toDouble();
                }

                bargainOfferPricePercent = double.parse(result["settings"]["bargainOfferPricePercent"].toString());

                _offerPriceController.clear();
                _messageController.clear();
                setState(() {});
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
              decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _bargainRequestData["storeData"] == null ? "Please choose store" : _bargainRequestData["storeData"]["name"],
                      style: TextStyle(
                        fontSize: fontSp * 14,
                        color: _bargainRequestData["storeData"] == null ? Colors.black.withOpacity(0.5) : Colors.black,
                      ),
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

  Widget _chooseItemPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ((_bargainRequestData["products"] == null || _bargainRequestData["products"].isEmpty) &&
                        (_bargainRequestData["services"] == null || _bargainRequestData["services"].isEmpty))
                    ? "Please choose Product/Service"
                    : "Want to change Product/Service",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black.withOpacity(0.7)),
              ),
              SizedBox(width: widthDp * 10),
              KeicyRaisedButton(
                width: widthDp * 100,
                height: heightDp * 40,
                color: _bargainRequestData["storeId"] != null ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                borderRadius: heightDp * 6,
                child: Text(
                  "Choose",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                ),
                onPressed: _bargainRequestData["storeId"] == null
                    ? null
                    : () {
                        ProductItemBottomSheet.show(
                          context,
                          storeIds: [_bargainRequestData["storeData"]["_id"]],
                          bargainAvailable: true,
                          callback: (String type, Map<String, dynamic> item) {
                            _bargainRequestData["services"] = [];
                            _bargainRequestData["products"] = [];
                            if (type == "products") {
                              _bargainRequestData["products"].add({"orderQuantity": 1, "data": item});
                            } else if (type == "services") {
                              _bargainRequestData["services"].add({"orderQuantity": 1, "data": item});
                            }
                            setState(() {});
                          },
                        );
                      },
              ),
            ],
          ),
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }

  Widget _productsPanel() {
    if ((_bargainRequestData["products"] == null || _bargainRequestData["products"].isEmpty) &&
        (_bargainRequestData["services"] == null || _bargainRequestData["services"].isEmpty)) {
      return SizedBox();
    }

    String type = "";
    double? price;
    double? offerPrice;

    if (_bargainRequestData["products"].isNotEmpty && _bargainRequestData["products"][0]["data"]["price"] != null) {
      type = "products";
      price = double.parse(_bargainRequestData["products"][0]["data"]["price"].toString()) -
          (_bargainRequestData["products"][0]["data"]["discount"] == null
              ? 0
              : double.parse(_bargainRequestData["products"][0]["data"]["discount"].toString()));
    } else if (_bargainRequestData["services"].isNotEmpty && _bargainRequestData["services"][0]["data"]["price"] != null) {
      type = "services";
      price = double.parse(_bargainRequestData["services"][0]["data"]["price"].toString()) -
          (_bargainRequestData["services"][0]["data"]["discount"] == null
              ? 0
              : double.parse(_bargainRequestData["services"][0]["data"]["discount"].toString()));
    }

    if (_bargainRequestData["offerPrice"] != null) {
      offerPrice = _bargainRequestData["offerPrice"];
    }

    return Column(
      children: [
        if (_bargainRequestData["products"].isNotEmpty)
          ProductItemForSelectionWidget(
            productModel: ProductModel.fromJson(_bargainRequestData["products"][0]["data"]),
            isLoading: false,
          )
        else
          ServiceItemForSelectionWidget(
            serviceModel: ServiceModel.fromJson(_bargainRequestData["services"][0]["data"]),
            isLoading: false,
          ),

        ///
        SizedBox(height: heightDp * 20),
        _bulkOrderWidget(),
        SizedBox(height: heightDp * 20),
        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
        SizedBox(height: heightDp * 30),

        ///
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
          child: Column(
            children: [
              Text(
                "Price Too High?",
                style: TextStyle(fontSize: fontSp * 30, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: heightDp * 10),
              Text(
                "How much are you willing to pay for this product",
                style: TextStyle(fontSize: fontSp * 17, color: Colors.black, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heightDp * 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
                child: Column(
                  children: [
                    ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₹", style: TextStyle(fontSize: fontSp * 30, color: Colors.black, fontWeight: FontWeight.bold)),
                        SizedBox(width: widthDp * 20),
                        Expanded(
                          child: TextFormField(
                            controller: _offerPriceController,
                            focusNode: _offerPriceFocusNode,
                            style: TextStyle(fontSize: fontSp * 50, color: Colors.black, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            autovalidateMode: AutovalidateMode.always,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: fontSp * 10, color: Colors.red),
                            ),
                            onChanged: (input) {
                              try {
                                _bargainRequestData["offerPrice"] = double.parse(input.trim());
                                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                                  setState(() {});
                                });
                              } catch (e) {
                                FlutterLogs.logThis(
                                  tag: "create_bargain_request_view",
                                  level: LogLevel.ERROR,
                                  subTag: "_productsPanel",
                                  exception: e is Exception ? e : null,
                                  error: e is Error ? e : null,
                                  errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
                                );
                              }
                            },
                            validator: (input) {
                              if (input!.isEmpty) {
                                _isValidated = false;
                                return "";
                              }
                              try {
                                if (price == null) {
                                  _isValidated = true;
                                  return null;
                                }
                                if (double.parse(input) >= price) {
                                  _isValidated = false;
                                  return "Please enter less value than item price";
                                } else {
                                  double bargainOfferPrice = bargainOfferPricePercent * price / 100;
                                  if (bargainOfferPrice > double.parse(input)) {
                                    _isValidated = false;
                                    return "Please enter bigger value than ${bargainOfferPrice.toStringAsFixed(2)}";
                                  } else {
                                    _isValidated = true;
                                    return null;
                                  }
                                }
                              } catch (e) {
                                _isValidated = false;
                                return "Invalid price value";
                              }
                            },
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                setState(() {
                                  _bargainRequestData["offerPrice"] = _bargainRequestData["offerPrice"] + 1;
                                  _offerPriceController.text = _bargainRequestData["offerPrice"].toString();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 10, bottom: heightDp * 0),
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
                                if (_bargainRequestData["offerPrice"] - 1 < 0) return;
                                setState(() {
                                  _bargainRequestData["offerPrice"] = _bargainRequestData["offerPrice"] - 1;
                                  _offerPriceController.text = _bargainRequestData["offerPrice"].toString();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 0, bottom: heightDp * 10),
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

                    ///
                    SizedBox(height: heightDp * 20),
                    Text(
                      "Possibility of Success (90%)",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                    ),

                    SizedBox(height: heightDp * 10),
                    Container(
                      width: double.infinity,
                      height: heightDp * 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(heightDp * 3),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 90,
                            child: Container(
                              width: double.infinity,
                              height: heightDp * 5,
                              decoration: BoxDecoration(
                                color: config.Colors().mainColor(1),
                                borderRadius: BorderRadius.circular(heightDp * 3),
                              ),
                            ),
                          ),
                          Expanded(flex: 100 - 90, child: SizedBox()),
                        ],
                      ),
                    ),

                    SizedBox(height: heightDp * 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Original Price",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              price == null
                                  ? Text(
                                      "₹",
                                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      "₹ ${numFormat.format(price)}",
                                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                            ],
                          ),
                        ),
                        Container(width: 2, height: heightDp * 40, color: Colors.black.withOpacity(0.2)),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Reduction",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              price == null || offerPrice == null || price < offerPrice
                                  ? Text(
                                      "₹",
                                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      "₹ ${numFormat.format(price - offerPrice)}\n(${numFormat.format(((price - offerPrice) / price * 100))}%)",
                                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        ///
        SizedBox(height: heightDp * 20),
        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
        SizedBox(height: heightDp * 20),
        _bargainDateTime(),
        SizedBox(height: heightDp * 20),
      ],
    );
  }

  Widget _bulkOrderWidget() {
    String type = "";
    if (_bargainRequestData["products"].isNotEmpty) {
      type = "products";
    } else if (_bargainRequestData["services"].isNotEmpty) {
      type = "services";
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KeicyCheckBox(
            iconSize: heightDp * 20,
            trueIconColor: config.Colors().mainColor(1),
            falseIconColor: Colors.grey.withOpacity(0.8),
            value: _bargainRequestData["isBulkOrder"],
            label: "Bulk Order",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            onChangeHandler: (value) {
              setState(() {
                _bargainRequestData["isBulkOrder"] = value;
                if (_bargainRequestData["products"].isNotEmpty) {
                  _bargainRequestData["products"][0]["orderQuantity"] = 1;
                }
                if (_bargainRequestData["services"].isNotEmpty) {
                  _bargainRequestData["services"][0]["orderQuantity"] = 1;
                }
              });
            },
          ),
          SizedBox(width: widthDp * 10),
          Container(
            width: widthDp * 100,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (!_bargainRequestData["isBulkOrder"]) return;
                    if ((_bargainRequestData["products"].isNotEmpty && _bargainRequestData["products"][0]["orderQuantity"] == 1) ||
                        (_bargainRequestData["services"].isNotEmpty && _bargainRequestData["services"][0]["orderQuantity"] == 1)) {
                      return;
                    }

                    if (_bargainRequestData["products"].isNotEmpty) {
                      _bargainRequestData["products"][0]["orderQuantity"] = _bargainRequestData["products"][0]["orderQuantity"] - 1;
                    }
                    if (_bargainRequestData["services"].isNotEmpty) {
                      _bargainRequestData["services"][0]["orderQuantity"] = _bargainRequestData["services"][0]["orderQuantity"] - 1;
                    }

                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        SizedBox(width: widthDp * 10),
                        Icon(Icons.remove,
                            color: (!_bargainRequestData["isBulkOrder"] ||
                                    (_bargainRequestData["products"].isNotEmpty && _bargainRequestData["products"][0]["orderQuantity"] == 1) ||
                                    (_bargainRequestData["services"].isNotEmpty && _bargainRequestData["services"][0]["orderQuantity"] == 1))
                                ? Colors.grey
                                : Color(0xFF17D18F),
                            size: heightDp * 20),
                        SizedBox(width: widthDp * 5),
                      ],
                    ),
                  ),
                ),
                Text(
                  type == "products"
                      ? "${_bargainRequestData["products"][0]["orderQuantity"]}"
                      : "${_bargainRequestData["services"][0]["orderQuantity"]}",
                  style: TextStyle(fontSize: fontSp * 16, color: Color(0xFF17D18F), fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () async {
                    if (!_bargainRequestData["isBulkOrder"]) return;
                    if (_bargainRequestData["products"].isNotEmpty) {
                      _bargainRequestData["products"][0]["orderQuantity"] = _bargainRequestData["products"][0]["orderQuantity"] + 1;
                    }
                    if (_bargainRequestData["services"].isNotEmpty) {
                      _bargainRequestData["services"][0]["orderQuantity"] = _bargainRequestData["services"][0]["orderQuantity"] + 1;
                    }

                    setState(() {});
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                    child: Row(
                      children: [
                        SizedBox(width: widthDp * 5),
                        Icon(Icons.add, color: !_bargainRequestData["isBulkOrder"] ? Colors.grey : Color(0xFF17D18F), size: heightDp * 20),
                        SizedBox(width: widthDp * 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bargainDateTime() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: Column(
        children: [
          Text(
            "By when you need this product/service",
            style: TextStyle(fontSize: fontSp * 17, color: Colors.black, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: heightDp * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _bargainRequestData["bargainDateTime"] == null
                    ? "Please choose Bargain DateTime"
                    : "${KeicyDateTime.convertDateTimeToDateString(
                        dateTime: DateTime.tryParse(_bargainRequestData['bargainDateTime']),
                        formats: 'Y-m-d h:i A',
                        isUTC: false,
                      )}",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
              KeicyRaisedButton(
                width: widthDp * 90,
                height: heightDp * 30,
                color: config.Colors().mainColor(1),
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                child: Text(
                  "Choose",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: _selectPickupDateTimeHandler,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectPickupDateTimeHandler() async {
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
        "create_bargain_request_view",
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
      _bargainRequestData["bargainDateTime"] = selecteDate!.toUtc().toIso8601String();
    });
  }

  Widget _messagePanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
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
          ),
        ],
      ),
    );
  }
}
