import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:keyboard_utils/keyboard_listener.dart' as KeyboardListener;
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:trapp/src/models/index.dart';

class TipPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final Function()? refreshCallback;

  TipPanel({
    @required this.orderModel,
    @required this.refreshCallback,
  });

  @override
  _TipPanelState createState() => _TipPanelState();
}

class _TipPanelState extends State<TipPanel> {
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

  TextEditingController _customTipController = TextEditingController();
  FocusNode _customTipFocusNode = FocusNode();

  bool _isCustomTip = false;
  bool _isTapped = false;

  KeyboardUtils _keyboardUtils = KeyboardUtils();
  int? _idKeyboardListener;

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

    _isTapped = false;
    _isCustomTip = false;

    _idKeyboardListener = _keyboardUtils.add(
      listener: KeyboardListener.KeyboardListener(
        willHideKeyboard: () {
          if (_customTipController.text.trim().replaceAll("₹ ", "") != "") {
            setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              _isCustomTip = true;
              widget.orderModel!.paymentDetail!.tip = int.parse(_customTipController.text.trim().replaceAll("₹ ", ""));
              widget.refreshCallback!();
            });
          } else {
            setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              _isCustomTip = false;
              _isTapped = false;
              // widget.orderModel!.paymentDetail!.tip = 0;
              widget.refreshCallback!();
            });
          }
        },
        willShowKeyboard: (double keyboardHeight) {},
      ),
    );
  }

  @override
  void dispose() {
    _keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 15),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Custom Tip",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "Tip the delivery boy for his service",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
          ),
          SizedBox(height: heightDp * 10),
          Wrap(
            spacing: widthDp * 10,
            runSpacing: heightDp * 5,
            children: List.generate(AppConfig.tipData.length, (index) {
              var tip = AppConfig.tipData[index];

              Widget _tipWidget = Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(heightDp * 6),
                  side: (((!_isCustomTip && widget.orderModel!.paymentDetail!.tip == tip) ||
                          (widget.orderModel!.paymentDetail!.tip != null && tip == "Custom" && _isCustomTip))
                      ? BorderSide(width: 2, color: config.Colors().mainColor(1))
                      : BorderSide(width: 1, color: Colors.grey)),
                ),
                child: Container(
                  width: tip != "Custom" ? widthDp * 70 : widthDp * 110,
                  height: heightDp * 30,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("img/tip.png", width: heightDp * 20, height: heightDp * 20, fit: BoxFit.cover),
                        Expanded(
                          child: Center(
                            child: tip != "Custom"
                                ? Text(
                                    tip == "no" ? tip : "₹ $tip",
                                    style: TextStyle(
                                      fontSize: fontSp * 16,
                                      color:
                                          !_isCustomTip && widget.orderModel!.paymentDetail!.tip == tip ? config.Colors().mainColor(1) : Colors.black,
                                      fontWeight: !_isCustomTip && widget.orderModel!.paymentDetail!.tip == tip ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  )
                                : TextFormField(
                                    controller: _customTipController,
                                    focusNode: _customTipFocusNode,
                                    style: TextStyle(
                                      fontSize: fontSp * 16,
                                      color: (widget.orderModel!.paymentDetail!.tip != null && tip == "Custom" && _isCustomTip)
                                          ? config.Colors().mainColor(1)
                                          : Colors.black,
                                      fontWeight: (widget.orderModel!.paymentDetail!.tip != null && tip == "Custom" && _isCustomTip)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(fontSize: 0, color: Colors.transparent),
                                      isDense: true,
                                      isCollapsed: true,
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.zero,
                                      hintText: _isTapped ? "" : tip,
                                      hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 0),
                                      border: InputBorder.none,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _isTapped = true;
                                      });
                                    },
                                    onEditingComplete: () {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      // if (_customTipController.text.trim().replaceAll("₹ ", "") != "") {
                                      //   setState(() {
                                      //     FocusScope.of(context).requestFocus(FocusNode());
                                      //     _isCustomTip = true;
                                      //     widget.orderModel!.paymentDetail!.tip = int.parse(_customTipController.text.trim().replaceAll("₹ ", ""));
                                      //   });
                                      // } else {
                                      //   setState(() {
                                      //     FocusScope.of(context).requestFocus(FocusNode());
                                      //     _isCustomTip = false;
                                      //     widget.orderModel!.paymentDetail!.tip = 0;
                                      //   });
                                      // }
                                    },
                                    onFieldSubmitted: (input) {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      // if (_customTipController.text.trim().replaceAll("₹ ", "") != "") {
                                      //   setState(() {
                                      //     FocusScope.of(context).requestFocus(FocusNode());
                                      //     _isCustomTip = true;
                                      //     widget.orderModel!.paymentDetail!.tip = int.parse(_customTipController.text.trim().replaceAll("₹ ", ""));
                                      //     widget.refreshCallback!();
                                      //   });
                                      // } else {
                                      //   setState(() {
                                      //     FocusScope.of(context).requestFocus(FocusNode());
                                      //     _isCustomTip = false;
                                      //     widget.orderModel!.paymentDetail!.tip = 0;
                                      //     widget.refreshCallback!();
                                      //   });
                                      // }
                                    },
                                    inputFormatters: [
                                      CurrencyTextInputFormatter(
                                        decimalDigits: 0,
                                        symbol: '₹ ',
                                      )
                                    ],
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              return (tip != "Custom")
                  ? GestureDetector(
                      onTap: () {
                        if (tip == "no") {
                          setState(() {
                            _isCustomTip = false;
                            _isTapped = false;
                            _customTipController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                            widget.orderModel!.paymentDetail!.tip = 0;
                            widget.refreshCallback!();
                          });
                        } else if (tip != "Custom") {
                          setState(() {
                            _isCustomTip = false;
                            _isTapped = false;
                            _customTipController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                            widget.orderModel!.paymentDetail!.tip = tip;
                            widget.refreshCallback!();
                          });
                        } else {
                          // _showCustomTipHandler();
                        }
                      },
                      child: _tipWidget,
                    )
                  : _tipWidget;
            }),
          ),
        ],
      ),
    );
  }
}
