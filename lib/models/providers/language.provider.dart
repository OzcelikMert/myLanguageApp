import 'package:flutter/material.dart';
import 'package:my_language_app/models/services/language.model.dart';

class LanguageProviderModel extends ChangeNotifier {
  LanguageGetResultModel? _selectedLanguage;

  LanguageGetResultModel get selectedLanguage => _selectedLanguage!;

  void setSelectedLanguage(LanguageGetResultModel selectedLanguage) {
    _selectedLanguage = selectedLanguage;
    notifyListeners();
  }
}