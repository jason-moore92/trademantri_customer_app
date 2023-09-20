import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/review_and_rating_widget.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class ProductItemReviewView extends StatefulWidget {
  final Map<String, dynamic>? itemData;
  final String? type;

  ProductItemReviewView({
    Key? key,
    this.itemData,
    this.type,
  }) : super(key: key);

  @override
  _ProductItemReviewViewState createState() => _ProductItemReviewViewState();
}

class _ProductItemReviewViewState extends State<ProductItemReviewView> {
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

  bool isLoading = false;

  ProductItemReviewProvider? _productItemReviewProvider;

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

    _productItemReviewProvider = ProductItemReviewProvider.of(context);

    _productItemReviewProvider!.setProductItemReviewState(
      _productItemReviewProvider!.productItemReviewState.update(
        progressState: 0,
        reviewList: [],
        reviewMetaData: Map<String, dynamic>(),
        isRefresh: true,
      ),
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _productItemReviewProvider!.addListener(_productItemReviewProviderListener);

      _productItemReviewProvider!.getProductItemReviewList(
        itemId: widget.itemData!["_id"],
        type: widget.type,
      );
    });
  }

  @override
  void dispose() {
    _productItemReviewProvider!.removeListener(_productItemReviewProviderListener);

    super.dispose();
  }

  void _productItemReviewProviderListener() async {
    if (_productItemReviewProvider!.productItemReviewState.progressState == -1) {
      if (_productItemReviewProvider!.productItemReviewState.isRefresh!) {
        _refreshController.refreshFailed();
        _productItemReviewProvider!.setProductItemReviewState(
          _productItemReviewProvider!.productItemReviewState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController.loadFailed();
      }
    } else if (_productItemReviewProvider!.productItemReviewState.progressState == 2) {
      if (_productItemReviewProvider!.productItemReviewState.isRefresh!) {
        _refreshController.refreshCompleted();
        _productItemReviewProvider!.setProductItemReviewState(
          _productItemReviewProvider!.productItemReviewState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    _productItemReviewProvider!.setProductItemReviewState(
      _productItemReviewProvider!.productItemReviewState.update(
        progressState: 1,
        reviewList: [],
        reviewMetaData: Map<String, dynamic>(),
        isRefresh: true,
      ),
    );

    await _productItemReviewProvider!.getProductItemReviewList(
      itemId: widget.itemData!["_id"],
      type: widget.type,
    );
  }

  void _onLoading() async {
    _productItemReviewProvider!.setProductItemReviewState(
      _productItemReviewProvider!.productItemReviewState.update(progressState: 1),
    );
    await _productItemReviewProvider!.getProductItemReviewList(
      itemId: widget.itemData!["_id"],
      type: widget.type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.itemData!["name"] + ProductItemReviewPageString.appbarTitle,
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<ProductItemReviewProvider>(builder: (context, productItemReviewProvider, _) {
        if (productItemReviewProvider.productItemReviewState.progressState == 0 ||
            productItemReviewProvider.productItemReviewState.progressState == 1) {
          // return Center(child: CupertinoActivityIndicator());
          isLoading = true;
        } else {
          isLoading = false;
        }

        if (productItemReviewProvider.productItemReviewState.progressState == -1) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
              child: Center(
                child: Text(
                  productItemReviewProvider.productItemReviewState.message!,
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
                      _productItemReviewProvider!.productItemReviewState.reviewMetaData == null ||
                      _productItemReviewProvider!.productItemReviewState.reviewMetaData!["nextPage"] == null
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
                          ProductItemReviewPageString.readMoreBitton,
                          style: TextStyle(fontSize: fontSp * 15, color: Colors.black),
                        ),
                        onPressed: () async {
                          _productItemReviewProvider!.setProductItemReviewState(
                            _productItemReviewProvider!.productItemReviewState.update(progressState: 1),
                          );
                          await _productItemReviewProvider!.getProductItemReviewList(
                            itemId: widget.itemData!["_id"],
                            type: widget.type,
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
    if (_productItemReviewProvider!.productItemReviewState.reviewList != null) {
      reviewListCount = _productItemReviewProvider!.productItemReviewState.reviewList!.length;
    }

    itemCount = reviewListCount + (!isLoading ? 0 : AppConfig.countLimitForList);
    if (itemCount == 0)
      return Center(
        child: Text(
          "No Review Available",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        ),
      );
    return ListView.separated(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        Map<String, dynamic> reviewAndRatingData;

        if (_productItemReviewProvider!.productItemReviewState.reviewList == null) {
          reviewAndRatingData = Map<String, dynamic>();
        } else {
          reviewAndRatingData = (index >= _productItemReviewProvider!.productItemReviewState.reviewList!.length)
              ? Map<String, dynamic>()
              : _productItemReviewProvider!.productItemReviewState.reviewList![index];
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
