import 'package:flutter/material.dart';

class ComponentButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? bgColor;
  final ButtonStyle? style;
  final bool? reverseIconAlign;

  const ComponentButton({Key? key, required this.text, required this.onPressed, this.icon, this.bgColor, this.style, this.reverseIconAlign}) : super(key: key);

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
          const SizedBox(width: 10),
          reverseIconAlign == true ? Icon(icon) : Text(text),
        ],
      ) : Text(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 25),
        minimumSize: Size(double.infinity, 0),
        primary: bgColor ?? Colors.deepPurpleAccent, // change button color here
        onPrimary: Colors.white, // change text color here
      ).merge(style),
    );
  }
}