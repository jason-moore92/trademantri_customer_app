// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:trapp/config/app_config.dart' as config;
// import 'package:trapp/src/elements/keicy_raised_button.dart';
// import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
// import 'package:trapp/src/elements/service_item_for_selection_widget.dart';
// import 'package:trapp/src/helpers/date_time_convert.dart';
// import 'package:trapp/src/models/index.dart';
// import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
// 
// import 'keicy_avatar_image.dart';

// class InvoiceWidget extends StatelessWidget {
//   final Map<String, dynamic>? orderData;
//   final bool? isLoading;

//   InvoiceWidget({
//     @required this.orderData,
//     @required this.isLoading,
//   });

//   /// Responsive design variables
//   double? deviceWidth;
//   double? deviceHeight;
//   double? statusbarHeight;
//   double? bottomBarHeight;
//   double? appbarHeight;
//   double? widthDp;
//   double? heightDp;
//   double? heightDp1;
//   double? fontSp;
//   ///////////////////////////////

//   @override
//   Widget build(BuildContext context) {
//     /// Responsive design variables
//     deviceWidth = 1.sw;
//     deviceHeight = 1.sh;
//     statusbarHeight = ScreenUtil().statusBarHeight;
//     bottomBarHeight = ScreenUtil().bottomBarHeight;
//     appbarHeight = AppBar().preferredSize.height;
//     widthDp = ScreenUtil().setWidth(1);
//     heightDp = ScreenUtil().setWidth(1);
//     heightDp1 = ScreenUtil().setHeight(1);
//     fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
//     ///////////////////////////////

//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 5),
//       elevation: 5,
//       color: Colors.white,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 10),
//         color: Colors.transparent,
//         child: isLoading! ? _shimmerWidget() : _notificationWidget(context),
//       ),
//     );
//   }

//   Widget _shimmerWidget() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       direction: ShimmerDirection.ltr,
//       enabled: isLoading!,
//       period: Duration(milliseconds: 1000),
//       child: Row(
//         children: [
//           Container(width: heightDp! * 80, height: heightDp! * 80, color: Colors.black),
//           SizedBox(width: widthDp! * 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   color: Colors.white,
//                   child: Text(
//                     "notification storeName",
//                     style: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(height: heightDp! * 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                       color: Colors.white,
//                       child: Text(
//                         "2021-09-23",
//                         style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: heightDp! * 5),
//                 Container(
//                   color: Colors.white,
//                   child: Text(
//                     "orderData title",
//                     style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 SizedBox(height: heightDp! * 5),
//                 Container(
//                   color: Colors.white,
//                   child: Text(
//                     "orderData body\npaymentLinkData body body body body",
//                     style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
//                     maxLines: 3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _notificationWidget(BuildContext context) {
//     Map<String, dynamic>? productData;
//     Map<String, dynamic>? serviceData;

//     if (orderData!["products"].length != 0) {
//       productData = orderData!["products"][0];
//     }
//     if (orderData!["services"].length != 0) {
//       serviceData = orderData!["services"][0];
//     }

//     return GestureDetector(
//       onTap: () {},
//       child: Column(
//         children: [
//           Row(
//             children: [
//               KeicyAvatarImage(
//                 url: orderData!["store"]["profile"]["image"],
//                 width: widthDp! * 70,
//                 height: widthDp! * 70,
//                 backColor: Colors.grey.withOpacity(0.4),
//                 borderRadius: heightDp! * 6,
//                 errorWidget: ClipRRect(
//                   borderRadius: BorderRadius.circular(heightDp! * 6),
//                   child: Image.asset(
//                     "img/store-icon/${orderData!["store"]["subType"].toString().toLowerCase()}-store.png",
//                     width: widthDp! * 70,
//                     height: widthDp! * 70,
//                   ),
//                 ),
//               ),
//               SizedBox(width: widthDp! * 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "${orderData!["store"]["name"]} Store",
//                           style: TextStyle(fontSize: fontSp! * 14, fontWeight: FontWeight.bold, color: Colors.black),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 3),
//                           decoration: BoxDecoration(
//                             color: orderData!["payStatus"] ? Colors.green : Colors.red,
//                             borderRadius: BorderRadius.circular(heightDp! * 6),
//                           ),
//                           child: Text(
//                             orderData!["payStatus"] ? "Paid" : "Not Paid",
//                             style: TextStyle(
//                               fontSize: fontSp! * 14,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: heightDp! * 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           orderData!["orderId"],
//                           style: TextStyle(fontSize: fontSp! * 12, color: Colors.black, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           KeicyDateTime.convertDateTimeToDateString(
//                             dateTime: DateTime.parse(orderData!["updatedAt"]).toLocal(),
//                             formats: "Y-m-d H:i",
//                             isUTC: false,
//                           ),
//                           style: TextStyle(fontSize: fontSp! * 12, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: heightDp! * 5),
//                     Row(
//                       children: [
//                         Text(
//                           '${orderData!["store"]["city"]}',
//                           style: TextStyle(fontSize: fontSp! * 11, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: heightDp! * 5),
//                     Text(
//                       "${orderData!["store"]["address"]}",
//                       style: TextStyle(fontSize: fontSp! * 11, color: Colors.black),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: heightDp! * 10),
//           Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
//           if (productData != null)
//             Column(
//               children: [
//                 SizedBox(height: heightDp! * 10),
//                 ProductItemForSelectionWidget(
//                   productData: productData,
//                   isLoading: productData.isEmpty,
//                 ),
//               ],
//             ),
//           if (productData == null && serviceData != null)
//             Column(
//               children: [
//                 SizedBox(height: heightDp! * 10),
//                 ServiceItemForSelectionWidget(
//                   serviceData: productData!,
//                   isLoading: productData.isEmpty,
//                 ),
//               ],
//             ),
//           SizedBox(height: heightDp! * 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   "To view invoice order details",
//                   style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
//                 ),
//               ),
//               SizedBox(width: widthDp! * 10),
//               KeicyRaisedButton(
//                 width: widthDp! * 120,
//                 height: heightDp! * 35,
//                 borderRadius: heightDp! * 6,
//                 color: config.Colors().mainColor(1),
//                 child: Text(
//                   "Details",
//                   style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (BuildContext context) => OrderDetailNewPage(
//                         orderModel: OrderModel.fromJson(orderData!),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
