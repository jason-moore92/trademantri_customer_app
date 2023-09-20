import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/announcement_widget.dart';
import 'package:trapp/src/elements/coupon_widget.dart';
import 'package:trapp/src/elements/job_posting_widget.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_item_widget.dart';
import 'package:trapp/src/elements/service_item_widget.dart';
import 'package:trapp/src/elements/store_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/AnnouncementDetailPage/index.dart';
import 'package:trapp/src/pages/CouponDetailPage/index.dart';
import 'package:trapp/src/pages/ProductItemDetailPage/index.dart';
import 'package:trapp/src/pages/SearchPage/index.dart';
import 'package:trapp/src/pages/StoreJobPostingApplyPage/index.dart';
import 'package:trapp/src/pages/StoreJobPostingDetailPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/pages/LoginAskPage/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class FavoriteListView extends StatefulWidget {
  final bool haveAppBar;

  FavoriteListView({Key? key, this.haveAppBar = false}) : super(key: key);

  @override
  _FavoriteListViewState createState() => _FavoriteListViewState();
}

class _FavoriteListViewState extends State<FavoriteListView> with SingleTickerProviderStateMixin {
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
  FavoriteProvider? _favoriteProvider;

  List<RefreshController> _refreshControllerList = [];

  TabController? _tabController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int _oldTabIndex = 0;

  List<String> _categoires = ["Stores", "Products", "Services", "Coupons", "Announcements", "store-job-postings"];

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

    _favoriteProvider = FavoriteProvider.of(context);
    _authProvider = AuthProvider.of(context);

    _refreshControllerList = [];
    for (var i = 0; i < _categoires.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = 0;

    _tabController = TabController(length: _categoires.length, vsync: this);

    _tabController!.addListener(_tabControllerListener);

    _favoriteProvider!.setFavoriteState(
      _favoriteProvider!.favoriteState.update(
        favoriteObjectListData: Map<String, dynamic>(),
        favoriteObjectMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _favoriteProvider!.addListener(_favoriteProviderListener);

      if (_authProvider!.authState.userModel!.id != null) {
        _favoriteProvider!.setFavoriteState(_favoriteProvider!.favoriteState.update(progressState: 1));
        _favoriteProvider!.getFavoriteData(
          userId: _authProvider!.authState.userModel!.id,
          category: _categoires[0].toLowerCase(),
        );
      }
    });
  }

  @override
  void dispose() {
    _favoriteProvider!.removeListener(_favoriteProviderListener);

    super.dispose();
  }

  void _favoriteProviderListener() async {
    if (_favoriteProvider!.favoriteState.progressState == -1) {
      if (_favoriteProvider!.favoriteState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _favoriteProvider!.setFavoriteState(
          _favoriteProvider!.favoriteState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_favoriteProvider!.favoriteState.progressState == 2) {
      if (_favoriteProvider!.favoriteState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _favoriteProvider!.setFavoriteState(
          _favoriteProvider!.favoriteState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _tabControllerListener() {
    if (_authProvider!.authState.userModel!.id == null) return;

    if ((_favoriteProvider!.favoriteState.progressState != 1) &&
        (_controller.text.isNotEmpty ||
            _favoriteProvider!.favoriteState.favoriteObjectListData![_categoires[_tabController!.index].toLowerCase()] == null ||
            _favoriteProvider!.favoriteState.favoriteObjectListData![_categoires[_tabController!.index].toLowerCase()].isEmpty)) {
      Map<String, dynamic> favoriteObjectListData = _favoriteProvider!.favoriteState.favoriteObjectListData!;
      Map<String, dynamic> favoriteObjectMetaData = _favoriteProvider!.favoriteState.favoriteObjectMetaData!;

      if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
        favoriteObjectListData[_categoires[_oldTabIndex].toLowerCase()] = [];
        favoriteObjectMetaData[_categoires[_oldTabIndex].toLowerCase()] = Map<String, dynamic>();
      }

      _favoriteProvider!.setFavoriteState(
        _favoriteProvider!.favoriteState.update(
          progressState: 1,
          favoriteObjectListData: favoriteObjectListData,
          favoriteObjectMetaData: favoriteObjectMetaData,
        ),
        isNotifiable: false,
      );

      _controller.clear();
      _oldTabIndex = _tabController!.index;

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _favoriteProvider!.getFavoriteData(
          userId: _authProvider!.authState.userModel!.id,
          category: _categoires[_tabController!.index].toLowerCase(),
          searchKey: _controller.text.trim(),
        );
      });
    }
    _oldTabIndex = _tabController!.index;
    setState(() {});
  }

  void _onRefresh() async {
    if (_authProvider!.authState.userModel!.id != null) {
      Map<String, dynamic> favoriteObjectListData = _favoriteProvider!.favoriteState.favoriteObjectListData!;
      Map<String, dynamic> favoriteObjectMetaData = _favoriteProvider!.favoriteState.favoriteObjectMetaData!;

      favoriteObjectListData[_categoires[_tabController!.index].toLowerCase()] = [];
      favoriteObjectMetaData[_categoires[_tabController!.index].toLowerCase()] = Map<String, dynamic>();
      _favoriteProvider!.setFavoriteState(
        _favoriteProvider!.favoriteState.update(
          progressState: 1,
          favoriteObjectListData: favoriteObjectListData,
          favoriteObjectMetaData: favoriteObjectMetaData,
          isRefresh: true,
        ),
      );
      _favoriteProvider!.getFavoriteData(
        userId: _authProvider!.authState.userModel!.id,
        category: _categoires[_tabController!.index].toLowerCase(),
        searchKey: _controller.text.trim(),
      );
    }
  }

  void _onLoading() async {
    if (_authProvider!.authState.userModel!.id != null) {
      _favoriteProvider!.setFavoriteState(
        _favoriteProvider!.favoriteState.update(progressState: 1),
      );
      _favoriteProvider!.getFavoriteData(
        userId: _authProvider!.authState.userModel!.id,
        category: _categoires[_tabController!.index].toLowerCase(),
        searchKey: _controller.text.trim(),
      );
    }
  }

  void _searchKeyFavoriteListHandler() {
    if (_authProvider!.authState.userModel!.id != null) {
      Map<String, dynamic> favoriteObjectListData = _favoriteProvider!.favoriteState.favoriteObjectListData!;
      Map<String, dynamic> favoriteObjectMetaData = _favoriteProvider!.favoriteState.favoriteObjectMetaData!;

      favoriteObjectListData[_categoires[_tabController!.index].toLowerCase()] = [];
      favoriteObjectMetaData[_categoires[_tabController!.index].toLowerCase()] = Map<String, dynamic>();
      _favoriteProvider!.setFavoriteState(
        _favoriteProvider!.favoriteState.update(
          progressState: 1,
          favoriteObjectListData: favoriteObjectListData,
          favoriteObjectMetaData: favoriteObjectMetaData,
        ),
      );
      _favoriteProvider!.getFavoriteData(
        userId: _authProvider!.authState.userModel!.id,
        category: _categoires[_tabController!.index].toLowerCase(),
        searchKey: _controller.text.trim(),
      );
    }
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
                "Favorites",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: AuthProvider.of(context).authState.userModel!.id == null
          ? LoginAskPage(
              callback: () => Navigator.of(context).pushNamed('/Pages', arguments: {"currentTab": 4}),
            )
          : Consumer<FavoriteProvider>(builder: (context, favoriteProvider, _) {
              // if (favoriteProvider.favoriteState.progressState == 0) {
              //   return Center(child: CupertinoActivityIndicator());
              // }
              return DefaultTabController(
                length: _categoires.length,
                child: Container(
                  width: deviceWidth,
                  height: deviceHeight,
                  child: Column(
                    children: [
                      _searchField(),
                      _tabBar(),
                      Expanded(child: _favoriteListPanel()),
                    ],
                  ),
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
        hintText: FavoriteListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        readOnly: _authProvider!.authState.userModel!.id == null,
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
        isScrollable: true,
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

  Widget _favoriteListPanel() {
    String category = _categoires[_tabController!.index].toLowerCase();

    List<dynamic> favoriteList = [];
    Map<String, dynamic> favoriteObjectMetaData = Map<String, dynamic>();

    if (_favoriteProvider!.favoriteState.favoriteObjectListData![category] != null) {
      favoriteList = _favoriteProvider!.favoriteState.favoriteObjectListData![category];
    }
    if (_favoriteProvider!.favoriteState.favoriteObjectMetaData![category] != null) {
      favoriteObjectMetaData = _favoriteProvider!.favoriteState.favoriteObjectMetaData![category];
    }

    int itemCount = 0;

    if (_favoriteProvider!.favoriteState.favoriteObjectListData![category] != null) {
      List<dynamic> data = _favoriteProvider!.favoriteState.favoriteObjectListData![category];
      itemCount += data.length;
    }

    if (_favoriteProvider!.favoriteState.progressState == 1) {
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
              enablePullDown: _authProvider!.authState.userModel!.id == null ? false : true,
              enablePullUp: _authProvider!.authState.userModel!.id == null
                  ? false
                  : (favoriteObjectMetaData["nextPage"] != null && _favoriteProvider!.favoriteState.progressState != 1),
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
                                            : _tabController!.index == 4
                                                ? "Announcement"
                                                : _tabController!.index == 5
                                                    ? "Job Posting"
                                                    : "") +
                            " Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> favoriteData = (index >= favoriteList.length) ? Map<String, dynamic>() : favoriteList[index];

                        switch (_tabController!.index) {
                          case 0:
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: heightDp * 10),
                              child: StoreWidget(
                                storeModel: favoriteData.isNotEmpty ? StoreModel.fromJson(favoriteData["data"]) : null,
                                loadingStatus: favoriteData.isEmpty,
                                buttonString: "Go to Store",
                                callback: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => StorePage(storeModel: StoreModel.fromJson(favoriteData["data"])),
                                    ),
                                  );
                                },
                              ),
                            );
                          case 1:
                            return Stack(
                              children: [
                                ProductItemWidget(
                                  productModel: favoriteData.isNotEmpty ? ProductModel.fromJson(favoriteData["data"]) : null,
                                  storeModel: favoriteData.isNotEmpty ? StoreModel.fromJson(favoriteData["store"]) : null,
                                  isLoading: favoriteData.isEmpty,
                                  isShowQuantity: false,
                                  isShowFavorite: false,
                                  isShowStoreName: true,
                                  tapCallback: () async {
                                    var result = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => ProductItemDetailPage(
                                          storeModel: StoreModel.fromJson(favoriteData["store"]),
                                          productModel: ProductModel.fromJson(favoriteData["data"]),
                                          type: "products",
                                          isForCart: true,
                                        ),
                                      ),
                                    );

                                    if (result != null && result) {
                                      _onRefresh();
                                    }
                                  },
                                ),
                              ],
                            );
                          case 2:
                            return ServiceItemWidget(
                              serviceData: favoriteData["data"],
                              storeModel: favoriteData.isNotEmpty ? StoreModel.fromJson(favoriteData["store"]) : null,
                              isLoading: favoriteData.isEmpty,
                              isShowFavorite: false,
                              isShowStoreName: true,
                              tapCallback: () async {
                                var result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ProductItemDetailPage(
                                      storeModel: StoreModel.fromJson(favoriteData["store"]),
                                      serviceModel: ServiceModel.fromJson(favoriteData["data"]),
                                      type: "services",
                                      isForCart: true,
                                    ),
                                  ),
                                );

                                if (result != null && result) {
                                  _onRefresh();
                                }
                              },
                            );
                          case 3:
                            return CouponWidget(
                              couponModel: favoriteData.isNotEmpty ? CouponModel.fromJson(favoriteData["data"]) : null,
                              storeModel: favoriteData["store"] != null ? StoreModel.fromJson(favoriteData["store"]) : null,
                              isLoading: favoriteData.isEmpty,
                              isShowFavorite: false,
                              isShowStoreName: true,
                              isGoToStore: true,
                              isShowView: false,
                            );
                          case 4:
                            if (favoriteData.isNotEmpty) {
                              favoriteData["data"]["store"] = favoriteData["store"];
                              favoriteData["data"]["coupon"] = favoriteData["coupon"];
                            }
                            return AnnouncementWidget(
                                announcementData: favoriteData["data"],
                                storeData: favoriteData["store"],
                                isLoading: favoriteData.isEmpty,
                                isShowStoreButton: true,
                                isShowFavoriteButton: false,
                                goToStoreHandler: () async {
                                  var result = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => StorePage(
                                        storeModel: StoreModel.fromJson(favoriteData["store"]),
                                      ),
                                    ),
                                  );
                                },
                                detailHandler: () async {
                                  var result = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => AnnouncementDetailPage(
                                        announcementData: favoriteData["data"],
                                        storeData: favoriteData["store"],
                                      ),
                                    ),
                                  );
                                });
                          case 5:
                            if (favoriteData.isNotEmpty) {
                              favoriteData["data"]["store"] = favoriteData["store"];
                            }
                            return JobPostingWidget(
                              jobPostingData: favoriteData["data"],
                              isLoading: favoriteData.isEmpty,
                              isShowFavorite: false,
                              detailHandler: () async {
                                var result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => StoreJobPostingDetailPage(
                                      jobPostingData: favoriteData["data"],
                                    ),
                                  ),
                                );

                                if (result != null && result["isUpdated"]) {
                                  Map<String, dynamic>? favoriteObjectListData = _favoriteProvider!.favoriteState.favoriteObjectListData;

                                  favoriteObjectListData![category][index] = result["jobPostingData"];
                                  _favoriteProvider!.setFavoriteState(
                                    _favoriteProvider!.favoriteState.update(
                                      favoriteObjectListData: favoriteObjectListData,
                                    ),
                                    isNotifiable: false,
                                  );

                                  setState(() {});
                                }
                              },
                              applyHandler: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => StoreJobPostingApplyPage(
                                      appliedJobData: {
                                        "jobPosting": favoriteData["data"],
                                        "store": favoriteData["store"],
                                      },
                                      isNew: true,
                                    ),
                                  ),
                                );
                              },
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
