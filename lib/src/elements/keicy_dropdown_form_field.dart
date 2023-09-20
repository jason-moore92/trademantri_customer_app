library keicy_dropdown_form_field;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeicyDropDownFormField extends FormField<dynamic> {
  KeicyDropDownFormField({
    Key? key,
    @required double? width,
    @required double? height,
    @required List<dynamic>? menuItems,
    Function(dynamic)? onChangeHandler,
    bool isDense: true,
    bool isExpanded: true,
    dynamic value,
    bool autovalidate: false,
    FormFieldValidator<dynamic>? onValidateHandler,
    Function(dynamic)? onSaveHandler,

    /// label
    String label = "",
    double labelSpacing = 5,
    TextStyle? labelStyle,

    /// icons
    List<Widget> prefixIcons = const [],
    List<Widget> suffixIcons = const [],
    bool isPrefixIconOutofField = false,
    bool isSuffixIconOutofField = false,
    double iconSpacing = 10,
    double iconSize = 20,
    Widget? icon,

    /// border
    Color fillColor = Colors.transparent,
    Border border = const Border(bottom: BorderSide(width: 1, color: Colors.black)),
    Border errorBorder = const Border(bottom: BorderSide(width: 1, color: Colors.red)),
    double borderRadius = 0,
    // textfield
    double contentHorizontalPadding = 5,
    double contentVerticalPadding = 5,
    TextStyle? itemStyle,
    TextStyle selectedItemStyle = const TextStyle(fontSize: 15, color: Colors.black),
    Color dropdownColor = Colors.white,
    String hintText = "",
    TextStyle hintStyle = const TextStyle(fontSize: 15, color: Colors.grey),
    bool fixedHeightState = false,
    bool isDoneValidate = false,
    FocusNode? focusNode,
    Color? iconEnabledColor,
    Color? iconDisabledColor,
    bool isImportant = false,
  }) : super(
          key: key,
          initialValue: value,
          autovalidate: autovalidate,
          validator: (value) {
            isDoneValidate = true;
            if (onValidateHandler != null) return onValidateHandler(value);
            return null;
          },
          onSaved: onSaveHandler,
          builder: (FormFieldState<dynamic> state) {
            itemStyle = itemStyle ?? selectedItemStyle;
            labelStyle = labelStyle ?? selectedItemStyle;

            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => KeicyDropDownFormFieldProvider(value)),
              ],
              child: Consumer<KeicyDropDownFormFieldProvider>(
                builder: (context, customDropDownFormFieldProvider, _) {
                  WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
                    if (customDropDownFormFieldProvider.isDoneValidate != isDoneValidate) customDropDownFormFieldProvider.setIsDoneValidate(true);
                  });
                  Widget prefixIcon = SizedBox();
                  Widget suffixIcon = SizedBox();
                  if (prefixIcons.length != 0 && !state.hasError && customDropDownFormFieldProvider.isDoneValidate)
                    prefixIcon = prefixIcons[0];
                  else if (prefixIcons.length != 0) prefixIcon = prefixIcons.length == 2 ? prefixIcons[1] : prefixIcons[0];

                  if (suffixIcons.length != 0 && !state.hasError && customDropDownFormFieldProvider.isDoneValidate)
                    suffixIcon = suffixIcons[0];
                  else if (suffixIcons.length != 0) suffixIcon = suffixIcons.length == 2 ? suffixIcons[1] : suffixIcons[0];

                  return Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        (label == "")
                            ? SizedBox()
                            : Row(
                                children: [
                                  Text(label, style: labelStyle),
                                  isImportant
                                      ? Text(
                                          "  *",
                                          style: labelStyle!.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                        (label == "") ? SizedBox() : SizedBox(height: labelSpacing),
                        Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            color: fillColor,
                            border: (state.hasError) ? errorBorder : border,
                            borderRadius: border.isUniform ? BorderRadius.circular(borderRadius) : null,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: contentHorizontalPadding, vertical: contentVerticalPadding),
                          child: Row(
                            children: <Widget>[
                              (!isPrefixIconOutofField) ? prefixIcon : SizedBox(),
                              (!isPrefixIconOutofField && prefixIcons.length != 0) ? SizedBox(width: iconSpacing) : SizedBox(),
                              Expanded(
                                child: DropdownButton(
                                  focusNode: focusNode,
                                  underline: SizedBox(),
                                  items: menuItems!
                                      .map((item) => DropdownMenuItem(
                                            child: new Text(item["text"], style: itemStyle),
                                            value: item["value"],
                                          ))
                                      .toList(),
                                  selectedItemBuilder: (BuildContext context) {
                                    return menuItems.map<Widget>((item) {
                                      return Text(
                                        item["text"],
                                        style: selectedItemStyle,
                                      );
                                    }).toList();
                                  },
                                  dropdownColor: dropdownColor,
                                  hint: Text(hintText, style: hintStyle),
                                  isDense: isDense,
                                  isExpanded: isExpanded,
                                  value: customDropDownFormFieldProvider.value,
                                  icon: icon,
                                  iconSize: iconSize,
                                  iconEnabledColor: iconEnabledColor,
                                  iconDisabledColor: iconDisabledColor,
                                  onChanged: (value) {
                                    onChangeHandler!(value);
                                    customDropDownFormFieldProvider.setValue(value);
                                    state.didChange(value);
                                  },
                                ),
                              ),
                              (!isSuffixIconOutofField && suffixIcons.length != 0) ? SizedBox(width: iconSpacing) : SizedBox(),
                              (!isSuffixIconOutofField) ? suffixIcon : SizedBox(),
                            ],
                          ),
                        ),
                        (state.hasError)
                            ? Container(
                                height: selectedItemStyle.fontSize,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  (state.errorText ?? ""),
                                  style: TextStyle(fontSize: selectedItemStyle.fontSize! * 0.8, color: Colors.red),
                                ),
                              )
                            : (fixedHeightState)
                                ? SizedBox(height: selectedItemStyle.fontSize)
                                : SizedBox(),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
}

class KeicyDropDownFormFieldProvider extends ChangeNotifier {
  static KeicyDropDownFormFieldProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<KeicyDropDownFormFieldProvider>(context, listen: listen);

  KeicyDropDownFormFieldProvider(value) {
    _value = value;
  }

  dynamic _value;
  dynamic get value => _value;
  void setValue(dynamic value) {
    if (_value != value) {
      _value = value;
    }
  }

  bool _isDoneValidate = false;
  bool get isDoneValidate => _isDoneValidate;
  void setIsDoneValidate(bool isDoneValidate) {
    if (_isDoneValidate != isDoneValidate) {
      _isDoneValidate = isDoneValidate;
    }
  }
}
