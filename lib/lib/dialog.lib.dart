import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/alert/index.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';

abstract class DialogLib {
  static Color success = Color(0xffAEDEF4);
  static Color danger = Color(0xffDD6B55);
  static Color cancel = Color(0xffD0D0D0);

  static String successText = "OK";
  static String confirmText = "Confirm";
  static String cancelText = "Cancel";

  static Curve showCurve = Curves.bounceOut;

  static ComponentDialogState? state;

  static void show(BuildContext context,
      {Curve? curve,
      String? title,
      String? subtitle,
      bool showCancelButton: false,
      ComponentDialogOnPressedOkay? onPress,
      Color? cancelButtonColor,
      Color? confirmButtonColor,
      String? cancelButtonText,
      String? confirmButtonText,
      EdgeInsets? titlePadding,
      EdgeInsets? subtitlePadding,
      TextAlign? titleTextAlign,
      TextStyle? titleStyle,
      TextAlign? subtitleTextAlign,
      TextStyle? subtitleStyle,
      ComponentDialogStyle? style}) {
    ComponentDialogOptions options = ComponentDialogOptions(
        showCancelButton: showCancelButton,
        title: title,
        subtitle: subtitle,
        style: style,
        onPress: onPress,
        confirmButtonColor: confirmButtonColor,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        cancelButtonColor: cancelButtonColor,
        titlePadding: titlePadding,
        subtitlePadding: subtitlePadding,
        titleTextAlign: titleTextAlign,
        titleStyle: titleStyle,
        subtitleTextAlign: subtitleTextAlign,
        subtitleStyle: subtitleStyle);
    if (state != null) {
      state?.update(options);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: ComponentDialog(curve: curve, options: options),
                ),
              ),
            );
          });
    }
  }
}
