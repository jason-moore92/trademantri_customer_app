import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/scratch_card_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class ScratchCardListView extends StatefulWidget {
  ScratchCardListView({Key? key}) : super(key: key);

  @override
  _ScratchCardListViewState createState() => _ScratchCardListViewState();
}

class _ScratchCardListViewState extends State<ScratchCardListView> with SingleTickerProviderStateMixin {
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
  ScratchCardListProvider? _scratchCardListProvider;
  RefreshController? _refreshController;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  String status = "ALL";

  var numFormat = NumberFormat.currency(symbol: "", name: "");

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    _scratchCardListProvider = ScratchCardListProvider.of(context);
    _authProvider = AuthProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _scratchCardListProvider!.addListener(_scratchCardListProviderListener);

      if (_authProvider!.authState.userModel!.id != null) {
        _scratchCardListProvider!.setScratchCardListState(_scratchCardListProvider!.scratchCardListState.update(progressState: 1));
        _scratchCardListProvider!.getScratchCardListData();
        _scratchCardListProvider!.sumRewardPoints();
      } else {
        LoginAskDialog.show(context, callback: () {
          Navigator.of(context).pushNamed('/Pages', arguments: {"currentTab": 3});
        });
      }
    });
  }

  @override
  void dispose() {
    _scratchCardListProvider!.removeListener(_scratchCardListProviderListener);

    super.dispose();
  }

  void _scratchCardListProviderListener() async {
    if (_scratchCardListProvider!.scratchCardListState.progressState == -1) {
      if (_scratchCardListProvider!.scratchCardListState.isRefresh!) {
        _scratchCardListProvider!.setScratchCardListState(
          _scratchCardListProvider!.scratchCardListState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_scratchCardListProvider!.scratchCardListState.progressState == 2) {
      if (_scratchCardListProvider!.scratchCardListState.isRefresh!) {
        _scratchCardListProvider!.setScratchCardListState(
          _scratchCardListProvider!.scratchCardListState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic> scratchCardListData = _scratchCardListProvider!.scratchCardListState.scratchCardListData!;
    Map<String, dynamic> scratchCardMetaData = _scratchCardListProvider!.scratchCardListState.scratchCardMetaData!;

    scratchCardListData[status] = [];
    scratchCardMetaData[status] = Map<String, dynamic>();
    _scratchCardListProvider!.setScratchCardListState(
      _scratchCardListProvider!.scratchCardListState.update(
        progressState: 1,
        scratchCardListData: scratchCardListData,
        scratchCardMetaData: scratchCardMetaData,
        isRefresh: true,
      ),
    );

    _scratchCardListProvider!.getScratchCardListData(
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _scratchCardListProvider!.setScratchCardListState(
      _scratchCardListProvider!.scratchCardListState.update(progressState: 1),
    );
    _scratchCardListProvider!.getScratchCardListData(
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyScratchCardListHandler() {
    Map<String, dynamic> scratchCardListData = _scratchCardListProvider!.scratchCardListState.scratchCardListData!;
    Map<String, dynamic> scratchCardMetaData = _scratchCardListProvider!.scratchCardListState.scratchCardMetaData!;

    scratchCardListData[status] = [];
    scratchCardMetaData[status] = Map<String, dynamic>();
    _scratchCardListProvider!.setScratchCardListState(
      _scratchCardListProvider!.scratchCardListState.update(
        progressState: 1,
        scratchCardListData: scratchCardListData,
        scratchCardMetaData: scratchCardMetaData,
      ),
    );

    _scratchCardListProvider!.getScratchCardListData(
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Scratch Cards",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
        flexibleSpace: Container(
          height: statusbarHeight + appbarHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFE4E4FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Consumer<ScratchCardListProvider>(builder: (context, scratchCardListProvider, _) {
        if (scratchCardListProvider.scratchCardListState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset("img/rewardPoints.png", width: deviceWidth, fit: BoxFit.fitWidth),
                  scratchCardListProvider.scratchCardListState.sumRewardPoints == -1
                      ? SizedBox()
                      : Positioned(
                          left: widthDp * 70,
                          top: widthDp * 90,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(heightDp * 8),
                              color: Color(0xFF162779),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              numFormat.format(scratchCardListProvider.scratchCardListState.sumRewardPoints),
                              style: TextStyle(fontSize: fontSp * 24, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                ],
              ),
              Expanded(child: _scratchCardListPanel()),
            ],
          ),
        );
      }),
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
        hintText: ScratchCardListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyScratchCardListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyScratchCardListHandler();
        },
      ),
    );
  }

  Widget _scratchCardListPanel() {
    List<dynamic> scratchCardList = [];
    Map<String, dynamic> scratchCardMetaData = Map<String, dynamic>();

    if (_scratchCardListProvider!.scratchCardListState.scratchCardListData![status] != null) {
      scratchCardList = _scratchCardListProvider!.scratchCardListState.scratchCardListData![status];
    }
    if (_scratchCardListProvider!.scratchCardListState.scratchCardMetaData![status] != null) {
      scratchCardMetaData = _scratchCardListProvider!.scratchCardListState.scratchCardMetaData![status];
    }

    int itemCount = 0;

    if (_scratchCardListProvider!.scratchCardListState.scratchCardListData![status] != null) {
      List<dynamic> data = _scratchCardListProvider!.scratchCardListState.scratchCardListData![status];
      itemCount += data.length;
    }

    if (_scratchCardListProvider!.scratchCardListState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: (scratchCardMetaData["nextPage"] != null && _scratchCardListProvider!.scratchCardListState.progressState != 1),
          header: WaterDropHeader(),
          footer: ClassicFooter(),
          controller: _refreshController!,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: itemCount == 0
              ? Center(
                  child: Text(
                    "No Scratch Card Available",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                )
              : ListView.builder(
                  itemCount: itemCount % 2 == 0 ? itemCount ~/ 2 : itemCount ~/ 2 + 1,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> orderData1 = (index * 2 >= scratchCardList.length) ? Map<String, dynamic>() : scratchCardList[index * 2];
                    Map<String, dynamic> orderData2 =
                        (index * 2 + 1 >= scratchCardList.length) ? Map<String, dynamic>() : scratchCardList[index * 2 + 1];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ScratchCardWidget(
                          orderModel: orderData1.isEmpty ? null : OrderModel.fromJson(orderData1),
                          isLoading: orderData1.isEmpty,
                          callback: (Map<String, dynamic> scratchCardData) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              _scratchCardListProvider!.scratchCardListState.scratchCardListData![status][index * 2]["scratchCard"][0] =
                                  scratchCardData;
                              setState(() {});
                            });
                          },
                        ),
                        (_scratchCardListProvider!.scratchCardListState.progressState == 2 && orderData2.isEmpty)
                            ? SizedBox()
                            : ScratchCardWidget(
                                orderModel: orderData1.isEmpty ? null : OrderModel.fromJson(orderData2),
                                isLoading: orderData2.isEmpty,
                                callback: (Map<String, dynamic> scratchCardData) {
                                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                                    _scratchCardListProvider!.scratchCardListState.scratchCardListData![status][index * 2]["scratchCard"][0] =
                                        scratchCardData;
                                    setState(() {});
                                  });
                                },
                              ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
