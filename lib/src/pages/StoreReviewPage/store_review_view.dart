import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/review_and_rating_widget.dart';
import 'package:trapp/src/providers/StoreReviewPageProvider/store_review_page_provider.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class StoreReviewView extends StatefulWidget {
  final Map<String, dynamic>? storeData;

  StoreReviewView({
    Key? key,
    this.storeData,
  }) : super(key: key);

  @override
  _StoreReviewViewState createState() => _StoreReviewViewState();
}

class _StoreReviewViewState extends State<StoreReviewView> {
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

  bool isLoading = true;

  AuthProvider? _authProvider;
  StoreReviewPageProvider? _storeReviewPageProvider;

  Map<String, dynamic>? storeHoursData;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

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

    _storeReviewPageProvider = StoreReviewPageProvider.of(context);
    _authProvider = AuthProvider.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _storeReviewPageProvider!.addListener(_storeReviewPageProviderListener);

      _storeReviewPageProvider!.getStoreReviewList(
        storeId: widget.storeData!["_id"],
      );
    });
  }

  @override
  void dispose() {
    _storeReviewPageProvider!.removeListener(_storeReviewPageProviderListener);

    super.dispose();
  }

  void _storeReviewPageProviderListener() async {
    if (_storeReviewPageProvider!.storeReviewPageState.progressState == -1) {
      if (_storeReviewPageProvider!.storeReviewPageState.isRefresh!) {
        _refreshController.refreshFailed();
        _storeReviewPageProvider!.setStoreReviewPageState(
          _storeReviewPageProvider!.storeReviewPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController.loadFailed();
      }
    } else if (_storeReviewPageProvider!.storeReviewPageState.progressState == 2) {
      if (_storeReviewPageProvider!.storeReviewPageState.isRefresh!) {
        _refreshController.refreshCompleted();
        _storeReviewPageProvider!.setStoreReviewPageState(
          _storeReviewPageProvider!.storeReviewPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    _storeReviewPageProvider!.setStoreReviewPageState(
      _storeReviewPageProvider!.storeReviewPageState.update(
        progressState: 1,
        reviewList: {widget.storeData!["_id"]: []},
        reviewMetaData: {widget.storeData!["_id"]: Map<String, dynamic>()},
        isRefresh: true,
      ),
    );

    await _storeReviewPageProvider!.getStoreReviewList(
      storeId: widget.storeData!["_id"],
    );
  }

  void _onLoading() async {
    _storeReviewPageProvider!.setStoreReviewPageState(
      _storeReviewPageProvider!.storeReviewPageState.update(progressState: 1),
    );
    await _storeReviewPageProvider!.getStoreReviewList(
      storeId: widget.storeData!["_id"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.storeData!["name"] + StoreReviewPageString.appbarTitle,
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<StoreReviewPageProvider>(builder: (context, storeReviewPageProvider, _) {
        if (storeReviewPageProvider.storeReviewPageState.progressState == 0 || storeReviewPageProvider.storeReviewPageState.progressState == 1) {
          // return Center(child: CupertinoActivityIndicator());
          isLoading = true;
        } else {
          isLoading = false;
        }

        if (storeReviewPageProvider.storeReviewPageState.progressState == -1) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
              child: Center(
                child: Text(
                  storeReviewPageProvider.storeReviewPageState.message!,
                  style: TextStyle(fontSize: fontSp * 15, color: Colors.black),
                ),
              ),
            ),
          );
        }

        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overScroll) {
                    overScroll.disallowGlow();
                    return true;
                  },
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    header: WaterDropHeader(),
                    footer: SizedBox(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: _reviewList(),
                  ),
                ),
              ),
              isLoading ||
                      _storeReviewPageProvider!.storeReviewPageState.reviewMetaData![widget.storeData!["_id"]] == null ||
                      _storeReviewPageProvider!.storeReviewPageState.reviewMetaData![widget.storeData!["_id"]]["nextPage"] == null
                  ? SizedBox()
                  : Container(
                      padding: EdgeInsets.all(heightDp * 20),
                      alignment: Alignment.center,
                      child: KeicyRaisedButton(
                        width: widthDp * 120,
                        height: heightDp * 35,
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: heightDp * 20,
                        child: Text(
                          StoreReviewPageString.readMoreBitton,
                          style: TextStyle(fontSize: fontSp * 15, color: Colors.black),
                        ),
                        onPressed: () async {
                          _storeReviewPageProvider!.setStoreReviewPageState(
                            _storeReviewPageProvider!.storeReviewPageState.update(progressState: 1),
                          );
                          await _storeReviewPageProvider!.getStoreReviewList(
                            storeId: widget.storeData!["_id"],
                          );
                        },
                      ),
                    )
            ],
          ),
        );
      }),
    );
  }

  Widget _reviewList() {
    int reviewListCount = 0;
    int itemCount = 0;
    if (_storeReviewPageProvider!.storeReviewPageState.reviewList![widget.storeData!["_id"]] != null) {
      reviewListCount = _storeReviewPageProvider!.storeReviewPageState.reviewList![widget.storeData!["_id"]].length;
    }

    itemCount = reviewListCount + (!isLoading ? 0 : AppConfig.countLimitForList);

    if (itemCount == 0) {
      return Center(
        child: Text(
          "No Store Review Available",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        ),
      );
    }

    return ListView.separated(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        Map<String, dynamic> reviewAndRatingData;

        if (_storeReviewPageProvider!.storeReviewPageState.reviewList![widget.storeData!["_id"]] == null) {
          reviewAndRatingData = Map<String, dynamic>();
        } else {
          reviewAndRatingData = (index >= _storeReviewPageProvider!.storeReviewPageState.reviewList![widget.storeData!["_id"]].length)
              ? Map<String, dynamic>()
              : _storeReviewPageProvider!.storeReviewPageState.reviewList![widget.storeData!["_id"]][index];
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
          child: ReviewAndRatingWidget(
            reviewAndRatingData: reviewAndRatingData,
            isLoading: index >= reviewListCount,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.4));
      },
    );
  }
}
