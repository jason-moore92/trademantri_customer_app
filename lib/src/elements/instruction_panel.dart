import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';

class InstructionPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final Function(GlobalKey<FormState>)? callback;

  InstructionPanel({
    @required this.orderModel,
    @required this.callback,
  });

  @override
  _InstructionPanelState createState() => _InstructionPanelState();
}

class _InstructionPanelState extends State<InstructionPanel> {
  /// Responsive design variables
  double? deviceWidth;
  double? deviceHeight;
  double? statusbarHeight;
  double? bottomBarHeight;
  double? appbarHeight;
  double? widthDp;
  double? heightDp;
  double? heightDp1;
  double? fontSp;
  ///////////////////////////////

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _instructionController = TextEditingController();
  FocusNode _instructionFocusNode = FocusNode();

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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    ///////////////////////////////

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      widget.callback!(_formkey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.event_note,
            size: heightDp! * 25,
            color: Colors.black.withOpacity(0.7),
          ),
          SizedBox(width: widthDp! * 20),
          Expanded(
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KeicyTextFormField(
                    controller: _instructionController,
                    focusNode: _instructionFocusNode,
                    width: null,
                    height: heightDp! * 120,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    border: Border.all(color: Colors.grey.withOpacity(0.4)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                    borderRadius: heightDp! * 6,
                    contentVerticalPadding: widthDp! * 10,
                    contentHorizontalPadding: heightDp! * 10,
                    textStyle: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                    hintStyle: TextStyle(fontSize: fontSp! * 16, color: Colors.grey.withOpacity(0.7)),
                    hintText: "Any Instructions?",
                    validatorHandler: (input) {
                      if (input.isNotEmpty && input.length > 1000) return "You can input 1000 characters at last";
                      return null;
                    },
                    onChangeHandler: (input) {
                      widget.orderModel!.instructions = input.trim();
                      setState(() {});
                    },
                    onSaveHandler: (input) {
                      widget.orderModel!.instructions = input.trim();
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onEditingCompleteHandler: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onFieldSubmittedHandler: (input) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                  SizedBox(height: heightDp! * 5),
                  Text(
                    "${_instructionController.text.length} / 1000",
                    style: TextStyle(
                      fontSize: fontSp! * 10,
                      color: _instructionController.text.length <= 1000 ? Colors.grey : Colors.red.withOpacity(0.7),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
