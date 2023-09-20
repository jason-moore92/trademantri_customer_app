import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/DeliveryAddressListPage/index.dart';
import 'package:trapp/src/pages/DeliveryPickupPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class DeliveryAddressBottomSheet {
  static Future<void> show(
    BuildContext context, {
    @required OrderModel? orderModel,
  }) async {
    /// Responsive design variables
    double deviceWidth;
    double widthDp;
    double heightDp;
    double fontSp;

    deviceWidth = 1.sw;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
          bool? isShowMessage;

          DeliveryAddressProvider deliveryAddressProvider = DeliveryAddressProvider.of(context);
          List<dynamic> deliveryAddressData =
              deliveryAddressProvider.deliveryAddressState.deliveryAddressData![AuthProvider.of(context).authState.userModel!.id];

          double maxDeliveryDistance = deliveryAddressProvider.deliveryAddressState.maxDeliveryDistance!;

          for (var i = 0; i < deliveryAddressData.length; i++) {
            double distance = Geolocator.distanceBetween(
              orderModel!.storeModel!.location!.latitude,
              orderModel.storeModel!.location!.longitude,
              deliveryAddressData[i]["address"]["location"]["lat"],
              deliveryAddressData[i]["address"]["location"]["lng"],
            );

            deliveryAddressData[i]["distance"] = distance;
          }

          deliveryAddressData.sort((a, b) {
            return a["distance"] > b["distance"] ? 1 : -1;
          });

          return BottomSheet(
            onClosing: () {},
            backgroundColor: Colors.transparent,
            builder: (context) {
              return Container(
                width: deviceWidth,
                alignment: Alignment.bottomCenter,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: heightDp * 20),
                          Row(
                            children: [
                              Image.asset("img/location.png", width: heightDp * 35, height: heightDp * 35, fit: BoxFit.cover),
                              SizedBox(width: widthDp * 15),
                              Text(
                                "Select Delivery Address",
                                style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: heightDp * 20),
                          Container(
                            constraints: BoxConstraints(minHeight: 0, minWidth: double.infinity, maxHeight: heightDp * 180),
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(deliveryAddressData.length, (index) {
                                  bool isdeliverable = deliveryAddressData[index]["distance"] <= maxDeliveryDistance * 1000;
                                  if ((isShowMessage == null) && !isdeliverable) {
                                    isShowMessage = true;
                                  } else if (isShowMessage != null && isShowMessage! && !isdeliverable) {
                                    isShowMessage = false;
                                  } else {
                                    isShowMessage = null;
                                  }

                                  return Column(
                                    children: [
                                      isShowMessage != null && isShowMessage!
                                          ? Container(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: widthDp * 30,
                                                    height: 1,
                                                    decoration: BoxDecoration(
                                                      border: Border(bottom: BorderSide(color: Colors.red, width: 1)),
                                                    ),
                                                  ),
                                                  SizedBox(width: widthDp * 5),
                                                  Expanded(
                                                    child: Text(
                                                      "The address below are more than ${maxDeliveryDistance}kms away. We dont deliver here. Please choose pick up option if you would like to.",
                                                      style: TextStyle(fontSize: fontSp * 12, color: Colors.red),
                                                    ),
                                                  ),
                                                  SizedBox(width: widthDp * 5),
                                                  Container(
                                                    width: widthDp * 30,
                                                    height: 1,
                                                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.red, width: 1))),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(),
                                      GestureDetector(
                                        onTap: () {
                                          if (!isdeliverable) return;
                                          Navigator.of(context).pop();

                                          orderModel!.deliveryPartnerDetails = Map<String, dynamic>();
                                          deliveryAddressProvider.setDeliveryAddressState(
                                            deliveryAddressProvider.deliveryAddressState.update(
                                              selectedDeliveryAddress: deliveryAddressData[index],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                deliveryAddressProvider.deliveryAddressState.selectedDeliveryAddress!["_id"] ==
                                                        deliveryAddressData[index]["_id"]
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_unchecked,
                                                size: heightDp * 20,
                                                color: isdeliverable ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.7),
                                              ),
                                              SizedBox(width: widthDp * 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${deliveryAddressData[index]["addressType"]}",
                                                          style: TextStyle(
                                                            fontSize: fontSp * 16,
                                                            color: isdeliverable ? Colors.black : Colors.grey.withOpacity(0.7),
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: widthDp * 10),
                                                        Text(
                                                          "${(deliveryAddressData[index]["distance"] / 1000).toStringAsFixed(3)} Km",
                                                          style: TextStyle(
                                                            fontSize: fontSp * 14,
                                                            color: isdeliverable ? Colors.black : Colors.grey.withOpacity(0.7),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: heightDp * 5),
                                                    deliveryAddressData[index]["building"] == null || deliveryAddressData[index]["building"] == ""
                                                        ? SizedBox()
                                                        : Column(
                                                            children: [
                                                              Text(
                                                                "${deliveryAddressData[index]["building"]}",
                                                                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              SizedBox(height: heightDp * 5),
                                                            ],
                                                          ),
                                                    Text(
                                                      "${deliveryAddressData[index]["address"]["address"]}",
                                                      style: TextStyle(
                                                        fontSize: fontSp * 14,
                                                        color: isdeliverable ? Colors.black : Colors.grey.withOpacity(0.7),
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: heightDp * 10),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => DeliveryPickupPage(orderModel: orderModel!),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                                color: Colors.transparent,
                                child: Wrap(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: heightDp * 20,
                                      color: Color(0xFF00D290),
                                    ),
                                    SizedBox(width: widthDp * 5),
                                    Text(
                                      "Add new address",
                                      style: TextStyle(
                                        fontSize: fontSp * 16,
                                        color: Color(0xFF00D290),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => DeliveryAddressListPage(),
                                  ),
                                );
                                refreshProvider.refresh();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                                color: Colors.transparent,
                                child: Wrap(
                                  children: [
                                    Icon(Icons.edit, size: heightDp * 15, color: Color(0xFF00D290)),
                                    SizedBox(width: widthDp * 5),
                                    Text(
                                      "Manage addresses",
                                      style: TextStyle(fontSize: fontSp * 16, color: Color(0xFF00D290), fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: heightDp * 10),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }
}
