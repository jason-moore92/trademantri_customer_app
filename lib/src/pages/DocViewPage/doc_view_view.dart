import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class DocViewView extends StatefulWidget {
  final String? doc;
  final String? appBarTitle;

  DocViewView({Key? key, this.doc, this.appBarTitle}) : super(key: key);

  @override
  _DocViewViewState createState() => _DocViewViewState();
}

class _DocViewViewState extends State<DocViewView> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  PdfController? _pdfController;
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String? path;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _readPDF();
    });
  }

  void _readPDF() async {
    File? file = await createFileOfPdfUrl();
    if (file != null) {
      path = file.path;
      _pdfController = PdfController(document: PdfDocument.openFile(path!));
    } else {
      path = "";
    }

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF162779),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          widget.appBarTitle!,
          style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: path == null
          ? Center(child: CupertinoActivityIndicator())
          : path == ""
              ? Container(
                  width: deviceWidth,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.doc}\nDownload Failed",
                        style: TextStyle(fontSize: fontSp * 20),
                      ),
                      SizedBox(height: heightDp * 20),
                      KeicyRaisedButton(
                        width: widthDp * 120,
                        height: heightDp * 35,
                        color: config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        child: Text(
                          "Try again",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                        onPressed: () {
                          path = null;
                          _readPDF();
                        },
                      )
                    ],
                  ),
                )
              : Stack(
                  children: [
                    PdfView(
                      documentLoader: Center(child: CircularProgressIndicator()),
                      pageLoader: Center(child: CircularProgressIndicator()),
                      controller: _pdfController!,
                      onDocumentLoaded: (document) {
                        setState(() {});
                      },
                      onPageChanged: (page) {
                        setState(() {});
                      },
                      onDocumentError: (err) {
                        errorMessage = err.toString();
                        setState(() {});
                      },
                      scrollDirection: Axis.vertical,
                    ),
                    errorMessage.isEmpty
                        ? Container()
                        : Container(
                            width: deviceWidth,
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Something was wrong", style: TextStyle(fontSize: fontSp * 20)),
                                SizedBox(height: heightDp * 20),
                                KeicyRaisedButton(
                                  width: widthDp * 120,
                                  height: heightDp * 35,
                                  color: config.Colors().mainColor(1),
                                  borderRadius: heightDp * 6,
                                  child: Text(
                                    "Try again",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    path = null;
                                    _readPDF();
                                  },
                                )
                              ],
                            ),
                          )
                  ],
                ),
    );
  }

  Future<File?> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    try {
      String url = widget.doc!;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
      return completer.future;
    } catch (e) {
      return null;
    }
  }
}
