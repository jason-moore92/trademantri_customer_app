import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/store_reward_point_widget.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class MyReferralListForStoreView extends StatefulWidget {
  MyReferralListForStoreView({Key? key}) : super(key: key);

  @override
  _MyReferralListForStoreViewState createState() => _MyReferralListForStoreViewState();
}

class _MyReferralListForStoreViewState extends State<MyReferralListForStoreView> with SingleTickerProviderStateMixin {
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
  ReferralRewardU2SOffersProvider? _referralRewardU2SOffersProvider;
  RefreshController? _refreshController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  String status = "ALL";

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

    _referralRewardU2SOffersProvider = ReferralRewardU2SOffersProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _refreshController = RefreshController(initialRefresh: false);

    // _referralRewardU2SOffersProvider!.setReferralRewardU2SOffersState(
    //   _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.update(
    //     progressState: 0,
    //     referralRewardOffersListData: Map<String, dynamic>(),
    //     referralRewardOffersMetaData: Map<String, dynamic>(),
    //   ),
    //   isNotifiable: false,
    // );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _referralRewardU2SOffersProvider!.addListener(_referralRewardU2SOffersProviderListener);

      if (_referralRewardU2SOffersProvider!.referralRewardU2SOffersState.progressState == 0) {
        _referralRewardU2SOffersProvider!.setReferralRewardU2SOffersState(
          _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.update(progressState: 1),
        );
        _referralRewardU2SOffersProvider!.getReferralRewardU2SOffersData(
          referredByUserId: _authProvider!.authState.userModel!.id,
        );
      }
    });
  }

  @override
  void dispose() {
    _referralRewardU2SOffersProvider!.removeListener(_referralRewardU2SOffersProviderListener);

    super.dispose();
  }

  void _referralRewardU2SOffersProviderListener() async {
    if (_referralRewardU2SOffersProvider!.referralRewardU2SOffersState.progressState == -1) {
      if (_referralRewardU2SOffersProvider!.referralRewardU2SOffersState.isRefresh!) {
        _referralRewardU2SOffersProvider!.setReferralRewardU2SOffersState(
          _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_referralRewardU2SOffersProvider!.referralRewardU2SOffersState.progressState == 2) {
      if (_referralRewardU2SOffersProvider!.referralRewardU2SOffersState.isRefresh!) {
        _referralRewardU2SOffersProvider!.setReferralRewardU2SOffersState(
          _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic> referralRewardOffersListData = _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.referralRewardOffersListData!;
    Map<String, dynamic> referralRewardOffersMetaData = _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.referralRewardOffersMetaData!;

    referralRewardOffersListData[status] = [];
    referralRewardOffersMetaData[status] = Map<String, dynamic>();
    _referralRewardU2SOffersProvider!.setReferralRewardU2SOffersState(
      _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.update(
        progressState: 1,
        referralRewardOffersListData: referralRewardOffersListData,
        referralRewardOffersMetaData: referralRewardOffersMetaData,
        isRefresh: true,
      ),
    );

    _referralRewardU2SOffersProvider!.getReferralRewardU2SOffersData(
      referredByUserId: _authProvider!.authState.userModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _referralRewardU2SOffersProvider!.setReferralRewardU2SOffersState(
      _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.update(progressState: 1),
    );
    _referralRewardU2SOffersProvider!.getReferralRewardU2SOffersData(
      referredByUserId: _authProvider!.authState.userModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyMyReferralListForStoreHandler() {
    Map<String, dynamic> referralRewardOffersListData = _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.referralRewardOffersListData!;
    Map<String, dynamic> referralRewardOffersMetaData = _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.referralRewardOffersMetaData!;

    referralRewardOffersListData[status] = [];
    referralRewardOffersMetaData[status] = Map<String, dynamic>();
    _referralRewardU2SOffersProvider!.setReferralRewardU2SOffersState(
      _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.update(
        progressState: 1,
        referralRewardOffersListData: referralRewardOffersListData,
        referralRewardOffersMetaData: referralRewardOffersMetaData,
      ),
    );

    _referralRewardU2SOffersProvider!.getReferralRewardU2SOffersData(
      referredByUserId: _authProvider!.authState.userModel!.id,
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
          "My Store Referrals",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<ReferralRewardU2SOffersProvider>(builder: (context, referralRewardU2SOffersProvider, _) {
        if (referralRewardU2SOffersProvider.referralRewardU2SOffersState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              _searchField(),
              Expanded(child: _myReferralListForStorePanel()),
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
        hintText: MyReferralListForStorePageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyMyReferralListForStoreHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyMyReferralListForStoreHandler();
        },
      ),
    );
  }

  Widget _myReferralListForStorePanel() {
    List<dynamic> myReferralListForStore = [];
    Map<String, dynamic> referralRewardOffersMetaData = Map<String, dynamic>();

    if (_referralRewardU2SOffersProvider!.referralRewardU2SOffersState.referralRewardOffersListData![status] != null) {
      myReferralListForStore = _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.referralRewardOffersListData![status];
    }
    if (_referralRewardU2SOffersProvider!.referralRewardU2SOffersState.referralRewardOffersMetaData![status] != null) {
      referralRewardOffersMetaData = _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.referralRewardOffersMetaData![status];
    }

    int itemCount = 0;

    if (_referralRewardU2SOffersProvider!.referralRewardU2SOffersState.referralRewardOffersListData![status] != null) {
      List<dynamic> data = _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.referralRewardOffersListData![status];
      itemCount += data.length;
    }

    if (_referralRewardU2SOffersProvider!.referralRewardU2SOffersState.progressState == 1) {
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
              enablePullUp: (referralRewardOffersMetaData["nextPage"] != null &&
                  _referralRewardU2SOffersProvider!.referralRewardU2SOffersState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Store Review Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> referralRewardData =
                            (index >= myReferralListForStore.length) ? Map<String, dynamic>() : myReferralListForStore[index];

                        return StoreRewardPointWidget(
                          referralRewardData: referralRewardData,
                          isLoading: referralRewardData.isEmpty,
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
