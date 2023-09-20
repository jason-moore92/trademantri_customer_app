import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'keicy_dropdown_form_field.dart';

class OrderGraphWidget extends StatefulWidget {
  final String storeCategoryId;

  OrderGraphWidget({this.storeCategoryId = ""});

  @override
  _OrderGraphWidgetState createState() => _OrderGraphWidgetState();
}

class _OrderGraphWidgetState extends State<OrderGraphWidget> {
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

  String? filter;

  List<dynamic> orderData = [];
  Map<DateTime, dynamic> orderGraphata = Map<DateTime, dynamic>();

  double? graphPanelWidth;
  double? graphPanelHeight;

  double totalSales = 0;

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

    filter = "day";
    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  void _dotsData() {
    orderGraphata = Map<DateTime, dynamic>();
    totalSales = 0;
    if (filter == "day") {
      for (var j = 0; j < 7; j++) {
        DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - (6 - j));
        DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1 - (6 - j));
        if (orderGraphata[startDate] == null) orderGraphata[startDate] = Map<String, dynamic>();
        for (var i = 0; i < orderData.length; i++) {
          DateTime orderDate = DateTime.tryParse(orderData[i]["updatedAt"])!.toLocal();
          if (orderDate.isAfter(startDate) && orderDate.isBefore(endDate)) {
            if (orderGraphata[startDate]["toPay"] == null) orderGraphata[startDate]["toPay"] = 0;
            if (orderGraphata[startDate]["totalQuantity"] == null) orderGraphata[startDate]["totalQuantity"] = 0;
            if (orderGraphata[startDate]["totalOrders"] == null) orderGraphata[startDate]["totalOrders"] = 0;
            orderGraphata[startDate]["toPay"] += orderData[i]["PaymentDetail"]["toPay"];
            orderGraphata[startDate]["totalQuantity"] += orderData[i]["PaymentDetail"]["totalQuantity"];
            orderGraphata[startDate]["totalOrders"] += 1;
            totalSales += orderData[i]["PaymentDetail"]["toPay"];
          }
        }
      }
    } else if (filter == "week") {
      for (var j = 0; j < 7; j++) {
        DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - (7 - j) * 7 + 1);
        DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - (6 - j) * 7 + 1);
        if (orderGraphata[startDate] == null) orderGraphata[startDate] = Map<String, dynamic>();
        for (var i = 0; i < orderData.length; i++) {
          DateTime orderDate = DateTime.tryParse(orderData[i]["updatedAt"])!.toLocal();
          if (orderDate.isAfter(startDate) && orderDate.isBefore(endDate)) {
            if (orderGraphata[startDate]["toPay"] == null) orderGraphata[startDate]["toPay"] = 0;
            if (orderGraphata[startDate]["totalQuantity"] == null) orderGraphata[startDate]["totalQuantity"] = 0;
            if (orderGraphata[startDate]["totalOrders"] == null) orderGraphata[startDate]["totalOrders"] = 0;
            orderGraphata[startDate]["toPay"] += orderData[i]["PaymentDetail"]["toPay"];
            orderGraphata[startDate]["totalQuantity"] += orderData[i]["PaymentDetail"]["totalQuantity"];
            orderGraphata[startDate]["totalOrders"] += 1;
            totalSales += orderData[i]["PaymentDetail"]["toPay"];
          }
        }
      }
    } else if (filter == "month") {
      for (var j = 0; j < 7; j++) {
        DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month - (6 - j), 1);
        DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1 - (6 - j), 1);
        if (orderGraphata[startDate] == null) orderGraphata[startDate] = Map<String, dynamic>();
        for (var i = 0; i < orderData.length; i++) {
          DateTime orderDate = DateTime.tryParse(orderData[i]["updatedAt"])!.toLocal();
          if (orderDate.isAfter(startDate) && orderDate.isBefore(endDate)) {
            if (orderGraphata[startDate]["toPay"] == null) orderGraphata[startDate]["toPay"] = 0;
            if (orderGraphata[startDate]["totalQuantity"] == null) orderGraphata[startDate]["totalQuantity"] = 0;
            if (orderGraphata[startDate]["totalOrders"] == null) orderGraphata[startDate]["totalOrders"] = 0;
            orderGraphata[startDate]["toPay"] += orderData[i]["PaymentDetail"]["toPay"];
            orderGraphata[startDate]["totalQuantity"] += orderData[i]["PaymentDetail"]["totalQuantity"];
            orderGraphata[startDate]["totalOrders"] += 1;
            totalSales += orderData[i]["PaymentDetail"]["toPay"];
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    graphPanelWidth = widthDp! * 370;
    graphPanelHeight = heightDp! * 280;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 10)),
      margin: EdgeInsets.only(left: widthDp! * 20, right: widthDp! * 20, top: heightDp! * 3, bottom: heightDp! * 17),
      child: Container(
        width: graphPanelWidth,
        height: graphPanelHeight,
        padding: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 15),
        child: StreamBuilder<dynamic>(
          stream: Stream.fromFuture(
            OrderApiProvider.getGraphDataByUser(
              userId: AuthProvider.of(context).authState.userModel!.id,
              filter: filter,
              storeCategoryId: widget.storeCategoryId,
            ),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CupertinoActivityIndicator());
            if (snapshot.data == null)
              return Center(
                child: Text("Sometimes was Wrong", style: TextStyle(fontSize: fontSp! * 20)),
              );

            orderData = snapshot.data["data"];

            _dotsData();

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("OverView", style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w500)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("₹ ${numFormat.format(totalSales)}",
                                style: TextStyle(fontSize: fontSp! * 20, color: Colors.black, fontWeight: FontWeight.bold)),
                            SizedBox(width: widthDp! * 10),
                            Text("Total Values", style: TextStyle(fontSize: fontSp! * 16, color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                    KeicyDropDownFormField(
                      width: widthDp! * 100,
                      height: heightDp! * 35,
                      menuItems: AppConfig.orderDataFilter,
                      value: filter,
                      selectedItemStyle: TextStyle(fontSize: fontSp! * 14, color: Colors.black, height: 1),
                      border: Border.all(),
                      borderRadius: heightDp! * 3,
                      onChangeHandler: (value) {
                        setState(() {
                          filter = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: heightDp! * 20),
                Expanded(
                  child: GraphWidget(
                    orderGraphata: orderGraphata,
                    graphPanelWidth: graphPanelWidth,
                    graphPanelHeight: graphPanelHeight,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class GraphWidget extends StatefulWidget {
  final Map<DateTime, dynamic>? orderGraphata;
  final double? graphPanelWidth;
  final double? graphPanelHeight;

  GraphWidget({
    @required this.orderGraphata,
    @required this.graphPanelWidth,
    @required this.graphPanelHeight,
  });

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
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

  List<int> showingIndicators = [];
  List<FlSpot> orderSpots = [];
  double? minValue;
  double? maxValue;
  int? _currentDotIndex;
  List<double>? rightTiles;
  List<String>? bottomTitles;
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

  void _graphData() {
    showingIndicators = [];
    rightTiles = [];
    bottomTitles = [];
    orderSpots = [];
    minValue = 0;
    maxValue = null;
    int i = 0;
    widget.orderGraphata!.forEach((date, paymentData) {
      double toPayValue = (paymentData.isEmpty ? 0 : double.parse(paymentData["toPay"].toString()));
      orderSpots.add(FlSpot(i.toDouble(), toPayValue));
      showingIndicators.add(i);
      if (maxValue == null) maxValue = toPayValue;
      if (maxValue! < toPayValue) {
        maxValue = toPayValue;
      }
      i++;
      bottomTitles!.add(
        KeicyDateTime.convertDateTimeToDateString(
          dateTime: date,
          formats: "d M\nY",
          isUTC: false,
        ),
      );
    });

    if (_currentDotIndex == null) _currentDotIndex = orderSpots.length - 1;

    for (var i = 0; i < 4; i++) {
      if (i == 0)
        rightTiles!.add(minValue!);
      else if (i == 3)
        rightTiles!.add(maxValue!);
      else {
        rightTiles!.add(minValue! + (maxValue! - minValue!) / 3 * i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _graphData();

    List<LineChartBarData> lineBarsData = [
      LineChartBarData(
        showingIndicators: showingIndicators, // tooltip will always show
        isStepLineChart: false,
        spots: orderSpots,
        isCurved: false,
        barWidth: 2,
        colors: [config.Colors().mainColor(1)],
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: heightDp! * 3,
              color: config.Colors().mainColor(1),
              strokeWidth: heightDp! * 3,
              strokeColor: config.Colors().mainColor(1),
            );
          },
          checkToShowDot: (spot, barData) {
            return spot.x == _currentDotIndex;
          },
        ),
        belowBarData: BarAreaData(
          show: false,
          // gradientColorStops: [0.5, 1.0],
          // gradientFrom: const Offset(0, 0),
          // gradientTo: const Offset(0, 1),
          colors: [Colors.transparent],
          spotsLine: BarAreaSpotsLine(
            show: true,
            flLineStyle: FlLine(
              color: config.Colors().mainColor(1),
              strokeWidth: 2,
            ),
            checkToShowSpotLine: (spot) {
              if (spot.x == _currentDotIndex) {
                return true;
              }

              return false;
            },
          ),
        ),
      ),
    ];

    return Container(
      width: widget.graphPanelWidth,
      height: widget.graphPanelHeight,
      child: Row(
        children: [
          _rightTitles(),
          SizedBox(width: widthDp! * 10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        enabled: false,
                        handleBuiltInTouches: true,
                        // fullHeightTouchLine: false,
                        getTouchLineStart: (barData, index) => -double.infinity, // default: from bottom,
                        getTouchLineEnd: (barData, index) => double.infinity, //to top,
                        // touchTooltipData: LineTouchTooltipData(
                        //   tooltipBgColor: Color(0xFF8B8B8B),
                        //   tooltipRoundedRadius: heightDp * 5,
                        //   fitInsideHorizontally: false,
                        //   length: orderSpots.length,
                        //   tooltipPadding: EdgeInsets.symmetric(
                        //     horizontal: widthDp * 5,
                        //     vertical: heightDp * 7,
                        //   ),
                        //   getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                        //     return lineBarsSpot.map((lineBarSpot) {
                        //       return LineTooltipItem(
                        //         children: [
                        //           TextSpan(
                        //             text: 'sf',
                        //             style: TextStyle(
                        //               fontFamily: "Avenir-Black",
                        //               color: Colors.white,
                        //               fontSize: fontSp * 15,
                        //             ),
                        //           ),
                        //           TextSpan(
                        //             text: "data",
                        //             style: TextStyle(
                        //               fontFamily: "Avenir-Black",
                        //               color: Colors.white,
                        //               fontSize: fontSp * 9,
                        //               height: 1,
                        //             ),
                        //           ),
                        //           TextSpan(
                        //             text: '\nPNL   ',
                        //             style: TextStyle(
                        //               fontFamily: "Avenir-Black",
                        //               color: Colors.white,
                        //               fontSize: fontSp * 10,
                        //               height: 1.5,
                        //             ),
                        //           ),
                        //         ],
                        //       );
                        //     }).toList();
                        //   },
                        // ),
                        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                          return spotIndexes.map((index) {
                            return TouchedSpotIndicatorData(
                              FlLine(
                                color: Colors.transparent,
                                strokeWidth: 2,
                              ),
                              FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: heightDp! * 3,
                                    color: config.Colors().mainColor(1),
                                    strokeWidth: heightDp! * 3,
                                    strokeColor: config.Colors().mainColor(1),
                                  );
                                },
                              ),
                            );
                          }).toList();
                        },
                        touchCallback: (LineTouchResponse lineTouch) {
                          // if (lineTouch.lineBarSpots!.length == 1 && lineTouch.touchInput is! FlLongPressEnd && lineTouch.touchInput is! FlPanEnd) {
                          if (lineTouch.lineBarSpots!.length == 1 && lineTouch.clickHappened) {
                            setState(() {
                              _currentDotIndex = lineTouch.lineBarSpots![0].spotIndex;
                            });
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: lineBarsData,
                      minY: minValue,
                      maxY: maxValue,
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(showTitles: false),
                        leftTitles: SideTitles(showTitles: false),
                        rightTitles: SideTitles(showTitles: false),
                      ),
                      gridData: FlGridData(show: false),
                    ),
                  ),
                ),
                SizedBox(height: heightDp! * 10),
                _bottomTitles(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rightTitles() {
    return Container(
      height: widget.graphPanelHeight,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(rightTiles!.length, (index) {
                return Text(
                  numFormat.format(rightTiles![rightTiles!.length - 1 - index]),
                  style: TextStyle(
                    fontFamily: "Avenir-Black",
                    color: Colors.black,
                    fontSize: fontSp! * 10,
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: heightDp! * 10),
          Text(
            "09 May\n2021",
            style: TextStyle(
              fontFamily: "Avenir-Black",
              fontSize: fontSp! * 10,
              color: Colors.transparent,
              height: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _bottomTitles() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(bottomTitles!.length, (index) {
          return Text(
            bottomTitles![index],
            style: TextStyle(
              fontFamily: "Avenir-Black",
              fontSize: fontSp! * 10,
              color: Colors.black,
              height: 1,
            ),
            textAlign: TextAlign.center,
          );
        }),
      ),
    );
  }
}
