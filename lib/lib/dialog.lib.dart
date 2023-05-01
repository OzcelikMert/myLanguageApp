import 'package:flutter/material.dart';

class DialogLib {
  final BuildContext context;

  DialogLib(this.context);

  Future<void> hide() async {
    Navigator.of(context).pop();
  }

  Future<void> showMessage({
    required String title,
    required String content,
    void Function()? onPressedNo,
    void Function()? onPressedOkay
  }) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.question_mark, size: 35),
          iconColor: Colors.blue,
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
              onPressed: () { Navigator.of(context).pop(); if(onPressedNo != null) onPressedNo(); },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () { Navigator.of(context).pop(); if(onPressedOkay != null) onPressedOkay(); },
            ),
          ],
        );
      },
    );
  }

  Future<void> showLoader({
    String text = "Loading...",
  }) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Padding(padding: EdgeInsets.all(20)),
                Text(text),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showSuccess({
    String title = "Success",
    required String content,
  }) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.check, size: 35),
          iconColor: Colors.green,
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
              child: Text('Okay'),
              onPressed: () { Navigator.of(context).pop(); },
            ),
          ],
        );
      },
    );
  }

  Future<void> showError({
    String title = "Error",
    required String content,
  }) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.error_outline, size: 35),
          iconColor: Colors.red,
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
              child: Text('Okay'),
              onPressed: () { Navigator.of(context).pop(); },
            ),
          ],
        );
      },
    );
  }
}