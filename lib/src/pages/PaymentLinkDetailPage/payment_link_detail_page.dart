import 'package:flutter/material.dart';

import 'index.dart';

class PaymentLinkDetailPage extends StatelessWidget {
  final Map<String, dynamic>? paymentLinkData;

  PaymentLinkDetailPage({@required this.paymentLinkData});

  @override
  Widget build(BuildContext context) {
    return PaymentLinkDetailView(paymentLinkData: paymentLinkData);
  }
}
