import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/user_reward_point_widget.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class MyReferralListView extends StatefulWidget {
  MyReferralListView({Key? key}) : super(key: key);

  @override
  _MyReferralListViewState createState() => _MyReferralListViewState();
}

class _MyReferralListViewState extends State<MyReferralListView> with SingleTickerProviderStateMixin {
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
  ReferralRewardU2UOffersProvider? _referralRewardOffersProvider;

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

    _referralRewardOffersProvider = ReferralRewardU2UOffersProvider.of(context);
    _authProvider = AuthProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    // _referralRewardOffersProvider!.setReferralRewardU2UOffersState(
    //   _referralRewardOffersProvider!.referralRewardU2UOffersState.update(
    //     progressState: 0,
    //     referralRewardOffersListData: Map<String, dynamic>(),
    //     referralRewardOffersMetaData: Map<String, dynamic>(),
    //   ),
    //   isNotifiable: false,
    // );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _referralRewardOffersProvider!.addListener(_referralRewardOffersProviderListener);

      if (_referralRewardOffersProvider!.referralRewardU2UOffersState.progressState == 0) {
        _referralRewardOffersProvider!
            .setReferralRewardU2UOffersState(_referralRewardOffersProvider!.referralRewardU2UOffersState.update(progressState: 1));
        _referralRewardOffersProvider!.getReferralRewardU2UOffersData(
          referredByUserId: _authProvider!.authState.userModel!.id,
        );
      }
    });
  }

  @override
  void dispose() {
    _referralRewardOffersProvider!.removeListener(_referralRewardOffersProviderListener);

    super.dispose();
  }

  void _referralRewardOffersProviderListener() async {
    if (_referralRewardOffersProvider!.referralRewardU2UOffersState.progressState == -1) {
      if (_referralRewardOffersProvider!.referralRewardU2UOffersState.isRefresh!) {
        _referralRewardOffersProvider!.setReferralRewardU2UOffersState(
          _referralRewardOffersProvider!.referralRewardU2UOffersState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_referralRewardOffersProvider!.referralRewardU2UOffersState.progressState == 2) {
      if (_referralRewardOffersProvider!.referralRewardU2UOffersState.isRefresh!) {
        _referralRewardOffersProvider!.setReferralRewardU2UOffersState(
          _referralRewardOffersProvider!.referralRewardU2UOffersState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic> referralRewardOffersListData = _referralRewardOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData!;
    Map<String, dynamic> referralRewardOffersMetaData = _referralRewardOffersProvider!.referralRewardU2UOffersState.referralRewardOffersMetaData!;

    referralRewardOffersListData[status] = [];
    referralRewardOffersMetaData[status] = Map<String, dynamic>();
    _referralRewardOffersProvider!.setReferralRewardU2UOffersState(
      _referralRewardOffersProvider!.referralRewardU2UOffersState.update(
        progressState: 1,
        referralRewardOffersListData: referralRewardOffersListData,
        referralRewardOffersMetaData: referralRewardOffersMetaData,
        isRefresh: true,
      ),
    );

    _referralRewardOffersProvider!.getReferralRewardU2UOffersData(
      referredByUserId: _authProvider!.authState.userModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _referralRewardOffersProvider!.setReferralRewardU2UOffersState(
      _referralRewardOffersProvider!.referralRewardU2UOffersState.update(progressState: 1),
    );
    _referralRewardOffersProvider!.getReferralRewardU2UOffersData(
      referredByUserId: _authProvider!.authState.userModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyMyReferralListHandler() {
    Map<String, dynamic> referralRewardOffersListData = _referralRewardOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData!;
    Map<String, dynamic> referralRewardOffersMetaData = _referralRewardOffersProvider!.referralRewardU2UOffersState.referralRewardOffersMetaData!;

    referralRewardOffersListData[status] = [];
    referralRewardOffersMetaData[status] = Map<String, dynamic>();
    _referralRewardOffersProvider!.setReferralRewardU2UOffersState(
      _referralRewardOffersProvider!.referralRewardU2UOffersState.update(
        progressState: 1,
        referralRewardOffersListData: referralRewardOffersListData,
        referralRewardOffersMetaData: referralRewardOffersMetaData,
      ),
    );

    _referralRewardOffersProvider!.getReferralRewardU2UOffersData(
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
          "My Referrals",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<ReferralRewardU2UOffersProvider>(builder: (context, referralRewardOffersProvider, _) {
        if (referralRewardOffersProvider.referralRewardU2UOffersState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              _searchField(),
              Expanded(child: _myReferralListPanel()),
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
        hintText: MyReferralListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyMyReferralListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyMyReferralListHandler();
        },
      ),
    );
  }

  Widget _myReferralListPanel() {
    List<dynamic> myReferralList = [];
    Map<String, dynamic> referralRewardOffersMetaData = Map<String, dynamic>();

    if (_referralRewardOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData![status] != null) {
      myReferralList = _referralRewardOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData![status];
    }
    if (_referralRewardOffersProvider!.referralRewardU2UOffersState.referralRewardOffersMetaData![status] != null) {
      referralRewardOffersMetaData = _referralRewardOffersProvider!.referralRewardU2UOffersState.referralRewardOffersMetaData![status];
    }

    int itemCount = 0;

    if (_referralRewardOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData![status] != null) {
      List<dynamic> data = _referralRewardOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData![status];
      itemCount += data.length;
    }

    if (_referralRewardOffersProvider!.referralRewardU2UOffersState.progressState == 1) {
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
                  _referralRewardOffersProvider!.referralRewardU2UOffersState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No User Reward Point Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> referralRewardData = (index >= myReferralList.length) ? Map<String, dynamic>() : myReferralList[index];

                        return UserRewardPointWidget(
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
