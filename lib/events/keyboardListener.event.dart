import 'package:flutter/material.dart';

class KeyboardListenerEvent extends WidgetsBindingObserver {
  final BuildContext context;
  final Function(double height)? onDisplayToggle;

  KeyboardListenerEvent(this.context, {this.onDisplayToggle = null});

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if(onDisplayToggle != null){
        onDisplayToggle!(keyboardHeight);
      }
    });
  }
}