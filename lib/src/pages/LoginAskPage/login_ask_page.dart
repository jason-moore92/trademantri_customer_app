import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'index.dart';

class LoginAskPage extends StatefulWidget {
  final Function? callback;

  LoginAskPage({@required this.callback});

  @override
  _LoginAskPageState createState() => _LoginAskPageState();
}

class _LoginAskPageState extends State<LoginAskPage> {
  @override
  Widget build(BuildContext context) {
    return LoginAskView(callback: widget.callback);
  }
}
