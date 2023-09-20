import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/payment_link_widget.dart';
import 'package:trapp/src/pages/PaymentLinkDetailPage/index.dart';
import 'package:trapp/src/pages/PaymentPage/payment_page.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class PaymentLinkListView extends StatefulWidget {
  PaymentLinkListView({Key? key}) : super(key: key);

  @override
  _PaymentLinkListViewState createState() => _PaymentLinkListViewState();
}

class _PaymentLinkListViewState extends State<PaymentLinkListView> with WidgetsBindingObserver {
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
  PaymentLinkProvider? _paymentLinkProvider;

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

    _paymentLinkProvider = PaymentLinkProvider.of(context);
    _authProvider = AuthProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    _paymentLinkProvider!.setPaymentLinkState(
      _paymentLinkProvider!.paymentLinkState.update(
        progressState: 0,
        paymentLinkListData: [],
        paymentLinkMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _paymentLinkProvider!.addListener(_paymentLinkProviderListener);

      _paymentLinkProvider!.setPaymentLinkState(_paymentLinkProvider!.paymentLinkState.update(progressState: 1));
      _paymentLinkProvider!.getNotificationData(
        userId: _authProvider!.authState.userModel!.id,
      );
    });
  }

  @override
  void dispose() {
    _paymentLinkProvider!.removeListener(_paymentLinkProviderListener);

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PaymentLinkListView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  void _paymentLinkProviderListener() async {
    if (_paymentLinkProvider!.paymentLinkState.progressState == -1) {
      if (_paymentLinkProvider!.paymentLinkState.isRefresh!) {
        _paymentLinkProvider!.setPaymentLinkState(
          _paymentLinkProvider!.paymentLinkState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_paymentLinkProvider!.paymentLinkState.progressState == 2) {
      if (_paymentLinkProvider!.paymentLinkState.isRefresh!) {
        _paymentLinkProvider!.setPaymentLinkState(
          _paymentLinkProvider!.paymentLinkState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic> paymentLinkListData = _paymentLinkProvider!.paymentLinkState.paymentLinkListData!;
    Map<String, dynamic> paymentLinkMetaData = _paymentLinkProvider!.paymentLinkState.paymentLinkMetaData!;

    paymentLinkListData = [];
    paymentLinkMetaData = Map<String, dynamic>();
    _paymentLinkProvider!.setPaymentLinkState(
      _paymentLinkProvider!.paymentLinkState.update(
        progressState: 1,
        paymentLinkListData: paymentLinkListData,
        paymentLinkMetaData: paymentLinkMetaData,
        isRefresh: true,
      ),
    );

    _paymentLinkProvider!.getNotificationData(
      userId: _authProvider!.authState.userModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _paymentLinkProvider!.setPaymentLinkState(
      _paymentLinkProvider!.paymentLinkState.update(progressState: 1),
    );
    _paymentLinkProvider!.getNotificationData(
      userId: _authProvider!.authState.userModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyPaymentLinkListHandler() {
    List<dynamic> paymentLinkListData = _paymentLinkProvider!.paymentLinkState.paymentLinkListData!;
    Map<String, dynamic> paymentLinkMetaData = _paymentLinkProvider!.paymentLinkState.paymentLinkMetaData!;

    paymentLinkListData = [];
    paymentLinkMetaData = Map<String, dynamic>();
    _paymentLinkProvider!.setPaymentLinkState(
      _paymentLinkProvider!.paymentLinkState.update(
        progressState: 1,
        paymentLinkListData: paymentLinkListData,
        paymentLinkMetaData: paymentLinkMetaData,
      ),
    );

    _paymentLinkProvider!.getNotificationData(
      userId: _authProvider!.authState.userModel!.id,
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
          "Payment Links",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<PaymentLinkProvider>(builder: (context, paymentLinkProvider, _) {
        if (paymentLinkProvider.paymentLinkState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Access all your payment links from different stores here.",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                    // SizedBox(width: widthDp * 5),
                    // KeicyRaisedButton(
                    //   width: widthDp * 140,
                    //   height: heightDp * 35,
                    //   color: config.Colors().mainColor(1),
                    //   borderRadius: heightDp * 6,
                    //   padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                    //   child: Text(
                    //     "+ New Payment",
                    //     style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    //   ),
                    //   onPressed: () {
                    //     // Navigator.of(context).push(
                    //     //   MaterialPageRoute(
                    //     //     builder: (BuildContext context) => GeneratePaymentLinkPage(
                    //     //       customerData: {},
                    //     //       storeData: AuthProvider.of(context).authState.userData["storeData"],
                    //     //     ),
                    //     //   ),
                    //     // );
                    //   },
                    // ),
                  ],
                ),
              ),
              SizedBox(height: heightDp * 10),
              _searchField(),
              SizedBox(height: heightDp * 10),
              Expanded(child: _notificationListPanel()),
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
        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.6)),
        hintText: PaymentLinkListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyPaymentLinkListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyPaymentLinkListHandler();
        },
        onEditingCompleteHandler: () {
          // FocusScope.of(context).requestFocus(FocusNode());
          // _searchKeyPaymentLinkListHandler();
        },
      ),
    );
  }

  Widget _notificationListPanel() {
    List<dynamic> notificationList = [];
    Map<String, dynamic> paymentLinkMetaData = Map<String, dynamic>();
    int itemCount = 0;

    notificationList = _paymentLinkProvider!.paymentLinkState.paymentLinkListData!;
    paymentLinkMetaData = _paymentLinkProvider!.paymentLinkState.paymentLinkMetaData!;
    itemCount += _paymentLinkProvider!.paymentLinkState.paymentLinkListData!.length;

    if (_paymentLinkProvider!.paymentLinkState.progressState == 1) {
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
              enablePullUp: (paymentLinkMetaData["nextPage"] != null && _paymentLinkProvider!.paymentLinkState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Payment Link Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> paymentLinkData = (index >= notificationList.length) ? Map<String, dynamic>() : notificationList[index];

                        return PaymentLinkWidget(
                          paymentLinkData: paymentLinkData,
                          isLoading: paymentLinkData.isEmpty,
                          tapHandler: () async {
                            var result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => PaymentLinkDetailPage(
                                  paymentLinkData: paymentLinkData,
                                ),
                              ),
                            );

                            if (result != null && result) {
                              _onRefresh();
                            }
                          },
                          payHandler: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => PaymentPage(
                                  paymentLink: paymentLinkData["paymentData"]["short_url"],
                                ),
                              ),
                            );

                            _onRefresh();
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
