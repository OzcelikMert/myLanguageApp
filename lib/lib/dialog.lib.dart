import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/alert/index.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';

abstract class DialogLib {
  static ComponentDialogState? state;

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }

  static void show(BuildContext context, ComponentDialogOptions options) {
    if (state != null) {
      state?.update(options);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(ThemeConst.paddings.xlg),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: ComponentDialog(options: options),
                ),
              ),
            );
          });
    }
  }
}
