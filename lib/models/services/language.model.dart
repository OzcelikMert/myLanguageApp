class LanguageGetParamModel {
  final int? languageId;
  final int? languageIsSelected;

  LanguageGetParamModel({
    this.languageId,
    this.languageIsSelected
  });
}

class LanguageAddParamModel {
  final String languageName;
  final String languageTTSArtist;
  final String languageTTSGender;

  LanguageAddParamModel({
    required this.languageName,
    required this.languageTTSArtist,
    required this.languageTTSGender
  });
}

class LanguageUpdateParamModel {
  final int whereLanguageId;
  final String? languageName;
  final String? languageTTSArtist;
  final String? languageTTSGender;
  final String? languageDailyUpdatedAt;
  final String? languageWeeklyUpdatedAt;
  final String? languageMonthlyUpdatedAt;
  final int? languageIsSelected;
  final int? languageDisplayedLanguage;

  LanguageUpdateParamModel({
    required this.whereLanguageId,
    this.languageName,
    this.languageTTSArtist,
    this.languageTTSGender,
    this.languageDailyUpdatedAt,
    this.languageWeeklyUpdatedAt,
    this.languageMonthlyUpdatedAt,
    this.languageIsSelected,
    this.languageDisplayedLanguage
  });
}

class LanguageDeleteParamModel {
  final int languageId;

  LanguageDeleteParamModel({
    required this.languageId
  });
}