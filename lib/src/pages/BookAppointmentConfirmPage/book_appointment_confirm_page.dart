import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class BookAppointmentConfirmPage extends StatefulWidget {
  final BookAppointmentModel? bookAppointmentModel;

  BookAppointmentConfirmPage({@required this.bookAppointmentModel});

  @override
  _BookAppointmentConfirmPageState createState() => _BookAppointmentConfirmPageState();
}

class _BookAppointmentConfirmPageState extends State<BookAppointmentConfirmPage> {
  @override
  Widget build(BuildContext context) {
    return BookAppointmentConfirmView(bookAppointmentModel: widget.bookAppointmentModel);
  }
}
