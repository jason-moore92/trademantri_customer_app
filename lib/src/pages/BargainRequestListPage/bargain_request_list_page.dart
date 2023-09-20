import 'package:flutter/material.dart';

import 'index.dart';

class BargainRequestListPage extends StatelessWidget {
  final bool haveAppBar;

  BargainRequestListPage({this.haveAppBar = false});

  @override
  Widget build(BuildContext context) {
    return BargainRequestListView(haveAppBar: haveAppBar);
  }
}
