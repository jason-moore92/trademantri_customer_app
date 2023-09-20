import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/pages/MyReferralListForStorePage/index.dart';
import 'package:trapp/src/pages/MyReferralListPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'index.dart';

class ReferEarnView extends StatefulWidget {
  ReferEarnView({Key? key}) : super(key: key);

  @override
  _ReferEarnViewState createState() => _ReferEarnViewState();
}

class _ReferEarnViewState extends State<ReferEarnView> {
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

  int _type = 0;

  ReferralRewardOfferTypeRulesProvider? _offerTypeRulesProvider;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  KeicyProgressDialog? _keicyProgressDialog;

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

    _type = 0;

    _offerTypeRulesProvider = ReferralRewardOfferTypeRulesProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _offerTypeRulesProvider!.getReferralRules();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Refer and Earn",
          style: TextStyle(fontSize: fontSp * 18, color: Color(0xFF162779)),
        ),
        elevation: 0,
      ),
      body: Consumer<ReferralRewardOfferTypeRulesProvider>(builder: (context, offerTypeRulesProvider, _) {
        if (offerTypeRulesProvider.referralRewardOfferTypeRulesState.progressState == 0 ||
            offerTypeRulesProvider.referralRewardOfferTypeRulesState.progressState == 1) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (offerTypeRulesProvider.referralRewardOfferTypeRulesState.progressState == -1) {
          return ErrorPage(
            message: offerTypeRulesProvider.referralRewardOfferTypeRulesState.message,
            callback: () {
              offerTypeRulesProvider.setReferralRewardOfferTypeRulesState(
                offerTypeRulesProvider.referralRewardOfferTypeRulesState.update(
                  progressState: 1,
                ),
              );
              offerTypeRulesProvider.getReferralRules();
            },
          );
        }

        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              _topBar(),
              Expanded(child: _type == 0 ? _storePanel() : _userPanel()),
            ],
          ),
        );
      }),
    );
  }

  Widget _storePanel() {
    if (_offerTypeRulesProvider!.referralRewardOfferTypeRulesState.storeReferralData!.isEmpty) {
      return Center(
        child: Text("No referral data", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset("img/Refer&Earn.png", width: deviceWidth, fit: BoxFit.fitWidth),
          SizedBox(height: heightDp * 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeicyRaisedButton(
                width: widthDp * 150,
                height: heightDp * 40,
                borderRadius: heightDp * 8,
                color: config.Colors().mainColor(1),
                child: Text("Your Referrals", style: TextStyle(fontSize: fontSp * 16, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyReferralListForStorePage(),
                    ),
                  );
                },
              ),
              SizedBox(width: widthDp * 20),
            ],
          ),
          SizedBox(height: heightDp * 20),
          _stepPanel(_offerTypeRulesProvider!.referralRewardOfferTypeRulesState.storeReferralData!),
          SizedBox(height: heightDp * 20),
          _step1(_offerTypeRulesProvider!.referralRewardOfferTypeRulesState.storeReferralData!),
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }

  Widget _userPanel() {
    if (_offerTypeRulesProvider!.referralRewardOfferTypeRulesState.userReferralData!.isEmpty) {
      return Center(
        child: Text("No referral data", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset("img/Refer&Earn1.png", width: deviceWidth, fit: BoxFit.fitWidth),
          SizedBox(height: heightDp * 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeicyRaisedButton(
                width: widthDp * 150,
                height: heightDp * 40,
                borderRadius: heightDp * 8,
                color: config.Colors().mainColor(1),
                child: Text("Your Referrals", style: TextStyle(fontSize: fontSp * 16, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyReferralListPage(),
                    ),
                  );
                },
              ),
              SizedBox(width: widthDp * 20),
            ],
          ),
          SizedBox(height: heightDp * 20),
          _stepPanel(_offerTypeRulesProvider!.referralRewardOfferTypeRulesState.userReferralData!),
          SizedBox(height: heightDp * 20),
          _step1(_offerTypeRulesProvider!.referralRewardOfferTypeRulesState.userReferralData!),
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Container(
      height: heightDp * 50,
      color: Color(0xFF528CCD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_type != 0) {
                  setState(() {
                    _type = 0;
                  });
                }
              },
              child: Container(
                height: heightDp * 50,
                color: _type != 0 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  "Store",
                  style: TextStyle(fontSize: fontSp * 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_type != 1) {
                  setState(() {
                    _type = 1;
                  });
                }
              },
              child: Container(
                height: heightDp * 50,
                color: _type != 1 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  "Friend",
                  style: TextStyle(fontSize: fontSp * 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepPanel(Map<String, dynamic> referralData) {
    return Container(
      width: deviceWidth,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: heightDp * 80,
                    height: heightDp * 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF122D51)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        "img/refer/1refer.png",
                        width: heightDp * 40,
                        height: heightDp * 40,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: heightDp * 50,
                child: Divider(height: 1, thickness: 1, color: Color(0xFF122D51)),
              ),
              Column(
                children: [
                  Container(
                    width: heightDp * 80,
                    height: heightDp * 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF122D51)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        "img/refer/2signup.png",
                        width: heightDp * 40,
                        height: heightDp * 40,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: heightDp * 50,
                child: Divider(height: 1, thickness: 1, color: Color(0xFF122D51)),
              ),
              Column(
                children: [
                  Container(
                    width: heightDp * 80,
                    height: heightDp * 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF122D51)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        "img/refer/3points.png",
                        width: heightDp * 40,
                        height: heightDp * 40,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: heightDp * 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: heightDp * 10, child: SizedBox()),
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      "${referralData["Step1Text"]}",
                      style: TextStyle(fontSize: fontSp * 13, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(width: heightDp * 10, child: SizedBox()),
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      "${referralData["Step2Text"]}",
                      style: TextStyle(fontSize: fontSp * 13, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(width: heightDp * 10, child: SizedBox()),
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      "${referralData["Step3Text"]}",
                      style: TextStyle(fontSize: fontSp * 13, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(width: heightDp * 10, child: SizedBox()),
            ],
          ),
          SizedBox(height: heightDp * 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
            child: Text(
              "${referralData["description"]}",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _step1(Map<String, dynamic> referralData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Your Referral Code",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: heightDp * 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
          ),
          child: Text(
            AuthProvider.of(context).authState.userModel!.referralCode!,
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: heightDp * 10),
        GestureDetector(
          onTap: () async {
            await Clipboard.setData(
              new ClipboardData(text: AuthProvider.of(context).authState.userModel!.referralCode!),
            );

            SuccessDialog.show(
              context,
              heightDp: heightDp,
              fontSp: fontSp,
              text: "Your referral code copied on the clipboard",
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
            child: Text(
              "Tap to Copy",
              style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: heightDp * 30),
        _type == 0
            ? KeicyRaisedButton(
                width: widthDp * 170,
                height: heightDp * 40,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 8,
                child: Text(
                  "Refer a Store",
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                ),
                onPressed: () async {
                  // var result = await ReferralOptionDialog.show(
                  //   context,
                  //   formkey: _formkey,
                  //   callback: (Map<String, dynamic> storeData) {
                  //   },
                  // );

                  var result = "referral_link";

                  if (result != null && result == "referral_link") {
                    Uri dynamicUrl = await DynamicLinkService.createReferStoreLink(
                      description: referralData["referralDesc"],
                      referralCode: AuthProvider.of(context).authState.userModel!.referralCode,
                      referredByUserId: AuthProvider.of(context).authState.userModel!.id,
                      appliedFor: "UserToStore",
                    );
                    Share.share(dynamicUrl.toString());
                  } else if (result != null && result == "store_detail") {
                    await ReferralStoreDetailDialog.show(
                      context,
                      formkey: _formkey,
                      callback: (Map<String, dynamic> storeData) async {
                        _referStoreHandler(referralData, storeData);
                      },
                    );
                  }
                },
              )
            : KeicyRaisedButton(
                width: widthDp * 170,
                height: heightDp * 40,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 8,
                child: Text(
                  "Refer a Friend",
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                ),
                onPressed: () async {
                  Uri dynamicUrl = await DynamicLinkService.createReferFriendLink(
                    description: referralData["referralDesc"],
                    referralCode: AuthProvider.of(context).authState.userModel!.referralCode,
                    referredByUserId: AuthProvider.of(context).authState.userModel!.id,
                    appliedFor: "UserToUser",
                  );
                  Share.share(dynamicUrl.toString());
                },
              ),
      ],
    );
  }

  void _referStoreHandler(Map<String, dynamic> referralData, storeData) async {
    await _keicyProgressDialog!.show();
    var result = await ReferralRewardU2SOffersApiProvider.addRewardPoint(
      referredByUserId: AuthProvider.of(context).authState.userModel!.id,
      referredBy: AuthProvider.of(context).authState.userModel!.referralCode,
      appliedFor: "UserToStore",
      storeName: storeData["storeName"],
      storeMobile: storeData["storeMobile"],
      storeAddress: storeData["storeAddress"],
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp);
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        callBack: () {
          _referStoreHandler(referralData, storeData);
        },
      );
    }
  }
}
