library keicy_raised_button;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class KeicyRaisedButton extends StatelessWidget {
  KeicyRaisedButton({
    Key? key,
    @required this.child,
    this.width = double.infinity,
    this.height = 50.0,
    this.color = Colors.white,
    this.disabledColor,
    this.textColor = Colors.black,
    this.borderRadius = 0.0,
    this.loading = false,
    this.brightness = Brightness.dark,
    this.progressIndicatorSize,
    this.onPressed,
    this.elevation = 0,
    this.borderWidth = 0,
    this.borderColor,
    this.padding,
    this.gradient,
  }) : super(key: key);
  final Widget? child;
  final Color color;
  final Color? disabledColor;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final bool loading;
  final Brightness brightness;
  double? progressIndicatorSize;
  final VoidCallback? onPressed;
  final double elevation;
  final double borderWidth;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;

  Widget buildSpinner(BuildContext context) {
    if (progressIndicatorSize == null) progressIndicatorSize = height / 2;
    return CupertinoTheme(
      data: CupertinoTheme.of(context).copyWith(brightness: brightness),
      child: SizedBox(
        width: progressIndicatorSize,
        height: progressIndicatorSize,
        child: CupertinoActivityIndicator(
          radius: progressIndicatorSize! / 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(width: borderWidth, color: gradient != null ? Colors.transparent : borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius + 2),
        ),
        gradient: gradient,
      ),
      child: RaisedButton(
        elevation: elevation,
        child: loading ? buildSpinner(context) : child,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        color: gradient == null ? color : Colors.transparent,
        disabledColor: disabledColor ?? color,
        textColor: textColor,
        onPressed: onPressed,
      ),
    );
  }
}
