import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class CategoryBottomSheet extends StatefulWidget {
  String? categoryId;
  Function(String, String)? callback;

  CategoryBottomSheet({
    @required this.categoryId,
    @required this.callback,
  });

  @override
  _CategoryBottomSheetState createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
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

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  AppDataProvider? _appDataProvider;

  String businessType = "";

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

    _appDataProvider = AppDataProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight - statusbarHeight,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: deviceHeight / 2,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(heightDp * 20), topRight: Radius.circular(heightDp * 20)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchField(),
                SizedBox(height: heightDp * 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Category",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                      ),
                      SizedBox(height: heightDp * 10),
                      Expanded(
                        child: NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (notification) {
                            notification.disallowGlow();
                            return true;
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(_appDataProvider!.appDataState.categoryList!.length, (index) {
                                Map<String, dynamic> categoryData = _appDataProvider!.appDataState.categoryList![index];
                                if (_controller.text.isNotEmpty &&
                                    !categoryData["categoryId"].toString().toLowerCase().contains(_controller.text.toLowerCase())) {
                                  return SizedBox();
                                }
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      businessType = categoryData["catgeorybusinessType"];
                                      widget.categoryId = categoryData["categoryId"];
                                    });
                                  },
                                  title: Row(
                                    children: [
                                      Radio<String>(
                                        value: categoryData["categoryId"],
                                        groupValue: widget.categoryId,
                                        onChanged: (value) {
                                          setState(() {
                                            businessType = categoryData["catgeorybusinessType"];
                                            widget.categoryId = categoryData["categoryId"];
                                          });
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            businessType = categoryData["catgeorybusinessType"];
                                            widget.categoryId = categoryData["categoryId"];
                                          });
                                        },
                                        child: Text(
                                          "${categoryData["categoryDesc"]}",
                                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightDp * 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(primary: Colors.white),
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          widget.callback!(widget.categoryId!, businessType);
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: config.Colors().mainColor(1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 40)),
                        ),
                        child: Text(
                          "Done",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return KeicyTextFormField(
      controller: _controller,
      focusNode: _focusNode,
      width: null,
      height: heightDp * 50,
      border: Border.all(color: Colors.grey.withOpacity(0.6)),
      errorBorder: Border.all(color: Colors.grey.withOpacity(0.6)),
      borderRadius: heightDp * 6,
      contentHorizontalPadding: widthDp * 10,
      textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
      hintText: "Search store categories",
      prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
      suffixIcons: [
        GestureDetector(
          onTap: () {
            _controller.clear();
            setState(() {});
          },
          child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
        ),
      ],
      onFieldSubmittedHandler: (input) {
        FocusScope.of(context).requestFocus(FocusNode());

        setState(() {});
      },
    );
  }
}
