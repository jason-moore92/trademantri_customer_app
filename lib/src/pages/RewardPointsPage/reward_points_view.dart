import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/pages/RewardPointsHistoryPage/index.dart';

import 'index.dart';

class RewardPointsView extends StatefulWidget {
  RewardPointsView({Key? key}) : super(key: key);

  @override
  _RewardPointsViewState createState() => _RewardPointsViewState();
}

class _RewardPointsViewState extends State<RewardPointsView> {
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

  RewardPointHistoryProvider? _rewardPointHistoryProvider;
  RefreshController? _refreshController;

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

    _rewardPointHistoryProvider = RewardPointHistoryProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _rewardPointHistoryProvider!.addListener(_rewardPointHistoryProviderListener);

      await _rewardPointHistoryProvider!.sumRewardPoints(userId: AuthProvider.of(context).authState.userModel!.id);
      await _rewardPointHistoryProvider!.getRewardPointsByUser(userId: AuthProvider.of(context).authState.userModel!.id);
    });
  }

  @override
  void dispose() {
    _rewardPointHistoryProvider!.removeListener(_rewardPointHistoryProviderListener);
    super.dispose();
  }

  void _rewardPointHistoryProviderListener() async {
    if (_rewardPointHistoryProvider!.rewardPointHistoryState.progressState == -1) {
      if (_rewardPointHistoryProvider!.rewardPointHistoryState.isRefresh!) {
        _refreshController!.refreshFailed();
        _rewardPointHistoryProvider!.setRewardPointHistoryState(
          _rewardPointHistoryProvider!.rewardPointHistoryState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_rewardPointHistoryProvider!.rewardPointHistoryState.progressState == 2) {
      if (_rewardPointHistoryProvider!.rewardPointHistoryState.isRefresh!) {
        _refreshController!.refreshCompleted();
        _rewardPointHistoryProvider!.setRewardPointHistoryState(
          _rewardPointHistoryProvider!.rewardPointHistoryState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List rewardPointListData = _rewardPointHistoryProvider!.rewardPointHistoryState.rewardPointListData!;
    Map<String, dynamic> rewardPointMetaData = _rewardPointHistoryProvider!.rewardPointHistoryState.rewardPointMetaData!;

    rewardPointListData = [];
    rewardPointMetaData = Map<String, dynamic>();
    _rewardPointHistoryProvider!.setRewardPointHistoryState(
      _rewardPointHistoryProvider!.rewardPointHistoryState.update(
        progressState: 1,
        rewardPointListData: rewardPointListData,
        rewardPointMetaData: rewardPointMetaData,
        isRefresh: true,
      ),
    );

    _rewardPointHistoryProvider!.getRewardPointsByUser(
      userId: AuthProvider.of(context).authState.userModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _rewardPointHistoryProvider!.setRewardPointHistoryState(
      _rewardPointHistoryProvider!.rewardPointHistoryState.update(progressState: 1),
    );
    _rewardPointHistoryProvider!.getRewardPointsByUser(
      userId: AuthProvider.of(context).authState.userModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyProductListHandler() {
    List rewardPointListData = _rewardPointHistoryProvider!.rewardPointHistoryState.rewardPointListData!;
    Map<String, dynamic> rewardPointMetaData = _rewardPointHistoryProvider!.rewardPointHistoryState.rewardPointMetaData!;

    rewardPointListData = [];
    rewardPointMetaData = Map<String, dynamic>();
    _rewardPointHistoryProvider!.setRewardPointHistoryState(
      _rewardPointHistoryProvider!.rewardPointHistoryState.update(
        progressState: 1,
        rewardPointListData: rewardPointListData,
        rewardPointMetaData: rewardPointMetaData,
        isRefresh: true,
      ),
    );

    _rewardPointHistoryProvider!.getRewardPointsByUser(
      userId: AuthProvider.of(context).authState.userModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "My Reward Points",
          style: TextStyle(fontSize: fontSp * 18, color: Color(0xFF162779)),
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
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: Consumer<RewardPointHistoryProvider>(builder: (context, rewardPointHistoryProvider, _) {
          if (rewardPointHistoryProvider.rewardPointHistoryState.progressState == 0) {
            return Column(
              children: [
                Image.asset("img/rewardPoints.png", width: deviceWidth, fit: BoxFit.fitWidth),
                Expanded(child: Center(child: CupertinoActivityIndicator())),
              ],
            );
          }

          if (rewardPointHistoryProvider.rewardPointHistoryState.progressState == -1) {
            return Column(
              children: [
                Image.asset("img/rewardPoints.png", width: deviceWidth, fit: BoxFit.fitWidth),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(widthDp * 20),
                      child: Text(rewardPointHistoryProvider.rewardPointHistoryState.message!, style: TextStyle(fontSize: fontSp * 16)),
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Stack(
                children: [
                  Image.asset("img/rewardPoints.png", width: deviceWidth, fit: BoxFit.fitWidth),
                  Positioned(
                    left: widthDp * 70,
                    top: widthDp * 90,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(heightDp * 8),
                        color: Color(0xFF162779),
                      ),
                      child: Text(
                        "${rewardPointHistoryProvider.rewardPointHistoryState.sumRewardPoint}",
                        style: TextStyle(fontSize: fontSp * 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              _searchField(),
              SizedBox(height: heightDp * 10),
              Expanded(child: _rewardPointListPanel()),
            ],
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
        textInputAction: TextInputAction.done,
        textStyle: TextStyle(fontSize: fontSp * 12, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 12, color: Colors.grey.withOpacity(0.6)),
        hintText: RewardPointsPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyProductListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        // onEditingCompleteHandler: () {
        //   FocusScope.of(context).requestFocus(FocusNode());
        //   _searchKeyProductListHandler();
        // },
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyProductListHandler();
        },
      ),
    );
  }

  Widget _rewardPointListPanel() {
    List<dynamic> rewardPointListData = [];
    Map<String, dynamic> rewardPointMetaData = Map<String, dynamic>();
    int itemCount = 0;

    rewardPointListData = _rewardPointHistoryProvider!.rewardPointHistoryState.rewardPointListData!;
    rewardPointMetaData = _rewardPointHistoryProvider!.rewardPointHistoryState.rewardPointMetaData!;
    itemCount += _rewardPointHistoryProvider!.rewardPointHistoryState.rewardPointListData!.length;

    if (_rewardPointHistoryProvider!.rewardPointHistoryState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (rewardPointMetaData["nextPage"] != null && _rewardPointHistoryProvider!.rewardPointHistoryState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshController!,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Reward Point Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  dynamic rewardData = (index >= rewardPointListData.length) ? Map<String, dynamic>() : rewardPointListData[index];

                  return rewardData.isEmpty ? _storeShimmerWidget() : _storeWidget(rewardData);
                },
              ),
      ),
    );
  }

  Widget _storeWidget(dynamic rewardData) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => RewardPointsHistoryPage(
              historyData: rewardData["history"],
              storeData: rewardData["store"],
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
          alignment: Alignment.center,
          child: Row(
            children: [
              KeicyAvatarImage(
                url: rewardData["store"]["profile"]["image"],
                width: heightDp * 80,
                height: heightDp * 80,
                backColor: Colors.grey.withOpacity(0.4),
                borderRadius: heightDp * 6,
                errorWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(heightDp * 6),
                  child: Image.asset(
                    "img/store-icon/${rewardData["store"]["subType"].toString().toLowerCase()}-store.png",
                    width: heightDp * 80,
                    height: heightDp * 80,
                  ),
                ),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rewardData["store"]["name"], style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w500)),
                    SizedBox(height: heightDp * 5),
                    Text(
                      rewardData["store"]["address"],
                      style: TextStyle(fontSize: fontSp * 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: widthDp * 10),
              Column(
                children: [
                  Row(
                    children: [
                      Image.asset("img/reward_points_icon.png", width: heightDp * 25, height: heightDp * 25),
                      SizedBox(width: widthDp * 5),
                      Text(
                        "${rewardData["rewardPoints"]}",
                        style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.bold, color: config.Colors().mainColor(1)),
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 6), color: config.Colors().mainColor(1)),
                    child: Text(
                      "History",
                      style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _storeShimmerWidget() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        direction: ShimmerDirection.ltr,
        enabled: true,
        period: Duration(milliseconds: 1000),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                width: heightDp * 80,
                height: heightDp * 80,
                color: Colors.white,
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text("dummy store name", style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: heightDp * 5),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "store dummy address store dummy addressstore dummy address store dummy address store dummy address",
                        style: TextStyle(fontSize: fontSp * 12, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: widthDp * 10),
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Image.asset("img/reward_points_icon.png", width: heightDp * 25, height: heightDp * 25),
                        SizedBox(width: widthDp * 5),
                        Text(
                          "100",
                          style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.bold, color: config.Colors().mainColor(1)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heightDp * 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 6), color: Colors.white),
                    child: Text(
                      "Redeem",
                      style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
