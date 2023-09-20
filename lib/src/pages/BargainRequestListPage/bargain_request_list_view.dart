import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/bargain_request_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/BargainRequestDetailPage/index.dart';
import 'package:trapp/src/pages/CheckOutPage/index.dart';
import 'package:trapp/src/pages/CreateBargainRequestPage/index.dart';
import 'package:trapp/src/pages/LoginAskPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class BargainRequestListView extends StatefulWidget {
  final bool haveAppBar;

  BargainRequestListView({Key? key, this.haveAppBar = false}) : super(key: key);

  @override
  _BargainRequestListViewState createState() => _BargainRequestListViewState();
}

class _BargainRequestListViewState extends State<BargainRequestListView> with SingleTickerProviderStateMixin {
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
  BargainRequestProvider? _bargainRequestProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  List<RefreshController> _refreshControllerList = [];

  TabController? _tabController;
  ScrollController? _controller;

  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int _oldTabIndex = 0;

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

    _bargainRequestProvider = BargainRequestProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshControllerList = [];
    for (var i = 0; i < AppConfig.bargainRequestStatusData.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = 0;

    _tabController = TabController(length: AppConfig.bargainRequestStatusData.length, vsync: this);

    _tabController!.addListener(_tabControllerListener);
    _controller = ScrollController();

    _bargainRequestProvider!.setBargainRequestState(
      _bargainRequestProvider!.bargainRequestState.update(
        bargainRequestListData: Map<String, dynamic>(),
        bargainRequestMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _bargainRequestProvider!.addListener(_bargainRequestProviderListener);

      if (_authProvider!.authState.userModel!.id != null) {
        _bargainRequestProvider!.setBargainRequestState(_bargainRequestProvider!.bargainRequestState.update(progressState: 1));
        _bargainRequestProvider!.getBargainRequestData(
          status: AppConfig.bargainRequestStatusData[0]["id"],
        );
      }
    });
  }

  @override
  void dispose() {
    _bargainRequestProvider!.removeListener(_bargainRequestProviderListener);

    super.dispose();
  }

  void _bargainRequestProviderListener() async {
    if (_bargainRequestProvider!.bargainRequestState.progressState == -1) {
      if (_bargainRequestProvider!.bargainRequestState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _bargainRequestProvider!.setBargainRequestState(
          _bargainRequestProvider!.bargainRequestState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_bargainRequestProvider!.bargainRequestState.progressState == 2) {
      if (_bargainRequestProvider!.bargainRequestState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _bargainRequestProvider!.setBargainRequestState(
          _bargainRequestProvider!.bargainRequestState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _tabControllerListener() {
    if ((_bargainRequestProvider!.bargainRequestState.progressState != 1) &&
        (_textController.text.isNotEmpty ||
            _bargainRequestProvider!.bargainRequestState.bargainRequestListData![AppConfig.bargainRequestStatusData[_tabController!.index]["id"]] ==
                null ||
            _bargainRequestProvider!
                .bargainRequestState.bargainRequestListData![AppConfig.bargainRequestStatusData[_tabController!.index]["id"]].isEmpty)) {
      Map<String, dynamic> bargainRequestListData = _bargainRequestProvider!.bargainRequestState.bargainRequestListData!;
      Map<String, dynamic> bargainRequestMetaData = _bargainRequestProvider!.bargainRequestState.bargainRequestMetaData!;

      if (_oldTabIndex != _tabController!.index && _textController.text.isNotEmpty) {
        bargainRequestListData[AppConfig.bargainRequestStatusData[_oldTabIndex]["id"]] = [];
        bargainRequestMetaData[AppConfig.bargainRequestStatusData[_oldTabIndex]["id"]] = Map<String, dynamic>();
      }

      _bargainRequestProvider!.setBargainRequestState(
        _bargainRequestProvider!.bargainRequestState.update(
          progressState: 1,
          bargainRequestListData: bargainRequestListData,
          bargainRequestMetaData: bargainRequestMetaData,
        ),
        isNotifiable: false,
      );

      _textController.clear();
      _oldTabIndex = _tabController!.index;

      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _bargainRequestProvider!.getBargainRequestData(
          status: AppConfig.bargainRequestStatusData[_tabController!.index]["id"],
          searchKey: _textController.text.trim(),
        );
      });
    } else {
      _oldTabIndex = _tabController!.index;
      setState(() {});
    }
  }

  void _onRefresh() async {
    Map<String, dynamic> bargainRequestListData = _bargainRequestProvider!.bargainRequestState.bargainRequestListData!;
    Map<String, dynamic> bargainRequestMetaData = _bargainRequestProvider!.bargainRequestState.bargainRequestMetaData!;

    bargainRequestListData[AppConfig.bargainRequestStatusData[_tabController!.index]["id"]] = [];
    bargainRequestMetaData[AppConfig.bargainRequestStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _bargainRequestProvider!.setBargainRequestState(
      _bargainRequestProvider!.bargainRequestState.update(
        progressState: 1,
        bargainRequestListData: bargainRequestListData,
        bargainRequestMetaData: bargainRequestMetaData,
        isRefresh: true,
      ),
    );

    _bargainRequestProvider!.getBargainRequestData(
      status: AppConfig.bargainRequestStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _bargainRequestProvider!.setBargainRequestState(
      _bargainRequestProvider!.bargainRequestState.update(progressState: 1),
    );
    _bargainRequestProvider!.getBargainRequestData(
      status: AppConfig.bargainRequestStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _searchKeyBargainRequestListHandler() {
    Map<String, dynamic> bargainRequestListData = _bargainRequestProvider!.bargainRequestState.bargainRequestListData!;
    Map<String, dynamic> bargainRequestMetaData = _bargainRequestProvider!.bargainRequestState.bargainRequestMetaData!;

    bargainRequestListData[AppConfig.bargainRequestStatusData[_tabController!.index]["id"]] = [];
    bargainRequestMetaData[AppConfig.bargainRequestStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _bargainRequestProvider!.setBargainRequestState(
      _bargainRequestProvider!.bargainRequestState.update(
        progressState: 1,
        bargainRequestListData: bargainRequestListData,
        bargainRequestMetaData: bargainRequestMetaData,
      ),
    );

    _bargainRequestProvider!.getBargainRequestData(
      status: AppConfig.bargainRequestStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !widget.haveAppBar
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                "Bargain Requests",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: AuthProvider.of(context).authState.userModel!.id == null
          ? LoginAskPage(
              callback: () => Navigator.of(context).pushNamed('/Pages', arguments: {"currentTab": 1}),
            )
          : Consumer<BargainRequestProvider>(builder: (context, bargainRequestProvider, _) {
              if (bargainRequestProvider.bargainRequestState.progressState == 0) {
                return Center(child: CupertinoActivityIndicator());
              }
              return DefaultTabController(
                length: AppConfig.bargainRequestStatusData.length,
                child: Container(
                  width: deviceWidth,
                  height: deviceHeight,
                  child: Column(
                    children: [
                      _searchField(),
                      _tabBar(),
                      Expanded(child: _bargainRequestListPanel()),
                    ],
                  ),
                ),
              );
            }),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Row(
        children: [
          Expanded(
            child: KeicyTextFormField(
              key: GlobalKey(),
              controller: _textController,
              focusNode: _focusNode,
              width: null,
              height: heightDp * 50,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: heightDp * 6,
              contentHorizontalPadding: widthDp * 10,
              textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
              hintText: BargainRequestListPageString.searchHint,
              prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
              suffixIcons: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _textController.clear();
                  },
                  child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
                ),
              ],
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
                _searchKeyBargainRequestListHandler();
              },
            ),
          ),
          SizedBox(width: widthDp * 10),
          KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 35,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            borderRadius: heightDp * 6,
            color: _bargainRequestProvider!.bargainRequestState.progressState == 0 || _bargainRequestProvider!.bargainRequestState.progressState == 1
                ? Colors.grey.withOpacity(0.5)
                : config.Colors().mainColor(1),
            child: Text("New Bargain", style: TextStyle(fontSize: fontSp * 12, color: Colors.white, letterSpacing: 0.5)),
            onPressed:
                _bargainRequestProvider!.bargainRequestState.progressState == 0 || _bargainRequestProvider!.bargainRequestState.progressState == 1
                    ? null
                    : () async {
                        _bargainRequestProvider!.removeListener(_bargainRequestProviderListener);
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => CreateBargainRequestPage(),
                          ),
                        );
                        if (result != null) {
                          if (widget.haveAppBar) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) => BargainRequestListPage(haveAppBar: widget.haveAppBar),
                              ),
                            );
                          } else {
                            Navigator.of(context).pushReplacementNamed('/Pages', arguments: {"currentTab": 1});
                          }
                        } else {
                          _bargainRequestProvider!.addListener(_bargainRequestProviderListener);
                        }
                      },
          ),
        ],
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
        isScrollable: true,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        indicatorWeight: 1,
        labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 5),
        labelStyle: TextStyle(fontSize: fontSp * 14),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: List.generate(AppConfig.bargainRequestStatusData.length, (index) {
          return Tab(
            child: Container(
              width: widthDp * 110,
              height: heightDp * 35,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _tabController!.index == index ? config.Colors().mainColor(1) : Colors.white,
                borderRadius: BorderRadius.circular(heightDp * 30),
              ),
              child: Text(
                "${AppConfig.bargainRequestStatusData[index]["name"]}",
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _bargainRequestListPanel() {
    String status = AppConfig.bargainRequestStatusData[_tabController!.index]["id"];

    List<dynamic> bargainRequestList = [];
    Map<String, dynamic> bargainRequestMetaData = Map<String, dynamic>();

    if (_bargainRequestProvider!.bargainRequestState.bargainRequestListData![status] != null) {
      bargainRequestList = _bargainRequestProvider!.bargainRequestState.bargainRequestListData![status];
    }
    if (_bargainRequestProvider!.bargainRequestState.bargainRequestMetaData![status] != null) {
      bargainRequestMetaData = _bargainRequestProvider!.bargainRequestState.bargainRequestMetaData![status];
    }

    int itemCount = 0;

    if (_bargainRequestProvider!.bargainRequestState.bargainRequestListData![status] != null) {
      List<dynamic> data = _bargainRequestProvider!.bargainRequestState.bargainRequestListData![status];
      itemCount += data.length;
    }

    if (_bargainRequestProvider!.bargainRequestState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
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
              enablePullUp: (bargainRequestMetaData["nextPage"] != null && _bargainRequestProvider!.bargainRequestState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshControllerList[_tabController!.index],
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Bargain Requests Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      controller: _controller,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> bargainRequestData =
                            (index >= bargainRequestList.length) ? Map<String, dynamic>() : bargainRequestList[index];

                        if (bargainRequestData.isNotEmpty && bargainRequestData["store"]["settings"] == null) {
                          bargainRequestData["store"]["settings"] = AppConfig.initialSettings;
                        }

                        if (bargainRequestData.isNotEmpty && bargainRequestData["user"] == null) {
                          bargainRequestData["user"] = AuthProvider.of(context).authState.userModel!.toJson();
                        }

                        return BargainRequestWidget(
                          bargainRequestModel: bargainRequestData.isNotEmpty ? BargainRequestModel.fromJson(bargainRequestData) : null,
                          loadingStatus: bargainRequestData.isEmpty,
                          detailCallback: () {
                            _detailCallback(BargainRequestModel.fromJson(bargainRequestData));
                          },
                          cancelCallback: (BargainRequestModel? bargainRequestModel) {
                            _cancelCallback(bargainRequestModel);
                          },
                          counterOfferCallback: (BargainRequestModel? bargainRequestModel) async {
                            _counterOfferCallback(bargainRequestModel);
                          },
                          completeCallback: (BargainRequestModel? bargainRequestModel) {
                            _completeCallback(bargainRequestModel);
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _detailCallback(BargainRequestModel? bargainRequestModel) async {
    _bargainRequestProvider!.removeListener(_bargainRequestProviderListener);
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => BargainRequestDetailPage(bargainRequestModel: bargainRequestModel),
      ),
    );
    _bargainRequestProvider!.addListener(_bargainRequestProviderListener);
    if (result != null) {
      for (var i = 0; i < AppConfig.bargainRequestStatusData.length; i++) {
        if (result == AppConfig.bargainRequestStatusData[i]["id"]) {
          _tabController!.animateTo(i);
          _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
          _onRefresh();
          break;
        }
      }
    }
  }

  void _cancelCallback(BargainRequestModel? bargainRequestModel) async {
    try {
      bargainRequestModel!.history!.add({
        "title": AppConfig.bargainHistoryData["cancelled"]["title"],
        "text": AppConfig.bargainHistoryData["cancelled"]["text"],
        "bargainType": AppConfig.bargainRequestStatusData[6]["id"],
        "date": DateTime.now().toUtc().toIso8601String(),
        "initialPrice": bargainRequestModel.history!.first["initialPrice"],
        "offerPrice": bargainRequestModel.offerPrice,
      });

      await _keicyProgressDialog!.show();
      bargainRequestModel.userModel = _authProvider!.authState.userModel;
      var result = await _bargainRequestProvider!.updateBargainRequestData(
        bargainRequestModel: bargainRequestModel,
        status: AppConfig.bargainRequestStatusData[6]["id"],
        subStatus: AppConfig.bargainRequestStatusData[6]["id"],
      );
      await _keicyProgressDialog!.hide();
      if (result["success"]) {
        _tabController!.animateTo(6);
        _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        _onRefresh();
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: result["message"],
          callBack: () {
            _cancelCallback(bargainRequestModel);
          },
        );
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "bargain_request_list_view",
        level: LogLevel.ERROR,
        subTag: "_cancelCallback",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  void _counterOfferCallback(BargainRequestModel? bargainRequestModel) async {
    bargainRequestModel!.history!.add({
      "title": AppConfig.bargainHistoryData["user_counter_offer"]["title"],
      "text": AppConfig.bargainHistoryData["user_counter_offer"]["text"],
      "bargainType": AppConfig.bargainRequestStatusData[1]["id"],
      "date": DateTime.now().toUtc().toIso8601String(),
      "initialPrice": bargainRequestModel.history!.first["initialPrice"],
      "offerPrice": bargainRequestModel.offerPrice,
    });

    await _keicyProgressDialog!.show();
    bargainRequestModel.userModel = _authProvider!.authState.userModel;
    List<dynamic> tmp = [];
    for (var i = 0; i < bargainRequestModel.userOfferPriceList!.length; i++) {
      tmp.add(bargainRequestModel.userOfferPriceList![i]);
    }
    tmp.add(bargainRequestModel.offerPrice);
    bargainRequestModel.userOfferPriceList = tmp;
    var result = await _bargainRequestProvider!.updateBargainRequestData(
      bargainRequestModel: bargainRequestModel,
      status: AppConfig.bargainRequestStatusData[1]["id"],
      subStatus: AppConfig.bargainSubStatusData[1]["id"],
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _tabController!.animateTo(1);
      _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
      _onRefresh();
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _cancelCallback(bargainRequestModel);
        },
      );
    }
  }

  void _completeCallback(BargainRequestModel? bargainRequestModel) async {
    _bargainRequestProvider!.removeListener(_bargainRequestProviderListener);
    OrderModel orderModel = OrderModel.fromJson(bargainRequestModel!.toJson());
    orderModel.storeModel = bargainRequestModel.storeModel;
    orderModel.category = AppConfig.orderCategories["bargain"];

    if (orderModel.products!.isNotEmpty) {
      orderModel.products!.first.orderPrice = bargainRequestModel.offerPrice;
    }
    if (orderModel.services!.isNotEmpty) {
      orderModel.services!.first.orderPrice = bargainRequestModel.offerPrice;
    }

    var result1 = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CheckoutPage(orderModel: orderModel),
      ),
    );
    _bargainRequestProvider!.addListener(_bargainRequestProviderListener);

    if (result1 != null && result1) {
      await _keicyProgressDialog!.show();
      bargainRequestModel.history!.add({
        "title": AppConfig.bargainHistoryData["completed"]["title"],
        "text": AppConfig.bargainHistoryData["completed"]["text"],
        "bargainType": AppConfig.bargainRequestStatusData[4]["id"],
        "date": DateTime.now().toUtc().toIso8601String(),
        "initialPrice": bargainRequestModel.history!.first["initialPrice"],
        "offerPrice": bargainRequestModel.offerPrice,
      });

      bargainRequestModel.userModel = _authProvider!.authState.userModel;
      var result = await _bargainRequestProvider!.updateBargainRequestData(
        bargainRequestModel: bargainRequestModel,
        status: AppConfig.bargainRequestStatusData[4]["id"],
        subStatus: AppConfig.bargainRequestStatusData[4]["id"],
      );
      await _keicyProgressDialog!.hide();
      if (result["success"]) {
        _tabController!.animateTo(4);
        _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        _onRefresh();
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: result["message"],
          callBack: () {
            _completeCallback(bargainRequestModel);
          },
        );
      }
    }
    return;
  }
}
