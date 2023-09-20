import 'package:flutter/material.dart';

import 'index.dart';

class StoreJobPostingApplyPage extends StatelessWidget {
  final Map<String, dynamic>? appliedJobData;
  final bool? isNew;

  StoreJobPostingApplyPage({@required this.appliedJobData, @required this.isNew});

  @override
  Widget build(BuildContext context) {
    return StoreJobPostingApplyView(appliedJobData: appliedJobData, isNew: isNew);
  }
}
