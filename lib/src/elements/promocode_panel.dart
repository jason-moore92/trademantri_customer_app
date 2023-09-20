import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/helpers/price_functions1.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class PromocodePanel extends StatefulWidget {
  final OrderModel? orderModel;
  final Function? refreshCallback;
  final bool? isReadOnly;
  final List? typeList;
  final bool? isForAssistant;

  PromocodePanel({
    @required this.orderModel,
    @required this.refreshCallback,
    this.isReadOnly = false,
    this.typeList = const [],
    this.isForAssistant = false,
  });

  @override
  _PromocodePanelState createState() => _PromocodePanelState();
}

class _PromocodePanelState extends State<PromocodePanel> {
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

  TextEditingController _promocodeController = TextEditingController();
  FocusNode _promocodeFocusNode = FocusNode();

  PromocodeProvider? _promocodeProvider;

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

    _promocodeProvider = PromocodeProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PromocodeProvider>(builder: (context, promocodeProvider, _) {
      if (widget.orderModel!.promocode == null) {
        _promocodeController.clear();
      }

      bool isReadOnly = widget.isReadOnly!;
      if (widget.orderModel!.storeModel != null &&
          (promocodeProvider.promocodeState.promocodeData![widget.orderModel!.storeModel!.subType] == null ||
              promocodeProvider.promocodeState.promocodeData![widget.orderModel!.storeModel!.subType]!.isEmpty)) {
        isReadOnly = true;
        _promocodeProvider!.setPromocodeState(_promocodeProvider!.promocodeState.update(progressState: 0), isNotifiable: false);
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Do you have a Promo code?",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
            ),
            Text(
              "Apply to get discount",
              style: TextStyle(fontSize: fontSp * 12, color: Colors.grey.withOpacity(1)),
            ),
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  child: KeicyTextFormField(
                    controller: _promocodeController,
                    focusNode: _promocodeFocusNode,
                    width: null,
                    height: heightDp * 40,
                    autofocus: false,
                    readOnly: isReadOnly || widget.orderModel!.promocode != null,
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    borderRadius: heightDp * 6,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
                    hintText: "Promocode",
                  ),
                ),
                SizedBox(width: widthDp * 10),
                GestureDetector(
                  onTap: _promocodeHandler,
                  child: Container(
                    height: heightDp * 40,
                    padding: EdgeInsets.symmetric(
                      horizontal: widthDp * 15,
                    ),
                    decoration: BoxDecoration(
                      color: isReadOnly ? Colors.grey.withOpacity(0.6) : config.Colors().mainColor(1),
                      borderRadius: BorderRadius.circular(heightDp * 6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.orderModel!.promocode != null ? "Cancel" : "Apply",
                      style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _promocodeHandler() async {
    if (widget.isReadOnly! || _promocodeController.text.isEmpty) return;

    FocusScope.of(context).requestFocus(FocusNode());

    if (widget.orderModel!.promocode != null) {
      widget.orderModel!.promocode = null;
      _promocodeController.clear();
      widget.refreshCallback!();
      return;
    }

    widget.orderModel!.promocode = PromocodeModel(promocodeCode: _promocodeController.text.trim());
    String message = "This promocode is wrong or is not valid for this type of order";

    double totalOriginPrice = PriceFunctions1.getTotalOrignPrice(orderModel: widget.orderModel!);

    for (var i = 0; i < _promocodeProvider!.promocodeState.promocodeData![widget.orderModel!.storeModel!.subType]!.length; i++) {
      PromocodeModel promocodeModel = _promocodeProvider!.promocodeState.promocodeData![widget.orderModel!.storeModel!.subType]![i];

      /// checking promocode
      if (promocodeModel.promocodeCode != _promocodeController.text.trim()) {
        continue;
      }

      if (promocodeModel.promocodeType == "Delivery" && widget.orderModel!.orderType == "Pickup") {
        message = "This promocode is for delivery order";
        break;
      }

      /// checking userIds
      if (promocodeModel.userIds!.isNotEmpty && !promocodeModel.userIds!.contains(AuthProvider.of(context).authState.userModel!.id)) {
        message = "This promocode cant be applied to your order";
        break;
      }

      /// checking storeIds
      if (promocodeModel.storeIds!.isNotEmpty && !promocodeModel.storeIds!.contains(widget.orderModel!.storeModel!.id)) {
        message = "This promocode cant be applied to your order";
        break;
      }

      /// checking promocode type
      if (widget.typeList!.isNotEmpty && !widget.typeList!.contains(promocodeModel.promocodeType)) {
        message = "This promocode cant be applied to your order";
        break;
      }

      /// checking validation dates
      DateTime? startDT = promocodeModel.validityStartDate;
      if (startDT!.isUtc) startDT = startDT.toLocal();
      DateTime? endDT = promocodeModel.validityEndDate;
      if (endDT!.isUtc) endDT = endDT.toLocal();

      if (!(startDT.isBefore(DateTime.now()) && endDT.isAfter(DateTime.now()))) {
        message = "This promocode cant be applied to your order";
        break;
      }

      /// checking noOfTimesCanApply
      if (promocodeModel.noOfTimesCanApply != null) {
        await _keicyProgressDialog!.show();
        var result = await OrderApiProvider.getPromocodeUsage(promocodeId: promocodeModel.id);
        await _keicyProgressDialog!.hide();

        if (result["success"] && result["data"].isNotEmpty) {
          if (promocodeModel.noOfTimesCanApply != null && promocodeModel.noOfTimesCanApply! <= result["data"][0]["promocodeCount"]) {
            message = "This promocode cant be applied to your order";
            break;
          }
        }
      }

      /// checking orderNumberAppliedTo and noOfTimesAppliedByUser
      if (promocodeModel.orderNumberAppliedTo != null || promocodeModel.noOfTimesAppliedByUser != null) {
        await _keicyProgressDialog!.show();
        var result = await OrderApiProvider.getPromocodeUsageByUsers(promocodeId: promocodeModel.id);
        await _keicyProgressDialog!.hide();

        if (result["success"] && result["data"].isNotEmpty) {
          if (promocodeModel.noOfTimesAppliedByUser != null && promocodeModel.noOfTimesAppliedByUser! <= result["data"][0]["promocodeCount"]) {
            message = "This promocode cant be applied to your order";
            break;
          }

          if (promocodeModel.orderNumberAppliedTo != null && promocodeModel.orderNumberAppliedTo != result["data"][0]["promocodeCount"] + 1) {
            message = "This promocode cant be applied to your order";
            break;
          }
        }
      }

      /// checking minimumorder
      if (!widget.isForAssistant! && promocodeModel.minimumorder != null && totalOriginPrice < promocodeModel.minimumorder!) {
        message = "To apply this code minimum order is ${promocodeModel.minimumorder}.";
        break;
      }
      await _keicyProgressDialog!.hide();

      widget.orderModel!.promocode = promocodeModel;
      message = "";
      break;
    }

    if (widget.orderModel!.promocode == null || widget.orderModel!.promocode!.id == null || widget.orderModel!.promocode!.id == "") {
      _promocodeController.clear();
      widget.orderModel!.promocode = null;
      ErrorDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: message,
        widthDp: widthDp,
        callBack: null,
        isTryButton: false,
      );
    } else {
      _promocodeController.text = widget.orderModel!.promocode!.promocodeCode!;
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp, text: "Added Promocode successfully");
    }
    widget.refreshCallback!();
  }
}
