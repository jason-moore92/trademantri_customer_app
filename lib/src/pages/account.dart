import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trapp/generated/l10n.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/ProfileSettingsDialog.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/qrcode_widget.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/DeliveryAddressListPage/delivery_address_list_page.dart';
import 'package:trapp/src/pages/FavoriteListPage/index.dart';
import 'package:trapp/src/pages/ChatListPage/index.dart';
import 'package:trapp/src/pages/OrderListPage/index.dart';
import 'package:trapp/src/pages/account_verification.dart';
import 'package:trapp/src/pages/mobile_verification.dart';
import 'package:trapp/src/providers/AppDataProvider/app_data_provider.dart';
import 'package:trapp/src/providers/AuthProvider/auth_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../dialogs/index.dart';

class AccountWidget extends StatefulWidget {
  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  /// Responsive design variables
  double deviceHeight = 0;
  double deviceWidth = 0;
  double appbarHeight = 0;
  double statusbarHeight = 0;
  double fontSp = 0;
  double widthDp = 0;
  double heightDp = 0;
  ///////////////////////////////

  final picker = ImagePicker();

  AuthProvider? _authProvider;
  File? _imageFile;
  KeicyProgressDialog? _keicyProgressDialog;
  UserModel? _userModel;

  @override
  void dispose() {
    _authProvider!.removeListener(_authProviderListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    ///////////////////////////////

    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _authProvider!.addListener(_authProviderListener);
    });
  }

  void _authProviderListener() async {
    if (_authProvider!.authState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_authProvider!.authState.progressState == 3) {
      _authProvider!.removeListener(_authProviderListener);

      if (_authProvider!.authState.accountVerifyMode == "email") {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => AccountVerificationPage(
              email: _userModel!.email,
            ),
          ),
        );
      }

      if (_authProvider!.authState.accountVerifyMode == "mobile") {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => AccountVerificationPage(
              mobile: _userModel!.mobile,
            ),
          ),
        );
      }

      _authProvider!.addListener(_authProviderListener);
    } else if (_authProvider!.authState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _authProvider!.authState.message!,
        callBack: _authProvider!.authState.errorCode == 500 ? _authProvider!.authState.callback : () {},
        isTryButton: _authProvider!.authState.errorCode == 500,
        cancelCallback: () {
          _authProvider!.setAuthState(
            _authProvider!.authState.update(callback: () {}),
            isNotifiable: false,
          );
        },
      );
      _authProvider!.setAuthState(
        _authProvider!.authState.update(progressState: 0, message: ""),
        isNotifiable: false,
      );
    } else if (_authProvider!.authState.progressState == 2) {
      _userModel = UserModel.copy(_authProvider!.authState.userModel!);
      _authProvider!.setAuthState(
        _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
        isNotifiable: false,
      );
    }
  }

  Widget _userInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _selectOptionBottomSheet();
                },
                child: Stack(
                  children: [
                    KeicyAvatarImage(
                      url: _userModel!.imageUrl,
                      userName: _userModel!.firstName,
                      imageFile: _imageFile,
                      width: heightDp * 70,
                      height: heightDp * 70,
                      backColor: Colors.grey.withOpacity(0.5),
                      textStyle: TextStyle(fontSize: fontSp * 25, color: Colors.black),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.photo_camera,
                        size: heightDp * 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: widthDp * 20),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      "${_userModel!.firstName} ${_userModel!.lastName}",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: fontSp * 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${_userModel!.email}",
                      style: Theme.of(context).textTheme.caption!.copyWith(fontSize: fontSp * 12),
                    ),
                    if (!_userModel!.verified!)
                      InkWell(
                        onTap: () async {
                          AuthProvider.of(context).initiateEmailVerification(
                            email: _userModel!.email,
                          );
                        },
                        child: Text(
                          "Verify now",
                          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: fontSp * 12),
                        ),
                      ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ],
          ),
        ),
        _imageFile == null
            ? SizedBox()
            : KeicyRaisedButton(
                width: widthDp * 80,
                height: heightDp * 30,
                borderRadius: heightDp * 6,
                color: Theme.of(context).hintColor,
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                ),
                onPressed: () {
                  // UploadFileApiProvider.uploadFile(file: _imageFile);
                  _updateUser(UserModel.copy(_userModel!), imageFile: _imageFile);
                },
              ),
      ],
    );
  }

  Widget _panel1() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: widthDp * 15, horizontal: heightDp * 10),
              onPressed: () async {
                _authProvider!.removeListener(_authProviderListener);

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => FavoriteListPage(haveAppBar: true),
                  ),
                );

                _authProvider!.addListener(_authProviderListener);
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).hintColor,
                  ),
                  Text(
                    'Favorite',
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ],
              ),
            ),
          ),
          // Expanded(
          //   child: FlatButton(
          //     padding: EdgeInsets.symmetric(vertical: widthDp * 15, horizontal: heightDp * 10),
          //     onPressed: () {},
          //     child: Column(
          //       children: <Widget>[
          //         Icon(
          //           Icons.star,
          //           color: Theme.of(context).hintColor,
          //         ),
          //         Text(
          //           'Following',
          //           style: Theme.of(context).textTheme.bodyText2,
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: widthDp * 15, horizontal: heightDp * 10),
              onPressed: () async {
                _authProvider!.removeListener(_authProviderListener);

                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => ChatListPage()),
                );

                _authProvider!.addListener(_authProviderListener);
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.chat,
                    color: Theme.of(context).hintColor,
                  ),
                  Text(
                    'Messages',
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text(
              'My Orders',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: FlatButton(
                onPressed: () async {
                  _authProvider!.removeListener(_authProviderListener);

                  await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)));

                  _authProvider!.addListener(_authProviderListener);
                },
                child: Text(
                  "View all",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.delivery_dining_outlined),
            title: Text(
              'Delivery Address',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: FlatButton(
                onPressed: () async {
                  _authProvider!.removeListener(_authProviderListener);

                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => DeliveryAddressListPage(),
                    ),
                  );

                  _authProvider!.addListener(_authProviderListener);
                },
                child: Text(
                  "View all",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileSettingPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Profile Settings',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: ProfileSettingsDialog(
                userModel: UserModel.copy(_userModel!),
                onChanged: (UserModel userModel) {
                  _updateUser(userModel);
                },
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'First Name',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Text(
              _userModel!.firstName!,
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Last Name',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Text(
              _userModel!.lastName!,
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
          ),
          // ListTile(
          //   onTap: () {},
          //   dense: true,
          //   title: Text(
          //     'Email',
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          //   trailing: Column(
          //     children: [
          //       Text(
          //         _userModel!.email.toString(),
          //         style: TextStyle(color: Theme.of(context).focusColor),
          //       ),
          //       if (_userModel!.verified!)
          //         Text(
          //           "Verified",
          //           style: TextStyle(
          //             color: Colors.green,
          //           ),
          //         ),
          //       if (!_userModel!.verified!)
          //         Text(
          //           "Not Veified",
          //           style: TextStyle(
          //             color: Colors.red,
          //           ),
          //         ),
          //     ],
          //   ),
          // ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'PhoneNumber',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Column(
              children: [
                Text(
                  _userModel!.mobile.toString(),
                  style: TextStyle(color: Theme.of(context).focusColor),
                ),
                if (_userModel!.phoneVerified!)
                  Text(
                    "Verified",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                if (!_userModel!.phoneVerified!)
                  InkWell(
                    onTap: () async {
                      AuthProvider.of(context).initiateMobileVerification(
                        mobile: _userModel!.mobile,
                      );
                    },
                    child: Text("Verify now"),
                  ),
                // if (!_userModel!.phoneVerified!)
                //   Text(
                //     "Not Veified",
                //     style: TextStyle(
                //       color: Colors.red,
                //     ),
                //   ),
              ],
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Date of birth',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Text(
              _userModel!.dob ?? "NA",
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrCodePanel() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      ),
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrCodeWidget(
                code: Encrypt.encryptString("ReferralCode-${_userModel!.referralCode}_UserId-${_userModel!.id}"),
                size: heightDp * 150,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accountSettingPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Account Settings',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Notification',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Switch(
              value: _userModel!.isNotifiable!,
              onChanged: (value) {
                setState(() {
                  _userModel!.isNotifiable = value;
                });
                _updateUser(_userModel!);
              },
            ),
          ),
          ListTile(
            onTap: () {
              ChangePasswordDialog.show(context, callback: _changePasswordHandler);
            },
            dense: true,
            title: Text(
              'Change Password',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Text(
              'Change',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          ListTile(
            onTap: () {
              FeedbackDialog.show(
                context,
                ratingValue: _authProvider!.authState.feedbackModel!.ratingValue!,
                feedbackText: _authProvider!.authState.feedbackModel!.feedbackText!,
                callback: _updateFeedback,
              );
            },
            dense: true,
            title: Row(
              children: <Widget>[
                Icon(Icons.star_outline_rounded, size: heightDp * 22, color: Theme.of(context).focusColor),
                SizedBox(width: 10),
                Text('Rate App', style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: heightDp * 16, color: Theme.of(context).focusColor),
              onPressed: null,
            ),
          ),
          ListTile(
            onTap: () {
              if (_checkAddContactAvailable()) {
                ContactDialog.show(context, _userModel!, callback: _addContact);
              } else {
                ErrorDialog.show(
                  context,
                  heightDp: heightDp,
                  fontSp: fontSp,
                  text: S.of(context).contact_count_over,
                  widthDp: widthDp,
                  callBack: null,
                  isTryButton: false,
                );
              }
            },
            dense: true,
            title: Row(
              children: <Widget>[
                Icon(Icons.info, size: heightDp * 22, color: Theme.of(context).focusColor),
                SizedBox(width: 10),
                Text('Help & Support', style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: heightDp * 16, color: Theme.of(context).focusColor),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }

  void _selectOptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              Container(
                child: Container(
                  padding: EdgeInsets.all(heightDp * 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: deviceWidth,
                        padding: EdgeInsets.all(heightDp * 10.0),
                        child: Text(
                          "Choose Option",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _getAvatarImage(ImageSource.camera);
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black.withOpacity(0.7),
                                size: heightDp * 25.0,
                              ),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "From Camera",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _getAvatarImage(ImageSource.gallery);
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.photo, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "From Gallery",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future _getAvatarImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, maxWidth: 500, maxHeight: 500);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      FlutterLogs.logInfo(
        "account",
        "_getAvatarImage",
        {
          "message": "No image selected.",
        }.toString(),
      );
    }
  }

  void _updateUser(UserModel userModel, {File? imageFile}) async {
    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(
        progressState: 1,
        callback: () {
          _updateUser(userModel, imageFile: imageFile);
        },
      ),
      isNotifiable: false,
    );
    await _authProvider!.updateUser(userModel, imageFile: imageFile);
  }

  void _changePasswordHandler(String oldPassword, String newPassword) async {
    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(
        progressState: 1,
        callback: () {
          _changePasswordHandler(oldPassword, newPassword);
        },
      ),
      isNotifiable: false,
    );
    _authProvider!.changePassword(email: _userModel!.email, oldPassword: oldPassword, newPassword: newPassword);
  }

  void _updateFeedback(double ratingValue, String feedbackText) async {
    FeedbackModel feedbackModel = FeedbackModel.copy(_authProvider!.authState.feedbackModel!);
    feedbackModel.userId = _authProvider!.authState.userModel!.id;
    feedbackModel.ratingValue = ratingValue;
    feedbackModel.feedbackText = feedbackText;

    await _keicyProgressDialog!.show();

    _authProvider!.setAuthState(
      _authProvider!.authState.update(
        progressState: 1,
        callback: () {
          _updateFeedback(ratingValue, feedbackText);
        },
      ),
      isNotifiable: false,
    );

    if (feedbackModel.id != null) {
      _authProvider!.updateFeedback(feedbackModel: feedbackModel);
    } else {
      _authProvider!.createFeedback(feedbackModel: feedbackModel);
    }
  }

  bool _checkAddContactAvailable() {
    var contactsInfo = AppDataProvider.of(context).prefs!.getString("contactsInfo") == null
        ? null
        : json.decode(AppDataProvider.of(context).prefs!.getString("contactsInfo")!);

    if (contactsInfo == null) {
      AppDataProvider.of(context).prefs!.setString(
            "contactsInfo",
            json.encode({
              "date": DateTime.now().millisecondsSinceEpoch,
              "count": 0,
            }),
          );
      return true;
    }
    if (DateTime.fromMillisecondsSinceEpoch(contactsInfo["date"]).year == DateTime.now().year &&
        DateTime.fromMillisecondsSinceEpoch(contactsInfo["date"]).month == DateTime.now().month &&
        DateTime.fromMillisecondsSinceEpoch(contactsInfo["date"]).day == DateTime.now().day) {
      if (contactsInfo["count"] >= AppConfig.supportRepeatCount) {
        return false;
      } else {
        return true;
      }
    } else {
      AppDataProvider.of(context).prefs!.setString(
            "contactsInfo",
            json.encode({
              "date": DateTime.now().millisecondsSinceEpoch,
              "count": 0,
            }),
          );
      return true;
    }
  }

  void _addContact(ContactModel contactModel) async {
    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(
        progressState: 1,
        callback: () {
          _addContact(contactModel);
        },
      ),
      isNotifiable: false,
    );
    var result = await _authProvider!.addContact(contactModel: contactModel);

    if (result) {
      var contactsInfo = AppDataProvider.of(context).prefs!.getString("contactsInfo") == null
          ? null
          : json.decode(AppDataProvider.of(context).prefs!.getString("contactsInfo")!);
      AppDataProvider.of(context).prefs!.setString(
            "contactsInfo",
            json.encode({
              "date": DateTime.now().millisecondsSinceEpoch,
              "count": contactsInfo["count"] + 1,
            }),
          );
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: heightDp,
        text: S.of(context).contact_success_dlg,
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headline6!.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Consumer<AuthProvider>(builder: (context, authProvider, _) {
        _userModel = UserModel.copy(authProvider.authState.userModel!);
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
          child: Column(
            children: <Widget>[
              _userInfo(),
              SizedBox(height: heightDp * 15),
              _panel1(),
              SizedBox(height: heightDp * 15),
              _orderPanel(),
              SizedBox(height: heightDp * 15),
              _profileSettingPanel(),
              SizedBox(height: heightDp * 15),
              // ListTile(
              //   onTap: () {
              //     AuthProvider.of(context).logout(
              //       fcmToken: AuthProvider.of(context).authState.userModel!.fcmToken,
              //     );
              //   },
              //   title: Text("Logout"),
              // ),
              SizedBox(height: heightDp * 15),
              _qrCodePanel(),
              SizedBox(height: heightDp * 15),
              _accountSettingPanel(),
            ],
          ),
        );
      }),
    );
  }
}
