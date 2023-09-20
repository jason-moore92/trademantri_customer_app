import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class RewardPointsHistoryPage extends StatelessWidget {
  final List<dynamic>? historyData;
  final Map<String, dynamic>? storeData;

  RewardPointsHistoryPage({@required this.historyData, @required this.storeData});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RewardPointHistoryProvider()),
      ],
      child: RewardPointsHistoryView(historyData: historyData, storeData: storeData),
    );
  }
}
