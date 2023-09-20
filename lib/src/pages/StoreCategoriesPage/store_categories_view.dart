import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/category_widget.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/pages/SearchPage/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class StoreCategoriesView extends StatefulWidget {
  final bool? forSelection;
  final bool? onlyStore;

  StoreCategoriesView({Key? key, this.forSelection, this.onlyStore}) : super(key: key);

  @override
  _StoreCategoriesViewState createState() => _StoreCategoriesViewState();
}

class _StoreCategoriesViewState extends State<StoreCategoriesView> {
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

  AppDataProvider? _appDataProvider;
  StoreCategoriesProvider? _storeCategoriesProvider;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

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
    _storeCategoriesProvider = StoreCategoriesProvider.of(context);

    _storeCategoriesProvider!.setStoreCategoriesState(
      _storeCategoriesProvider!.searchState.update(
        categoryList: _appDataProvider!.appDataState.categoryList,
      ),
      isNotifiable: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getCategoryHandler(String searchKey) {
    _storeCategoriesProvider!.setStoreCategoriesState(_storeCategoriesProvider!.searchState.update(progressState: 1));

    _storeCategoriesProvider!.getCategoryList(
      appDataProvider: _appDataProvider,
      distance: _appDataProvider!.appDataState.distance,
      currentLocation: _appDataProvider!.appDataState.currentLocation!,
      searchKey: searchKey,
      userId: AuthProvider.of(context).authState.userModel!.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Store Categories",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
      ),
      body: Consumer<StoreCategoriesProvider>(builder: (context, storeCategoriesProvider, _) {
        return GestureDetector(
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
                    _savedStoreCategoriesTextList(),
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
        );
      }),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 25),
      child: KeicyTextFormField(
        controller: _controller,
        focusNode: _focusNode,
        width: null,
        autofocus: true,
        height: heightDp * 50,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: heightDp * 6,
        contentHorizontalPadding: widthDp * 10,
        textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
        hintText: StoreCategoriesPageString.searchCategogryHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              _getCategoryHandler("");
              setState(() {});
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _getCategoryHandler(input.trim());
          setState(() {});
        },
      ),
    );
  }

  Widget _savedStoreCategoriesTextList() {
    List<dynamic> _categoryStoreCategoriesKeywords = _appDataProvider!.prefs!.getString("category_search_keywords") == null
        ? []
        : json.decode(_appDataProvider!.prefs!.getString("category_search_keywords")!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: heightDp * 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
          child: Wrap(
            spacing: widthDp * 15,
            runSpacing: heightDp * 15,
            children: List.generate(
              _categoryStoreCategoriesKeywords.length,
              (index) {
                if (_categoryStoreCategoriesKeywords[index] == "") return SizedBox();

                return GestureDetector(
                  onTap: () {
                    _controller.text = _categoryStoreCategoriesKeywords[index];
                    FocusScope.of(context).requestFocus(FocusNode());
                    _getCategoryHandler(_controller.text);
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(heightDp * 15),
                    ),
                    child: Text(
                      _categoryStoreCategoriesKeywords[index],
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: heightDp * 10),
        Divider(height: heightDp * 20, thickness: heightDp * 10, color: Colors.grey.withOpacity(0.3)),
      ],
    );
  }

  Widget _categoryListPanel() {
    bool loadingStatus = false;

    if (_storeCategoriesProvider!.searchState.progressState == 1) {
      loadingStatus = true;
    }

    return ListView.separated(
      itemCount: loadingStatus ? AppConfig.countLimitForList : _storeCategoriesProvider!.searchState.categoryList!.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> categoryData = loadingStatus ? Map<String, dynamic>() : _storeCategoriesProvider!.searchState.categoryList![index];

        return GestureDetector(
          onTap: () {
            if (widget.forSelection!) {
              Navigator.of(context).pop(categoryData);
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchPage(
                    categoryData: categoryData,
                    isFromCategory: true,
                    forSelection: widget.forSelection!,
                    onlyStore: widget.onlyStore!,
                  ),
                ),
              );
            }
          },
          child: CategoryWidget(categoryData: categoryData, loadingStatus: loadingStatus),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.grey.withOpacity(0.4));
      },
    );
  }
}
