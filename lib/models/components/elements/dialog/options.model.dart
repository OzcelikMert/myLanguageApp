import 'package:flutter/material.dart';

typedef ComponentDialogOnPressedOkay = Future<bool?> Function(bool isConfirm);

enum ComponentDialogIcon { success, error, confirm, loading, none }

class ComponentDialogOptions {
  final Curve curve;
  final String? title;
  final String? content;
  final ComponentDialogOnPressedOkay? onPressed;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final bool? showCancelButton;
  final ComponentDialogIcon icon;

  ComponentDialogOptions(
      {this.curve = Curves.bounceOut,
      this.showCancelButton,
      this.title,
      this.content,
      this.onPressed,
      this.cancelButtonColor,
      this.cancelButtonText,
      this.confirmButtonColor,
      this.confirmButtonText,
      this.icon = ComponentDialogIcon.none});
}
