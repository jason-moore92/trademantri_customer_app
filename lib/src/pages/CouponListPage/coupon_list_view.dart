import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/error_dialog.dart';
import 'package:trapp/src/elements/coupon_for_order_widget.dart';
import 'package:trapp/src/elements/coupon_widget.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CouponDetailPage/coupon_detail_page.dart';
import 'package:trapp/src/pages/ErrorPage/error_page.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'index.dart';

class CouponListView extends StatefulWidget {
  final StoreModel? storeModel;
  final CouponModel? selectedCoupon;
  final OrderModel? orderModel;
  final List<dynamic>? productCategories;
  final List<dynamic>? serviceCategories;
  final List<dynamic>? productIds;
  final List<dynamic>? serviceIds;
  final bool isForOrder;

  CouponListView({
    Key? key,
    this.storeModel,
    this.orderModel,
    this.selectedCoupon,
    this.isForOrder = false,
    this.productCategories,
    this.serviceCategories,
    this.productIds,
    this.serviceIds,
  }) : super(key: key);

  @override
  _CouponListViewState createState() => _CouponListViewState();
}

class _CouponListViewState extends State<CouponListView> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  CouponListProvider? _couponListProvider;

  List<RefreshController> _refreshControllerList = [];
  List<String> _categoryList = ["Active", "Used", "Future", "Expired"];

  TabController? _tabController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int _oldTabIndex = 0;

  KeicyProgressDialog? _keicyProgressDialog;

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

    _couponListProvider = CouponListProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshControllerList = [];

    _oldTabIndex = 0;

    _couponListProvider!.setCouponListState(
      _couponListProvider!.couponState.update(
        progressState: 0,
        couponListData: Map<String, dynamic>(),
        couponMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    _tabController = TabController(length: _categoryList.length, vsync: this);

    for (var i = 0; i < _categoryList.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _couponListProvider!.addListener(_couponListProviderListener);
      _tabController!.addListener(_tabControllerListener);

      _couponListProvider!.setCouponListState(
        _couponListProvider!.couponState.update(progressState: 1),
      );

      _couponListProvider!.getCouponListData(
        storeId: widget.storeModel!.id,
        userId: widget.isForOrder ? AuthProvider.of(context).authState.userModel!.id : null,
        productCategories: widget.isForOrder ? widget.productCategories : null,
        serviceCategories: widget.isForOrder ? widget.serviceCategories : null,
        productIds: widget.isForOrder ? widget.productIds : null,
        serviceIds: widget.isForOrder ? widget.serviceIds : null,
        status: _categoryList[0],
        searchKey: _controller.text.trim(),
      );
    });
  }

  void _tabControllerListener() {
    if ((_couponListProvider!.couponState.progressState != 1) &&
        (_controller.text.isNotEmpty ||
            _couponListProvider!.couponState.couponListData![_categoryList[_tabController!.index]] == null ||
            _couponListProvider!.couponState.couponListData![_categoryList[_tabController!.index]].isEmpty)) {
      Map<String, dynamic>? couponListData = _couponListProvider!.couponState.couponListData;
      Map<String, dynamic>? couponMetaData = _couponListProvider!.couponState.couponMetaData;

      if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
        couponListData![_categoryList[_oldTabIndex]] = [];
        couponMetaData![_categoryList[_oldTabIndex]] = Map<String, dynamic>();
      }

      _couponListProvider!.setCouponListState(
        _couponListProvider!.couponState.update(
          progressState: 1,
          couponListData: couponListData,
          couponMetaData: couponMetaData,
        ),
      );

      _controller.clear();
      _oldTabIndex = _tabController!.index;

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _couponListProvider!.getCouponListData(
          storeId: widget.storeModel!.id,
          userId: widget.isForOrder ? AuthProvider.of(context).authState.userModel!.id : null,
          productCategories: widget.isForOrder ? widget.productCategories : null,
          serviceCategories: widget.isForOrder ? widget.serviceCategories : null,
          productIds: widget.isForOrder ? widget.productIds : null,
          serviceIds: widget.isForOrder ? widget.serviceIds : null,
          status: _categoryList[_tabController!.index],
          searchKey: _controller.text.trim(),
        );
      });
    }
    _oldTabIndex = _tabController!.index;
    setState(() {});
  }

  @override
  void dispose() {
    _couponListProvider!.removeListener(_couponListProviderListener);

    super.dispose();
  }

  void _couponListProviderListener() async {
    if (_tabController == null) return;
    if (_couponListProvider!.couponState.progressState == -1) {
      if (_couponListProvider!.couponState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _couponListProvider!.setCouponListState(
          _couponListProvider!.couponState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_couponListProvider!.couponState.progressState == 2) {
      if (_couponListProvider!.couponState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _couponListProvider!.setCouponListState(
          _couponListProvider!.couponState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? couponListData = _couponListProvider!.couponState.couponListData;
    Map<String, dynamic>? couponMetaData = _couponListProvider!.couponState.couponMetaData;

    couponListData![_categoryList[_tabController!.index]] = [];
    couponMetaData![_categoryList[_tabController!.index]] = Map<String, dynamic>();
    _couponListProvider!.setCouponListState(
      _couponListProvider!.couponState.update(
        progressState: 1,
        couponListData: couponListData,
        couponMetaData: couponMetaData,
        isRefresh: true,
      ),
    );

    _couponListProvider!.getCouponListData(
      storeId: widget.storeModel!.id,
      userId: widget.isForOrder ? AuthProvider.of(context).authState.userModel!.id : null,
      productCategories: widget.isForOrder ? widget.productCategories : null,
      serviceCategories: widget.isForOrder ? widget.serviceCategories : null,
      productIds: widget.isForOrder ? widget.productIds : null,
      serviceIds: widget.isForOrder ? widget.serviceIds : null,
      status: _categoryList[_tabController!.index],
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _couponListProvider!.setCouponListState(
      _couponListProvider!.couponState.update(progressState: 1),
    );
    _couponListProvider!.getCouponListData(
      storeId: widget.storeModel!.id,
      userId: widget.isForOrder ? AuthProvider.of(context).authState.userModel!.id : null,
      productCategories: widget.isForOrder ? widget.productCategories : null,
      serviceCategories: widget.isForOrder ? widget.serviceCategories : null,
      productIds: widget.isForOrder ? widget.productIds : null,
      serviceIds: widget.isForOrder ? widget.serviceIds : null,
      status: _categoryList[_tabController!.index],
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyCouponListHandler() {
    Map<String, dynamic>? couponListData = _couponListProvider!.couponState.couponListData;
    Map<String, dynamic>? couponMetaData = _couponListProvider!.couponState.couponMetaData;

    couponListData![_categoryList[_tabController!.index]] = [];
    couponMetaData![_categoryList[_tabController!.index]] = Map<String, dynamic>();
    _couponListProvider!.setCouponListState(
      _couponListProvider!.couponState.update(
        progressState: 1,
        couponListData: couponListData,
        couponMetaData: couponMetaData,
      ),
    );

    _couponListProvider!.getCouponListData(
      storeId: widget.storeModel!.id,
      userId: widget.isForOrder ? AuthProvider.of(context).authState.userModel!.id : null,
      productCategories: widget.isForOrder ? widget.productCategories : null,
      serviceCategories: widget.isForOrder ? widget.serviceCategories : null,
      productIds: widget.isForOrder ? widget.productIds : null,
      serviceIds: widget.isForOrder ? widget.serviceIds : null,
      status: _categoryList[_tabController!.index],
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FavoriteProvider.of(context).favoriteUpdateHandler();
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              _appBar(),
              SizedBox(height: heightDp * 15),
              _searchField(),
              SizedBox(height: heightDp * 10),
              Expanded(
                child: Consumer<CouponListProvider>(builder: (context, couponListProvider, _) {
                  if (couponListProvider.couponState.progressState == 0) {
                    return Center(child: CupertinoActivityIndicator());
                  }

                  if (couponListProvider.couponState.progressState == -1) {
                    return ErrorPage(
                      message: couponListProvider.couponState.message,
                      callback: () {
                        _couponListProvider!.setCouponListState(
                          _couponListProvider!.couponState.update(
                            progressState: 1,
                            isRefresh: true,
                          ),
                        );

                        _couponListProvider!.getCouponListData(
                          storeId: widget.storeModel!.id,
                          userId: widget.isForOrder ? AuthProvider.of(context).authState.userModel!.id : null,
                          productCategories: widget.isForOrder ? widget.productCategories : null,
                          serviceCategories: widget.isForOrder ? widget.serviceCategories : null,
                          productIds: widget.isForOrder ? widget.productIds : null,
                          serviceIds: widget.isForOrder ? widget.serviceIds : null,
                          status: _categoryList[0],
                          searchKey: _controller.text.trim(),
                        );
                      },
                    );
                  }

                  return DefaultTabController(
                    length: _categoryList.length,
                    child: _productListPanel(),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      width: deviceWidth,
      child: Column(
        children: [
          Container(
            height: statusbarHeight,
            color: config.Colors().mainColor(1).withOpacity(1),
          ),
          Stack(
            children: [
              Container(
                width: deviceWidth,
                child: Column(
                  children: [
                    Container(
                      width: deviceWidth,
                      alignment: Alignment.topCenter,
                      color: config.Colors().mainColor(1).withOpacity(1),
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: Column(
                        children: [
                          SizedBox(height: heightDp * 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Coupons",
                                style: TextStyle(fontSize: fontSp * 24, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                "img/coupons.png",
                                width: heightDp * 100,
                                height: heightDp * 100,
                                color: Colors.white,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          // if (!widget.isForOrder)
                          SizedBox(height: heightDp * 15),
                        ],
                      ),
                    ),
                    // if (!widget.isForOrder)
                    SizedBox(height: heightDp * 22.5),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  FavoriteProvider.of(context).favoriteUpdateHandler();
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      SizedBox(height: heightDp * 10),
                      Icon(Icons.arrow_back_ios, size: heightDp * 25, color: Colors.white),
                    ],
                  ),
                ),
              ),
              // if (!widget.isForOrder)
              Positioned(
                bottom: 0,
                child: Container(
                  width: deviceWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isForOrder)
                        Container(
                          height: heightDp * 45,
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(heightDp * 6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                offset: Offset(0, 3),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Available",
                              style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: deviceWidth * 0.9,
                          height: heightDp * 45,
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(heightDp * 45),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                offset: Offset(0, 3),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: _tabBar(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp * 15),
          Text(
            "Only one coupon can be used per order",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Row(
        children: [
          Expanded(
            child: KeicyTextFormField(
              controller: _controller,
              focusNode: _focusNode,
              width: null,
              height: heightDp * 40,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: heightDp * 6,
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              textStyle: TextStyle(fontSize: fontSp * 12, color: Colors.black),
              hintStyle: TextStyle(fontSize: fontSp * 12, color: Colors.grey.withOpacity(0.6)),
              hintText: CouponListPageString.searchHint,
              prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
              suffixIcons: [
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                    _searchKeyCouponListHandler();
                  },
                  child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
                ),
              ],
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
                _searchKeyCouponListHandler();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: false,
      indicatorColor: config.Colors().mainColor(1),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.zero,
      labelStyle: TextStyle(fontSize: fontSp * 16),
      labelColor: config.Colors().mainColor(1),
      unselectedLabelColor: Colors.black,
      tabs: List.generate(_categoryList.length, (index) {
        return Tab(
          text: "${_categoryList[index]}",
        );
      }),
    );
  }

  Widget _productListPanel() {
    int index = _tabController!.index;
    String category = _categoryList[index];

    List<dynamic> couponListData = [];
    Map<String, dynamic> couponMetaData = Map<String, dynamic>();

    if (_couponListProvider!.couponState.couponListData![category] != null) {
      couponListData = _couponListProvider!.couponState.couponListData![category];
    }
    if (_couponListProvider!.couponState.couponMetaData![category] != null) {
      couponMetaData = _couponListProvider!.couponState.couponMetaData![category];
    }

    int itemCount = 0;

    if (_couponListProvider!.couponState.couponListData![category] != null) {
      int length = _couponListProvider!.couponState.couponListData![category].length;
      itemCount += length;
    }

    if (_couponListProvider!.couponState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (couponMetaData["nextPage"] != null && _couponListProvider!.couponState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshControllerList[index],
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Coupons Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : _couponListProvider!.couponState.progressState == 2 && _tabController!.index == 1
                ? Center(
                    child: Text(
                      "No Used Coupons",
                      style: TextStyle(
                        fontSize: fontSp * 20,
                        color: Colors.black,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> couponData = (index >= couponListData.length) ? Map<String, dynamic>() : couponListData[index];

                      if (widget.isForOrder)
                        return CouponForOrderWidget(
                          couponModel: couponData.isNotEmpty ? CouponModel.fromJson(couponData) : null,
                          selectedCoupon: widget.selectedCoupon,
                          isLoading: couponData.isEmpty,
                          storeId: widget.storeModel!.id,
                          tapHandler: () async {
                            if (widget.isForOrder) {
                              _couponForOrderTapHadler(couponData);
                            }
                          },
                        );
                      else
                        return CouponWidget(
                          couponModel: couponData.isNotEmpty ? CouponModel.fromJson(couponData) : null,
                          isLoading: couponData.isEmpty,
                          storeModel: widget.storeModel,
                          tapHandler: () {},
                        );
                    },
                  ),
      ),
    );
  }

  void _viewHandler(CouponModel couponModel) async {
    FavoriteProvider.of(context).favoriteUpdateHandler();

    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CouponDetailPage(
          couponModel: couponModel,
          storeModel: widget.storeModel,
        ),
      ),
    );
  }

  void _couponForOrderTapHadler(Map<String, dynamic> couponData) async {
    ///
    await _keicyProgressDialog!.show();
    String message = await CouponModel.checkUsageLimit(CouponModel.fromJson(couponData));
    await _keicyProgressDialog!.hide();
    if (message != "") {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: message,
        isTryButton: false,
        callBack: () {},
      );
      return;
    }

    ///
    message = CouponModel.checkAppliedFor(orderModel: widget.orderModel, couponModel: CouponModel.fromJson(couponData))["message"];
    if (message != "" && message != "ALL") {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: message,
        isTryButton: false,
        callBack: () {},
      );
      return;
    }

    message = CouponModel.checkCouponMinRequests(orderModel: widget.orderModel, couponModel: CouponModel.fromJson(couponData));
    if (message != "") {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: message,
        isTryButton: false,
        callBack: () {},
      );
      return;
    }

    message = CouponModel.checkBOGO(orderModel: widget.orderModel, couponModel: CouponModel.fromJson(couponData));
    if (message != "") {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: message,
        isTryButton: false,
        callBack: () {},
      );
      return;
    }
    Navigator.of(context).pop(couponData);
  }
}
