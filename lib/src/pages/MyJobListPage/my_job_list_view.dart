import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/applied_job_widget.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/pages/MyJobDetailPage/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class MyJobListView extends StatefulWidget {
  MyJobListView({Key? key}) : super(key: key);

  @override
  _MyJobListViewState createState() => _MyJobListViewState();
}

class _MyJobListViewState extends State<MyJobListView> with SingleTickerProviderStateMixin {
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

  AppliedJobProvider? _appliedJobProvider;
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

    _appliedJobProvider = AppliedJobProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    _appliedJobProvider!.setAppliedJobState(
      _appliedJobProvider!.appliedJobState.update(
        progressState: 0,
        appliedJobListData: [],
        appliedJobMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _appliedJobProvider!.addListener(_appliedJobProviderListener);

      _appliedJobProvider!.setAppliedJobState(_appliedJobProvider!.appliedJobState.update(progressState: 1));
      _appliedJobProvider!.getAppliedJobData(
        status: status,
        searchKey: _controller.text.trim(),
      );
    });
  }

  @override
  void dispose() {
    _appliedJobProvider!.removeListener(_appliedJobProviderListener);

    super.dispose();
  }

  void _appliedJobProviderListener() async {
    if (_appliedJobProvider!.appliedJobState.progressState == -1) {
      if (_appliedJobProvider!.appliedJobState.isRefresh!) {
        _appliedJobProvider!.setAppliedJobState(
          _appliedJobProvider!.appliedJobState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_appliedJobProvider!.appliedJobState.progressState == 2) {
      if (_appliedJobProvider!.appliedJobState.isRefresh!) {
        _appliedJobProvider!.setAppliedJobState(
          _appliedJobProvider!.appliedJobState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic> appliedJobListData = _appliedJobProvider!.appliedJobState.appliedJobListData!;
    Map<String, dynamic> appliedJobMetaData = _appliedJobProvider!.appliedJobState.appliedJobMetaData!;

    appliedJobListData = [];
    appliedJobMetaData = Map<String, dynamic>();
    _appliedJobProvider!.setAppliedJobState(
      _appliedJobProvider!.appliedJobState.update(
        progressState: 1,
        appliedJobListData: appliedJobListData,
        appliedJobMetaData: appliedJobMetaData,
        isRefresh: true,
      ),
    );

    _appliedJobProvider!.getAppliedJobData(
      status: status,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _appliedJobProvider!.setAppliedJobState(
      _appliedJobProvider!.appliedJobState.update(progressState: 1),
    );
    _appliedJobProvider!.getAppliedJobData(
      status: status,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyMyJobListHandler() {
    List<dynamic> appliedJobListData = _appliedJobProvider!.appliedJobState.appliedJobListData!;
    Map<String, dynamic> appliedJobMetaData = _appliedJobProvider!.appliedJobState.appliedJobMetaData!;

    appliedJobListData = [];
    appliedJobMetaData = Map<String, dynamic>();
    _appliedJobProvider!.setAppliedJobState(
      _appliedJobProvider!.appliedJobState.update(
        progressState: 1,
        appliedJobListData: appliedJobListData,
        appliedJobMetaData: appliedJobMetaData,
      ),
    );

    _appliedJobProvider!.getAppliedJobData(
      status: status,
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
          "My Jobs",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<AppliedJobProvider>(builder: (context, appliedJobProvider, _) {
        if (appliedJobProvider.appliedJobState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              _searchField(),
              SizedBox(height: heightDp * 10),
              Expanded(child: _myJobListPanel()),
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
        contentVerticalPadding: heightDp * 8,
        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.6)),
        hintText: MyJobListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyMyJobListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyMyJobListHandler();
        },
      ),
    );
  }

  Widget _myJobListPanel() {
    List<dynamic> myJobList = [];
    Map<String, dynamic> appliedJobMetaData = Map<String, dynamic>();

    if (_appliedJobProvider!.appliedJobState.appliedJobListData != null) {
      myJobList = _appliedJobProvider!.appliedJobState.appliedJobListData!;
    }
    if (_appliedJobProvider!.appliedJobState.appliedJobMetaData != null) {
      appliedJobMetaData = _appliedJobProvider!.appliedJobState.appliedJobMetaData!;
    }

    int itemCount = 0;

    if (_appliedJobProvider!.appliedJobState.appliedJobListData != null) {
      itemCount += _appliedJobProvider!.appliedJobState.appliedJobListData!.length;
    }

    if (_appliedJobProvider!.appliedJobState.progressState == 1) {
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
              enablePullUp: (appliedJobMetaData["nextPage"] != null && _appliedJobProvider!.appliedJobState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Job Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> appliedJobData = (index >= myJobList.length) ? Map<String, dynamic>() : myJobList[index];

                        return AppliedJobWidget(
                          appliedJobData: appliedJobData,
                          isLoading: appliedJobData.isEmpty,
                          detailHandler: () async {
                            var result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => MyJobDetailPage(
                                  appliedJobData: appliedJobData,
                                ),
                              ),
                            );

                            if (result != null && result["isUpdated"]) {
                              // List<dynamic> appliedJobListData = _appliedJobProvider!.appliedJobState.appliedJobListData!;

                              // appliedJobListData[index] = result["jobPostingData"];
                              // _appliedJobProvider!.setAppliedJobState(
                              //   _appliedJobProvider!.appliedJobState.update(
                              //     appliedJobListData: appliedJobListData,
                              //   ),
                              //   isNotifiable: false,
                              // );

                              // setState(() {});
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
}
