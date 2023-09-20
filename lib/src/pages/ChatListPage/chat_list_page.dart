import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/providers/ChatProvider/index.dart';

import 'index.dart';

class ChatListPage extends StatelessWidget {
  final int? initIndex;

  ChatListPage({this.initIndex = 0});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: ChatListView(initIndex: initIndex),
    );
  }
}
