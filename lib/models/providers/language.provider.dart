import 'package:flutter/material.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/services/language.service.dart';

class LanguageProviderModel extends ChangeNotifier {
  Map<String, dynamic>? _selectedLanguage;

  Map<String, dynamic> get selectedLanguage => _selectedLanguage!;

  void setSelectedLanguage(Map<String, dynamic> selectedLanguage) {
    _selectedLanguage = selectedLanguage;
    notifyListeners();
  }

  Future<bool> initSelectedLanguage() async {
    var languages = await LanguageService.get(LanguageGetParamModel(languageIsSelected: 1));
    if(languages.isNotEmpty){
      setSelectedLanguage(languages[0]);
      return true;
    }else {
      return false;
    }
  }
}