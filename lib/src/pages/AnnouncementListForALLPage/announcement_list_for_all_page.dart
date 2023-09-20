import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class AnnouncementListForALLPage extends StatelessWidget {
  final String? storeId;

  AnnouncementListForALLPage({this.storeId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnnouncementListProvider()),
      ],
      child: AnnouncementListForALLView(storeId: storeId),
    );
  }
}
