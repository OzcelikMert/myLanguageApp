import 'package:flutter/material.dart';

class KeyboardProviderModel extends ChangeNotifier {
  double _height = 0.0;

  double get height => _height!;

  void setHeight(double height) {
    _height = height;
    notifyListeners();
  }
}