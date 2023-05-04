import 'package:flutter/material.dart';

class ThemeConst {
  static _ThemeColorConst colors = _ThemeColorConst();
  static _ThemePaddingConst paddings = _ThemePaddingConst();
  static _ThemeFontSizeConst fontSizes = _ThemeFontSizeConst();
}

class _ThemeColorConst {
  Color dark = Colors.black.withBlue(28).withGreen(28).withRed(28);
  Color gray = Colors.black.withBlue(74).withGreen(74).withRed(74);
  Color light = Colors.white.withRed(220).withGreen(220).withBlue(220);
  Color primary = Colors.deepPurpleAccent;
  Color secondary = Colors.blue.shade800;
  Color success = Colors.green.shade800;
  Color danger = Colors.pink.shade800;
  Color warning = Colors.orange.withRed(224).withGreen(112).withBlue(14);
  Color info = Colors.teal.shade800;
}

class _ThemePaddingConst {
  double xlg = 40;
  double lg = 30;
  double md = 20;
  double sm = 10;
  double xsm = 5;
}

class _ThemeFontSizeConst {
  double xlg = 35;
  double lg = 25;
  double md = 15;
  double sm = 10;
  double xsm = 6;
}