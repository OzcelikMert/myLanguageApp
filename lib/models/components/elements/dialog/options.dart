import 'package:flutter/material.dart';

typedef ComponentDialogOnPressedOkay = bool Function(bool isConfirm);

enum ComponentDialogIcon { success, error, confirm, loading }

class ComponentDialogOptions {
  final String? title;
  final String? subtitle;
  final ComponentDialogOnPressedOkay? onPress;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final bool? showCancelButton;
  final EdgeInsets? titlePadding;
  final EdgeInsets? subtitlePadding;
  final TextAlign? titleTextAlign;
  final TextStyle? titleStyle;
  final TextAlign? subtitleTextAlign;
  final TextStyle? subtitleStyle;
  final ComponentDialogIcon? icon;

  ComponentDialogOptions(
      {this.showCancelButton: false,
        this.title,
        this.subtitle,
        this.onPress,
        this.cancelButtonColor,
        this.cancelButtonText,
        this.confirmButtonColor,
        this.confirmButtonText,
        this.titlePadding,
        this.subtitlePadding,
        this.titleTextAlign,
        this.titleStyle,
        this.subtitleTextAlign,
        this.subtitleStyle,
        this.icon});
}