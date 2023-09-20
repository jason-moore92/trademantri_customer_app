import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:printing/printing.dart';
import 'package:pdf/src/pdf/page_format.dart' as PFormat;
import 'package:trapp/src/elements/keicy_progress_dialog.dart';

class PrintWidget extends StatelessWidget {
  final String? path;
  final double? size;
  final Color? color;
  final Function(Uint8List)? callback;

  KeicyProgressDialog? _progressDialog;

  PrintWidget({
    Key? key,
    @required this.path,
    this.size,
    this.color = Colors.black,
    this.callback,
  }) : super(key: key);

  Future<File> getFileFromUrl({name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(path!));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      FlutterLogs.logInfo(
        "print_widget",
        "getFileFromUrl",
        {
          "path": dir.path,
        }.toString(),
      );
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthDp = 0;
    double heightDp = 0;

    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);

    if (_progressDialog == null) _progressDialog = KeicyProgressDialog.of(context);

    return GestureDetector(
      onTap: () async {
        try {
          _progressDialog!.show();
          File pdfFile = await getFileFromUrl();

          _progressDialog!.hide();
          await Printing.layoutPdf(
            onLayout: (_) => pdfFile.readAsBytesSync(),
            format: PFormat.PdfPageFormat.a4,
          );
        } catch (e) {
          _progressDialog!.hide();
          FlutterLogs.logThis(
            tag: "print_widget",
            level: LogLevel.ERROR,
            subTag: "onTap:Print",
            exception: e is Exception ? e : null,
            error: e is Error ? e : null,
            errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
          );
        }
      },
      child: Container(
        color: Colors.transparent,
        // padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
        child: Icon(Icons.print_outlined, size: size ?? heightDp * 25, color: color),
      ),
    );
  }
}
