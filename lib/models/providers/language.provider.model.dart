import 'package:flutter/material.dart';
import 'package:mylanguageapp/models/services/language.model.dart';

class LanguageProviderModel extends ChangeNotifier {
  LanguageGetResultModel? _selectedLanguage = null;

  LanguageGetResultModel get selectedLanguage => _selectedLanguage!;

  void setSelectedLanguage(LanguageGetResultModel selectedLanguage) {
    _selectedLanguage = selectedLanguage;
    notifyListeners();
  }
}