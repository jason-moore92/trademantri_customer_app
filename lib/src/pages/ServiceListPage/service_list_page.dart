import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class ServiceListPage extends StatelessWidget {
  final List<String>? storeIds;
  final StoreModel? storeModel;
  final bool isForSelection;

  ServiceListPage({
    @required this.storeIds,
    @required this.storeModel,
    this.isForSelection = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceListPageProvider()),
      ],
      child: ServiceListView(storeIds: storeIds, storeModel: storeModel, isForSelection: isForSelection),
    );
  }
}
