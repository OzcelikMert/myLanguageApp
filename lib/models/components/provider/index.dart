import 'package:flutter/material.dart';

class ProviderModel extends ChangeNotifier{
  late int _languageId;
  int get languageId => _languageId;

  set languageId(int value) {
    _languageId = value;
    notifyListeners();
  }

  late String _languageName;
  String get languageName => _languageName;

  set languageName(String value) {
    _languageName = value;
    notifyListeners();
  }
}