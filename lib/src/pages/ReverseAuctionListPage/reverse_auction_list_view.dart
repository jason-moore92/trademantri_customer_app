import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/reverse_auction_widget.dart';
import 'package:trapp/src/pages/CreateReverseAuctionPage/index.dart';
import 'package:trapp/src/pages/ReverseAuctionDetailPage/index.dart';
import 'package:trapp/src/pages/LoginAskPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class ReverseAuctionListView extends StatefulWidget {
  final bool haveAppBar;

  ReverseAuctionListView({Key? key, this.haveAppBar = false}) : super(key: key);

  @override
  _ReverseAuctionListViewState createState() => _ReverseAuctionListViewState();
}

class _ReverseAuctionListViewState extends State<ReverseAuctionListView> with SingleTickerProviderStateMixin {
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
  ReverseAuctionProvider? _reverseAuctionProvider;
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

    _reverseAuctionProvider = ReverseAuctionProvider.of(context);
    _authProvider = AuthProvider.of(context);

    _refreshControllerList = [];
    for (var i = 0; i < AppConfig.reverseAuctionStatusData.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = 0;

    _tabController = TabController(length: AppConfig.reverseAuctionStatusData.length, vsync: this);

    _tabController!.addListener(_tabControllerListener);
    _controller = ScrollController();

    _reverseAuctionProvider!.setReverseAuctionState(
      _reverseAuctionProvider!.reverseAuctionState.update(
        reverseAuctionListData: Map<String, dynamic>(),
        reverseAuctionMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _reverseAuctionProvider!.addListener(_reverseAuctionProviderListener);
      if (_authProvider!.authState.userModel!.id != null) {
        _reverseAuctionProvider!.setReverseAuctionState(_reverseAuctionProvider!.reverseAuctionState.update(progressState: 1));
        _reverseAuctionProvider!.getReverseAuctionDataByUser(
          userId: _authProvider!.authState.userModel!.id,
          status: AppConfig.reverseAuctionStatusData[0]["id"],
        );
      }
    });
  }

  @override
  void dispose() {
    _reverseAuctionProvider!.removeListener(_reverseAuctionProviderListener);

    super.dispose();
  }

  void _reverseAuctionProviderListener() async {
    if (_reverseAuctionProvider!.reverseAuctionState.progressState == -1) {
      if (_reverseAuctionProvider!.reverseAuctionState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _reverseAuctionProvider!.setReverseAuctionState(
          _reverseAuctionProvider!.reverseAuctionState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_reverseAuctionProvider!.reverseAuctionState.progressState == 2) {
      if (_reverseAuctionProvider!.reverseAuctionState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _reverseAuctionProvider!.setReverseAuctionState(
          _reverseAuctionProvider!.reverseAuctionState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _tabControllerListener() {
    if ((_reverseAuctionProvider!.reverseAuctionState.progressState != 1) &&
        (_textController.text.isNotEmpty ||
            _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData![AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]] ==
                null ||
            _reverseAuctionProvider!
                .reverseAuctionState.reverseAuctionListData![AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]].isEmpty)) {
      Map<String, dynamic> reverseAuctionListData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData!;
      Map<String, dynamic> reverseAuctionMetaData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionMetaData!;

      if (_oldTabIndex != _tabController!.index && _textController.text.isNotEmpty) {
        reverseAuctionListData[AppConfig.reverseAuctionStatusData[_oldTabIndex]["id"]] = [];
        reverseAuctionMetaData[AppConfig.reverseAuctionStatusData[_oldTabIndex]["id"]] = Map<String, dynamic>();
      }

      _reverseAuctionProvider!.setReverseAuctionState(
        _reverseAuctionProvider!.reverseAuctionState.update(
          progressState: 1,
          reverseAuctionListData: reverseAuctionListData,
          reverseAuctionMetaData: reverseAuctionMetaData,
        ),
        isNotifiable: false,
      );

      _textController.clear();
      _oldTabIndex = _tabController!.index;

      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _reverseAuctionProvider!.getReverseAuctionDataByUser(
          userId: _authProvider!.authState.userModel!.id,
          status: AppConfig.reverseAuctionStatusData[_tabController!.index]["id"],
          searchKey: _textController.text.trim(),
        );
      });
    } else {
      _oldTabIndex = _tabController!.index;
      setState(() {});
    }
  }

  void _onRefresh() async {
    Map<String, dynamic> reverseAuctionListData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData!;
    Map<String, dynamic> reverseAuctionMetaData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionMetaData!;

    reverseAuctionListData[AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]] = [];
    reverseAuctionMetaData[AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _reverseAuctionProvider!.setReverseAuctionState(
      _reverseAuctionProvider!.reverseAuctionState.update(
        progressState: 1,
        reverseAuctionListData: reverseAuctionListData,
        reverseAuctionMetaData: reverseAuctionMetaData,
        isRefresh: true,
      ),
    );

    _reverseAuctionProvider!.getReverseAuctionDataByUser(
      userId: _authProvider!.authState.userModel!.id,
      status: AppConfig.reverseAuctionStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _reverseAuctionProvider!.setReverseAuctionState(
      _reverseAuctionProvider!.reverseAuctionState.update(progressState: 1),
    );
    _reverseAuctionProvider!.getReverseAuctionDataByUser(
      userId: _authProvider!.authState.userModel!.id,
      status: AppConfig.reverseAuctionStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _searchKeyReverseAuctionListHandler() {
    Map<String, dynamic> reverseAuctionListData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData!;
    Map<String, dynamic> reverseAuctionMetaData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionMetaData!;

    reverseAuctionListData[AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]] = [];
    reverseAuctionMetaData[AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _reverseAuctionProvider!.setReverseAuctionState(
      _reverseAuctionProvider!.reverseAuctionState.update(
        progressState: 1,
        reverseAuctionListData: reverseAuctionListData,
        reverseAuctionMetaData: reverseAuctionMetaData,
      ),
    );

    _reverseAuctionProvider!.getReverseAuctionDataByUser(
      userId: _authProvider!.authState.userModel!.id,
      status: AppConfig.reverseAuctionStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !widget.haveAppBar
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                "Reverse Auction",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: AuthProvider.of(context).authState.userModel!.id == null
          ? LoginAskPage(
              callback: () => Navigator.of(context).pushNamed('/Pages', arguments: {"currentTab": 3}),
            )
          : Consumer<ReverseAuctionProvider>(builder: (context, reverseAuctionProvider, _) {
              if (reverseAuctionProvider.reverseAuctionState.progressState == 0) {
                return Center(child: CupertinoActivityIndicator());
              }
              return DefaultTabController(
                length: AppConfig.reverseAuctionStatusData.length,
                child: Container(
                  width: deviceWidth,
                  height: deviceHeight,
                  child: Column(
                    children: [
                      _searchField(),
                      _tabBar(),
                      Expanded(child: _reverseAuctionListPanel()),
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
              hintText: ReverseAuctionListPageString.searchHint,
              prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
              suffixIcons: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _textController.clear();
                    _searchKeyReverseAuctionListHandler();
                  },
                  child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
                ),
              ],
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
                _searchKeyReverseAuctionListHandler();
              },
            ),
          ),
          SizedBox(width: widthDp * 10),
          KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 35,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            borderRadius: heightDp * 6,
            color:
                (_reverseAuctionProvider!.reverseAuctionState.progressState == 1 || _reverseAuctionProvider!.reverseAuctionState.progressState == 0)
                    ? Colors.grey.withOpacity(0.5)
                    : config.Colors().mainColor(1),
            child: Text(
              "New Auction",
              style: TextStyle(fontSize: fontSp * 12, color: Colors.white, letterSpacing: 0.5),
            ),
            onPressed:
                (_reverseAuctionProvider!.reverseAuctionState.progressState == 1 || _reverseAuctionProvider!.reverseAuctionState.progressState == 0)
                    ? null
                    : () async {
                        _reverseAuctionProvider!.removeListener(_reverseAuctionProviderListener);
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => CreateReverseAuctionPage(),
                          ),
                        );
                        if (result != null) {
                          if (widget.haveAppBar) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) => ReverseAuctionListPage(haveAppBar: widget.haveAppBar),
                              ),
                            );
                          } else {
                            Navigator.of(context).pushReplacementNamed('/Pages', arguments: {"currentTab": 3});
                          }
                        } else {
                          _reverseAuctionProvider!.addListener(_reverseAuctionProviderListener);
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
        tabs: List.generate(AppConfig.reverseAuctionStatusData.length, (index) {
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
                "${AppConfig.reverseAuctionStatusData[index]["name"]}",
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _reverseAuctionListPanel() {
    String status = AppConfig.reverseAuctionStatusData[_tabController!.index]["id"];

    List<dynamic> reverseAuctionList = [];
    Map<String, dynamic> reverseAuctionMetaData = Map<String, dynamic>();

    if (_reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData![status] != null) {
      reverseAuctionList = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData![status];
    }
    if (_reverseAuctionProvider!.reverseAuctionState.reverseAuctionMetaData![status] != null) {
      reverseAuctionMetaData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionMetaData![status];
    }

    int itemCount = 0;

    if (_reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData![status] != null) {
      List<dynamic> data = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData![status];
      itemCount += data.length;
    }

    if (_reverseAuctionProvider!.reverseAuctionState.progressState == 1) {
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
              enablePullUp: (reverseAuctionMetaData["nextPage"] != null && _reverseAuctionProvider!.reverseAuctionState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshControllerList[_tabController!.index],
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Reverse auction Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      controller: _controller,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> reverseAuctionData =
                            (index >= reverseAuctionList.length) ? Map<String, dynamic>() : reverseAuctionList[index];
                        return ReverseAuctionWidget(
                          reverseAuctionData: reverseAuctionData,
                          loadingStatus: reverseAuctionData.isEmpty,
                          detailCallback: () {
                            _detailCallback(reverseAuctionData);
                          },
                          cancelCallback: () {
                            NormalAskDialog.show(
                              context,
                              title: "Reverse Auction cancel",
                              content: "Do you really want to cancel this auction? Stores will be notified that your auction is cancelled.",
                              callback: () async {
                                _cancelCallback(json.decode(json.encode(reverseAuctionData)));
                              },
                            );
                          },
                          changeEndDateHandler: () {
                            _selectPickupDateTimeHandler(json.decode(json.encode(reverseAuctionData)), "biddingEnd");
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

  void _selectPickupDateTimeHandler(Map<String, dynamic> reverseAuctionData, String type) async {
    DateTime? selecteDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
      selectableDayPredicate: (date) {
        if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
        if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
        return true;
      },
    );
    if (selecteDate == null) return;

    TimeOfDay? time = await showCustomTimePicker(
      context: context,
      onFailValidation: (context) => FlutterLogs.logWarn(
        "reverse_auction_list_view",
        "_selectPickupDateTimeHandler",
        "Unavailable selection",
      ),
      initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    );

    if (time == null) return;
    selecteDate = selecteDate.add(Duration(hours: time.hour, minutes: time.minute));
    setState(() {
      if (!selecteDate!.isUtc) selecteDate = selecteDate!.toUtc();

      if (type == "biddingStart") {
        reverseAuctionData["biddingStartDateTime"] = selecteDate!.toUtc().toIso8601String();
      } else if (type == "biddingEnd") {
        reverseAuctionData["biddingEndDateTime"] = selecteDate!.toUtc().toIso8601String();
      }
      _changeEndDateHandler(reverseAuctionData);
    });
  }

  void _detailCallback(Map<String, dynamic> reverseAuctionData) async {
    _reverseAuctionProvider!.removeListener(_reverseAuctionProviderListener);
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ReverseAuctionDetailPage(reverseAuctionData: reverseAuctionData),
      ),
    );
    _reverseAuctionProvider!.addListener(_reverseAuctionProviderListener);
    if (result != null) {
      for (var i = 0; i < AppConfig.reverseAuctionStatusData.length; i++) {
        if (result == AppConfig.reverseAuctionStatusData[i]["id"]) {
          _tabController!.animateTo(i);
          _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
          _onRefresh();
          break;
        }
      }
    }
  }

  void _cancelCallback(Map<String, dynamic> reverseAuctionData) async {
    await _keicyProgressDialog!.show();
    var result = await _reverseAuctionProvider!.updateReverseAuctionData(
      reverseAuctionData: reverseAuctionData,
      status: AppConfig.reverseAuctionStatusData[3]["id"],
      storeName: "Store Name 1",
      userName: "${AuthProvider.of(context).authState.userModel!.firstName} ${AuthProvider.of(context).authState.userModel!.lastName}",
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _tabController!.animateTo(3);
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
          _cancelCallback(reverseAuctionData);
        },
      );
    }
  }

  void _changeEndDateHandler(Map<String, dynamic> reverseAuctionData) async {
    await _keicyProgressDialog!.show();
    var result = await _reverseAuctionProvider!.updateReverseAuctionData(
      reverseAuctionData: reverseAuctionData,
      status: "change_end_date",
      storeName: "Store Name 1",
      userName: "${AuthProvider.of(context).authState.userModel!.firstName} ${AuthProvider.of(context).authState.userModel!.lastName}",
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _onRefresh();
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _changeEndDateHandler(reverseAuctionData);
        },
      );
    }
  }
}
