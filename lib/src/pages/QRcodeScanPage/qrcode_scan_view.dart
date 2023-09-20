// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:trapp/config/app_config.dart' as config;
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:trapp/src/dialogs/index.dart';
// import 'package:trapp/src/dialogs/normal_ask_dialog.dart';
// import 'package:trapp/src/helpers/encrypt.dart';
// import 'package:trapp/src/pages/OrderDetailPage/index.dart';
// import 'package:trapp/src/pages/StorePage/index.dart';
// import 'package:trapp/src/providers/index.dart';
// import 'index.dart';

// class QRCodeScanView extends StatefulWidget {
//   QRCodeScanView({Key key}) : super(key: key);

//   @override
//   _QRCodeScanViewState createState() => _QRCodeScanViewState();
// }

// class _QRCodeScanViewState extends State<QRCodeScanView> {
//   /// Responsive design variables
//   double deviceWidth;
//   double deviceHeight;
//   double statusbarHeight;
//   double bottomBarHeight;
//   double appbarHeight;
//   double widthDp;
//   double heightDp;
//   double heightDp1;
//   double fontSp;
//   ///////////////////////////////

//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode result;
//   QRViewController controller;

//   bool permission;

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller.resumeCamera();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     /// Responsive design variables
//     deviceWidth = 1.sw;
//     deviceHeight = 1.sh;
//     statusbarHeight = ScreenUtil().statusBarHeight;
//     bottomBarHeight = ScreenUtil().bottomBarHeight;
//     appbarHeight = AppBar().preferredSize.height;
//     widthDp = ScreenUtil().setWidth(1);
//     heightDp = ScreenUtil().setWidth(1);
//     heightDp1 = ScreenUtil().setHeight(1);
//     fontSp = ScreenUtil().setSp(1, ) / ScreenUtil().textScaleFactor;
//     ///////////////////////////////

//     permission = false;

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       var status = await Permission.camera.status;
//       if (!status.isGranted) {
//         var newStatus = await Permission.camera.request();
//         if (!newStatus.isGranted) {
//           ErrorDialog.show(
//             context,
//             widthDp: widthDp,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: "Your camera permission isn't granted",
//             isTryButton: false,
//             callBack: () {
//               Navigator.of(context).pop();
//             },
//           );
//         } else {
//           setState(() {
//             permission = true;
//           });
//         }
//       } else {
//         setState(() {
//           permission = true;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) async {
//       await controller.pauseCamera();
//       result = scanData;
//       try {
//         if (result.code != null) {
//           String qrCodeString = Encrypt.decryptString(result.code);
//           String type = qrCodeString.split("_").first;

//           if (type == "Order") {
//             String orderId = qrCodeString.split("_")[1];
//             String storeId = qrCodeString.split("_")[2].split("-").last;
//             String userId = qrCodeString.split("_")[3].split("-").last;
//             if (userId == AuthProvider.of(context).authState.userModel.id) {
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => OrderDetailPage(
//                     orderId: orderId,
//                     storeId: storeId,
//                     userId: userId,
//                   ),
//                 ),
//               );
//               return;
//             } else {
//               ErrorDialog.show(
//                 context,
//                 widthDp: widthDp,
//                 heightDp: heightDp,
//                 fontSp: fontSp,
//                 text: "This order does not belong to you, please try a different QR code",
//                 callBack: () {
//                   controller.resumeCamera();
//                 },
//                 isTryButton: false,
//               );
//               return;
//             }
//           } else if (type == "Store") {
//             String storeId = qrCodeString.split("_")[1];
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (BuildContext context) => StorePage(storeId: storeId),
//               ),
//             );
//             return;
//           }
//         }
//       } catch (e) {}

//       ErrorDialog.show(
//         context,
//         widthDp: widthDp,
//         heightDp: heightDp,
//         fontSp: fontSp,
//         text: "This qr code is invalid. Please try again",
//         callBack: () {
//           controller.resumeCamera();
//         },
//         isTryButton: false,
//       );
//       return;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!permission) {
//       return Scaffold(
//         body: Center(child: CupertinoActivityIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         centerTitle: true,
//         title: Text(
//           "QR Code Scan",
//           style: TextStyle(fontSize: fontSp * 18, color: Color(0xFF162779)),
//         ),
//         elevation: 0,
//       ),
//       body: Container(
//         width: deviceWidth,
//         height: deviceHeight,
//         child: Column(
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   QRView(
//                     key: qrKey,
//                     onQRViewCreated: _onQRViewCreated,
//                     overlay: QrScannerOverlayShape(
//                       borderColor: Colors.red,
//                       borderRadius: 10,
//                       borderLength: 30,
//                       borderWidth: 10,
//                       cutOutSize: deviceWidth * 0.7,
//                     ),
//                   ),
//                   Container(
//                     width: deviceWidth,
//                     padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
//                     child: Text(
//                       "Scan Store QR code to open the store directly or Scan Order QR code to open the order details.",
//                       style: TextStyle(fontSize: fontSp * 15, color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
