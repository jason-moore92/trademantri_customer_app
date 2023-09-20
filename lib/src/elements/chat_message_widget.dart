import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/chat_model.dart';
import 'package:trapp/src/pages/CouponDetailPage/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:url_launcher/url_launcher.dart';

class ChatMessageWidget extends StatefulWidget {
  final ChatRoomModel? chatRoomModel;
  final ChatModel? chatModel;
  final bool? isLoading;
  final String? myUserId;
  final File? file;
  final List<File>? imageFileList;

  ChatMessageWidget({
    @required this.chatRoomModel,
    @required this.chatModel,
    @required this.myUserId,
    @required this.isLoading,
    this.file,
    @required this.imageFileList,
  });

  @override
  _BargainRequestWidgetState createState() => _BargainRequestWidgetState();
}

class _BargainRequestWidgetState extends State<ChatMessageWidget> {
  /// Responsive design variables
  double? deviceWidth;
  double? deviceHeight;
  double? statusbarHeight;
  double? bottomBarHeight;
  double? appbarHeight;
  double? widthDp;
  double? heightDp;
  double? heightDp1;
  double? fontSp;
  ///////////////////////////////

  GlobalKey _imageKey = GlobalKey();
  double? _imageWidth;
  double? _imageHeight;

  bool isMine = false;

  var numFormat = NumberFormat.currency(symbol: "", name: "");

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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_imageWidth == null && _imageHeight == null && _imageKey.currentContext != null) {
        try {
          RenderBox renderBox = _imageKey.currentContext!.findRenderObject() as RenderBox;
          _imageWidth = renderBox.size.width;
          _imageHeight = renderBox.size.height;
          setState(() {});
        } catch (e) {
          FlutterLogs.logThis(
            tag: "chat_message_widget",
            level: LogLevel.ERROR,
            subTag: "addPostFrameCallback",
            exception: e is Exception ? e : null,
            error: e is Error ? e : null,
            errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isMine = widget.chatModel!.senderId == widget.myUserId;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: heightDp! * 5),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (widget.chatModel!.createAt == null || widget.isLoading!)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp! * 10),
              child: CupertinoActivityIndicator(),
            )
          else
            Column(
              crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.chatModel!.messageType == MessageType.text) _textWidget(),
                    if (widget.chatModel!.messageType == MessageType.invoice) _paymnetLinkWidget(),
                    if (widget.chatModel!.messageType == MessageType.image) _imageWidget(),
                    if (widget.chatModel!.messageType == MessageType.file) _fileWidget(),
                    if (widget.chatModel!.messageType == MessageType.coupon) _couponWidget(),
                  ],
                ),
                SizedBox(height: heightDp! * 5),
                Text(
                  KeicyDateTime.convertDateTimeToDateString(
                    dateTime: widget.chatModel!.createAt,
                    formats: "h:i A",
                    isUTC: false,
                  ),
                  style: TextStyle(fontSize: fontSp! * 8, color: Colors.black),
                  textAlign: isMine ? TextAlign.end : TextAlign.start,
                )
              ],
            ),
        ],
      ),
    );
  }

  Widget _textWidget() {
    return Container(
      constraints: BoxConstraints(maxWidth: deviceWidth! * 0.7),
      padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
      decoration: BoxDecoration(
        color: isMine ? config.Colors().mainColor(0.3) : Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMine ? heightDp! * 6 : 0),
          topRight: Radius.circular(heightDp! * 6),
          bottomLeft: Radius.circular(heightDp! * 6),
          bottomRight: Radius.circular(isMine ? 0 : heightDp! * 6),
        ),
      ),
      child: Text(
        "${widget.chatModel!.message}",
        style: TextStyle(
          fontSize: fontSp! * 12,
          color: Colors.black,
          decorationStyle: TextDecorationStyle.solid,
          decorationThickness: 1,
          decorationColor: Colors.black,
          decoration: widget.chatModel!.additionalData["messageType"] == MessageType.invoice ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }

  Widget _paymnetLinkWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailNewPage(
              orderId: widget.chatModel!.additionalData['orderId'],
              storeId: widget.chatModel!.additionalData['storeId'],
              userId: widget.chatModel!.additionalData['userId'],
            ),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: deviceWidth! * 0.7),
        padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
        decoration: BoxDecoration(
          color: isMine ? config.Colors().mainColor(0.3) : Colors.blue.withOpacity(0.3),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMine ? heightDp! * 6 : 0),
            topRight: Radius.circular(heightDp! * 6),
            bottomLeft: Radius.circular(heightDp! * 6),
            bottomRight: Radius.circular(isMine ? 0 : heightDp! * 6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.chatModel!.message}",
              style: TextStyle(
                fontSize: fontSp! * 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                decorationStyle: TextDecorationStyle.solid,
                decorationThickness: 1,
                decorationColor: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              "Quantity: ${numFormat.format(widget.chatModel!.additionalData['totalQuantity'])}",
              style: TextStyle(
                fontSize: fontSp! * 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Amount: ₹ ${numFormat.format(widget.chatModel!.additionalData['toPay'])}",
              style: TextStyle(
                fontSize: fontSp! * 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageWidget() {
    if (widget.chatModel!.additionalData["uploadStatus"] == "uploaded")
      return SizedBox(
        width: deviceWidth! * 0.5,
        height: (deviceWidth! * 0.5) / widget.chatModel!.additionalData["rate"],
        child: Container(
          width: deviceWidth! * 0.5,
          height: (deviceWidth! * 0.5) / widget.chatModel!.additionalData["rate"],
          color: Colors.grey.withOpacity(0.4),
          child: KeicyAvatarImage(
            url: widget.chatModel!.message,
            width: deviceWidth! * 0.5,
            height: (deviceWidth! * 0.5) / widget.chatModel!.additionalData["rate"],
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    if (widget.file != null)
      return Stack(
        children: [
          Image.file(
            widget.file!,
            width: deviceWidth! * 0.5,
            fit: BoxFit.fitWidth,
          ),
          if (widget.chatModel!.additionalData["rate"] != null)
            Container(
              width: deviceWidth! * 0.5,
              height: (deviceWidth! * 0.5) / widget.chatModel!.additionalData["rate"],
              constraints: BoxConstraints(maxWidth: deviceWidth! * 0.5),
              color: Colors.black.withOpacity(0.2),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );

    return SizedBox();
  }

  Widget _fileWidget() {
    return widget.chatModel!.message == "uploading"
        ? CupertinoActivityIndicator()
        : Container(
            constraints: BoxConstraints(maxWidth: deviceWidth! * 0.7),
            decoration: BoxDecoration(
              color: isMine ? config.Colors().mainColor(0.3) : Colors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMine ? heightDp! * 6 : 0),
                topRight: Radius.circular(heightDp! * 6),
                bottomLeft: Radius.circular(heightDp! * 6),
                bottomRight: Radius.circular(isMine ? 0 : heightDp! * 6),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
                  child: Text(
                    "${widget.chatModel!.additionalData["fileName"]}",
                    style: TextStyle(
                      fontSize: fontSp! * 14,
                      color: Colors.black,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 1,
                      decorationColor: Colors.black,
                      decoration:
                          widget.chatModel!.additionalData["messageType"] == MessageType.invoice ? TextDecoration.underline : TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(height: heightDp! * 10),
                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.7)),
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch(widget.chatModel!.message!)) {
                      await launch(
                        widget.chatModel!.message!,
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    } else {
                      throw 'Could not launch ${widget.chatModel!.message!}';
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Open",
                            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _couponWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => CouponDetailPage(
              couponId: widget.chatModel!.additionalData['couponId'],
            ),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: deviceWidth! * 0.7),
        padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
        decoration: BoxDecoration(
          color: isMine ? config.Colors().mainColor(0.3) : Colors.blue.withOpacity(0.3),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMine ? heightDp! * 6 : 0),
            topRight: Radius.circular(heightDp! * 6),
            bottomLeft: Radius.circular(heightDp! * 6),
            bottomRight: Radius.circular(isMine ? 0 : heightDp! * 6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Coupon",
              style: TextStyle(
                fontSize: fontSp! * 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                decorationStyle: TextDecorationStyle.solid,
                decorationThickness: 1,
                decorationColor: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              "Code: ${widget.chatModel!.additionalData['discountCode']}",
              style: TextStyle(
                fontSize: fontSp! * 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
