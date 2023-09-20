import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/providers/StoreReviewPageProvider/index.dart';

import 'index.dart';

class StoreReviewPage extends StatelessWidget {
  final Map<String, dynamic>? storeData;

  StoreReviewPage({@required this.storeData});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreReviewPageProvider()),
      ],
      child: StoreReviewView(storeData: storeData),
    );
  }
}
