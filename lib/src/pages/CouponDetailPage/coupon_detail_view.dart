import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/favorite_icon_widget.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
import 'package:trapp/src/elements/service_item_for_selection_widget.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

class CouponDetailView extends StatefulWidget {
  final CouponModel? couponModel;
  final StoreModel? storeModel;

  CouponDetailView({Key? key, this.storeModel, this.couponModel}) : super(key: key);

  @override
  _CouponDetailViewState createState() => _CouponDetailViewState();
}

class _CouponDetailViewState extends State<CouponDetailView> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _shareHandler(CouponModel couponModel) async {
    Uri dynamicUrl = await DynamicLinkService.createCouponDynamicLink(
      storeModel: widget.storeModel,
      couponModel: couponModel,
    );
    Share.share(dynamicUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Colors.white;

    /// percent
    if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[0]["value"]) {
      backColor = Colors.green;
    }
    // fix amount
    else if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[1]["value"]) {
      backColor = Colors.blue;
    }
    // BOGO
    else if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"]) {
      backColor = Colors.red;
    }
    return WillPopScope(
      onWillPop: () async {
        FavoriteProvider.of(context).favoriteUpdateHandler();
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: Container(
              width: deviceWidth,
              color: backColor,
              child: Column(
                children: [
                  ///
                  _headerWidget(),

                  Container(
                    width: deviceWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(heightDp * 30),
                        topRight: Radius.circular(heightDp * 30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: heightDp * 10),

                        ///
                        SizedBox(height: heightDp * 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                          child: _userLimitPanel(),
                        ),

                        ///
                        SizedBox(height: heightDp * 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                          child: _descriptionPanel(),
                        ),

                        ///
                        SizedBox(height: heightDp * 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                          child: _appliedToPanel(),
                        ),

                        ///
                        SizedBox(height: heightDp * 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                          child: _termsPanel(),
                        ),

                        ///
                        SizedBox(height: heightDp * 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerWidget() {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${widget.couponModel!.discountData!["discountValue"]} % ",
            style: TextStyle(
              fontSize: fontSp * 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " OFF",
            style: TextStyle(
              fontSize: fontSp * 16,
              color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${widget.couponModel!.discountData!["discountValue"]} ₹ ",
            style: TextStyle(
              fontSize: fontSp * 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " OFF",
            style: TextStyle(
              fontSize: fontSp * 16,
              color: Colors.white,
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
                  fontSize: fontSp * 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Get ${widget.couponModel!.discountData!["customerBogo"]["get"]["quantity"]}",
                    style: TextStyle(
                      fontSize: fontSp * 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: widthDp * 10),
                  Text(
                    widget.couponModel!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]
                        ? "${AppConfig.discountBuyValueForCoupon[0]["text"].toString().toUpperCase()}"
                        : "${widget.couponModel!.discountData!["customerBogo"]["get"]["percentValue"]} %  OFF",
                    style: TextStyle(
                      fontSize: fontSp * 14,
                      color: Colors.white,
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
    return Container(
      width: deviceWidth,
      color: backColor,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      margin: EdgeInsets.only(top: statusbarHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              FavoriteProvider.of(context).favoriteUpdateHandler();
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: heightDp * 10),
              child: Icon(Icons.arrow_back_ios, size: heightDp * 25, color: Colors.white),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: heightDp * 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.couponModel!.discountCode}",
                        style: TextStyle(fontSize: fontSp * 30, color: Colors.white, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(height: heightDp * 5),
                      discountWidget,
                    ],
                  ),
                ),
              ),
              SizedBox(width: widthDp * 15),
              KeicyAvatarImage(
                url: widget.couponModel!.images!.isNotEmpty
                    ? widget.couponModel!.images![0]
                    : AppConfig.discountTypeImages[widget.couponModel!.discountType],
                width: heightDp * 150,
                height: heightDp * 150,
                backColor: Colors.grey.withOpacity(0.6),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "${widget.couponModel!.discountCode}",
          //             style: TextStyle(fontSize: fontSp * 26, color: Colors.white, fontWeight: FontWeight.w600),
          //             maxLines: 2,
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //           SizedBox(height: heightDp * 5),
          //           discountWidget,
          //         ],
          //       ),
          //     ),
          //     KeicyAvatarImage(
          //       url: widget.couponModel!.images.isNotEmpty
          //           ? widget.couponModel!.images[0]
          //           : AppConfig.discountTypeImages[widget.couponModel!.discountType],
          //       width: heightDp * 120,
          //       height: heightDp * 120,
          //       backColor: Colors.grey.withOpacity(0.6),
          //     ),
          //   ],
          // ),
          SizedBox(height: heightDp * 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Validity : " + validateString,
                style: TextStyle(fontSize: fontSp * 16, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  FavoriteIconWidget(
                    category: "coupons",
                    id: widget.couponModel!.id,
                    storeId: widget.storeModel!.id,
                    color: Colors.white,
                    size: heightDp * 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      _shareHandler(widget.couponModel!);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                      color: Colors.transparent,
                      child: Icon(
                        Icons.share,
                        size: heightDp * 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }

  Widget _userLimitPanel() {
    String str = "";
    if (widget.couponModel!.usageLimits == AppConfig.usageLimitsForCoupon[0]["value"]) {
      str = "You can use this coupon unlimited number of times";
    } else if (widget.couponModel!.usageLimits == AppConfig.usageLimitsForCoupon[1]["value"]) {
      str = "You can use this coupon maximum of ${widget.couponModel!.limitNumbers} times";
    } else if (widget.couponModel!.usageLimits == AppConfig.usageLimitsForCoupon[2]["value"]) {
      str = "You can use this coupon only 1 time";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Usage Limit :",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 10),
        Text(
          str,
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        ),
      ],
    );
  }

  Widget _descriptionPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description :",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 10),
        Text(
          "${widget.couponModel!.description}",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        ),
      ],
    );
  }

  Widget _appliedToPanel() {
    Widget appliedWidget = SizedBox();
    if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"]) {
      String getTypeString = "";

      if (widget.couponModel!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]) {
        getTypeString = "Free";
      } else {
        getTypeString = "${widget.couponModel!.discountData!["customerBogo"]["get"]["percentValue"]}% OFF";
      }

      appliedWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          Text(
            "You Buy :",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 10),
          Text(
            "${widget.couponModel!.discountData!["customerBogo"]["buy"]["quantity"]} Quantity of any product(s)/service(s) below",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
          ),
          SizedBox(height: heightDp * 5),
          Padding(
            padding: EdgeInsets.only(left: widthDp * 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///
                if (widget.couponModel!.discountData!["customerBogo"]["buy"]["products"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Products :",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: heightDp * 5),
                      Padding(
                        padding: EdgeInsets.only(left: widthDp * 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.couponModel!.discountData!["customerBogo"]["buy"]["products"].length,
                            (index) {
                              return ProductItemForSelectionWidget(
                                productModel:
                                    ProductModel.fromJson(widget.couponModel!.discountData!["customerBogo"]["buy"]["products"][index]["data"]),
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 5),
                                isLoading: false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                ///
                if (widget.couponModel!.discountData!["customerBogo"]["buy"]["services"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 10),
                      Text(
                        "Services :",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: heightDp * 5),
                      Padding(
                        padding: EdgeInsets.only(left: widthDp * 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.couponModel!.discountData!["customerBogo"]["buy"]["services"].length,
                            (index) {
                              return ServiceItemForSelectionWidget(
                                serviceModel:
                                    ServiceModel.fromJson(widget.couponModel!.discountData!["customerBogo"]["buy"]["services"][index]["data"]),
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 5),
                                isLoading: false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          ///
          SizedBox(height: heightDp * 10),
          Text(
            "You Get :",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 10),
          Text(
            "${widget.couponModel!.discountData!["customerBogo"]["get"]["quantity"]} "
            "Quantity of any product(s)/service(s) for $getTypeString",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
          ),
          SizedBox(height: heightDp * 5),
          Padding(
            padding: EdgeInsets.only(left: widthDp * 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///
                if (widget.couponModel!.discountData!["customerBogo"]["get"]["products"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Products :",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: heightDp * 5),
                      Padding(
                        padding: EdgeInsets.only(left: widthDp * 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.couponModel!.discountData!["customerBogo"]["get"]["products"].length,
                            (index) {
                              return ProductItemForSelectionWidget(
                                productModel:
                                    ProductModel.fromJson(widget.couponModel!.discountData!["customerBogo"]["get"]["products"][index]["data"]),
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 5),
                                isLoading: false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                ///
                if (widget.couponModel!.discountData!["customerBogo"]["get"]["services"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 10),
                      Text(
                        "Services :",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: heightDp * 5),
                      Padding(
                        padding: EdgeInsets.only(left: widthDp * 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.couponModel!.discountData!["customerBogo"]["get"]["services"].length,
                            (index) {
                              return ServiceItemForSelectionWidget(
                                serviceModel:
                                    ServiceModel.fromJson(widget.couponModel!.discountData!["customerBogo"]["get"]["services"][index]["data"]),
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 5),
                                isLoading: false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    } else if (widget.couponModel!.appliedFor == AppConfig.appliesToForCoupon[0]["value"]) {
      appliedWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Applieds To :",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 10),
          Padding(
            padding: EdgeInsets.only(left: widthDp * 10),
            child: Text(
              "Entire Order",
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            ),
          ),
        ],
      );
    } else if (widget.couponModel!.appliedFor == AppConfig.appliesToForCoupon[1]["value"]) {
      appliedWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Applieds To :",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 10),
          Padding(
            padding: EdgeInsets.only(left: widthDp * 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///
                if (widget.couponModel!.appliedData!["appliedCategories"]["productCategories"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Categories :",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: heightDp * 5),
                      Padding(
                        padding: EdgeInsets.only(left: widthDp * 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.couponModel!.appliedData!["appliedCategories"]["productCategories"].length,
                            (index) {
                              return Text(
                                "${widget.couponModel!.appliedData!["appliedCategories"]["productCategories"][index]}",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                ///
                if (widget.couponModel!.appliedData!["appliedCategories"]["serviceCategories"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 10),
                      Text(
                        "Service Categories :",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: heightDp * 5),
                      Padding(
                        padding: EdgeInsets.only(left: widthDp * 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.couponModel!.appliedData!["appliedCategories"]["serviceCategories"].length,
                            (index) {
                              return Text(
                                "${widget.couponModel!.appliedData!["appliedCategories"]["serviceCategories"][index]}",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    } else if (widget.couponModel!.appliedFor == AppConfig.appliesToForCoupon[2]["value"]) {
      appliedWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Applieds To :",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 10),
          Padding(
            padding: EdgeInsets.only(left: widthDp * 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///
                if (widget.couponModel!.appliedData!["appliedItems"]["products"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Products :",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: heightDp * 5),
                      Padding(
                        padding: EdgeInsets.only(left: widthDp * 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.couponModel!.appliedData!["appliedItems"]["products"].length,
                            (index) {
                              return ProductItemForSelectionWidget(
                                productModel: ProductModel.fromJson(widget.couponModel!.appliedData!["appliedItems"]["products"][index]["data"]),
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 5),
                                isLoading: false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                ///
                if (widget.couponModel!.appliedData!["appliedItems"]["services"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 10),
                      Text(
                        "Services :",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: heightDp * 5),
                      Padding(
                        padding: EdgeInsets.only(left: widthDp * 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.couponModel!.appliedData!["appliedItems"]["services"].length,
                            (index) {
                              return ServiceItemForSelectionWidget(
                                serviceModel: ServiceModel.fromJson(widget.couponModel!.appliedData!["appliedItems"]["services"][index]["data"]),
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 5),
                                isLoading: false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    }

    return appliedWidget;
  }

  Widget _termsPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Terms & Condition :",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 10),
        Text(
          "${widget.couponModel!.terms}",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        ),
      ],
    );
  }
}
