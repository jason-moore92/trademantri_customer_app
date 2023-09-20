import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/models/index.dart';

class OrderStatusStepsWidget extends StatefulWidget {
  final OrderModel? orderModel;

  OrderStatusStepsWidget({@required this.orderModel});

  @override
  _OrderStatusStepsWidgetState createState() => _OrderStatusStepsWidgetState();
}

class _OrderStatusStepsWidgetState extends State<OrderStatusStepsWidget> {
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

  List<dynamic> statusList = [];

  @override
  Widget build(BuildContext context) {
    double stepWidth = widthDp! * 60;
    if (widget.orderModel!.orderHistorySteps!.length + widget.orderModel!.orderFutureSteps!.length == 6) {
      stepWidth = widthDp! * 65;
    } else if (widget.orderModel!.orderHistorySteps!.length + widget.orderModel!.orderFutureSteps!.length == 5) {
      stepWidth = widthDp! * 70;
    } else {
      stepWidth = widthDp! * 90;
    }

    double circularSize = widthDp! * 35;
    double indent = (deviceWidth! - stepWidth * (widget.orderModel!.orderHistorySteps!.length + widget.orderModel!.orderFutureSteps!.length)) / 2 +
        (stepWidth - circularSize) / 2;
    double indent1 = (deviceWidth! - stepWidth * (widget.orderModel!.orderFutureSteps!.length + 1));
    if (indent < 0) indent = 0;
    if (indent1 < 0) indent1 = 0;

    return Column(
      children: [
        ///
        Stack(
          children: [
            Divider(
              height: circularSize,
              thickness: 2,
              color: Colors.green,
              indent: indent,
              endIndent: indent,
            ),
            Center(
              child: Container(
                width: stepWidth * (widget.orderModel!.orderHistorySteps!.length + widget.orderModel!.orderFutureSteps!.length),
                color: Colors.transparent,
                child: Divider(
                  height: circularSize,
                  thickness: 2,
                  color: Colors.grey,
                  indent: indent1,
                  endIndent: (stepWidth - circularSize) / 2,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(widget.orderModel!.orderHistorySteps!.length + widget.orderModel!.orderFutureSteps!.length, (index) {
                if (index < widget.orderModel!.orderHistorySteps!.length) {
                  return Container(
                    width: stepWidth,
                    child: Container(
                      width: circularSize,
                      height: circularSize,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.orderModel!.orderHistorySteps![index]["text"] == "Order Cancelled" ||
                                  widget.orderModel!.orderHistorySteps![index]["text"] == "Order Rejected"
                              ? Colors.red
                              : Colors.green,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                        color: widget.orderModel!.orderHistorySteps![index]["text"] == "Order Cancelled" ||
                                widget.orderModel!.orderHistorySteps![index]["text"] == "Order Rejected"
                            ? Colors.red
                            : Colors.green,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                          widget.orderModel!.orderHistorySteps![index]["text"] == "Order Cancelled" ||
                                  widget.orderModel!.orderHistorySteps![index]["text"] == "Order Rejected"
                              ? Icons.close
                              : Icons.check,
                          size: widthDp! * 25,
                          color: Colors.white),
                    ),
                  );
                } else {
                  return Container(
                    width: stepWidth,
                    child: Container(
                      width: circularSize,
                      height: circularSize,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.check, size: widthDp! * 25, color: Colors.transparent),
                    ),
                  );
                }
              }),
            ),
          ],
        ),

        ///
        SizedBox(
          height: heightDp! * 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.orderModel!.orderHistorySteps!.length + widget.orderModel!.orderFutureSteps!.length, (index) {
            if (index < widget.orderModel!.orderHistorySteps!.length) {
              return Container(
                width: stepWidth,
                child: Text(
                  "${widget.orderModel!.orderHistorySteps![index]["text"]}",
                  style: TextStyle(fontSize: fontSp! * 10, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Container(
                width: stepWidth,
                child: Text(
                  "${widget.orderModel!.orderFutureSteps![index - widget.orderModel!.orderHistorySteps!.length]["text"]}",
                  style: TextStyle(fontSize: fontSp! * 10, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}
