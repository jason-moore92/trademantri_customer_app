import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/ApiDataProviders/book_appointment_api_provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/success_dialog.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/BookAppointmentConfirmPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class DetailsPanel extends StatefulWidget {
  DetailsPanel({Key? key}) : super(key: key);

  @override
  _DetailsPanelState createState() => _DetailsPanelState();
}

class _DetailsPanelState extends State<DetailsPanel> {
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;

  BookAppointmentProvider? _bookAppointmentProvider;

  BookAppointmentModel? _bookAppointmentModel;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _commentsController = TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _mobileFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _commentsFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  KeicyProgressDialog? _keicyProgressDialog;

  List<dynamic> _gestsList = [];

  @override
  void initState() {
    super.initState();

    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    _bookAppointmentProvider = BookAppointmentProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _bookAppointmentModel = BookAppointmentModel.copy(_bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!);

    _nameController.text = (_bookAppointmentModel!.userModel!.firstName ?? "") + " " + (_bookAppointmentModel!.userModel!.lastName ?? "");
    _mobileController.text = _bookAppointmentModel!.userModel!.mobile ?? "";
    _emailController.text = _bookAppointmentModel!.userModel!.email ?? "";

    for (var i = 0; i < _bookAppointmentModel!.appointmentModel!.maxNumOfGuestsPerTimeSlot!; i++) {
      _gestsList.add({"value": i + 1, "text": "${i + 1} people"});
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _bookAppointmentProvider!.addListener(_bookAppointmentProviderListener);
    });
  }

  void _bookAppointmentProviderListener() {
    _bookAppointmentModel = BookAppointmentModel.copy(_bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!);
    setState(() {});
  }

  @override
  void dispose() {
    _bookAppointmentProvider!.removeListener(_bookAppointmentProviderListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookAppointmentProvider>(builder: (context, bookAppointmentProvider, _) {
      return KeyboardAware(builder: (context, keyboardConfig) {
        return Container(
          height: deviceHeight - statusbarHeight - appbarHeight - heightDp * 40,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KeicyTextFormField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      width: null,
                      height: heightDp * 40,
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                      borderRadius: heightDp * 6,
                      contentHorizontalPadding: heightDp * 10,
                      label: "Name",
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                      hintText: "Name",
                      validatorHandler: (input) {
                        if (input.isEmpty) return "Please enter name";
                        return null;
                      },
                      onSaveHandler: (input) {
                        _bookAppointmentModel!.name = input.trim();
                      },
                      onEditingCompleteHandler: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      onFieldSubmittedHandler: (input) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    KeicyTextFormField(
                      controller: _mobileController,
                      focusNode: _mobileFocusNode,
                      width: null,
                      height: heightDp * 40,
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                      borderRadius: heightDp * 6,
                      contentHorizontalPadding: heightDp * 10,
                      label: "Mobile",
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                      hintText: "Mobile",
                      keyboardType: TextInputType.phone,
                      validatorHandler: (input) {
                        if (input.isEmpty) return "Please enter Mobile";
                        if (input.length != 10) return "Please enter 10 digits";
                        return null;
                      },
                      onSaveHandler: (input) {
                        _bookAppointmentModel!.mobile = input.trim();
                      },
                      onEditingCompleteHandler: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      onFieldSubmittedHandler: (input) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    KeicyTextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      width: null,
                      height: heightDp * 40,
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                      borderRadius: heightDp * 6,
                      contentHorizontalPadding: heightDp * 10,
                      label: "Email",
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                      hintText: "Email",
                      keyboardType: TextInputType.phone,
                      validatorHandler: (input) {
                        if (input.isEmpty) return "Please enter email";
                        if (!KeicyValidators.isValidEmail(input.trim())) return "Please enter correct email";
                        return null;
                      },
                      onSaveHandler: (input) {
                        _bookAppointmentModel!.email = input.trim();
                      },
                      onEditingCompleteHandler: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      onFieldSubmittedHandler: (input) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    KeicyDropDownFormField(
                      width: null,
                      height: heightDp * 40,
                      menuItems: _gestsList,
                      value: _bookAppointmentModel!.noOfGuests,
                      selectedItemStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      borderRadius: heightDp * 6,
                      contentHorizontalPadding: heightDp * 10,
                      label: "Number of Guests",
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      prefixIcons: [Icon(Icons.people, size: heightDp * 20)],
                      onChangeHandler: (value) {
                        setState(() {
                          _bookAppointmentModel!.noOfGuests = value;
                        });
                      },
                      onSaveHandler: (value) {
                        _bookAppointmentModel!.noOfGuests = value;
                      },
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                        SizedBox(height: heightDp * 5),
                        Text(
                          "${_bookAppointmentModel!.appointmentModel!.address}",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      ],
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    KeicyTextFormField(
                      controller: _commentsController,
                      focusNode: _commentsFocusNode,
                      width: null,
                      height: heightDp * 80,
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                      borderRadius: heightDp * 6,
                      contentHorizontalPadding: heightDp * 10,
                      label: "Comments",
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                      hintText: "Comments",
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      onSaveHandler: (input) {
                        _bookAppointmentModel!.comments = input.trim();
                      },
                      onEditingCompleteHandler: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      onFieldSubmittedHandler: (input) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    Center(
                      child: KeicyRaisedButton(
                        width: heightDp * 100,
                        height: heightDp * 40,
                        color: config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: fontSp * 16),
                        ),
                        onPressed: _saveHandler,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }

  void _saveHandler() async {
    if (!_formkey.currentState!.validate()) return;
    _formkey.currentState!.save();

    _bookAppointmentModel!.dateTime = KeicyDateTime.convertDateStringToDateTime(
      dateString: _bookAppointmentModel!.date,
      isUTC: true,
    );

    _bookAppointmentProvider!.setBookAppointmentState(
      _bookAppointmentProvider!.bookAppointmentState.update(
        bookAppointmentModel: _bookAppointmentModel,
      ),
    );

    await _keicyProgressDialog!.show();

    var result = await BookAppointmentApiProvider.creatBooking(bookAppointmentModel: _bookAppointmentModel);
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      BookAppointmentModel bookAppointmentModel = BookAppointmentModel.fromJson(result["data"]);
      bookAppointmentModel.userModel = _bookAppointmentModel!.userModel;
      bookAppointmentModel.storeModel = _bookAppointmentModel!.storeModel;
      bookAppointmentModel.appointmentModel = _bookAppointmentModel!.appointmentModel;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => BookAppointmentConfirmPage(
            bookAppointmentModel: bookAppointmentModel,
          ),
        ),
      );
    } else {
      ErrorDialog.show(
        context,
        heightDp: heightDp,
        widthDp: widthDp,
        fontSp: fontSp,
        text: result["message"] ?? "Something was wrong",
      );
    }
  }
}
