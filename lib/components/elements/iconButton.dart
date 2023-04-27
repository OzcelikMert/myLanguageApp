import 'package:flutter/material.dart';

class ComponentIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final ButtonStyle? style;

  const ComponentIconButton({Key? key, required this.onPressed, required this.icon, this.style, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      style: ElevatedButton.styleFrom().merge(style),
    );
  }
}