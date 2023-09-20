import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';

class CategoryTotalOrdersWidget extends StatefulWidget {
  final Map<String, dynamic>? categoryData;
  final Function? onTapHandler;

  CategoryTotalOrdersWidget({
    @required this.categoryData,
    this.onTapHandler,
  });

  @override
  _CategoryTotalOrdersWidgetState createState() => _CategoryTotalOrdersWidgetState();
}

class _CategoryTotalOrdersWidgetState extends State<CategoryTotalOrdersWidget> {
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
    return GestureDetector(
      onTap: () {
        if (widget.onTapHandler != null) {
          widget.onTapHandler!();
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 10),
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 8)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(heightDp! * 8),
            border: null,
          ),
          child: widget.categoryData!.isEmpty ? _shimmerWidget() : _orderWidget(),
        ),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: true,
      period: Duration(milliseconds: 1000),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "OrderID",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "2021-04-05",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              ),
            ],
          ),
          Divider(height: heightDp! * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "User Name:",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "Userfirst  last Name:",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp! * 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "User Mobile:",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "123456780",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              ),
            ],
          ),
          Divider(height: heightDp! * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

          ///
          Column(
            children: [
              SizedBox(height: heightDp! * 5),
              Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Order Type: ",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "orderType",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          Column(
            children: [
              SizedBox(height: heightDp! * 5),
              Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Order Type: ",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "orderType",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp! * 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "To Pay: ",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "₹ 1375.23",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              ),
            ],
          ),

          SizedBox(height: heightDp! * 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Order Status: ",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "orderStatus ",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              ),
            ],
          ),

          Divider(height: heightDp! * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KeicyRaisedButton(
                width: widthDp! * 100,
                height: heightDp! * 30,
                color: Colors.white,
                borderRadius: heightDp! * 8,
                child: Text(
                  "Accept",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
                ),
                onPressed: () {
                  ///
                },
              ),
              KeicyRaisedButton(
                width: widthDp! * 100,
                height: heightDp! * 30,
                color: Colors.white,
                borderRadius: heightDp! * 8,
                child: Text(
                  "Reject",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
                ),
                onPressed: () {
                  ///
                },
              ),
              KeicyRaisedButton(
                width: widthDp! * 120,
                height: heightDp! * 30,
                color: Colors.white,
                borderRadius: heightDp! * 8,
                padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_forward_ios, size: heightDp! * 15, color: Colors.transparent),
                    Text(
                      "To detail",
                      style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
                    ),
                    Icon(Icons.arrow_forward_ios, size: heightDp! * 15, color: Colors.white),
                  ],
                ),
                onPressed: () {
                  ///
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderWidget() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(heightDp! * 6),
          child: Image.asset(
            "img/category-icon/${widget.categoryData!["category"]["categoryId"].toString().toLowerCase()}-icon.png",
            width: widthDp! * 50,
            height: widthDp! * 50,
          ),
        ),
        // KeicyAvatarImage(
        //   url: widget.categoryData["categoryIconUrl"],
        //   width: widthDp * 50,
        //   height: widthDp * 50,
        //   backColor: Colors.grey.withOpacity(0.4),
        //   borderRadius: heightDp * 6,
        // ),
        SizedBox(width: widthDp! * 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.categoryData!["category"]["categoryDesc"]}",
                style: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Container(
          height: widthDp! * 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${widget.categoryData!["totalOrderCount"]}",
                    style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: widthDp! * 5),
                  Text(
                    "Orders",
                    style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "₹ ${widget.categoryData!["totalPrice"]}",
                    style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
