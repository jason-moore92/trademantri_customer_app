import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CheckOutPage/index.dart';
import 'package:trapp/src/pages/ReverseAuctionDetailPage/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class ReverseAuctionStoreListView extends StatefulWidget {
  final Map<String, dynamic>? reverseAuctionData;
  final Function? acceptHandler;
  final String? reverseAuctionId;
  final String? storeIdList;

  ReverseAuctionStoreListView({
    Key? key,
    @required this.reverseAuctionData,
    @required this.acceptHandler,
    @required this.reverseAuctionId,
    @required this.storeIdList,
  }) : super(key: key);

  @override
  _ReverseAuctionStoreListViewState createState() => _ReverseAuctionStoreListViewState();
}

class _ReverseAuctionStoreListViewState extends State<ReverseAuctionStoreListView> with SingleTickerProviderStateMixin {
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
  ReverseAuctionStoreProvider? _reverseAuctionStoreProvider;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  String? _updatedOrderStatus;

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

    _reverseAuctionStoreProvider = ReverseAuctionStoreProvider.of(context);
    _authProvider = AuthProvider.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _reverseAuctionStoreProvider!.addListener(_reverseAuctionStoreProviderListener);

      _reverseAuctionStoreProvider!.getAuctionStoreData(
        reverseAuctionId: widget.reverseAuctionId,
        storeIdList: widget.storeIdList,
      );
    });
  }

  @override
  void dispose() {
    _reverseAuctionStoreProvider!.removeListener(_reverseAuctionStoreProviderListener);

    super.dispose();
  }

  void _reverseAuctionStoreProviderListener() async {
    if (_reverseAuctionStoreProvider!.reverseAuctionStoreState.progressState == -1) {
      if (_reverseAuctionStoreProvider!.reverseAuctionStoreState.isRefresh!) {
        _refreshController.refreshFailed();
        _reverseAuctionStoreProvider!.setReverseAuctionStoreState(
          _reverseAuctionStoreProvider!.reverseAuctionStoreState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController.loadFailed();
      }
    } else if (_reverseAuctionStoreProvider!.reverseAuctionStoreState.progressState == 2) {
      if (_reverseAuctionStoreProvider!.reverseAuctionStoreState.isRefresh!) {
        _refreshController.refreshCompleted();
        _reverseAuctionStoreProvider!.setReverseAuctionStoreState(
          _reverseAuctionStoreProvider!.reverseAuctionStoreState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic> reverseAuctionStoreListData = _reverseAuctionStoreProvider!.reverseAuctionStoreState.reverseAuctionStoreListData!;
    Map<String, dynamic> reverseAuctionStoreMetaData = _reverseAuctionStoreProvider!.reverseAuctionStoreState.reverseAuctionStoreMetaData!;

    reverseAuctionStoreListData = [];
    reverseAuctionStoreMetaData = Map<String, dynamic>();
    _reverseAuctionStoreProvider!.setReverseAuctionStoreState(
      _reverseAuctionStoreProvider!.reverseAuctionStoreState.update(
        progressState: 1,
        reverseAuctionStoreListData: reverseAuctionStoreListData,
        reverseAuctionStoreMetaData: reverseAuctionStoreMetaData,
        isRefresh: true,
      ),
    );

    _reverseAuctionStoreProvider!.getAuctionStoreData(
      reverseAuctionId: widget.reverseAuctionId,
      storeIdList: widget.storeIdList,
      searchKey: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _reverseAuctionStoreProvider!.setReverseAuctionStoreState(
      _reverseAuctionStoreProvider!.reverseAuctionStoreState.update(progressState: 1),
    );
    _reverseAuctionStoreProvider!.getAuctionStoreData(
      reverseAuctionId: widget.reverseAuctionId,
      storeIdList: widget.storeIdList,
      searchKey: _textController.text.trim(),
    );
  }

  void _searchKeyReverseAuctionStoreListHandler() {
    List<dynamic> reverseAuctionStoreListData = _reverseAuctionStoreProvider!.reverseAuctionStoreState.reverseAuctionStoreListData!;
    Map<String, dynamic> reverseAuctionStoreMetaData = _reverseAuctionStoreProvider!.reverseAuctionStoreState.reverseAuctionStoreMetaData!;

    reverseAuctionStoreListData = [];
    reverseAuctionStoreMetaData = Map<String, dynamic>();
    _reverseAuctionStoreProvider!.setReverseAuctionStoreState(
      _reverseAuctionStoreProvider!.reverseAuctionStoreState.update(
        progressState: 1,
        reverseAuctionStoreListData: reverseAuctionStoreListData,
        reverseAuctionStoreMetaData: reverseAuctionStoreMetaData,
      ),
    );

    _reverseAuctionStoreProvider!.getAuctionStoreData(
      reverseAuctionId: widget.reverseAuctionId,
      storeIdList: widget.storeIdList,
      searchKey: _textController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(_updatedOrderStatus);
          },
        ),
        centerTitle: true,
        title: Text(
          "Reverse Auction Store List",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<ReverseAuctionStoreProvider>(builder: (context, reverseAuctionStoreProvider, _) {
        if (reverseAuctionStoreProvider.reverseAuctionStoreState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return DefaultTabController(
          length: AppConfig.reverseAuctionStatusData.length,
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                _searchField(),
                SizedBox(height: heightDp * 10),
                Expanded(child: _reverseAuctionListPanel()),
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
        controller: _textController,
        focusNode: _focusNode,
        width: null,
        height: heightDp * 50,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: heightDp * 6,
        contentHorizontalPadding: widthDp * 10,
        textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
        hintText: ReverseAuctionStoreListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _textController.clear();
              _searchKeyReverseAuctionStoreListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyReverseAuctionStoreListHandler();
        },
      ),
    );
  }

  Widget _reverseAuctionListPanel() {
    List<dynamic> reverseAuctionStoreList = [];
    Map<String, dynamic> reverseAuctionStoreMetaData = Map<String, dynamic>();
    int itemCount = 0;

    reverseAuctionStoreList = _reverseAuctionStoreProvider!.reverseAuctionStoreState.reverseAuctionStoreListData!;
    reverseAuctionStoreMetaData = _reverseAuctionStoreProvider!.reverseAuctionStoreState.reverseAuctionStoreMetaData!;
    itemCount += _reverseAuctionStoreProvider!.reverseAuctionStoreState.reverseAuctionStoreListData!.length;

    if (_reverseAuctionStoreProvider!.reverseAuctionStoreState.progressState == 1) {
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
              enablePullUp:
                  (reverseAuctionStoreMetaData["nextPage"] != null && _reverseAuctionStoreProvider!.reverseAuctionStoreState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Store Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> storeData =
                            (index >= reverseAuctionStoreList.length) ? Map<String, dynamic>() : reverseAuctionStoreList[index];
                        return StorePanel(
                          storeData: storeData,
                          acceptHandler: _acceptHandler,
                          status: widget.reverseAuctionData!["status"],
                          loadingStatus: storeData.isEmpty,
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _acceptHandler(double storeBiddingPrice, Map<String, dynamic> storeData) async {
    widget.reverseAuctionData!["offerPrice"] = storeBiddingPrice;

    OrderModel orderModel = OrderModel.fromJson(widget.reverseAuctionData!);
    orderModel.storeModel = StoreModel.fromJson(storeData);
    orderModel.category = AppConfig.orderCategories["reverse_auction"];
    if (orderModel.products!.isNotEmpty) {
      orderModel.products!.first.orderPrice = widget.reverseAuctionData!["offerPrice"];
    }
    if (orderModel.services!.isNotEmpty) {
      orderModel.services!.first.orderPrice = widget.reverseAuctionData!["offerPrice"];
    }

    var result1 = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CheckoutPage(orderModel: orderModel),
      ),
    );

    if (result1 != null && result1) {
      var result = await ReverseAuctionProvider.of(context).updateReverseAuctionData(
        reverseAuctionData: widget.reverseAuctionData!,
        status: AppConfig.reverseAuctionStatusData[4]["id"],
        storeName: storeData["name"],
        userName: "${_authProvider!.authState.userModel!.firstName} ${_authProvider!.authState.userModel!.lastName}",
      );
      if (result["success"]) {
        widget.reverseAuctionData!["status"] = AppConfig.reverseAuctionStatusData[4]["id"];
        _updatedOrderStatus = AppConfig.reverseAuctionStatusData[4]["id"];
        setState(() {});
        SuccessDialog.show(
          context,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "This Auction was accepted",
        );
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: result["message"],
          callBack: () {
            _acceptHandler(storeBiddingPrice, storeData);
          },
        );
      }
    }
  }
}
