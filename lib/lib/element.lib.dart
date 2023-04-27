import 'package:flutter/material.dart';

class ElementLib {
  final BuildContext context;

  ElementLib(this.context);

  Future<void> showMessageBox({
    required String title,
    required String content,
    void Function()? onPressedNo,
    void Function()? onPressedOkay
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No!'),
              onPressed: onPressedNo ?? () { Navigator.of(context).pop(); },
            ),
            TextButton(
              child: Text('Okay'),
              onPressed: onPressedOkay ?? () { Navigator.of(context).pop(); },
            ),
          ],
        );
      },
    );
  }
}