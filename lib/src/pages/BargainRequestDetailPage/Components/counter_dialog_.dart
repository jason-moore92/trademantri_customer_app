import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/index.dart';

class CounterDialog {
  static show(
    BuildContext context, {
    @required Map<String, dynamic>? bargainRequestData,
    @required Map<String, dynamic>? storeData,
    @required double? widthDp,
    @required double? heightDp,
    @required double? fontSp,
    EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    double? borderRadius,
    Color? barrierColor,
    text = "Something went wrong",
    bool barrierDismissible = false,
    @required Function(Map<String, dynamic>)? callBack,
    Function? cancelCallback,
    int delaySecondes = 2,
    bool isTryButton = true,
  }) async {
    TextEditingController _controller = TextEditingController();
    FocusNode _focusNode = FocusNode();

    double? originPrice = 0;

    if (bargainRequestData!["products"].isNotEmpty && bargainRequestData["products"][0]["data"]["price"] != null) {
      originPrice = double.parse(bargainRequestData["products"][0]["data"]["price"].toString()) -
          (bargainRequestData["products"][0]["data"]["discount"] != null
              ? double.parse(bargainRequestData["products"][0]["data"]["discount"].toString())
              : 0);
    } else if (bargainRequestData["services"].isNotEmpty && bargainRequestData["services"][0]["data"]["price"] != null) {
      originPrice = double.parse(bargainRequestData["services"][0]["data"]["price"].toString()) -
          (bargainRequestData["services"][0]["data"]["discount"] != null
              ? double.parse(bargainRequestData["services"][0]["data"]["discount"].toString())
              : 0);
    }

    bool _isValidated = false;

    if (storeData!["settings"] == null) {
      storeData["settings"] = AppConfig.initialSettings;
    }

    if (storeData["settings"]["bargainOfferPricePercent"] == null) {
      storeData["settings"]["bargainOfferPricePercent"] = AppConfig.initialSettings["bargainOfferPricePercent"];
    }

    if (storeData["settings"]["bargainOfferPrice"] != null && storeData["settings"]["bargainOfferPricePercent"] == null) {
      storeData["settings"]["bargainOfferPricePercent"] = storeData["settings"]["bargainOfferPrice"].toDouble();
    }
    double bargainOfferPricePercent = storeData["settings"]["bargainOfferPricePercent"].toDouble();

    var result = await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      // barrierColor: barrierColor,
      builder: (BuildContext context1) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => RefreshProvider()),
          ],
          child: Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
            return SimpleDialog(
              elevation: 0.0,
              backgroundColor: Colors.white,
              insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 10)),
              titlePadding: titlePadding ?? EdgeInsets.zero,
              contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: widthDp! * 20, vertical: heightDp * 20),
              children: [
                Center(
                  child: Text(
                    "Price Too High",
                    style: TextStyle(fontSize: fontSp! * 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: heightDp * 10),
                Center(
                  child: Text(
                    "Would you like to Counter to Store offer",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),

                ///
                SizedBox(height: heightDp * 20),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(left: widthDp! * 10, right: widthDp * 10, top: heightDp * 15, bottom: heightDp * 0),
                              color: Colors.transparent,
                              child: Transform.rotate(
                                angle: pi / 2.0,
                                child: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.transparent),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 0, bottom: heightDp * 15),
                              color: Colors.transparent,
                              child: Transform.rotate(
                                angle: -pi / 2.0,
                                child: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.transparent),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: _controller,
                                focusNode: _focusNode,
                                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(heightDp * 6),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(heightDp * 6),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(heightDp * 6),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(heightDp * 6),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(heightDp * 6),
                                  ),
                                  errorStyle: TextStyle(fontSize: fontSp * 10, color: Colors.red),
                                  errorMaxLines: 2,
                                  contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                autovalidateMode: AutovalidateMode.always,
                                onChanged: (input) {
                                  try {
                                    bargainRequestData["offerPrice"] = double.parse(input.trim());

                                    if (input.isEmpty) {
                                      _isValidated = false;
                                    }
                                    try {
                                      if (originPrice == null) {
                                        _isValidated = true;
                                      }
                                      if (double.parse(input) >= originPrice!) {
                                        _isValidated = false;
                                      } else {
                                        double bargainOfferPrice = bargainOfferPricePercent * originPrice / 100;
                                        if (bargainOfferPrice > double.parse(input)) {
                                          _isValidated = false;
                                        } else {
                                          _isValidated = true;
                                        }
                                      }
                                    } catch (e) {
                                      _isValidated = false;
                                    }
                                  } catch (e) {
                                    FlutterLogs.logThis(
                                      tag: "counter_dialog_",
                                      level: LogLevel.ERROR,
                                      subTag: "show",
                                      exception: e is Exception ? e : null,
                                      error: e is Error ? e : null,
                                      errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
                                    );
                                  }
                                  refreshProvider.refresh();
                                },
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    _isValidated = false;
                                    return "";
                                  }
                                  try {
                                    if (originPrice == null) {
                                      _isValidated = true;
                                      return null;
                                    }
                                    if (double.parse(input) >= originPrice) {
                                      _isValidated = false;
                                      return "Please enter less value than orign price $originPrice";
                                    } else {
                                      double bargainOfferPrice = bargainOfferPricePercent * originPrice / 100;
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
                          ],
                        ),
                      ),
                      // KeicyTextFormField(
                      //   controller: _controller,
                      //   focusNode: _focusNode,
                      //   width: widthDp * 150,
                      //   height: heightDp * 50,
                      //   border: Border.all(color: Colors.black),
                      //   errorBorder: Border.all(color: Colors.red),
                      //   errorStringFontSize: fontSp * 10,
                      //   textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                      //   keyboardType: TextInputType.number,
                      //   textAlign: TextAlign.center,
                      //   autovalidateMode: AutovalidateMode.always,
                      //   onChangeHandler: (input) {

                      //   },
                      //   validatorHandler: (input) {

                      //   },
                      // ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _controller.text = (double.parse(_controller.text) + 1).toString();
                              refreshProvider.refresh();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 15, bottom: heightDp * 0),
                              decoration: BoxDecoration(color: Colors.transparent),
                              child: Transform.rotate(
                                angle: pi / 2.0,
                                child: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _controller.text = (double.parse(_controller.text) - 1).toString();
                              refreshProvider.refresh();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 0, bottom: heightDp * 15),
                              decoration: BoxDecoration(color: Colors.transparent),
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

                ///
                SizedBox(height: heightDp * 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("Originial Price", style: TextStyle(fontSize: fontSp * 14, color: Colors.black)),
                        SizedBox(height: heightDp * 5),
                        Text(
                          originPrice == null ? "" : "₹ ${originPrice}",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Redution Price", style: TextStyle(fontSize: fontSp * 14, color: Colors.black)),
                        SizedBox(height: heightDp * 5),
                        Text(
                          originPrice == null ? "" : "₹ ${originPrice - (_controller.text.isNotEmpty ? double.parse(_controller.text) : 0)}",
                          // "₹ ${price - double.parse(bargainRequestData["offerPrice"].toString())}",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: heightDp * 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("User Offer Price", style: TextStyle(fontSize: fontSp * 14, color: Colors.black)),
                        SizedBox(height: heightDp * 5),
                        Text(
                          bargainRequestData["userOfferPriceList"].isNotEmpty ? "₹ ${bargainRequestData["userOfferPriceList"].last}" : "",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Store Offer Price", style: TextStyle(fontSize: fontSp * 14, color: Colors.black)),
                        SizedBox(height: heightDp * 5),
                        Text(
                          bargainRequestData["storeOfferPriceList"].isNotEmpty ? "₹ ${bargainRequestData["storeOfferPriceList"].last}" : "",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: heightDp * 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    KeicyRaisedButton(
                      width: widthDp * 120,
                      height: heightDp * 40,
                      color: _isValidated ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                      child: Text(
                        "Counter",
                        style: TextStyle(fontSize: fontSp * 16, color: _isValidated ? Colors.white : Colors.black),
                      ),
                      onPressed: !_isValidated
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              if (callBack != null) {
                                callBack(bargainRequestData);
                              }
                            },
                    ),
                    KeicyRaisedButton(
                      width: widthDp * 120,
                      height: heightDp * 40,
                      color: Colors.grey.withOpacity(0.6),
                      child: Text("Cancel", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            );
          }),
        );
      },
    );
  }
}
