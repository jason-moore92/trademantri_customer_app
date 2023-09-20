import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/pickup_panel.dart';
import 'package:trapp/src/models/index.dart';

import 'delivery_panel.dart';

class PickupDeliveryOptionPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final Map<String, dynamic>? deliveryPartner;
  final Function()? pickupCallback;
  final Function()? deliveryCallback;
  final Function()? refreshCallback;
  final bool? isReadOnly;
  final bool? checkMinAmount;

  PickupDeliveryOptionPanel({
    @required this.orderModel,
    @required this.deliveryPartner,
    @required this.pickupCallback,
    @required this.deliveryCallback,
    @required this.refreshCallback,
    this.isReadOnly = false,
    this.checkMinAmount = true,
  });

  @override
  _PickupDeliveryOptionPanelState createState() => _PickupDeliveryOptionPanelState();
}

class _PickupDeliveryOptionPanelState extends State<PickupDeliveryOptionPanel> {
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

  int? _orderType;

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

    _orderType = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: _orderType,
                      onChanged: (int? value) {
                        if (widget.isReadOnly!) return;
                        setState(() {
                          _orderType = value;
                          widget.pickupCallback!();
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.isReadOnly!) return;
                        setState(() {
                          _orderType = 0;
                          widget.pickupCallback!();
                        });
                      },
                      child: Text(
                        "Pick up",
                        style: TextStyle(
                          fontSize: fontSp! * 14,
                          color: _orderType == 0 ? config.Colors().mainColor(1) : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _orderType,
                      onChanged: (int? value) {
                        setState(() {
                          if (widget.isReadOnly!) return;
                          _orderType = value;
                          widget.deliveryCallback!();
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.isReadOnly!) return;
                          _orderType = 1;
                          widget.deliveryCallback!();
                        });
                      },
                      child: Text(
                        "Delivery",
                        style: TextStyle(
                          fontSize: fontSp! * 14,
                          color: _orderType == 1 ? config.Colors().mainColor(1) : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _orderType == 0
              ? PickupPanel(
                  orderModel: widget.orderModel,
                  refreshCallback: widget.refreshCallback!,
                )
              : DeliveryPanel(
                  checkMinAmount: widget.checkMinAmount,
                  orderModel: widget.orderModel,
                  deliveryPartner: widget.deliveryPartner,
                  refreshCallback: widget.refreshCallback,
                ),
        ],
      ),
    );
  }
}
