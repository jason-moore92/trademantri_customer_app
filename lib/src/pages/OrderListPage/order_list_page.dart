import 'package:flutter/material.dart';

import 'index.dart';

class OrderListPage extends StatelessWidget {
  final bool haveAppBar;

  OrderListPage({this.haveAppBar = false});

  @override
  Widget build(BuildContext context) {
    return OrderListView(haveAppBar: haveAppBar);
  }
}
