import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'index.dart';
import '../../providers/index.dart';

class CreateReverseAuctionPage extends StatelessWidget {
  final bool haveAppBar;

  CreateReverseAuctionPage({this.haveAppBar = true});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReverseAuctionProvider()),
      ],
      child: CreateReverseAuctionView(haveAppBar: haveAppBar),
    );
  }
}
