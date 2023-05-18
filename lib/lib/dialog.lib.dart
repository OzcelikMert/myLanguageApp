import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/alert/index.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/models/components/elements/dialog/options.model.dart';

abstract class DialogLib {
  static ComponentDialogState? dialogState = null;

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<void> show(BuildContext context, ComponentDialogOptions options) async {
    Completer<void> completer = Completer<void>();

    if (dialogState != null) {
        dialogState?.update(options);
        completer.complete();
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
                    body: ComponentDialog(options: options, onBuild: () { completer.complete(); }),
                  ),
                ),
              );
            });
      }
    return completer.future;
  }
}
