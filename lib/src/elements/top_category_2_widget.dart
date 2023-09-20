library keicy_text_form_field;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/pages/SearchPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class TopCategory2Widget extends StatelessWidget {
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
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!);
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!);
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!.sublist(1));
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!.sublist(3));
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!.sublist(3));
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!.sublist(3));
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!.sublist(3));
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!.sublist(3));
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!.sublist(3));
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!.sublist(3));
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!.sublist(3));
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!);
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!);
    // categoryList.addAll(_appDataProvider!.appDataState.categoryList!);

    double imageWidth = widthDp * 50;
    double imageHeight = widthDp * 50;
    double cardWidth = widthDp * 120;
    double cardHeight = heightDp * 140;
    double mainAxisSpacing = widthDp * 10;
    double crossAxisSpacing = heightDp * 10;

    return Column(
      children: [
        SizedBox(height: heightDp * 20),
        Container(
          // height: heightDp * 360,
          width: deviceWidth,
          height: categoryList.length <= 3
              ? cardHeight + heightDp * 5
              : categoryList.length <= 6
                  ? cardHeight * 2 + crossAxisSpacing + heightDp * 5
                  : cardHeight * 3 + crossAxisSpacing * 2 + heightDp * 5,
          alignment: Alignment.center,
          child: GridView.builder(
            physics: categoryList.length <= 9 ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
            scrollDirection: categoryList.length <= 9 ? Axis.vertical : Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: categoryList.length <= 9 ? cardWidth / cardHeight : cardHeight / cardWidth,
            ),
            padding: EdgeInsets.zero,
            itemCount: categoryList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Map<String, dynamic> categoryData = categoryList[index];

              return GestureDetector(
                onTap: () {
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
                  child: Card(
                    shadowColor: Colors.black.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 6)),
                    elevation: 3,
                    // margin: EdgeInsets.zero,
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: widthDp * 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(heightDp * 6),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            child: Image.asset(
                              "img/category-icon/${categoryData["categoryId"].toString().toLowerCase()}-icon.png",
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // KeicyAvatarImage(
                          //   url: categoryData["categoryIconUrl"],
                          //   width: widthDp * 50,
                          //   height: widthDp * 50,
                          //   backColor: Colors.grey.withOpacity(0.4),
                          //   userName: "  ",
                          // ),
                          Expanded(
                            child: Center(
                              child: Text(
                                categoryData["categoryDesc"],
                                style: TextStyle(
                                  fontSize: fontSp * 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
