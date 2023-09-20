library keicy_text_form_field;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRCodeIconWidget extends StatefulWidget {
  @override
  _QRCodeIconWidgetState createState() => _QRCodeIconWidgetState();
}

class _QRCodeIconWidgetState extends State<QRCodeIconWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  @override
  Widget build(BuildContext context) {
    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    return GestureDetector(
      onTap: () async {
        if (AuthProvider.of(context).authState.userModel!.id == null) {
          LoginAskDialog.show(context, callback: () async {
            qrcodeHandler();
          });
        } else {
          qrcodeHandler();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: widthDp * 10),
        color: Colors.transparent,
        child: Image.asset(
          "img/qrcode_scan.png",
          width: heightDp * 40,
          height: heightDp * 40,
          fit: BoxFit.cover,
          // color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }

  void qrcodeHandler() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      var newStatus = await Permission.camera.request();
      if (!newStatus.isGranted) {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "Your camera permission isn't granted",
          isTryButton: false,
          callBack: () {
            Navigator.of(context).pop();
          },
        );
        return;
      }
    }
    NormalDialog.show(
      context,
      content: "Scan Store QR code to open the store directly, Scan Order QR-code to open the order details",
      callback: () async {
        var result = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
        if (result == "-1") return;
        String qrCodeString = Encrypt.decryptString(result);

        String type = qrCodeString.split("_").first;

        if (qrCodeString.contains("http")) {
          if (await canLaunch(qrCodeString)) {
            await launch(
              qrCodeString,
              forceSafariVC: false,
              forceWebView: false,
            );
          } else {
            throw 'Could not launch $qrCodeString';
          }
          return;
        } else if (type == "Order") {
          String orderId = qrCodeString.split("_")[1];
          String storeId = qrCodeString.split("_")[2].split("-").last;
          String userId = qrCodeString.split("_")[3].split("-").last;
          if (userId == AuthProvider.of(context).authState.userModel!.id) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => OrderDetailNewPage(
                  orderId: orderId,
                  storeId: storeId,
                  userId: userId,
                ),
              ),
            );
            return;
          } else {
            ErrorDialog.show(
              context,
              widthDp: widthDp,
              heightDp: heightDp,
              fontSp: fontSp,
              text: "This order does not belong to you, please try a different QR code",
              callBack: () {
                qrcodeHandler();
              },
              isTryButton: true,
            );
            return;
          }
        } else if (type == "Store") {
          String storeId = qrCodeString.split("_")[1];
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => StorePage(storeId: storeId),
            ),
          );
          return;
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "This qr code is invalid. Please try again",
            callBack: () {
              qrcodeHandler();
            },
            isTryButton: true,
          );
        }
      },
    );
  }
}
