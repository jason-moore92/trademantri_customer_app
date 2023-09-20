library keicy_text_form_field;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/pages/SearchPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class TopCategory1Widget extends StatelessWidget {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  AppDataProvider? _appDataProvider;

  @override
  Widget build(BuildContext context) {
    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    ///////////////////////////////

    _appDataProvider = AppDataProvider.of(context);

    List<dynamic> categoryList = [];
    categoryList.addAll(_appDataProvider!.appDataState.categoryList!);
    // categoryList.addAll(_appDataProvider.appDataState.categoryList.sublist(1));
    // categoryList.addAll(_appDataProvider.appDataState.categoryList.sublist(1));
    // categoryList.addAll(_appDataProvider.appDataState.categoryList);

    double cardWidth = categoryList.length <= 2 ? widthDp * 170 : widthDp * 160;
    double cardHeight = cardWidth * 250 / 400;
    double mainAxisSpacing = widthDp * 20;
    double crossAxisSpacing = heightDp * 20;

    return Container(
      width: deviceWidth,
      height: categoryList.length <= 2 ? cardHeight : cardHeight * 2 + crossAxisSpacing,
      alignment: Alignment.center,
      child: GridView.builder(
        physics: categoryList.length <= 2 ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
        scrollDirection: categoryList.length <= 2 ? Axis.vertical : Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: 250 / 400,
        ),
        padding: EdgeInsets.zero,
        itemCount: categoryList.length > 6 ? 6 : categoryList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map<String, dynamic> categoryData = categoryList[index];

          return GestureDetector(
            onTap: () {
              // Navigator.of(context).pushNamed('/Pages', arguments: {
              //   "currentTab": 0,
              //   "categoryData": categoryData,
              // });

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchPage(
                    categoryData: categoryData,
                    onlyStore: false,
                  ),
                ),
              );
            },
            child: Container(
              width: cardWidth,
              height: cardHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(heightDp * 10),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(heightDp * 10),
                      child: Image.asset(
                        "img/category-image/${categoryData["categoryId"].toString().toLowerCase()}.png",
                        width: cardWidth,
                        height: cardHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // KeicyAvatarImage(
                    //   url: categoryData["categoryBigImageUrl"],
                    //   width: widthDp * 180,
                    //   height: widthDp * 180 * 250 / 400,
                    //   backColor: Colors.grey.withOpacity(0.4),
                    //   borderRadius: heightDp * 10,
                    //   errorWidget: Container(
                    //     width: widthDp * 180,
                    //   height: widthDp * 180 * 250 / 400,

                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.all(widthDp * 10),
                    //   child: Text(
                    //     "${categoryData["categoryDesc"]}",
                    //     style: TextStyle(
                    //       fontSize: fontSp * 18,
                    //       fontWeight: FontWeight.w900,
                    //       color: Colors.white,
                    //       letterSpacing: 1.5,
                    //       shadows: [
                    //         BoxShadow(color: Colors.black.withOpacity(0.3), offset: Offset(1, 3), blurRadius: 6),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
