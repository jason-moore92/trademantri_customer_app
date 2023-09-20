import 'package:flutter/material.dart';

import 'index.dart';

class DocViewPage extends StatelessWidget {
  final String? doc;
  final String? appBarTitle;

  DocViewPage({@required this.doc, @required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return DocViewView(doc: doc, appBarTitle: appBarTitle);
  }
}
