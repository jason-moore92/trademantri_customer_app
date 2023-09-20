import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';

class DeliveryOptionPanel extends StatefulWidget {
  final OrderModel? orderModel;

  DeliveryOptionPanel({@required this.orderModel});

  @override
  _DeliveryOptionPanelState createState() => _DeliveryOptionPanelState();
}

class _DeliveryOptionPanelState extends State<DeliveryOptionPanel> {
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 15),
      child: Row(
        children: [
          KeicyCheckBox(
            iconSize: heightDp! * 25,
            iconColor: config.Colors().mainColor(1),
            labelSpacing: widthDp! * 20,
            label: "No Contact Delivery",
            labelStyle: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.w500),
            value: widget.orderModel!.noContactDelivery ?? true,
            onChangeHandler: (value) {
              widget.orderModel!.noContactDelivery = value;
            },
          ),
        ],
      ),
    );
  }
}
