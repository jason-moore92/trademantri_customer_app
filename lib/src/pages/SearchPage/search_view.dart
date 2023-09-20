import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/coupon_widget.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_item_widget.dart';
import 'package:trapp/src/elements/service_item_widget.dart';
import 'package:trapp/src/elements/store_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CouponDetailPage/coupon_detail_page.dart';
import 'package:trapp/src/pages/ProductItemDetailPage/index.dart';
import 'package:trapp/src/pages/StoreCategoriesPage/store_categories_page.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/providers/index.dart';

class SearchView extends StatefulWidget {
  final Map<String, dynamic>? categoryData;
  final bool isFromCategory;
  final bool forSelection;
  final bool? onlyStore;

  SearchView({
    Key? key,
    this.categoryData,
    this.isFromCategory = false,
    this.forSelection = false,
    this.onlyStore,
  }) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with SingleTickerProviderStateMixin {
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

  AuthProvider? _authProvider;
  AppDataProvider? _appDataProvider;
  SearchProvider? _searchProvider;

  List<RefreshController> _refreshControllerList = [];

  TabController? _tabController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int _oldTabIndex = 0;

  List<String> _categoires = ["Stores", "Products", "Services", "Coupons"];

  String? _type;

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

    _searchProvider = SearchProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _appDataProvider = AppDataProvider.of(context);

    _refreshControllerList = [];
    for (var i = 0; i < _categoires.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = _authProvider!.authState.loginState != LoginState.IsLogin ? 0 : 0;

    _tabController = TabController(length: _categoires.length, vsync: this);

    _tabController!.addListener(_tabControllerListener);

    _type = widget.categoryData!["categoryId"];

    if (_searchProvider!.searchState.storeList![_type] == null || _searchProvider!.searchState.storeList![_type]!.isEmpty) {
      _searchProvider!.setSearchState(
        _searchProvider!.searchState.update(progressState: 1),
        isNotifiable: false,
      );
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _searchProvider!.addListener(_searchProviderListener);

      if ((_searchProvider!.searchState.storeList![_type] == null || _searchProvider!.searchState.storeList![_type]!.isEmpty)) {
        _searchProvider!.getStoreList(
          categoryId: _type,
          location: _appDataProvider!.appDataState.currentLocation!["location"],
          distance: _appDataProvider!.appDataState.distance,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchProvider!.removeListener(_searchProviderListener);

    super.dispose();
  }

  void _searchProviderListener() async {
    try {
      if (_tabController!.index == 0) {
        if (_searchProvider!.searchState.progressState == -1) {
          if (_searchProvider!.searchState.isStoreRefresh!) {
            _refreshControllerList[_tabController!.index].refreshFailed();
            _searchProvider!.setSearchState(
              _searchProvider!.searchState.update(isStoreRefresh: false),
              isNotifiable: false,
            );
          } else {
            _refreshControllerList[_tabController!.index].loadFailed();
          }
        } else if (_searchProvider!.searchState.progressState == 2) {
          if (_searchProvider!.searchState.isStoreRefresh!) {
            _refreshControllerList[_tabController!.index].refreshCompleted();
            _searchProvider!.setSearchState(
              _searchProvider!.searchState.update(isStoreRefresh: false),
              isNotifiable: false,
            );
          } else {
            _refreshControllerList[_tabController!.index].loadComplete();
          }
        }
      }

      ///
      else if (_tabController!.index == 1) {
        if (_searchProvider!.searchState.progressState == -1) {
          if (_searchProvider!.searchState.isProductRefresh!) {
            _refreshControllerList[_tabController!.index].refreshFailed();
            _searchProvider!.setSearchState(
              _searchProvider!.searchState.update(isProductRefresh: false),
              isNotifiable: false,
            );
          } else {
            _refreshControllerList[_tabController!.index].loadFailed();
          }
        } else if (_searchProvider!.searchState.progressState == 2) {
          if (_searchProvider!.searchState.isProductRefresh!) {
            _refreshControllerList[_tabController!.index].refreshCompleted();
            _searchProvider!.setSearchState(
              _searchProvider!.searchState.update(isProductRefresh: false),
              isNotifiable: false,
            );
          } else {
            _refreshControllerList[_tabController!.index].loadComplete();
          }
        }
      }

      ///
      else if (_tabController!.index == 2) {
        if (_searchProvider!.searchState.progressState == -1) {
          if (_searchProvider!.searchState.isServiceRefresh!) {
            _refreshControllerList[_tabController!.index].refreshFailed();
            _searchProvider!.setSearchState(
              _searchProvider!.searchState.update(isServiceRefresh: false),
              isNotifiable: false,
            );
          } else {
            _refreshControllerList[_tabController!.index].loadFailed();
          }
        } else if (_searchProvider!.searchState.progressState == 2) {
          if (_searchProvider!.searchState.isServiceRefresh!) {
            _refreshControllerList[_tabController!.index].refreshCompleted();
            _searchProvider!.setSearchState(
              _searchProvider!.searchState.update(isServiceRefresh: false),
              isNotifiable: false,
            );
          } else {
            _refreshControllerList[_tabController!.index].loadComplete();
          }
        }
      }

      ///
      else if (_tabController!.index == 3) {
        if (_searchProvider!.searchState.progressState == -1) {
          if (_searchProvider!.searchState.isCouponRefresh!) {
            _refreshControllerList[_tabController!.index].refreshFailed();
            _searchProvider!.setSearchState(
              _searchProvider!.searchState.update(isCouponRefresh: false),
              isNotifiable: false,
            );
          } else {
            _refreshControllerList[_tabController!.index].loadFailed();
          }
        } else if (_searchProvider!.searchState.progressState == 2) {
          if (_searchProvider!.searchState.isCouponRefresh!) {
            _refreshControllerList[_tabController!.index].refreshCompleted();
            _searchProvider!.setSearchState(
              _searchProvider!.searchState.update(isCouponRefresh: false),
              isNotifiable: false,
            );
          } else {
            _refreshControllerList[_tabController!.index].loadComplete();
          }
        }
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "search_view",
        level: LogLevel.ERROR,
        subTag: "_searchProviderListener",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  void _tabControllerListener() {
    String category = _categoires[_tabController!.index].toLowerCase();

    if (category == "stores") {
      if ((_searchProvider!.searchState.progressState != 1) &&
          (_controller.text.isNotEmpty ||
              _searchProvider!.searchState.storeList![_type!] == null ||
              _searchProvider!.searchState.storeList![_type!].isEmpty)) {
        Map<String, dynamic> storeList = _searchProvider!.searchState.storeList!;
        Map<String, dynamic> storeMetaData = _searchProvider!.searchState.storeMetaData!;

        if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
          storeList[_type!] = [];
          storeMetaData[_type!] = Map<String, dynamic>();
        }

        _searchProvider!.setSearchState(
          _searchProvider!.searchState.update(
            progressState: 1,
            storeList: storeList,
            storeMetaData: storeMetaData,
          ),
          isNotifiable: false,
        );

        _controller.clear();
        _oldTabIndex = _tabController!.index;

        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          _searchProvider!.getStoreList(
            categoryId: _type,
            location: _appDataProvider!.appDataState.currentLocation!["location"],
            distance: _appDataProvider!.appDataState.distance,
            searchKey: _controller.text.trim(),
          );
        });
      }
    } else if (category == "products") {
      if ((_searchProvider!.searchState.progressState != 1) &&
          (_controller.text.isNotEmpty ||
              _searchProvider!.searchState.productList![_type!] == null ||
              _searchProvider!.searchState.productList![_type!].isEmpty)) {
        Map<String, dynamic> productList = _searchProvider!.searchState.productList!;
        Map<String, dynamic> productMetaData = _searchProvider!.searchState.productMetaData!;

        if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
          productList[_type!] = [];
          productMetaData[_type!] = Map<String, dynamic>();
        }

        _searchProvider!.setSearchState(
          _searchProvider!.searchState.update(
            progressState: 1,
            productList: productList,
            productMetaData: productMetaData,
          ),
          isNotifiable: false,
        );

        _controller.clear();
        _oldTabIndex = _tabController!.index;

        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          _searchProvider!.getProductList(
            categoryId: _type,
            location: _appDataProvider!.appDataState.currentLocation!["location"],
            distance: _appDataProvider!.appDataState.distance,
            searchKey: _controller.text.trim(),
          );
        });
      }
    } else if (category == "services") {
      if ((_searchProvider!.searchState.progressState != 1) &&
          (_controller.text.isNotEmpty ||
              _searchProvider!.searchState.serviceList![_type!] == null ||
              _searchProvider!.searchState.serviceList![_type!].isEmpty)) {
        Map<String, dynamic> serviceList = _searchProvider!.searchState.serviceList!;
        Map<String, dynamic> serviceMetaData = _searchProvider!.searchState.serviceMetaData!;

        if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
          serviceList[_type!] = [];
          serviceMetaData[_type!] = Map<String, dynamic>();
        }

        _searchProvider!.setSearchState(
          _searchProvider!.searchState.update(
            progressState: 1,
            serviceList: serviceList,
            serviceMetaData: serviceMetaData,
          ),
          isNotifiable: false,
        );

        _controller.clear();
        _oldTabIndex = _tabController!.index;

        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          _searchProvider!.getServiceList(
            categoryId: _type,
            location: _appDataProvider!.appDataState.currentLocation!["location"],
            distance: _appDataProvider!.appDataState.distance,
            searchKey: _controller.text.trim(),
          );
        });
      }
    } else if (category == "coupons") {
      if ((_searchProvider!.searchState.progressState != 1) &&
          (_controller.text.isNotEmpty ||
              _searchProvider!.searchState.couponList![_type!] == null ||
              _searchProvider!.searchState.couponList![_type!].isEmpty)) {
        Map<String, dynamic> couponList = _searchProvider!.searchState.couponList!;
        Map<String, dynamic> couponMetaData = _searchProvider!.searchState.couponMetaData!;

        if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
          couponList[_type!] = [];
          couponMetaData[_type!] = Map<String, dynamic>();
        }

        _searchProvider!.setSearchState(
          _searchProvider!.searchState.update(
            progressState: 1,
            couponList: couponList,
            couponMetaData: couponMetaData,
          ),
          isNotifiable: false,
        );

        _controller.clear();
        _oldTabIndex = _tabController!.index;

        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          _searchProvider!.getCouponList(
            categoryId: _type,
            location: _appDataProvider!.appDataState.currentLocation!["location"],
            distance: _appDataProvider!.appDataState.distance,
            searchKey: _controller.text.trim(),
          );
        });
      }
    }
    _oldTabIndex = _tabController!.index;
    setState(() {});
  }

  void _onRefresh() async {
    String category = _categoires[_tabController!.index].toLowerCase();

    if (category == "stores") {
      Map<String, dynamic> storeList = _searchProvider!.searchState.storeList!;
      Map<String, dynamic> storeMetaData = _searchProvider!.searchState.storeMetaData!;

      storeList[_type!] = [];
      storeMetaData[_type!] = Map<String, dynamic>();

      _searchProvider!.setSearchState(
        _searchProvider!.searchState.update(
          progressState: 1,
          storeList: storeList,
          storeMetaData: storeMetaData,
          isStoreRefresh: true,
        ),
      );
      _searchProvider!.getStoreList(
        categoryId: _type,
        location: _appDataProvider!.appDataState.currentLocation!["location"],
        distance: _appDataProvider!.appDataState.distance,
        searchKey: _controller.text.trim(),
      );
    } else if (category == "products") {
      Map<String, dynamic> productList = _searchProvider!.searchState.productList!;
      Map<String, dynamic> productMetaData = _searchProvider!.searchState.productMetaData!;

      productList[_type!] = [];
      productMetaData[_type!] = Map<String, dynamic>();

      _searchProvider!.setSearchState(
        _searchProvider!.searchState.update(
          progressState: 1,
          productList: productList,
          productMetaData: productMetaData,
          isProductRefresh: true,
        ),
      );
      _searchProvider!.getProductList(
        categoryId: _type,
        location: _appDataProvider!.appDataState.currentLocation!["location"],
        distance: _appDataProvider!.appDataState.distance,
        searchKey: _controller.text.trim(),
      );
    } else if (category == "services") {
      Map<String, dynamic> serviceList = _searchProvider!.searchState.serviceList!;
      Map<String, dynamic> serviceMetaData = _searchProvider!.searchState.serviceMetaData!;

      serviceList[_type!] = [];
      serviceMetaData[_type!] = Map<String, dynamic>();

      _searchProvider!.setSearchState(
        _searchProvider!.searchState.update(
          progressState: 1,
          serviceList: serviceList,
          serviceMetaData: serviceMetaData,
          isServiceRefresh: true,
        ),
      );
      _searchProvider!.getServiceList(
        categoryId: _type,
        location: _appDataProvider!.appDataState.currentLocation!["location"],
        distance: _appDataProvider!.appDataState.distance,
        searchKey: _controller.text.trim(),
      );
    } else if (category == "coupons") {
      Map<String, dynamic> couponList = _searchProvider!.searchState.couponList!;
      Map<String, dynamic> couponMetaData = _searchProvider!.searchState.couponMetaData!;

      couponList[_type!] = [];
      couponMetaData[_type!] = Map<String, dynamic>();

      _searchProvider!.setSearchState(
        _searchProvider!.searchState.update(
          progressState: 1,
          couponList: couponList,
          couponMetaData: couponMetaData,
          isCouponRefresh: true,
        ),
      );
      _searchProvider!.getCouponList(
        categoryId: _type,
        location: _appDataProvider!.appDataState.currentLocation!["location"],
        distance: _appDataProvider!.appDataState.distance,
        searchKey: _controller.text.trim(),
      );
    }
  }

  void _onLoading() async {
    String category = _categoires[_tabController!.index].toLowerCase();

    _searchProvider!.setSearchState(
      _searchProvider!.searchState.update(progressState: 1),
    );
    if (category == "stores") {
      _searchProvider!.getStoreList(
        categoryId: _type,
        location: _appDataProvider!.appDataState.currentLocation!["location"],
        distance: _appDataProvider!.appDataState.distance,
        searchKey: _controller.text.trim(),
      );
    } else if (category == "products") {
      _searchProvider!.getProductList(
        categoryId: _type,
        location: _appDataProvider!.appDataState.currentLocation!["location"],
        distance: _appDataProvider!.appDataState.distance,
        searchKey: _controller.text.trim(),
      );
    } else if (category == "services") {
      _searchProvider!.getServiceList(
        categoryId: _type,
        location: _appDataProvider!.appDataState.currentLocation!["location"],
        distance: _appDataProvider!.appDataState.distance,
        searchKey: _controller.text.trim(),
      );
    } else if (category == "coupons") {
      _searchProvider!.getCouponList(
        categoryId: _type,
        location: _appDataProvider!.appDataState.currentLocation!["location"],
        distance: _appDataProvider!.appDataState.distance,
        searchKey: _controller.text.trim(),
      );
    }
  }

  void _searchKeyFavoriteListHandler() {
    _onRefresh();
  }

  void _cartAndFavoriteUpdateHandler() {
    if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin && AuthProvider.of(context).authState.userModel!.id != null) {
      CartProvider.of(context).cartUpdateHandler(
        fcmToken: AuthProvider.of(context).authState.userModel!.fcmToken,
        userId: AuthProvider.of(context).authState.userModel!.id,
      );

      FavoriteProvider.of(context).favoriteUpdateHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _cartAndFavoriteUpdateHandler();
        if (!widget.forSelection) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => StoreCategoriesPage(onlyStore: widget.onlyStore),
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              _cartAndFavoriteUpdateHandler();
              if (!widget.forSelection) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => StoreCategoriesPage(onlyStore: widget.onlyStore),
                  ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          centerTitle: true,
          title: Text(
            "Search Page",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: Consumer<SearchProvider>(builder: (context, searchProvider, _) {
          return DefaultTabController(
            length: _categoires.length,
            child: Container(
              width: deviceWidth,
              height: deviceHeight,
              child: Column(
                children: [
                  _searchField(),
                  if (_authProvider!.authState.loginState != LoginState.IsLogin || widget.onlyStore!) SizedBox(height: heightDp * 5) else _tabBar(),
                  Expanded(child: _itemListPanel()),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
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
        hintText: "Search for name",
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyFavoriteListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyFavoriteListHandler();
        },
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      width: deviceWidth,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      ),
      alignment: Alignment.center,
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: Color(0xFF15D08E),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 15),
        labelStyle: TextStyle(fontSize: fontSp * 14),
        labelColor: Color(0xFF15D08E),
        unselectedLabelColor: Colors.black,
        tabs: List.generate(_categoires.length, (index) {
          return Tab(
            text: _categoires[index] == "store-job-postings" ? "Jobs" : "${_categoires[index]}",
          );
        }),
      ),
    );
  }

  Widget _itemListPanel() {
    String category = _categoires[_tabController!.index].toLowerCase();

    List<dynamic> itemList = [];
    Map<String, dynamic> itemMetaData = Map<String, dynamic>();
    int itemCount = 0;

    if (category == "stores") {
      if (_searchProvider!.searchState.storeList![_type] != null) {
        itemList = _searchProvider!.searchState.storeList![_type];
      }
      if (_searchProvider!.searchState.storeMetaData![_type] != null) {
        itemMetaData = _searchProvider!.searchState.storeMetaData![_type];
      }

      if (_searchProvider!.searchState.storeList![_type] != null) {
        List<dynamic> data = _searchProvider!.searchState.storeList![_type];
        itemCount += data.length;
      }

      if (_searchProvider!.searchState.progressState == 1) {
        itemCount += AppConfig.countLimitForList;
      }
    } else if (category == "products") {
      if (_searchProvider!.searchState.productList![_type] != null) {
        itemList = _searchProvider!.searchState.productList![_type];
      }
      if (_searchProvider!.searchState.productMetaData![_type] != null) {
        itemMetaData = _searchProvider!.searchState.productMetaData![_type];
      }

      if (_searchProvider!.searchState.productList![_type] != null) {
        List<dynamic> data = _searchProvider!.searchState.productList![_type];
        itemCount += data.length;
      }

      if (_searchProvider!.searchState.progressState == 1) {
        itemCount += AppConfig.countLimitForList;
      }
    } else if (category == "services") {
      if (_searchProvider!.searchState.serviceList![_type] != null) {
        itemList = _searchProvider!.searchState.serviceList![_type];
      }
      if (_searchProvider!.searchState.serviceMetaData![_type] != null) {
        itemMetaData = _searchProvider!.searchState.serviceMetaData![_type];
      }

      if (_searchProvider!.searchState.serviceList![_type] != null) {
        List<dynamic> data = _searchProvider!.searchState.serviceList![_type];
        itemCount += data.length;
      }

      if (_searchProvider!.searchState.progressState == 1) {
        itemCount += AppConfig.countLimitForList;
      }
    } else if (category == "coupons") {
      if (_searchProvider!.searchState.couponList![_type] != null) {
        itemList = _searchProvider!.searchState.couponList![_type];
      }
      if (_searchProvider!.searchState.serviceMetaData![_type] != null) {
        itemMetaData = _searchProvider!.searchState.serviceMetaData![_type];
      }

      if (_searchProvider!.searchState.couponList![_type] != null) {
        List<dynamic> data = _searchProvider!.searchState.couponList![_type];
        itemCount += data.length;
      }

      if (_searchProvider!.searchState.progressState == 1) {
        itemCount += AppConfig.countLimitForList;
      }
    }

    return Column(
      children: [
        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowGlow();
              return true;
            },
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: (itemMetaData["nextPage"] != null && _searchProvider!.searchState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshControllerList[_tabController!.index],
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No " +
                            (_tabController!.index == 0
                                ? "Store"
                                : _tabController!.index == 1
                                    ? "Product"
                                    : _tabController!.index == 2
                                        ? "Service"
                                        : _tabController!.index == 3
                                            ? "Coupon"
                                            : "") +
                            " Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> itemData = (index >= itemList.length) ? Map<String, dynamic>() : itemList[index];

                        switch (_tabController!.index) {
                          case 0:
                            return GestureDetector(
                              onTap: () {
                                if (itemData.isEmpty) return;
                                if (widget.forSelection) {
                                  Navigator.of(context).pop(itemData);
                                  return;
                                }

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => StorePage(storeModel: StoreModel.fromJson(itemData)),
                                  ),
                                );
                              },
                              child: StoreWidget(
                                storeModel: StoreModel.fromJson(itemData),
                                loadingStatus: itemData.isEmpty,
                              ),
                            );
                          case 1:
                            return GestureDetector(
                              onTap: () {
                                if (itemData.isEmpty) return;
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: ProductItemWidget(
                                  productModel: itemData.isEmpty ? null : ProductModel.fromJson(itemData),
                                  storeModel: itemData.isEmpty ? null : StoreModel.fromJson(itemData["store"]),
                                  isLoading: itemData.isEmpty,
                                  isShowStoreName: true,
                                  tapCallback: () async {
                                    _cartAndFavoriteUpdateHandler();

                                    var result = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => ProductItemDetailPage(
                                          storeModel: StoreModel.fromJson(itemData["store"]),
                                          productModel: ProductModel.fromJson(itemData),
                                          type: "products",
                                          isForCart: true,
                                        ),
                                      ),
                                    );

                                    if (result != null && result) {
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            );
                          case 2:
                            return GestureDetector(
                              onTap: () {
                                if (itemData.isEmpty) return;
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: ServiceItemWidget(
                                  serviceData: itemData,
                                  storeModel: itemData.isEmpty ? null : StoreModel.fromJson(itemData["store"]),
                                  isLoading: itemData.isEmpty,
                                  isShowStoreName: true,
                                  tapCallback: () async {
                                    _cartAndFavoriteUpdateHandler();

                                    var result = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => ProductItemDetailPage(
                                          storeModel: StoreModel.fromJson(itemData["store"]),
                                          serviceModel: ServiceModel.fromJson(itemData),
                                          type: "services",
                                          isForCart: true,
                                        ),
                                      ),
                                    );

                                    if (result != null && result) {
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            );
                          case 3:
                            return GestureDetector(
                              onTap: () {
                                if (itemData.isEmpty) return;
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: CouponWidget(
                                  couponModel: itemData.isEmpty ? null : CouponModel.fromJson(itemData),
                                  storeModel: itemData.isEmpty ? null : StoreModel.fromJson(itemData["store"]),
                                  isLoading: itemData.isEmpty,
                                  isGoToStore: true,
                                  isShowStoreName: true,
                                ),
                              ),
                            );
                          default:
                            return SizedBox();
                        }
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
