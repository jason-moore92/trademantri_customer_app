import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class ReverseAuctionDetailPage extends StatefulWidget {
  final Map<String, dynamic>? reverseAuctionData;
  final String? reverseAuctionId;
  final String? userId;
  final String? storeId;

  ReverseAuctionDetailPage({
    this.reverseAuctionData,
    this.reverseAuctionId,
    this.userId,
    this.storeId,
  });

  @override
  _ReverseAuctionDetailPageState createState() => _ReverseAuctionDetailPageState();
}

class _ReverseAuctionDetailPageState extends State<ReverseAuctionDetailPage> {
  @override
  Widget build(BuildContext context) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double heightDp = ScreenUtil().setWidth(1);

    if (widget.reverseAuctionData == null && widget.reverseAuctionId != null) {
      return StreamBuilder<dynamic>(
          stream: Stream.fromFuture(
            ReverseAuctionApiProvider.getReverseAuction(
              reverseAuctionId: widget.reverseAuctionId,
              userId: widget.userId,
              storeId: widget.storeId,
            ),
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isNotEmpty) {
                  Map<String, dynamic> data = snapshot.data["data"][0]["reverse_auction"];
                  data["user"] = snapshot.data["data"][0]["user"];
                  data["storeId"] = snapshot.data["data"][0]["storeId"];
                  data["history"] = snapshot.data["data"][0]["history"];
                  return ReverseAuctionDetailView(reverseAuctionData: data);
                } else if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isEmpty) {
                  return Scaffold(
                    body: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: heightDp * 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your store is not part of this reverse auction",
                              style: TextStyle(fontSize: fontSp * 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: heightDp * 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 15, vertical: heightDp * 5),
                                decoration: BoxDecoration(
                                  color: config.Colors().mainColor(1),
                                  borderRadius: BorderRadius.circular(heightDp * 8),
                                ),
                                child: Text(
                                  "Ok",
                                  style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return ErrorPage(
                    message: snapshot.hasData ? snapshot.data["message"] : "",
                    callback: () {
                      setState(() {});
                    },
                  );
                }
              default:
            }
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          });
    }
    return ReverseAuctionDetailView(reverseAuctionData: widget.reverseAuctionData);
  }
}
