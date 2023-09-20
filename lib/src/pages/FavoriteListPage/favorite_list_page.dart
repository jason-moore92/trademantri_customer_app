import 'package:flutter/material.dart';

import 'index.dart';

class FavoriteListPage extends StatelessWidget {
  final bool haveAppBar;

  FavoriteListPage({this.haveAppBar = false});

  @override
  Widget build(BuildContext context) {
    return FavoriteListView(haveAppBar: haveAppBar);
  }
}
