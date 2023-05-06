int _languageId = 0;
String _languageName = "";

class Values {
  static get getLanguageId { return _languageId; }
  static set setLanguageId(int languageId) { _languageId = languageId; }

  static get getLanguageName { return _languageName; }
  static set setLanguageName(String languageName) { _languageName = languageName; }
}