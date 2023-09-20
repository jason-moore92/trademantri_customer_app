import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/category_widget.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'index.dart';

class SearchCategoryView extends StatefulWidget {
  SearchCategoryView({Key? key}) : super(key: key);

  @override
  _SearchCategoryViewState createState() => _SearchCategoryViewState();
}

class _SearchCategoryViewState extends State<SearchCategoryView> {
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

  CategoryProvider? _categoryProvider;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<String> _selectedCategoryType = ["store", "services"];
  Map<String, dynamic>? _selectedCategoryData;

  bool _useserch = false;

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

    _categoryProvider = CategoryProvider.of(context);

    _useserch = false;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_useserch && _controller.text.isNotEmpty) {
      _selectedCategoryType = [];
      for (var i = 0; i < ["store", "services"].length; i++) {
        String businessType = ["store", "services"][i];
        for (var j = 0; j < _categoryProvider!.categoryState.categoryData![businessType].length; j++) {
          Map<String, dynamic> categoryData = _categoryProvider!.categoryState.categoryData![businessType][j];
          if (categoryData["categoryDesc"].toString().toLowerCase().contains(_controller.text.trim().toLowerCase()) &&
              !_selectedCategoryType.contains(categoryData["catgeorybusinessType"])) {
            _selectedCategoryType.add(categoryData["catgeorybusinessType"]);
          }
        }
      }
    } else if (_useserch && _controller.text.isEmpty) {
      _selectedCategoryType = ["store", "services"];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop(_selectedCategoryData);
          },
        ),
        centerTitle: true,
        title: Text("Select Category", style: TextStyle(fontSize: fontSp * 20, color: Colors.black)),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            child: Container(
              width: deviceWidth,
              height: deviceHeight - statusbarHeight - appbarHeight,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _searchField(),
                  SizedBox(height: heightDp * 10),
                  _checkboxPanel(),
                  SizedBox(height: heightDp * 10),
                  Expanded(
                    child: _categoryListPanel(),
                  ),
                  SizedBox(height: heightDp * 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 25),
      child: KeicyTextFormField(
        controller: _controller,
        focusNode: _focusNode,
        width: null,
        height: heightDp * 50,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: heightDp * 6,
        contentHorizontalPadding: widthDp * 10,
        textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
        hintText: SearchCategoryPageString.searchCategogryHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _useserch = true;
              _selectedCategoryData = null;
              _controller.clear();
              setState(() {});
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onChangeHandler: (input) {
          _useserch = true;
          _selectedCategoryData = null;
          // FocusScope.of(context).requestFocus(FocusNode());
          setState(() {});
        },
      ),
    );
  }

  Widget _checkboxPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          KeicyCheckBox(
            iconSize: heightDp * 25,
            value: _selectedCategoryType.contains("store"),
            iconColor: config.Colors().mainColor(1),
            label: "store",
            labelStyle: TextStyle(fontSize: fontSp * 20, color: Colors.black),
            labelSpacing: widthDp * 10,
            onChangeHandler: (value) {
              _useserch = false;
              _selectedCategoryData = null;
              if (value) {
                _selectedCategoryType.add("store");
              } else {
                _selectedCategoryType.remove("store");
              }
              setState(() {});
            },
          ),
          KeicyCheckBox(
            iconSize: heightDp * 25,
            value: _selectedCategoryType.contains("services"),
            iconColor: config.Colors().mainColor(1),
            label: "services",
            labelStyle: TextStyle(fontSize: fontSp * 20, color: Colors.black),
            labelSpacing: widthDp * 10,
            onChangeHandler: (value) {
              _useserch = false;
              _selectedCategoryData = null;
              if (value) {
                _selectedCategoryType.add("services");
              } else {
                _selectedCategoryType.remove("services");
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _categoryListPanel() {
    List<Map<String, dynamic>> categoryList = [];

    for (var i = 0; i < _selectedCategoryType.length; i++) {
      String businessType = _selectedCategoryType[i];
      for (var j = 0; j < _categoryProvider!.categoryState.categoryData![businessType].length; j++) {
        if (_controller.text.isNotEmpty) {
          String desc = _categoryProvider!.categoryState.categoryData![businessType][j]["categoryDesc"].toString().toLowerCase();
          String input = _controller.text.trim().toLowerCase();
          if (desc.contains(input)) {
            categoryList.add(_categoryProvider!.categoryState.categoryData![businessType][j]);
          }
        } else {
          categoryList.add(_categoryProvider!.categoryState.categoryData![businessType][j]);
        }
      }
    }

    categoryList.sort((a, b) {
      return a["categoryDesc"].compareTo(b["categoryDesc"]);
    });

    return ListView.separated(
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> categoryData = categoryList[index];

        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(categoryData);
            // setState(() {
            //   _selectedCategoryData = categoryData;
            // });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: heightDp * 5),
            color: _selectedCategoryData != null && _selectedCategoryData!["categoryId"] == categoryData["categoryId"]
                ? config.Colors().mainColor(0.1)
                : Colors.transparent,
            child: CategoryWidget(
              categoryData: categoryData,
              loadingStatus: false,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.grey.withOpacity(0.4), height: 1, thickness: 1);
      },
    );
  }
}
