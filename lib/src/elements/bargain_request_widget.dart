import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/bargain_request_model.dart';
import 'package:trapp/src/pages/BargainRequestDetailPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class BargainRequestWidget extends StatefulWidget {
  final BargainRequestModel? bargainRequestModel;
  final bool? loadingStatus;
  final Function(BargainRequestModel?)? cancelCallback;
  final Function(BargainRequestModel?)? counterOfferCallback;
  final Function(BargainRequestModel?)? completeCallback;
  final Function()? detailCallback;

  BargainRequestWidget({
    @required this.bargainRequestModel,
    @required this.loadingStatus,
    this.cancelCallback,
    this.counterOfferCallback,
    this.completeCallback,
    this.detailCallback,
  });

  @override
  _BargainRequestWidgetState createState() => _BargainRequestWidgetState();
}

class _BargainRequestWidgetState extends State<BargainRequestWidget> {
  /// Responsive design variables
  double? deviceWidth;
  double? deviceHeight;
  double? statusbarHeight;
  double? bottomBarHeight;
  double? appbarHeight;
  double? widthDp;
  double? heightDp;
  double? heightDp1;
  double? fontSp;

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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 5),
      color: Colors.white,
      elevation: 4,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
        child: widget.loadingStatus! ? _shimmerWidget() : _orderWidget(),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: widthDp! * 70,
                height: widthDp! * 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(heightDp! * 6),
                ),
              ),
              SizedBox(width: widthDp! * 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "store name Store",
                        style: TextStyle(fontSize: fontSp! * 14, fontWeight: FontWeight.bold, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: heightDp! * 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.white,
                          child: Text(
                            "bargainRequestId",
                            style: TextStyle(fontSize: fontSp! * 12, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Container(
                        //   color: Colors.white,
                        //   child: Text(
                        //     "2021-05-23",
                        //     style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: heightDp! * 5),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "City name",
                        style: TextStyle(fontSize: fontSp! * 11, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: heightDp! * 5),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "address address",
                        style: TextStyle(fontSize: fontSp! * 11, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          Divider(height: heightDp! * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Bargain Request Status:   ",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "bargainRequestStatus",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp! * 7),
          Container(
            width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "Bargain Request Date:  ",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Text(
                    "2021-05-87",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          ///
          SizedBox(height: heightDp! * 7),
          Container(
            width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "Offer Price:  ",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Text(
                    "324.23",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          ///
          SizedBox(height: heightDp! * 7),
          Container(
            width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "Original Price:  ",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Text(
                    "324.34",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          ///
          Divider(height: heightDp! * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        ],
      ),
    );
  }

  Widget _orderWidget() {
    String bargainRequestStatus = "";
    if (widget.bargainRequestModel!.status != widget.bargainRequestModel!.subStatus) {
      for (var i = 0; i < AppConfig.bargainSubStatusData.length; i++) {
        if (AppConfig.bargainSubStatusData[i]["id"] == widget.bargainRequestModel!.subStatus) {
          bargainRequestStatus = AppConfig.bargainSubStatusData[i]["name"];
          break;
        }
      }
    } else {
      for (var i = 0; i < AppConfig.bargainRequestStatusData.length; i++) {
        if (AppConfig.bargainRequestStatusData[i]["id"] == widget.bargainRequestModel!.status) {
          bargainRequestStatus = AppConfig.bargainRequestStatusData[i]["name"];
          break;
        }
      }
    }

    double originPrice = 0.0;

    if (widget.bargainRequestModel!.products!.isNotEmpty && widget.bargainRequestModel!.products![0].productModel!.price != null) {
      originPrice = widget.bargainRequestModel!.products![0].productModel!.price! - widget.bargainRequestModel!.products![0].productModel!.discount!;
    } else if (widget.bargainRequestModel!.services!.isNotEmpty && widget.bargainRequestModel!.services![0].serviceModel!.price != null) {
      originPrice = widget.bargainRequestModel!.services![0].serviceModel!.price! - widget.bargainRequestModel!.services![0].serviceModel!.discount!;
    }

    return GestureDetector(
      onTap: widget.detailCallback,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                KeicyAvatarImage(
                  url: widget.bargainRequestModel!.storeModel!.profile!["image"],
                  width: widthDp! * 70,
                  height: widthDp! * 70,
                  backColor: Colors.grey.withOpacity(0.4),
                  borderRadius: heightDp! * 6,
                  errorWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(heightDp! * 6),
                    child: Image.asset(
                      "img/store-icon/${widget.bargainRequestModel!.storeModel!.subType!.toLowerCase()}-store.png",
                      width: widthDp! * 70,
                      height: widthDp! * 70,
                    ),
                  ),
                ),
                SizedBox(width: widthDp! * 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.bargainRequestModel!.storeModel!.name} Store",
                        style: TextStyle(fontSize: fontSp! * 14, fontWeight: FontWeight.bold, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: heightDp! * 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.bargainRequestModel!.bargainRequestId!,
                            style: TextStyle(fontSize: fontSp! * 12, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            KeicyDateTime.convertDateTimeToDateString(
                              dateTime: widget.bargainRequestModel!.updatedAt,
                              formats: "Y-m-d H:i",
                              isUTC: false,
                            ),
                            style: TextStyle(fontSize: fontSp! * 12, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp! * 5),
                      Text(
                        '${widget.bargainRequestModel!.storeModel!.city}',
                        style: TextStyle(fontSize: fontSp! * 11, color: Colors.black),
                      ),
                      SizedBox(height: heightDp! * 5),
                      Text(
                        "${widget.bargainRequestModel!.storeModel!.address}",
                        style: TextStyle(fontSize: fontSp! * 11, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(left: widthDp * 10, top: heightDp * 10, bottom: heightDp * 10),
                //   child: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
                // ),
              ],
            ),

            ///
            Divider(height: heightDp! * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bargain Request Status:   ",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Text(
                  bargainRequestStatus,
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp! * 7),
            Container(
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bargain Request Date:  ",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: widget.bargainRequestModel!.bargainDateTime,
                      formats: 'Y-m-d h:i A',
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                  ),
                ],
              ),
            ),

            ///
            SizedBox(height: heightDp! * 7),
            Container(
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Offer Price:  ",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${widget.bargainRequestModel!.offerPrice}",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                  ),
                ],
              ),
            ),

            ///
            SizedBox(height: heightDp! * 7),
            Container(
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Original Price:  ",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    originPrice == 0 ? "" : "$originPrice",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                  ),
                ],
              ),
            ),

            ///
            Divider(height: heightDp! * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

            ///
            if (AppConfig.bargainRequestStatusData[1]["id"] == widget.bargainRequestModel!.status)
              _userOfferButtonGroup()
            else if (AppConfig.bargainRequestStatusData[2]["id"] == widget.bargainRequestModel!.status)
              _storeOfferButtonGroup()
            else if (AppConfig.bargainRequestStatusData[3]["id"] == widget.bargainRequestModel!.status)
              _acceptOrderActionButtonGroup()
            else
              SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _userOfferButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp! * 150,
          height: heightDp! * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp! * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest Cancel",
              content: "Do you want to cancel this bargain request?",
              callback: () {
                widget.cancelCallback!(BargainRequestModel.copy(widget.bargainRequestModel!));
              },
            );
          },
        ),
      ],
    );
  }

  Widget _storeOfferButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        KeicyRaisedButton(
          width: widthDp! * 130,
          height: heightDp! * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp! * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
          child: Text(
            "Offer Counter",
            style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
          ),
          onPressed: () async {
            await CounterDialog.show(
              context,
              bargainRequestModel: BargainRequestModel.copy(widget.bargainRequestModel!),
              storeModel: widget.bargainRequestModel!.storeModel,
              widthDp: widthDp!,
              heightDp: heightDp!,
              fontSp: fontSp!,
              callBack: (BargainRequestModel? bargainRequestModel) async {
                widget.counterOfferCallback!(bargainRequestModel);
              },
            );
          },
        ),
        KeicyRaisedButton(
          width: widthDp! * 110,
          height: heightDp! * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp! * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
          child: Text(
            "Complete",
            style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest complete",
              content: "Do you want to complete this bargain request?",
              callback: () {
                widget.completeCallback!(BargainRequestModel.copy(widget.bargainRequestModel!));
              },
            );
          },
        ),
        KeicyRaisedButton(
          width: widthDp! * 110,
          height: heightDp! * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp! * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest Cancel",
              content: "Do you want to cancel this bargain request?",
              callback: () {
                widget.cancelCallback!(BargainRequestModel.copy(widget.bargainRequestModel!));
              },
            );
          },
        ),
      ],
    );
  }

  Widget _acceptOrderActionButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp! * 135,
          height: heightDp! * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp! * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
          child: Text(
            "Complete",
            style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest complete",
              content: "Do you want to complete this bargain request?",
              callback: () {
                widget.completeCallback!(BargainRequestModel.copy(widget.bargainRequestModel!));
              },
            );
          },
        ),
        KeicyRaisedButton(
          width: widthDp! * 135,
          height: heightDp! * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp! * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest Cancel",
              content: "Do you want to cancel this bargain request?",
              callback: () {
                widget.cancelCallback!(BargainRequestModel.copy(widget.bargainRequestModel!));
              },
            );
          },
        ),
      ],
    );
  }
}
