import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class CouponListPage extends StatelessWidget {
  final StoreModel? storeModel;
  final OrderModel? orderModel;
  final CouponModel? selectedCoupon;
  final bool isForOrder;
  final List<dynamic>? productCategories;
  final List<dynamic>? serviceCategories;
  final List<dynamic>? productIds;
  final List<dynamic>? serviceIds;

  CouponListPage({
    @required this.storeModel,
    this.selectedCoupon,
    this.orderModel,
    this.isForOrder = false,
    this.productCategories,
    this.serviceCategories,
    this.productIds,
    this.serviceIds,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CouponListProvider()),
      ],
      child: CouponListView(
        storeModel: storeModel,
        selectedCoupon: selectedCoupon,
        orderModel: orderModel,
        isForOrder: isForOrder,
        productCategories: productCategories,
        serviceCategories: serviceCategories,
        productIds: productIds,
        serviceIds: serviceIds,
      ),
    );
  }
}
