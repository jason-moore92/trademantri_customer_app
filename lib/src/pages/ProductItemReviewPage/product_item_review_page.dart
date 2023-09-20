import 'package:flutter/material.dart';

import 'index.dart';

class ProductItemReviewPage extends StatelessWidget {
  final Map<String, dynamic>? itemData;
  final String? type;

  ProductItemReviewPage({@required this.itemData, @required this.type});

  @override
  Widget build(BuildContext context) {
    return ProductItemReviewView(itemData: itemData, type: type);
  }
}
