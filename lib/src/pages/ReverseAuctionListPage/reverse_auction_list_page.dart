import 'package:flutter/material.dart';

import 'index.dart';

class ReverseAuctionListPage extends StatelessWidget {
  final bool haveAppBar;

  ReverseAuctionListPage({this.haveAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ReverseAuctionListView(haveAppBar: haveAppBar),
    );
  }
}
