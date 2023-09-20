import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class OrderAssistantPage extends StatelessWidget {
  final OrderModel? orderModel;
  final Map<String, dynamic>? selectedStoreData;
  final bool haveAppBar;
  final bool haveProducts;
  final bool haveServices;

  OrderAssistantPage({
    this.orderModel,
    this.haveAppBar = true,
    this.selectedStoreData,
    this.haveProducts = true,
    this.haveServices = true,
  });

  @override
  Widget build(BuildContext context) {
    return OrderAssistantView(
      orderModel: orderModel,
      selectedStoreData: selectedStoreData ?? Map<String, dynamic>(),
      haveAppBar: haveAppBar,
      haveProducts: haveProducts,
      haveServices: haveServices,
    );
  }
}
