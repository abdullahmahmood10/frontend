import 'package:flutter/material.dart';
import 'package:mmm_s_application3/core/app_export.dart';
import 'package:mmm_s_application3/widgets/base_button.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.backgroundColor = const Color.fromRGBO(33, 150, 243, 1), // Add backgroundColor parameter
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    double? height,
    double? width,
    required String text,
  }) : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          height: height,
          width: width,
          alignment: alignment,
          margin: margin,
        );

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Color backgroundColor; // Define backgroundColor parameter

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget,
          )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: this.height ?? 55.v,
        width: this.width ?? double.maxFinite,
        margin: margin,
        decoration: decoration?.copyWith(color: backgroundColor), // Set background color
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor), // Set button background color
          ),
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Text(
                text,
                style: buttonTextStyle ??
                    theme.textTheme.titleMedium?.copyWith(color: Colors.white) ?? // Change text color to white
                    TextStyle(color: Colors.white), // Fallback if theme.textTheme.titleMedium is null
              ),
              rightIcon ?? const SizedBox.shrink(),
            ],
          ),
        ),
      );
}
