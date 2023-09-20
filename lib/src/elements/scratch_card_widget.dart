import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/models/order_model.dart';
import 'package:trapp/src/providers/ScratchCardProvider/index.dart';

class ScratchCardWidget extends StatefulWidget {
  final OrderModel? orderModel;
  final bool? isLoading;
  final Function? callback;

  ScratchCardWidget({@required this.orderModel, @required this.isLoading, @required this.callback});

  @override
  _ScratchCardWidgetState createState() => _ScratchCardWidgetState();
}

class _ScratchCardWidgetState extends State<ScratchCardWidget> {
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

  ScratchCardProvider? _scratchCardProvider;

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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: widthDp * 10,
        right: widthDp * 10,
        top: heightDp * 5,
        bottom: heightDp * 10,
      ),
      elevation: 5,
      child: Container(
        width: widthDp * 170,
        height: heightDp * 250,
        color: Colors.transparent,
        child: widget.isLoading! ? _shimmerWidget() : _orderWidget(),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.isLoading!,
      period: Duration(milliseconds: 1000),
      child: Container(
        width: widthDp * 170,
        height: heightDp * 250,
        color: Colors.white,
      ),
    );
  }

  Widget _orderWidget() {
    if (widget.orderModel!.scratchCard![0]["status"] == "not_scratched") {
      return GestureDetector(
        onTap: () async {
          await ScratchCardDialog.show(
            context,
            scratchCardId: widget.orderModel!.scratchCard![0]["_id"],
            callback: (Map<String, dynamic> scratchCardData) {
              Navigator.of(context).pop();
              widget.callback!(scratchCardData);
            },
          );
        },
        child: Container(
          width: widthDp * 170,
          height: heightDp * 250,
          color: config.Colors().mainColor(1),
        ),
      );
    } else if (widget.orderModel!.scratchCard![0]["status"] == "scratched" && widget.orderModel!.scratchCard![0]["amount"] == 0) {
      return _nextTimeWidget();
    } else if (widget.orderModel!.scratchCard![0]["status"] == "scratched" && widget.orderModel!.scratchCard![0]["amount"] != 0) {
      return _winWidget();
    }
    return SizedBox();

    // double _opacity = 0.0;
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => ScratchCardProvider()),
    //   ],
    //   child: Consumer<ScratchCardProvider>(builder: (context, scratchCardProvider, _) {
    //     if (_scratchCardProvider == null) _scratchCardProvider = ScratchCardProvider.of(context);

    //     if (scratchCardProvider.scratchCardState.scratchCardData!["status"] == "scratched") {
    //       if (widget.callback != null) {
    //         widget.callback!(scratchCardProvider.scratchCardState.scratchCardData!);
    //       }
    //       widget.orderModel!.scratchCard![0] = scratchCardProvider.scratchCardState.scratchCardData!;
    //     }

    //     if (widget.orderModel!.scratchCard![0]["status"] == "scratched") return _winWidget();

    //     return Column(
    //       children: [
    //         StatefulBuilder(builder: (context, StateSetter setState) {
    //           return Scratcher(
    //             color: scratchCardProvider.scratchCardState.progressState != 1 && _opacity == 1 ? Colors.transparent : config.Colors().mainColor(1),
    //             accuracy: ScratchAccuracy.low,
    //             threshold: 50,
    //             brushSize: heightDp * 40,
    //             onThreshold: () async {
    //               _opacity = 1;
    //               setState(() {});
    //             },
    //             onScratchStart: () {
    //               if (scratchCardProvider.scratchCardState.progressState == 0) {
    //                 scratchCardProvider.setScratchCardState(scratchCardProvider.scratchCardState.update(progressState: 1));
    //                 scratchCardProvider.getScratchCard(scratchCardId: widget.orderModel!.scratchCard![0]["_id"]);
    //               }
    //             },
    //             child: AnimatedOpacity(
    //               duration: Duration(milliseconds: 100),
    //               opacity: _opacity,
    //               child: Container(
    //                 width: widthDp * 170,
    //                 height: heightDp * 250,
    //                 child: scratchCardProvider.scratchCardState.progressState == 1
    //                     ? _loadingWidget()
    //                     : scratchCardProvider.scratchCardState.progressState == -1
    //                         ? _nextTimeWidget()
    //                         : scratchCardProvider.scratchCardState.progressState == 2 &&
    //                                 scratchCardProvider.scratchCardState.scratchCardData!["amount"] == 0
    //                             ? _nextTimeWidget()
    //                             : scratchCardProvider.scratchCardState.progressState == 2 &&
    //                                     scratchCardProvider.scratchCardState.scratchCardData!["amount"] != 0
    //                                 ? _winWidget()
    //                                 : SizedBox(),
    //               ),
    //             ),
    //           );
    //         }),
    //       ],
    //     );
    //   }),
    // );
  }

  Widget _nextTimeWidget() {
    return Container(
      width: widthDp * 170,
      height: heightDp * 250,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      child: Center(
        child: Image.asset(
          "img/betterlucknexttime.png",
          width: heightDp * 150,
          height: heightDp * 150,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      width: widthDp * 170,
      height: heightDp * 250,
      child: Center(
        child: Text(
          "Loading ...",
          style: TextStyle(fontSize: fontSp * 20),
        ),
      ),
    );
  }

  Widget _winWidget() {
    return Container(
      width: widthDp * 170,
      height: heightDp * 250,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              "img/youwon.png",
              height: double.infinity,
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(height: heightDp * 10),
          Text(
            "₹ ${widget.orderModel!.scratchCard![0]["amount"]}",
            style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "* The amount is converted into TradeMantri points and is added to your account. The total points you won",
            style: TextStyle(fontSize: fontSp * 12),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "${widget.orderModel!.scratchCard![0]["amountInPoints"]} Pts",
            style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
