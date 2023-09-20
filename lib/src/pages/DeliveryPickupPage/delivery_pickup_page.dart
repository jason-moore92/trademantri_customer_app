import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class DeliveryPickupPage extends StatelessWidget {
  final OrderModel? orderModel;
  final Map<String, dynamic>? deliveryAddress;
  final bool? forEdit;

  DeliveryPickupPage({this.orderModel, this.deliveryAddress, this.forEdit = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: DeliveryPickupView(orderModel: orderModel, deliveryAddress: deliveryAddress, forEdit: forEdit),
    );
  }
}
