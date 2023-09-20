library keicy_checkbox;

import 'package:flutter/material.dart';

class KeicyCheckBox extends FormField<Map<String, dynamic>> {
  KeicyCheckBox({
    Key? key,
    double? width,
    double? height,
    bool value = false,
    IconData trueIcon = Icons.check_box,
    IconData falseIcon = Icons.check_box_outline_blank,
    @required double? iconSize,
    Color iconColor = Colors.blue,
    Color? trueIconColor,
    Color? falseIconColor,
    Color disabledColor = Colors.grey,
    String label = "",
    TextStyle? labelStyle,
    double labelFontSize = 20,
    Color labelColor = Colors.black,
    double labelSpacing = 10,
    bool autovalidate = false,
    bool enabled = true,
    bool readOnly = false,
    bool fixedHeightState = false,
    bool stateChangePossible = false,
    Function? onSaveHandler,
    Function? onChangeHandler,
    FormFieldValidator<bool>? onValidateHandler,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(
          key: key,
          initialValue: {"value": value, "oldValue": value},
          autovalidateMode: autovalidate ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (onValidateHandler != null) return onValidateHandler(value!["value"]);
            return null;
          },
          onSaved: (value) {
            if (onSaveHandler != null) onSaveHandler(value!["value"]);
          },
          builder: (FormFieldState<Map<String, dynamic>> state) {
            trueIconColor = trueIconColor ?? iconColor;
            falseIconColor = falseIconColor ?? iconColor;
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              if (value != state.value!["oldValue"]) {
                state.didChange({"value": value, "oldValue": value});
              }
            });
            return Padding(
              padding: EdgeInsets.zero,
              child: state.value!["value"]
                  ? _createTappableIcon(
                      state,
                      enabled,
                      readOnly,
                      trueIcon,
                      trueIconColor!,
                      disabledColor,
                      iconSize != null ? iconSize : height!,
                      label,
                      labelFontSize,
                      labelColor,
                      width,
                      height,
                      fixedHeightState,
                      stateChangePossible,
                      onChangeHandler,
                      labelStyle,
                      crossAxisAlignment,
                      labelSpacing,
                    )
                  : _createTappableIcon(
                      state,
                      enabled,
                      readOnly,
                      falseIcon,
                      falseIconColor!,
                      disabledColor,
                      iconSize != null ? iconSize : height!,
                      label,
                      labelFontSize,
                      labelColor,
                      width,
                      height,
                      fixedHeightState,
                      stateChangePossible,
                      onChangeHandler,
                      labelStyle,
                      crossAxisAlignment,
                      labelSpacing,
                    ),
            );
          },
        );

  static Widget _createTappableIcon(
    FormFieldState<Map<String, dynamic>> state,
    bool enabled,
    bool readOnly,
    IconData icon,
    Color iconColor,
    Color disabledColor,
    double iconSize,
    String label,
    double labelFontSize,
    Color labelColor,
    double? width,
    double? height,
    bool fixedHeightState,
    bool stateChangePossible,
    Function? onChangeHandler,
    TextStyle? labelStyle,
    CrossAxisAlignment crossAxisAlignment,
    double labelSpacing,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (enabled && !readOnly) ? () => tapHandler(state, stateChangePossible, onChangeHandler) : null,
          child: Container(
            width: width,
            // height: height,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: (label == "") ? MainAxisAlignment.center : MainAxisAlignment.start,
              crossAxisAlignment: crossAxisAlignment,
              children: <Widget>[
                Icon(icon, color: enabled ? iconColor : disabledColor, size: iconSize),
                (label == "") ? SizedBox() : SizedBox(width: labelSpacing),
                (label == "")
                    ? SizedBox()
                    : (width == null)
                        ? Text(label, style: labelStyle ?? TextStyle(fontSize: labelFontSize, color: labelColor))
                        : Expanded(
                            child: Text(label, style: labelStyle ?? TextStyle(fontSize: labelFontSize, color: labelColor)),
                          )
              ],
            ),
          ),
        ),
        (state.hasError)
            ? Container(
                height: labelFontSize + 5,
                child: Text(
                  (state.errorText ?? ""),
                  style: TextStyle(fontSize: (labelStyle != null) ? labelStyle.fontSize! * 0.8 : labelFontSize * 0.8, color: Colors.red),
                ),
              )
            : (fixedHeightState)
                ? SizedBox(height: labelFontSize + 5)
                : SizedBox(),
      ],
    );
  }
}

void tapHandler(FormFieldState<Map<String, dynamic>> state, bool stateChangePossible, Function? onChangeHandler) {
  bool newState = !state.value!["value"];
  state.didChange({"value": newState, "oldValue": state.value!["oldValue"]});
  if (onChangeHandler != null) onChangeHandler(newState);
}
