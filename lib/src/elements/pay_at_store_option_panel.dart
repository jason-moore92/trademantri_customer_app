import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';

class PayAtStorePanel extends StatefulWidget {
  final OrderModel? orderModel;

  PayAtStorePanel({@required this.orderModel});

  @override
  _PayAtStorePanelState createState() => _PayAtStorePanelState();
}

class _PayAtStorePanelState extends State<PayAtStorePanel> {
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
            label: "Pay At Store",
            labelStyle: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.w500),
            value: widget.orderModel!.payAtStore ?? false,
            onChangeHandler: (value) {
              widget.orderModel!.payAtStore = value;
            },
          ),
        ],
      ),
    );
  }
}
