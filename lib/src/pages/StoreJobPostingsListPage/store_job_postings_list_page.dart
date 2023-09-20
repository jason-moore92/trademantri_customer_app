import 'package:flutter/material.dart';

import 'index.dart';

class StoreJobPostingsListPage extends StatelessWidget {
  final String? storeId;

  StoreJobPostingsListPage({this.storeId = ""});

  @override
  Widget build(BuildContext context) {
    return StoreJobPostingsListView(storeId: storeId);
  }
}
