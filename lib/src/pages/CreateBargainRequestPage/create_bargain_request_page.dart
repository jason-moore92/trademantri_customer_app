import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'index.dart';
import '../../providers/index.dart';

class CreateBargainRequestPage extends StatefulWidget {
  final Map<String, dynamic> storeData;
  final bool haveAppBar;

  CreateBargainRequestPage({
    this.haveAppBar = true,
    this.storeData = const {},
  });

  @override
  _CreateBargainRequestPageState createState() => _CreateBargainRequestPageState();
}

class _CreateBargainRequestPageState extends State<CreateBargainRequestPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BargainRequestProvider>(create: (_) => BargainRequestProvider()),
      ],
      child: CreateBargainRequestView(storeData: widget.storeData, haveAppBar: widget.haveAppBar),
    );
  }
}
