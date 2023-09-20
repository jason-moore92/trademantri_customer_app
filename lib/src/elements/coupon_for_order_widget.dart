import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';

class CouponForOrderWidget extends StatefulWidget {
  final CouponModel? couponModel;
  final CouponModel? selectedCoupon;
  final String? storeId;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Function()? tapHandler;

  CouponForOrderWidget({
    @required this.couponModel,
    this.selectedCoupon,
    @required this.storeId,
    this.isLoading = true,
    this.padding,
    this.margin,
    this.tapHandler,
  });

  @override
  _ProductItemForSelectionWidgetState createState() => _ProductItemForSelectionWidgetState();
}

class _ProductItemForSelectionWidgetState extends State<CouponForOrderWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  bool _customerBogoBuyProductLimit = true;
  bool _customerBogoBuyServiceLimit = true;
  bool _customerBogoGetProductLimit = true;
  bool _customerBogoGetServiceLimit = true;
  bool _appliedProductCagtegoryLimit = true;
  bool _appliedServiceCagtegoryLimit = true;
  bool _appliedProductItemLimit = true;
  bool _appliedServiceItemLimit = true;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: widget.margin ??
          EdgeInsets.only(
            left: widthDp * 15,
            right: widthDp * 15,
            top: heightDp * 5,
            bottom: heightDp * 10,
          ),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 6)),
      elevation: 0,
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(heightDp * 6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow.withOpacity(0.15),
            border: Border(top: BorderSide(color: config.Colors().mainColor(1), width: 3)),
          ),
          child: widget.isLoading ? _shimmerWidget() : _mainWidget(),
        ),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.yellow.withOpacity(0.01),
      highlightColor: Colors.yellow.withOpacity(0.2),
      direction: ShimmerDirection.ltr,
      enabled: widget.isLoading,
      period: Duration(milliseconds: 1000),
      child: Column(
        children: [
          Container(
            height: heightDp * 150,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _mainWidget() {
    String validateString = KeicyDateTime.convertDateTimeToDateString(
      dateTime: widget.couponModel!.startDate,
      formats: "Y/m/d",
      isUTC: false,
    );

    if (widget.couponModel!.endDate != null) {
      validateString += " - " +
          KeicyDateTime.convertDateTimeToDateString(
            dateTime: widget.couponModel!.endDate,
            formats: "Y/m/d",
            isUTC: false,
          );
    }

    Color backColor = Colors.white;

    Widget discountWidget = SizedBox();

    /// percent
    if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[0]["value"]) {
      backColor = Colors.green;
      discountWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${widget.couponModel!.discountData!["discountValue"]} % ",
            style: TextStyle(
              fontSize: fontSp * 24,
              color: config.Colors().mainColor(1),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " OFF",
            style: TextStyle(
              fontSize: fontSp * 18,
              color: config.Colors().mainColor(1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    // fix amount
    else if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[1]["value"]) {
      backColor = Colors.blue;
      discountWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${widget.couponModel!.discountData!["discountValue"]} ₹ ",
            style: TextStyle(
              fontSize: fontSp * 24,
              color: config.Colors().mainColor(1),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " OFF",
            style: TextStyle(
              fontSize: fontSp * 18,
              color: config.Colors().mainColor(1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    // BOGO
    else if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"]) {
      backColor = Colors.red;
      discountWidget = Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Buy ${widget.couponModel!.discountData!["customerBogo"]["buy"]["quantity"]}",
                style: TextStyle(
                  fontSize: fontSp * 20,
                  color: config.Colors().mainColor(1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Get ${widget.couponModel!.discountData!["customerBogo"]["get"]["quantity"]}",
                    style: TextStyle(
                      fontSize: fontSp * 20,
                      color: config.Colors().mainColor(1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: widthDp * 10),
                  Text(
                    widget.couponModel!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]
                        ? "${AppConfig.discountBuyValueForCoupon[0]["text"].toString().toUpperCase()}"
                        : "${widget.couponModel!.discountData!["customerBogo"]["get"]["percentValue"]} %  OFF",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: config.Colors().mainColor(1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: widget.tapHandler,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                discountWidget,
                GestureDetector(
                  // onTap: widget.tapHandler,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                    color: Colors.transparent,
                    child: Icon(
                      Icons.check_circle_outline_outlined,
                      size: heightDp * 25,
                      color: widget.selectedCoupon != null && widget.selectedCoupon!.id == widget.couponModel!.id
                          ? Colors.green
                          : Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Coupon Code : ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Text(
                    "${widget.couponModel!.discountCode}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 5),
            _discountPanel(),

            ///
            SizedBox(height: heightDp * 5),
            _appliesToPanel(),

            SizedBox(height: heightDp * 5),
            _minimumRequirementsPanel(),

            SizedBox(height: heightDp * 5),
            _userLimitPanel(),
          ],
        ),
      ),
    );
  }

  Widget _discountPanel() {
    String discountType = "";
    for (var i = 0; i < AppConfig.discountTypeForCoupon.length; i++) {
      if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[i]["value"]) {
        discountType = AppConfig.discountTypeForCoupon[i]["text"];
        break;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Discount Type : ",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                "$discountType",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
            ),
          ],
        ),
        if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[0]["value"]) _discountPercentPanel(),
        if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[1]["value"]) _discountFixedAmountPanel(),
        if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"]) _discountBoGoPanel(),
      ],
    );
  }

  Widget _discountPercentPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: heightDp * 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Discount Percent : ",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                "${widget.couponModel!.discountData!["discountValue"]} %",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _discountFixedAmountPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: heightDp * 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fixed Amount : ",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                "${widget.couponModel!.discountData!["discountValue"]} ₹",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _discountBoGoPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: heightDp * 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "When Customer buys : ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: widthDp * 10),
                Text(
                  "${widget.couponModel!.discountData!["customerBogo"]["buy"]["quantity"]} Quantity ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: heightDp * 2),
        Text(
          "    Any of the following products/services",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        ),
        if (widget.couponModel!.discountData!["customerBogo"]["buy"]["products"].length != 0)
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: widthDp * 20),
                  Text(
                    "Products : ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Column(
                      children: List.generate(
                          _customerBogoBuyProductLimit ? 1 : widget.couponModel!.discountData!["customerBogo"]["buy"]["products"].length, (index) {
                        return Row(
                          children: [
                            SizedBox(width: widthDp * 10),
                            Expanded(
                              child: Text(
                                "${widget.couponModel!.discountData!["customerBogo"]["buy"]["products"][index]["data"]["name"]}",
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
              if (widget.couponModel!.discountData!["customerBogo"]["get"]["products"].length != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _customerBogoBuyProductLimit = !_customerBogoBuyProductLimit;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        color: Colors.transparent,
                        child: Text(
                          _customerBogoBuyProductLimit ? "Show More" : "Show Less",
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        if (widget.couponModel!.discountData!["customerBogo"]["buy"]["services"].length != 0)
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: widthDp * 20),
                  Text(
                    "Services : ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Column(
                      children: List.generate(
                          _customerBogoBuyServiceLimit ? 1 : widget.couponModel!.discountData!["customerBogo"]["buy"]["services"].length, (index) {
                        return Row(
                          children: [
                            SizedBox(width: widthDp * 10),
                            Expanded(
                              child: Text(
                                "${widget.couponModel!.discountData!["customerBogo"]["buy"]["services"][index]["data"]["name"]}",
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
              if (widget.couponModel!.discountData!["customerBogo"]["buy"]["services"].length != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _customerBogoBuyServiceLimit = !_customerBogoBuyServiceLimit;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        color: Colors.transparent,
                        child: Text(
                          _customerBogoBuyServiceLimit ? "Show More" : "Show Less",
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

        ///
        SizedBox(height: heightDp * 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Customer gets : ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: widthDp * 10),
                Text(
                  "${widget.couponModel!.discountData!["customerBogo"]["get"]["quantity"]} Quantity ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: heightDp * 2),
        Text(
          "    Any of the following products/services",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        ),
        if (widget.couponModel!.discountData!["customerBogo"]["get"]["products"].length != 0)
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: widthDp * 20),
                  Text(
                    "Products : ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Column(
                      children: List.generate(
                        _customerBogoGetProductLimit ? 1 : widget.couponModel!.discountData!["customerBogo"]["get"]["products"].length,
                        (index) {
                          return Row(
                            children: [
                              SizedBox(width: widthDp * 10),
                              Expanded(
                                child: Text(
                                  "${widget.couponModel!.discountData!["customerBogo"]["get"]["products"][index]["data"]["name"]}",
                                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.couponModel!.discountData!["customerBogo"]["get"]["products"].length != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _customerBogoGetProductLimit = !_customerBogoGetProductLimit;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        color: Colors.transparent,
                        child: Text(
                          _customerBogoGetProductLimit ? "Show More" : "Show Less",
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        if (widget.couponModel!.discountData!["customerBogo"]["get"]["services"].length != 0)
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: widthDp * 20),
                  Text(
                    "Services : ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Column(
                      children: List.generate(
                        _customerBogoGetServiceLimit ? 1 : widget.couponModel!.discountData!["customerBogo"]["get"]["services"].length,
                        (index) {
                          return Row(
                            children: [
                              SizedBox(width: widthDp * 10),
                              Expanded(
                                child: Text(
                                  "${widget.couponModel!.discountData!["customerBogo"]["get"]["services"][index]["data"]["name"]}",
                                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.couponModel!.discountData!["customerBogo"]["get"]["services"].length != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _customerBogoGetServiceLimit = !_customerBogoGetServiceLimit;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        color: Colors.transparent,
                        child: Text(
                          _customerBogoGetServiceLimit ? "Show More" : "Show Less",
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }

  Widget _appliesToPanel() {
    String appliesTo = "";
    for (var i = 0; i < AppConfig.appliesToForCoupon.length; i++) {
      if (widget.couponModel!.appliedFor == AppConfig.appliesToForCoupon[i]["value"]) {
        appliesTo = AppConfig.appliesToForCoupon[i]["text"];
        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Applies To : ",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                "$appliesTo",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
            ),
          ],
        ),
        if (widget.couponModel!.appliedFor == AppConfig.appliesToForCoupon[1]["value"]) _appliesToCategoryPanel(),
        // if (widget.couponModel!.appliedFor == AppConfig.appliesToForCoupon[2]["value"]) _appliesToItemsPanel(),
      ],
    );
  }

  Widget _appliesToCategoryPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.couponModel!.appliedData!["appliedCategories"]["productCategories"].length != 0)
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: widthDp * 20),
                  Text(
                    "Product Categories : ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: widthDp * 20),
                  Expanded(
                    child: Wrap(
                      spacing: widthDp * 10,
                      runSpacing: heightDp * 5,
                      children: List.generate(
                        _appliedProductCagtegoryLimit ? 1 : widget.couponModel!.appliedData!["appliedCategories"]["productCategories"].length,
                        (index) {
                          return Text(
                            "${widget.couponModel!.appliedData!["appliedCategories"]["productCategories"][index]}",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.couponModel!.appliedData!["appliedCategories"]["productCategories"].length != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _appliedProductCagtegoryLimit = !_appliedProductCagtegoryLimit;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        color: Colors.transparent,
                        child: Text(
                          _appliedProductCagtegoryLimit ? "Show More" : "Show Less",
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        if (widget.couponModel!.appliedData!["appliedCategories"]["serviceCategories"].length != 0)
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: widthDp * 20),
                  Text(
                    "Service Categories : ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: widthDp * 20),
                  Expanded(
                    child: Wrap(
                      spacing: widthDp * 10,
                      runSpacing: heightDp * 5,
                      children: List.generate(
                        _appliedServiceCagtegoryLimit ? 1 : widget.couponModel!.appliedData!["appliedCategories"]["serviceCategories"].length,
                        (index) {
                          return Text(
                            "${widget.couponModel!.appliedData!["appliedCategories"]["serviceCategories"][index]}",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.couponModel!.appliedData!["appliedCategories"]["serviceCategories"].length != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _appliedServiceCagtegoryLimit = !_appliedServiceCagtegoryLimit;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        color: Colors.transparent,
                        child: Text(
                          _appliedServiceCagtegoryLimit ? "Show More" : "Show Less",
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }

  Widget _appliesToItemsPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.couponModel!.appliedData!["appliedItems"]["products"].length != 0)
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: widthDp * 20),
                  Text(
                    "Products : ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Column(
                      children: List.generate(
                        _appliedProductItemLimit ? 1 : widget.couponModel!.appliedData!["appliedItems"]["products"].length,
                        (index) {
                          return Row(
                            children: [
                              SizedBox(width: widthDp * 10),
                              Expanded(
                                child: Text(
                                  "${widget.couponModel!.appliedData!["appliedItems"]["products"][index]["data"]["name"]}",
                                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.couponModel!.appliedData!["appliedItems"]["products"].length != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _appliedProductItemLimit = !_appliedProductItemLimit;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        color: Colors.transparent,
                        child: Text(
                          _appliedProductItemLimit ? "Show More" : "Show Less",
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        if (widget.couponModel!.appliedData!["appliedItems"]["services"].length != 0)
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: widthDp * 20),
                  Text(
                    "Services : ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Column(
                      children: List.generate(
                        _appliedServiceItemLimit ? 1 : widget.couponModel!.appliedData!["appliedItems"]["services"].length,
                        (index) {
                          return Row(
                            children: [
                              SizedBox(width: widthDp * 10),
                              Expanded(
                                child: Text(
                                  "${widget.couponModel!.appliedData!["appliedItems"]["services"][index]["data"]["name"]}",
                                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.couponModel!.appliedData!["appliedItems"]["services"].length != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _appliedServiceItemLimit = !_appliedServiceItemLimit;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        color: Colors.transparent,
                        child: Text(
                          _appliedServiceItemLimit ? "Show More" : "Show Less",
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }

  Widget _minimumRequirementsPanel() {
    String minimunRequirements = "";
    for (var i = 0; i < AppConfig.minRequirementsForCoupon.length; i++) {
      if (widget.couponModel!.minimumRequirements == AppConfig.minRequirementsForCoupon[i]["value"]) {
        minimunRequirements = AppConfig.minRequirementsForCoupon[i]["text"];
        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Minimum Requirements : ",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                (widget.couponModel!.minimumRequirements == AppConfig.minRequirementsForCoupon[0]["value"]) ? "$minimunRequirements" : "",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
            ),
          ],
        ),
        if ((widget.couponModel!.minimumRequirements == AppConfig.minRequirementsForCoupon[1]["value"]))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: widthDp * 10),
                  Text(
                    "Purchase Amount: ${widget.couponModel!.minimumAmount} ₹",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: widthDp * 10),
                  Expanded(
                    child: Text(
                      "(You need to buy minimal ${widget.couponModel!.minimumAmount} ₹ of above selected products/services)",
                      style: TextStyle(fontSize: fontSp * 13, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        if ((widget.couponModel!.minimumRequirements == AppConfig.minRequirementsForCoupon[2]["value"]))
          Column(
            children: [
              Row(
                children: [
                  SizedBox(width: widthDp * 10),
                  Text(
                    "Quantity: ${widget.couponModel!.minimumQuantity}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: widthDp * 10),
                  Expanded(
                    child: Text(
                      "(You need to buy minimal ${widget.couponModel!.minimumQuantity} Quantity of above selected products/services)",
                      style: TextStyle(fontSize: fontSp * 13, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _userLimitPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.couponModel!.usageLimits == AppConfig.usageLimitsForCoupon[0]["value"])
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Note : ",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Text(
                  "You can apply this coupon unlimited times.",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),
        if (widget.couponModel!.usageLimits == AppConfig.usageLimitsForCoupon[1]["value"])
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Note : ",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Text(
                  "You can apply this coupon at most ${widget.couponModel!.limitNumbers} times.",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),
        if (widget.couponModel!.usageLimits == AppConfig.usageLimitsForCoupon[2]["value"])
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Note : ",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Text(
                  "You can apply this coupon only once.",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
