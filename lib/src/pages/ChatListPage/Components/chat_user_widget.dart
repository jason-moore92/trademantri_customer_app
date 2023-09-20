import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/chat_model.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/providers/AuthProvider/auth_provider.dart';

class ChatUserWidget extends StatefulWidget {
  final ChatRoomModel? chatRoomModel;
  final bool? isFirstUser;
  final bool? loadingStatus;
  final Function? callback;

  ChatUserWidget({
    @required this.chatRoomModel,
    @required this.isFirstUser,
    @required this.loadingStatus,
    this.callback,
  });

  @override
  _StoreWidgetState createState() => _StoreWidgetState();
}

class _StoreWidgetState extends State<ChatUserWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      color: Colors.transparent,
      child: widget.loadingStatus! ? _shimmerWidget() : _storeWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Row(
        children: [
          Container(
            width: widthDp * 80,
            height: widthDp * 80,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightDp * 6)),
          ),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: widthDp * 100,
                  color: Colors.white,
                  child: Text(
                    "Loading ...",
                    style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.transparent),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  width: widthDp * 140,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        'storeData city',
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                      SizedBox(width: widthDp * 15),
                      Text(
                        'Km',
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  width: widthDp * 200,
                  color: Colors.white,
                  child: Text(
                    "storeData address",
                    style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  width: widthDp * 100,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 5), color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, size: heightDp * 15, color: Colors.white),
                      SizedBox(width: widthDp * 5),
                      Text(
                        "type",
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeWidget() {
    Map<String, dynamic>? useData;
    String? userType = "";
    int? newMessageCount = 0;
    String? imageUrl = "";
    String? userName = "";
    String? email = "";
    Widget? errorWidget;

    if (widget.chatRoomModel!.lastSenderId != AuthProvider.of(context).authState.userModel!.id && widget.chatRoomModel!.newMessageCount != 0) {
      newMessageCount = widget.chatRoomModel!.newMessageCount!;
    }

    if (widget.isFirstUser!) {
      useData = widget.chatRoomModel!.firstUserData!;
      userType = widget.chatRoomModel!.firstUserType;
    } else {
      useData = widget.chatRoomModel!.secondUserData!;
      userType = widget.chatRoomModel!.secondUserType;
    }

    if (userType == ChatUserTypes.customer) {
      imageUrl = useData["imageUrl"];
      userName = (useData["firstName"] + " " + useData["lastName"]).toString().toUpperCase();
      email = useData["email"];
    } else if (userType == ChatUserTypes.business) {
      userName = useData["name"];
      email = useData["email"];
      imageUrl = useData["profile"]["image"];
      errorWidget = ClipRRect(
        borderRadius: BorderRadius.circular(widthDp * 60),
        child: Image.asset(
          "img/store-icon/${useData["subType"].toString().toLowerCase()}-store.png",
          width: widthDp * 60,
          height: widthDp * 60,
          fit: BoxFit.fill,
        ),
      );
    } else if (userType == ChatUserTypes.delivery) {
      imageUrl = useData["imageUrl"];
      userName = (useData["firstName"] + " " + useData["lastName"]).toString().toUpperCase();
      email = useData["email"];
    }

    String lastMessage = "";
    Widget icon = SizedBox();
    // widget.chatRoomModel!.lastMessage == "" ? "No message" : '${widget.chatRoomModel!.lastMessage}',
    if (widget.chatRoomModel!.lastMessage == "") {
      lastMessage = "No message";
    } else {
      switch (widget.chatRoomModel!.lastMessageType) {
        case MessageType.text:
          lastMessage = widget.chatRoomModel!.lastMessage!;
          // icon = Text("A", style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold));
          icon = Icon(Icons.title_outlined, size: heightDp * 20);
          break;
        case MessageType.invoice:
          lastMessage = "Invoice";
          icon = Image.asset("img/payment.png", width: heightDp * 25, height: heightDp * 25);
          break;
        case MessageType.image:
          lastMessage = "Image";
          icon = Icon(Icons.image_outlined, size: heightDp * 20);
          break;
        case MessageType.file:
          lastMessage = "File";
          icon = RotatedBox(quarterTurns: 1, child: Icon(Icons.link, size: heightDp * 20));
          break;
        case MessageType.coupon:
          lastMessage = "Coupon";
          icon = Image.asset("img/coupons.png", width: heightDp * 25, height: heightDp * 25);
          break;
        case MessageType.b2bInvoice:
          lastMessage = "B2B Invoice";
          icon = Image.asset("img/payment.png", width: heightDp * 25, height: heightDp * 25);
          break;
        default:
      }
    }

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Stack(
            children: [
              KeicyAvatarImage(
                url: imageUrl,
                width: widthDp * 60,
                height: widthDp * 60,
                backColor: Colors.grey.withOpacity(0.4),
                borderRadius: widthDp * 60,
                shimmerEnable: widget.loadingStatus!,
                userName: userName,
                textStyle: TextStyle(fontSize: fontSp * 20),
                errorWidget: errorWidget,
              ),
              if (newMessageCount != 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(heightDp * 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text("$newMessageCount", style: TextStyle(fontSize: fontSp * 10, color: Colors.white)),
                  ),
                ),
            ],
          ),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$userName",
                  style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.bold, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: heightDp * 5),
                Text(
                  "$email",
                  style: TextStyle(fontSize: fontSp * 12, fontWeight: FontWeight.bold, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  children: [
                    icon,
                    SizedBox(width: widthDp * 5),
                    Text(
                      lastMessage,
                      style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: widthDp * 10),
          Container(
            width: widthDp * 90,
            child: Column(
              children: [
                widget.chatRoomModel!.isBlocked!
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 8, vertical: heightDp * 5),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(heightDp * 5)),
                        child: Text(
                          "Blocked",
                          style: TextStyle(fontSize: fontSp * 10, color: Colors.white, height: 1),
                        ),
                      )
                    : Text(
                        KeicyDateTime.convertDateTimeToDateString(
                          dateTime: widget.chatRoomModel!.lastMessageDate,
                          formats: 'Y-m-d\nh:i A',
                          isUTC: false,
                        ),
                        style: TextStyle(
                          fontSize: fontSp * 10,
                          color: widget.chatRoomModel!.lastMessage == "" ? Colors.transparent : Colors.black,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
