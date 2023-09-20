import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/invoice_widget.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class InvoiceListView extends StatefulWidget {
  InvoiceListView({Key? key}) : super(key: key);

  @override
  _InvoiceListViewState createState() => _InvoiceListViewState();
}

class _InvoiceListViewState extends State<InvoiceListView> with SingleTickerProviderStateMixin {
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

  InvoicesProvider? _invoicesProvider;

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

    _invoicesProvider = InvoicesProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    _invoicesProvider!.setInvoicesState(
      _invoicesProvider!.invoicesState.update(
        progressState: 0,
        invoicesListData: [],
        invoicesMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _invoicesProvider!.addListener(_invoicesProviderListener);

      _invoicesProvider!.setInvoicesState(_invoicesProvider!.invoicesState.update(progressState: 1));
      _invoicesProvider!.getStoreInvoices();
    });
  }

  @override
  void dispose() {
    _invoicesProvider!.removeListener(_invoicesProviderListener);

    super.dispose();
  }

  void _invoicesProviderListener() async {
    if (_invoicesProvider!.invoicesState.progressState == -1) {
      if (_invoicesProvider!.invoicesState.isRefresh!) {
        _invoicesProvider!.setInvoicesState(
          _invoicesProvider!.invoicesState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_invoicesProvider!.invoicesState.progressState == 2) {
      if (_invoicesProvider!.invoicesState.isRefresh!) {
        _invoicesProvider!.setInvoicesState(
          _invoicesProvider!.invoicesState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic> invoicesListData = _invoicesProvider!.invoicesState.invoicesListData!;
    Map<String, dynamic> invoicesMetaData = _invoicesProvider!.invoicesState.invoicesMetaData!;

    invoicesListData = [];
    invoicesMetaData = Map<String, dynamic>();
    _invoicesProvider!.setInvoicesState(
      _invoicesProvider!.invoicesState.update(
        progressState: 1,
        invoicesListData: invoicesListData,
        invoicesMetaData: invoicesMetaData,
        isRefresh: true,
      ),
    );

    _invoicesProvider!.getStoreInvoices(
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _invoicesProvider!.setInvoicesState(
      _invoicesProvider!.invoicesState.update(progressState: 1),
    );
    _invoicesProvider!.getStoreInvoices(
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyInvoiceListHandler() {
    List<dynamic> invoicesListData = _invoicesProvider!.invoicesState.invoicesListData!;
    Map<String, dynamic> invoicesMetaData = _invoicesProvider!.invoicesState.invoicesMetaData!;

    invoicesListData = [];
    invoicesMetaData = Map<String, dynamic>();
    _invoicesProvider!.setInvoicesState(
      _invoicesProvider!.invoicesState.update(
        progressState: 1,
        invoicesListData: invoicesListData,
        invoicesMetaData: invoicesMetaData,
      ),
    );

    _invoicesProvider!.getStoreInvoices(
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
          "Invoices",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<InvoicesProvider>(builder: (context, invoicesProvider, _) {
        if (invoicesProvider.invoicesState.progressState == 0) {
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
                        "Create invoices and send orders to customers to do your business at ease",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
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
        contentVerticalPadding: heightDp * 8,
        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.6)),
        hintText: InvoiceListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyInvoiceListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyInvoiceListHandler();
        },
      ),
    );
  }

  Widget _notificationListPanel() {
    List<dynamic> notificationList = [];
    Map<String, dynamic> invoicesMetaData = Map<String, dynamic>();
    int itemCount = 0;

    notificationList = _invoicesProvider!.invoicesState.invoicesListData!;
    invoicesMetaData = _invoicesProvider!.invoicesState.invoicesMetaData!;
    itemCount += _invoicesProvider!.invoicesState.invoicesListData!.length;

    if (_invoicesProvider!.invoicesState.progressState == 1) {
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
              enablePullUp: (invoicesMetaData["nextPage"] != null && _invoicesProvider!.invoicesState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Invoice Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> orderData = (index >= notificationList.length) ? Map<String, dynamic>() : notificationList[index];
                        if (orderData.isNotEmpty && orderData["user"] == null) orderData["user"] = AuthProvider.of(context).authState.userModel;

                        return InvoiceWidget(
                          orderModel: orderData.isEmpty ? null : OrderModel.fromJson(orderData),
                          isLoading: orderData.isEmpty,
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
