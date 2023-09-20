import 'package:flutter/material.dart';

import 'index.dart';

class AppointmentListPage extends StatelessWidget {
  final String? storeId;

  AppointmentListPage({@required this.storeId});

  @override
  Widget build(BuildContext context) {
    return AppointmentListView(storeId: storeId);
  }
}
