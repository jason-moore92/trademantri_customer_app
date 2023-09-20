import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class OrderConfirmationPage extends StatelessWidget {
  final OrderModel? orderModel;

  OrderConfirmationPage({@required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return OrderConfirmationView(orderModel: orderModel);
  }
}
