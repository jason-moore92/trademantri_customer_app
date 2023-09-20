import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoryWidget extends StatefulWidget {
  final Map<String, dynamic>? categoryData;
  final bool? loadingStatus;

  CategoryWidget({@required this.categoryData, @required this.loadingStatus});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
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
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////
  }

  @override
  Widget build(BuildContext context) {
    Widget shimmerWidet = Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Row(
        children: [
          Container(
            width: widthDp * 50,
            height: widthDp * 50,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightDp * 6)),
          ),
          SizedBox(width: widthDp * 15),
          Container(
            width: widthDp * 100,
            color: Colors.white,
            child: Text(
              "${widget.categoryData!["categoryDesc"]}",
              style: TextStyle(
                fontSize: fontSp * 11,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    Widget categoryWidget = Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(heightDp * 6),
          child: Image.asset(
            "img/category-icon/${widget.categoryData!["categoryId"].toString().toLowerCase()}-icon.png",
            width: widthDp * 50,
            height: widthDp * 50,
          ),
        ),
        // KeicyAvatarImage(
        //   url: widget.categoryData!["categoryIconUrl"],
        //   width: widthDp * 50,
        //   height: widthDp * 50,
        //   backColor: Colors.grey.withOpacity(0.4),
        //   borderRadius: heightDp * 6,
        // ),
        SizedBox(width: widthDp * 15),
        Text(
          "${widget.categoryData!["categoryDesc"]}",
          style: TextStyle(
            fontSize: fontSp * 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      color: Colors.transparent,
      child: widget.loadingStatus! ? shimmerWidet : categoryWidget,
    );
  }
}
