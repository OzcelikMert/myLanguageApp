import 'package:flutter/material.dart';

enum ComponentButtonSize {
  sm,
  md,
  lg
}

class ComponentButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? bgColor;
  final ButtonStyle? style;
  final bool? reverseIconAlign;
  final ComponentButtonSize? buttonSize;

  const ComponentButton({Key? key, required this.text, required this.onPressed, this.icon, this.bgColor, this.style, this.reverseIconAlign, this.buttonSize}) : super(key: key);

  double _getIconTextPadding() {
    double value = 10;
    if(buttonSize != null){
      switch(buttonSize) {
        case ComponentButtonSize.lg: value = 15; break;
        case ComponentButtonSize.sm: value = 5; break;
      }
    }
    return value;
  }

  double _getStyleVerticalPadding() {
    double value = 25;
    if(buttonSize != null){
      switch(buttonSize) {
        case ComponentButtonSize.lg: value = 35; break;
        case ComponentButtonSize.sm: value = 15; break;
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: icon != null ? Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          reverseIconAlign == true ? Text(text) : Icon(icon),
          Padding(padding: EdgeInsets.all(_getIconTextPadding())),
          reverseIconAlign == true ? Icon(icon) : Text(text),
        ],
      ) : Text(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: _getStyleVerticalPadding(), horizontal: 25),
        minimumSize: Size(double.infinity, 0),
        primary: bgColor ?? Colors.deepPurpleAccent, // change button color here
        onPrimary: Colors.white, // change text color here
      ).merge(style),
    );
  }
}