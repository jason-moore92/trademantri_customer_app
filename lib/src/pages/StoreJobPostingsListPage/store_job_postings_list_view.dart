import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/job_posting_widget.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/pages/SearchLocationPage/index.dart';
import 'package:trapp/src/pages/StoreJobPostingApplyPage/index.dart';
import 'package:trapp/src/pages/StoreJobPostingDetailPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class StoreJobPostingsListView extends StatefulWidget {
  final String? storeId;

  StoreJobPostingsListView({Key? key, this.storeId = ""}) : super(key: key);

  @override
  _StoreJobPostingsListViewState createState() => _StoreJobPostingsListViewState();
}

class _StoreJobPostingsListViewState extends State<StoreJobPostingsListView> with SingleTickerProviderStateMixin {
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

  StoreJobPostingsProvider? _storeJobPostingsProvider;

  RefreshController? _refreshController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  String status = "ALL";

  Map<String, dynamic> _currentLocation = Map<String, dynamic>();
  int? _currentDistance;

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

    _storeJobPostingsProvider = StoreJobPostingsProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    _storeJobPostingsProvider!.setStoreJobPostingsState(
      _storeJobPostingsProvider!.storeJobPostingsState.update(
        progressState: 0,
        storeJobPostingsListData: [],
        storeJobPostingsMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    if (widget.storeId == "") {
      _currentLocation = AppDataProvider.of(context).appDataState.currentLocation!["location"];
      _currentDistance = AppDataProvider.of(context).appDataState.distance;
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _storeJobPostingsProvider!.addListener(_storeJobPostingsProviderListener);

      _storeJobPostingsProvider!.setStoreJobPostingsState(_storeJobPostingsProvider!.storeJobPostingsState.update(progressState: 1));
      _storeJobPostingsProvider!.getStoreJobPostingsData(
        storeId: widget.storeId!,
        userId: AuthProvider.of(context).authState.userModel!.id,
        latitude: _currentLocation["lat"],
        longitude: _currentLocation["lng"],
        distance: _currentDistance,
        status: status,
        searchKey: _controller.text.trim(),
      );
    });
  }

  @override
  void dispose() {
    _storeJobPostingsProvider!.removeListener(_storeJobPostingsProviderListener);

    super.dispose();
  }

  void _storeJobPostingsProviderListener() async {
    if (_storeJobPostingsProvider!.storeJobPostingsState.progressState == -1) {
      if (_storeJobPostingsProvider!.storeJobPostingsState.isRefresh!) {
        _storeJobPostingsProvider!.setStoreJobPostingsState(
          _storeJobPostingsProvider!.storeJobPostingsState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_storeJobPostingsProvider!.storeJobPostingsState.progressState == 2) {
      if (_storeJobPostingsProvider!.storeJobPostingsState.isRefresh!) {
        _storeJobPostingsProvider!.setStoreJobPostingsState(
          _storeJobPostingsProvider!.storeJobPostingsState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic> storeJobPostingsListData = _storeJobPostingsProvider!.storeJobPostingsState.storeJobPostingsListData!;
    Map<String, dynamic> storeJobPostingsMetaData = _storeJobPostingsProvider!.storeJobPostingsState.storeJobPostingsMetaData!;

    storeJobPostingsListData = [];
    storeJobPostingsMetaData = Map<String, dynamic>();
    _storeJobPostingsProvider!.setStoreJobPostingsState(
      _storeJobPostingsProvider!.storeJobPostingsState.update(
        progressState: 1,
        storeJobPostingsListData: storeJobPostingsListData,
        storeJobPostingsMetaData: storeJobPostingsMetaData,
        isRefresh: true,
      ),
    );

    _storeJobPostingsProvider!.getStoreJobPostingsData(
      storeId: widget.storeId!,
      userId: AuthProvider.of(context).authState.userModel!.id,
      latitude: _currentLocation["lat"],
      longitude: _currentLocation["lng"],
      distance: _currentDistance,
      status: status,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _storeJobPostingsProvider!.setStoreJobPostingsState(
      _storeJobPostingsProvider!.storeJobPostingsState.update(progressState: 1),
    );
    _storeJobPostingsProvider!.getStoreJobPostingsData(
      storeId: widget.storeId!,
      userId: AuthProvider.of(context).authState.userModel!.id,
      latitude: _currentLocation["lat"],
      longitude: _currentLocation["lng"],
      distance: _currentDistance,
      status: status,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyStoreJobPostingsListHandler() {
    List<dynamic> storeJobPostingsListData = _storeJobPostingsProvider!.storeJobPostingsState.storeJobPostingsListData!;
    Map<String, dynamic> storeJobPostingsMetaData = _storeJobPostingsProvider!.storeJobPostingsState.storeJobPostingsMetaData!;

    storeJobPostingsListData = [];
    storeJobPostingsMetaData = Map<String, dynamic>();
    _storeJobPostingsProvider!.setStoreJobPostingsState(
      _storeJobPostingsProvider!.storeJobPostingsState.update(
        progressState: 1,
        storeJobPostingsListData: storeJobPostingsListData,
        storeJobPostingsMetaData: storeJobPostingsMetaData,
      ),
    );

    _storeJobPostingsProvider!.getStoreJobPostingsData(
      storeId: widget.storeId!,
      userId: AuthProvider.of(context).authState.userModel!.id,
      latitude: _currentLocation["lat"],
      longitude: _currentLocation["lng"],
      distance: _currentDistance,
      status: status,
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
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              FavoriteProvider.of(context).favoriteUpdateHandler();

              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            "Find Jobs",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: Consumer<StoreJobPostingsProvider>(builder: (context, storeJobPostingsProvider, _) {
          if (storeJobPostingsProvider.storeJobPostingsState.progressState == 0) {
            return Center(child: CupertinoActivityIndicator());
          }
          return Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: widthDp * 20),
                    Expanded(
                      child: Text(
                        "The best way to start your job search. Find  jobs that match your skillset in a specific location.",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                    if (widget.storeId == "") SizedBox(width: widthDp * 5),
                    if (widget.storeId == "")
                      KeicyRaisedButton(
                        width: widthDp * 160,
                        height: heightDp * 35,
                        color: config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                        child: Text(
                          "Change Location",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                        onPressed: () async {
                          FavoriteProvider.of(context).favoriteUpdateHandler();
                          var result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => SearchLocationPage(isGettingLocation: true),
                            ),
                          );
                          if (result != null) {
                            _currentLocation = result["location"];
                            _currentDistance = result["distance"];
                            setState(() {});
                            _onRefresh();
                          }
                        },
                      ),
                    SizedBox(width: widthDp * 20),
                  ],
                ),
                SizedBox(height: heightDp * 10),
                _searchField(),
                SizedBox(height: heightDp * 10),
                Expanded(child: _storeJobPostingsListPanel()),
              ],
            ),
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
        contentVerticalPadding: heightDp * 8,
        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.6)),
        hintText: StoreJobPostingsListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyStoreJobPostingsListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyStoreJobPostingsListHandler();
        },
      ),
    );
  }

  Widget _storeJobPostingsListPanel() {
    List<dynamic> storeJobPostingsList = [];
    Map<String, dynamic> storeJobPostingsMetaData = Map<String, dynamic>();
    int itemCount = 0;

    storeJobPostingsList = _storeJobPostingsProvider!.storeJobPostingsState.storeJobPostingsListData!;
    storeJobPostingsMetaData = _storeJobPostingsProvider!.storeJobPostingsState.storeJobPostingsMetaData!;
    itemCount += _storeJobPostingsProvider!.storeJobPostingsState.storeJobPostingsListData!.length;

    if (_storeJobPostingsProvider!.storeJobPostingsState.progressState == 1) {
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
              enablePullUp: (storeJobPostingsMetaData["nextPage"] != null && _storeJobPostingsProvider!.storeJobPostingsState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Job Posting Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> jobPostingData =
                            (index >= storeJobPostingsList.length) ? Map<String, dynamic>() : storeJobPostingsList[index];

                        return JobPostingWidget(
                          jobPostingData: jobPostingData,
                          isLoading: jobPostingData.isEmpty,
                          detailHandler: () async {
                            FavoriteProvider.of(context).favoriteUpdateHandler();
                            var result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => StoreJobPostingDetailPage(
                                  jobPostingData: jobPostingData,
                                ),
                              ),
                            );

                            if (result != null && result["isUpdated"]) {
                              List<dynamic> storeJobPostingsListData = _storeJobPostingsProvider!.storeJobPostingsState.storeJobPostingsListData!;

                              storeJobPostingsListData[index] = result["jobPostingData"];
                              _storeJobPostingsProvider!.setStoreJobPostingsState(
                                _storeJobPostingsProvider!.storeJobPostingsState.update(
                                  storeJobPostingsListData: storeJobPostingsListData,
                                ),
                                isNotifiable: false,
                              );

                              setState(() {});
                            }
                          },
                          applyHandler: () async {
                            FavoriteProvider.of(context).favoriteUpdateHandler();
                            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin &&
                                AuthProvider.of(context).authState.userModel!.id != null) {
                              _applyHandler(index, jobPostingData);
                            } else {
                              LoginAskDialog.show(context, callback: () async {
                                _applyHandler(index, jobPostingData);
                              });
                            }
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

  void _applyHandler(int index, Map<String, dynamic> jobPostingData) async {
    KeicyProgressDialog keicyProgressDialog = KeicyProgressDialog.of(context);
    await keicyProgressDialog.show();
    var result = await AppliedJobApiProvider.checkApplied(
      storeJobId: jobPostingData["_id"],
      storeId: jobPostingData["storeId"],
      userId: AuthProvider.of(context).authState.userModel!.id,
    );
    await keicyProgressDialog.hide();

    if (result["success"] && result["data"] == null) {
      var result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => StoreJobPostingApplyPage(
            appliedJobData: {
              "jobPosting": jobPostingData,
              "store": jobPostingData["store"],
            },
            isNew: true,
          ),
        ),
      );

      if (result != null && result["isUpdated"] && result["appliedJob"] != null) {
        jobPostingData["appliedJob"] = result["appliedJob"];
        _storeJobPostingsProvider!.storeJobPostingsState.storeJobPostingsListData![index] = jobPostingData;
        setState(() {});
      }

      return;
    } else {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "This job is already applied.",
      );
      _onRefresh();
    }
  }
}
