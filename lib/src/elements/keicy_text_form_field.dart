library keicy_text_form_field;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_utils/keyboard_listener.dart' as KeybardListener;
import 'package:keyboard_utils/keyboard_utils.dart';

class KeicyTextFormField extends StatefulWidget {
  KeicyTextFormField({
    Key? key,
    @required this.width,
    @required this.height,
    this.maxHeight,
    this.initialValue,
    this.controller,
    this.fixedHeightState = false,
    this.prefixIcons = const [],
    this.suffixIcons = const [],
    this.isPrefixIconOutofField = false,
    this.isSuffixIconOutofField = false,
    this.enableShowPassword = false,
    this.iconSpacing = 10,
    this.label = "",
    this.labelStyle,
    this.labelSpacing,
    this.border = const Border(bottom: BorderSide(width: 1, color: Colors.black)),
    this.errorBorder = const Border(bottom: BorderSide(width: 1, color: Colors.red)),
    this.borderRadius = 0,
    this.textStyle = const TextStyle(fontSize: 20, color: Colors.black),
    this.hintStyle = const TextStyle(fontSize: 20, color: Colors.grey),
    this.hintText = "",
    this.contentHorizontalPadding = 5,
    this.contentVerticalPadding = 5,
    this.textAlign = TextAlign.left,
    this.keyboardType = TextInputType.text,
    this.validatorHandler,
    this.onSaveHandler,
    this.fillColor = Colors.transparent,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.obscureText = false,
    this.autofocus = false,
    this.onChangeHandler,
    this.onTapHandler,
    this.onFieldSubmittedHandler,
    this.onEditingCompleteHandler,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.errorStringFontSize,
    this.inputFormatters,
    this.focusNode,
    this.isImportant = false,
    this.isUseKeyboardListener = false,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double? maxHeight;
  final String? initialValue;
  final TextEditingController? controller;
  final bool? fixedHeightState;
  final List<Widget>? prefixIcons;
  final List<Widget>? suffixIcons;
  final bool? isPrefixIconOutofField;
  final bool? isSuffixIconOutofField;
  final bool? enableShowPassword;
  final double? iconSpacing;
  final String? label;
  final TextStyle? labelStyle;
  final double? labelSpacing;
  final Border? border;
  final Border? errorBorder;
  final double? borderRadius;
  final double? contentHorizontalPadding;
  final double? contentVerticalPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String? hintText;
  final Color? fillColor;
  double? errorStringFontSize;
  FocusNode? focusNode;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final bool? obscureText;
  final Function(String)? validatorHandler;
  final Function(String)? onSaveHandler;
  final Function(String)? onChangeHandler;
  final Function(String)? onFieldSubmittedHandler;
  final Function()? onTapHandler;
  final Function()? onEditingCompleteHandler;
  final bool? autofocus;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool? readOnly;
  final bool? isImportant;
  final bool isUseKeyboardListener;
  final inputFormatters;

  @override
  _KeicyTextFormFieldState createState() => _KeicyTextFormFieldState();
}

class _KeicyTextFormFieldState extends State<KeicyTextFormField> {
  KeyboardUtils _keyboardUtils = KeyboardUtils();
  int? _idKeyboardListener;
  String? inputString;

  @override
  void initState() {
    super.initState();
    inputString = "";

    _idKeyboardListener = _keyboardUtils.add(
      listener: KeybardListener.KeyboardListener(
        willHideKeyboard: () {
          if (!widget.isUseKeyboardListener) return;
          if (widget.onFieldSubmittedHandler != null) {
            FocusScope.of(context).requestFocus(FocusNode());
            widget.onFieldSubmittedHandler!(inputString!);
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
    if (widget.errorStringFontSize == null) widget.errorStringFontSize = widget.textStyle!.fontSize! * 0.8;
    widget.focusNode = widget.focusNode ?? FocusNode();

    return Material(
      color: Colors.transparent,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => KeicyTextFormFieldProvider()),
        ],
        child: Consumer<KeicyTextFormFieldProvider>(
          builder: (context, customTextFormFieldProvider, _) {
            Widget prefixIcon = SizedBox();
            Widget suffixIcon = SizedBox();
            if (widget.prefixIcons!.length != 0 && customTextFormFieldProvider.isValidated) {
              prefixIcon = widget.prefixIcons![0];
            } else if (widget.prefixIcons!.length != 0 && !customTextFormFieldProvider.isValidated) {
              prefixIcon = widget.prefixIcons!.length == 2 ? widget.prefixIcons![1] : widget.prefixIcons![0];
            }

            if (widget.suffixIcons!.length != 0 && customTextFormFieldProvider.isValidated) {
              suffixIcon = widget.suffixIcons![0];
            } else if (widget.suffixIcons!.length != 0 && !customTextFormFieldProvider.isValidated) {
              suffixIcon = widget.suffixIcons!.length == 2 ? widget.suffixIcons![1] : widget.suffixIcons![0];
            }

            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(widget.focusNode);
              },
              child: Container(
                width: widget.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// prefix Icon
                    (widget.isPrefixIconOutofField! && widget.prefixIcons!.length != 0)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              prefixIcon,
                              SizedBox(width: widget.iconSpacing),
                            ],
                          )
                        : SizedBox(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// label
                          (widget.label != "")
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(widget.label!, style: widget.labelStyle ?? widget.textStyle),
                                        widget.isImportant!
                                            ? Text(
                                                "  *",
                                                style:
                                                    (widget.labelStyle ?? widget.textStyle)!.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                    SizedBox(height: widget.labelSpacing ?? widget.labelSpacing),
                                  ],
                                )
                              : SizedBox(),
                          Container(
                            width: double.maxFinite,
                            height: widget.height,
                            // constraints: maxHeight != null ? BoxConstraints(maxHeight: maxHeight) : null,
                            padding: EdgeInsets.symmetric(
                              horizontal: widget.contentHorizontalPadding!,
                              vertical: widget.contentVerticalPadding!,
                            ),
                            alignment: (widget.keyboardType == TextInputType.multiline) ? Alignment.topLeft : Alignment.center,
                            decoration: BoxDecoration(
                              color: widget.fillColor,
                              border: (customTextFormFieldProvider.errorText == "") ? widget.border : widget.errorBorder,
                              borderRadius: ((customTextFormFieldProvider.errorText == "" && widget.border!.isUniform) ||
                                      (customTextFormFieldProvider.errorText != "" && widget.errorBorder!.isUniform))
                                  ? BorderRadius.circular(widget.borderRadius!)
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                /// prefix icon
                                (!widget.isPrefixIconOutofField! && widget.prefixIcons!.length != 0) ? prefixIcon : SizedBox(),
                                (!widget.isPrefixIconOutofField! && widget.prefixIcons!.length != 0)
                                    ? SizedBox(width: widget.iconSpacing)
                                    : SizedBox(),
                                Expanded(
                                  child: Container(
                                    constraints: widget.maxHeight != null ? BoxConstraints(maxHeight: widget.maxHeight!) : null,
                                    child: TextFormField(
                                      focusNode: widget.focusNode,
                                      initialValue: widget.controller == null ? widget.initialValue : null,
                                      controller: widget.controller,
                                      style: widget.textStyle,
                                      autofocus: widget.autofocus!,
                                      maxLines: widget.maxLines,
                                      textInputAction: widget.textInputAction,
                                      textCapitalization: widget.textCapitalization,
                                      readOnly: widget.readOnly!,
                                      textAlign: widget.textAlign!,
                                      keyboardType: widget.keyboardType,
                                      autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(fontSize: 0, color: Colors.transparent, height: 0),
                                        isDense: true,
                                        isCollapsed: true,
                                        hintText: widget.hintText,
                                        hintStyle: widget.hintStyle,
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      inputFormatters: widget.inputFormatters,
                                      obscureText: widget.obscureText!,
                                      onTap: widget.onTapHandler,
                                      onChanged: (input) {
                                        customTextFormFieldProvider.setErrorText("");
                                        if (widget.onChangeHandler != null) widget.onChangeHandler!(input.trim());
                                        inputString = input;
                                      },
                                      validator: (input) {
                                        if (widget.validatorHandler == null) return null;
                                        var result = widget.validatorHandler!(input!.trim());
                                        if (result != null) {
                                          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                                            customTextFormFieldProvider.setIsValidated(false, result);
                                          });
                                        } else {
                                          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                                            customTextFormFieldProvider.setIsValidated(true, "");
                                          });
                                        }
                                        return result;
                                      },
                                      onSaved: (input) {
                                        if (widget.onSaveHandler == null) return null;
                                        if (widget.onSaveHandler != null) {
                                          widget.onSaveHandler!(input!.trim());
                                        }
                                      },
                                      onEditingComplete: () {
                                        if (widget.isUseKeyboardListener) return;
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        if (widget.onEditingCompleteHandler != null) {
                                          widget.onEditingCompleteHandler!();
                                        }
                                      },
                                      onFieldSubmitted: (input) {
                                        if (widget.isUseKeyboardListener) return;
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        if (widget.onFieldSubmittedHandler != null) {
                                          widget.onFieldSubmittedHandler!(input);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                ((!widget.isSuffixIconOutofField! && widget.suffixIcons!.length != 0) || widget.enableShowPassword!)
                                    ? SizedBox(width: widget.iconSpacing)
                                    : SizedBox(),
                                ((!widget.isSuffixIconOutofField! && widget.suffixIcons!.length != 0) || widget.enableShowPassword!)
                                    ? suffixIcon
                                    : SizedBox()
                              ],
                            ),
                          ),
                          (customTextFormFieldProvider.errorText != "" && widget.errorStringFontSize != 0)
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    customTextFormFieldProvider.errorText,
                                    style: TextStyle(fontSize: widget.errorStringFontSize, color: Colors.red),
                                  ),
                                )
                              : (widget.fixedHeightState!)
                                  ? SizedBox(height: widget.errorStringFontSize! + 8)
                                  : SizedBox(),
                        ],
                      ),
                    ),
                    (widget.isSuffixIconOutofField! && widget.suffixIcons!.length != 0) ? SizedBox(width: widget.iconSpacing) : SizedBox(),
                    (widget.isSuffixIconOutofField! && widget.suffixIcons!.length != 0) ? suffixIcon : SizedBox(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class KeicyTextFormFieldProvider extends ChangeNotifier {
  static KeicyTextFormFieldProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<KeicyTextFormFieldProvider>(context, listen: listen);

  bool _isValidated = false;
  bool get isValidated => _isValidated;

  String _errorText = "";
  String get errorText => _errorText;

  void setErrorText(String errorText) {
    if (_errorText != errorText) {
      _errorText = errorText;
      notifyListeners();
    }
  }

  void setIsValidated(bool isValidated, String errorText) {
    if (_isValidated != isValidated || _errorText != errorText) {
      _isValidated = isValidated;
      _errorText = errorText;
      notifyListeners();
    }
  }
}
