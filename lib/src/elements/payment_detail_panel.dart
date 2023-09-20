import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class PaymentDetailPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final EdgeInsetsGeometry? padding;

  PaymentDetailPanel({@required this.orderModel, this.padding});

  @override
  _PaymentDetailPanelState createState() => _PaymentDetailPanelState();
}

class _PaymentDetailPanelState extends State<PaymentDetailPanel> {
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

  var numFormat = NumberFormat.currency(symbol: "", name: "");

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryAddressProvider>(builder: (context, deliveryAddressProvider, _) {
      return Container(
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///
            Text(
              "Payment Detail",
              style: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.w500),
            ),

            ///
            SizedBox(height: heightDp! * 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Count",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
                Text(
                  "${numFormat.format(widget.orderModel!.paymentDetail!.totalQuantity)}",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              ],
            ),

            ///
            Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Item Price",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
                Row(
                  children: [
                    Text(
                      "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.totalPrice! - widget.orderModel!.paymentDetail!.totalTaxAfterDiscount!)}",
                      style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                    ),
                    widget.orderModel!.paymentDetail!.totalPrice == widget.orderModel!.paymentDetail!.totalOriginPrice
                        ? SizedBox()
                        : Row(
                            children: [
                              SizedBox(width: widthDp! * 5),
                              Text(
                                "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.totalOriginPrice! - widget.orderModel!.paymentDetail!.totalTaxBeforeDiscount!)}",
                                style: TextStyle(
                                  fontSize: fontSp! * 12,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ],
            ),

            ///
            if (widget.orderModel!.promocode != null)
              Column(
                children: [
                  Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Promo code applied",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                      Text(
                        "${widget.orderModel!.promocode!.promocodeCode}",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),

            ///
            if (widget.orderModel!.paymentDetail!.totalPromocodeDiscount != 0)
              Column(
                children: [
                  Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Promoode Discount",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.totalPromocodeDiscount)}",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

            ///
            if (widget.orderModel!.coupon != null)
              Column(
                children: [
                  Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coupon applied",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                      Text(
                        "${widget.orderModel!.coupon!.discountCode}",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),

            ///
            if (widget.orderModel!.paymentDetail!.totalCouponDiscount != 0)
              Column(
                children: [
                  Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Coupon Discount",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.totalCouponDiscount)}",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

            ///
            if (widget.orderModel!.deliveryAddress != null &&
                widget.orderModel!.deliveryAddress!.address != null &&
                widget.orderModel!.deliveryAddress!.address!.address != "")
              Column(
                children: [
                  Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Delivery Price",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              _deliveryBreakdownDialog();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: widthDp! * 10),
                              color: Colors.transparent,
                              child: Icon(Icons.info_outline, size: heightDp! * 20, color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.deliveryChargeAfterDiscount)}",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                          if (widget.orderModel!.paymentDetail!.deliveryDiscount != 0)
                            Row(
                              children: [
                                SizedBox(width: widthDp! * 5),
                                Text(
                                  "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.deliveryChargeBeforeDiscount)}",
                                  style: TextStyle(
                                    fontSize: fontSp! * 12,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

            ///
            if (widget.orderModel!.paymentDetail!.tip != 0)
              Column(
                children: [
                  Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tip",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                      Text(
                        "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.tip)}",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),

            ///
            if (widget.orderModel!.paymentDetail!.totalTaxAfterDiscount != 0)
              Column(
                children: [
                  Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tax",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                      Text(
                        "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.totalTaxAfterDiscount)}",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),

            Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
                Row(
                  children: [
                    Text(
                      "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.totalPrice)}",
                      style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                    ),
                    if (widget.orderModel!.paymentDetail!.totalPrice != widget.orderModel!.paymentDetail!.totalOriginPrice)
                      Row(
                        children: [
                          SizedBox(width: widthDp! * 5),
                          Text(
                            "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.totalOriginPrice)}",
                            style: TextStyle(
                              fontSize: fontSp! * 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),

            ///
            // Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),

            ///
            widget.orderModel!.redeemRewardData == null || widget.orderModel!.redeemRewardData!["tradeRedeemRewardValue"] == 0
                ? SizedBox()
                : Column(
                    children: [
                      Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TradeMantri Redeem Reward value",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                          Text(
                            "₹ ${numFormat.format(widget.orderModel!.redeemRewardData!["tradeRedeemRewardValue"] ?? 0)}",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),

            ///
            widget.orderModel!.redeemRewardData!.isEmpty || widget.orderModel!.redeemRewardData!["redeemRewardValue"] == 0
                ? SizedBox()
                : Column(
                    children: [
                      Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Redeem Reward value",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                          Text(
                            "₹ ${numFormat.format(widget.orderModel!.redeemRewardData!["redeemRewardValue"] ?? 0)}",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),

            ///
            Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            Column(
              children: [
                SizedBox(height: heightDp! * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "To Pay",
                      style: TextStyle(
                        fontSize: fontSp! * 14,
                        color: ((widget.orderModel!.paymentDetail!.toPay! -
                                    (widget.orderModel!.redeemRewardData!["redeemRewardValue"] ?? 0) -
                                    (widget.orderModel!.redeemRewardData!["tradeRedeemRewardValue"] ?? 0)) <=
                                0)
                            ? Colors.red
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.toPay! - (widget.orderModel!.redeemRewardData!["redeemRewardValue"] ?? 0) - (widget.orderModel!.redeemRewardData!["tradeRedeemRewardValue"] ?? 0))}",
                      style: TextStyle(
                        fontSize: fontSp! * 14,
                        color: ((widget.orderModel!.paymentDetail!.toPay! -
                                    (widget.orderModel!.redeemRewardData!["redeemRewardValue"] ?? 0) -
                                    (widget.orderModel!.redeemRewardData!["tradeRedeemRewardValue"] ?? 0)) <=
                                0)
                            ? Colors.red
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            ///
            if (widget.orderModel!.rewardPointData!.isNotEmpty && widget.orderModel!.paymentDetail!.rewardPointsEarnedPerOrder != 0)
              Column(
                children: [
                  Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "* You are going to earn ",
                          style: TextStyle(fontSize: fontSp! * 12, color: Colors.blue),
                        ),
                        TextSpan(
                          text: "${widget.orderModel!.paymentDetail!.rewardPointsEarnedPerOrder}",
                          style: TextStyle(fontSize: fontSp! * 12, color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: " reward points from this order.",
                          style: TextStyle(fontSize: fontSp! * 12, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }

  void _deliveryBreakdownDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheet(
          backgroundColor: Colors.transparent,
          onClosing: () {},
          builder: (context) {
            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Container(
                  width: deviceWidth,
                  padding: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(heightDp! * 20), topRight: Radius.circular(heightDp! * 20)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Charges Breakdown",
                            style: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: widthDp! * 10),
                              child: Icon(Icons.close, size: heightDp! * 25, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: heightDp! * 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery partner name",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                          Text(
                            "${widget.orderModel!.deliveryPartnerDetails!["deliveryPartnerName"] == null ? widget.orderModel!.storeModel!.name : widget.orderModel!.deliveryPartnerDetails!["deliveryPartnerName"]}",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp! * 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total distance",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                          Text(
                            "${(widget.orderModel!.deliveryAddress!.distance! / 1000).toStringAsFixed(3)} Km",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp! * 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Distance Charge",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                          Text(
                            "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.deliveryChargeBeforeDiscount)}",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: heightDp! * 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Distance Discount",
                                style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                              ),
                              Text(
                                "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.deliveryDiscount)}",
                                style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(height: heightDp! * 20, thickness: 1, color: Colors.black.withOpacity(0.1)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.deliveryChargeAfterDiscount)}",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
