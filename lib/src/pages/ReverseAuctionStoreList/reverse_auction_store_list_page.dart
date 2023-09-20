import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class ReverseAuctionStoreListPage extends StatelessWidget {
  final Map<String, dynamic>? reverseAuctionData;
  final Function? acceptHandler;
  final String? reverseAuctionId;
  final String? storeIdList;

  ReverseAuctionStoreListPage({
    @required this.reverseAuctionData,
    @required this.acceptHandler,
    @required this.reverseAuctionId,
    @required this.storeIdList,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReverseAuctionStoreProvider()),
      ],
      child: ReverseAuctionStoreListView(
        reverseAuctionData: reverseAuctionData,
        acceptHandler: acceptHandler,
        reverseAuctionId: reverseAuctionId,
        storeIdList: storeIdList,
      ),
    );
  }
}
