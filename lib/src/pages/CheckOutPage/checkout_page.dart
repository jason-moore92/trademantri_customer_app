import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ErrorPage/error_page.dart';

import 'index.dart';

class CheckoutPage extends StatelessWidget {
  final OrderModel? orderModel;

  CheckoutPage({@required this.orderModel});

  @override
  Widget build(BuildContext context) {
    if (orderModel!.storeModel!.deliveryInfo != null &&
        orderModel!.storeModel!.deliveryInfo!.mode == "DELIVERY_BY_PARTNER" &&
        orderModel!.storeModel!.deliveryInfo!.deliveryPartnerId != null) {
      return StreamBuilder<dynamic>(
        stream: Stream.fromFuture(DeliveryPartnerApiProvider.getDeliveryPartner(id: orderModel!.storeModel!.deliveryInfo!.deliveryPartnerId)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          }

          if (!snapshot.data["success"]) {
            return ErrorPage(
              message: snapshot.data["message"],
              callback: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CheckoutPage(
                      orderModel: orderModel,
                    ),
                  ),
                );
              },
            );
          }

          return CheckoutView(
            orderModel: orderModel,
            deliveryPartner: snapshot.data["data"],
          );
        },
      );
    } else {
      return CheckoutView(orderModel: orderModel);
    }
  }
}
