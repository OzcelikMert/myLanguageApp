class LanguageResultModel {
  final int languageId;
  final String languageName;
  final String languageCreatedAt;
  final String languageUpdatedAt;
  final String languageTTSArtist;
  final String languageTTSArtistGender;
  final String languageDailyUpdatedAt;
  final String languageWeeklyUpdatedAt;
  final String languageMonthlyUpdatedAt;

  LanguageResultModel({
    required this.languageId,
    required this.languageName,
    required this.languageCreatedAt,
    required this.languageUpdatedAt,
    required this.languageTTSArtist,
    required this.languageTTSArtistGender,
    required this.languageDailyUpdatedAt,
    required this.languageWeeklyUpdatedAt,
    required this.languageMonthlyUpdatedAt
  });
}

class LanguageAddParamModel {
  final String languageName;
  final String languageTTSArtist;
  final String languageTTSArtistGender;

  LanguageAddParamModel({
    required this.languageName,
    required this.languageTTSArtist,
    required this.languageTTSArtistGender,
  });

  Map<String, dynamic> toJson() => {
    'languageName': languageName,
    'languageTTSArtist': languageTTSArtist,
    'languageTTSArtistGender': languageTTSArtistGender,
  };
}

class LanguageUpdateParamModel {
  final int languageId;
  final String? languageName;
  final String? languageTTSArtist;
  final String? languageTTSArtistGender;
  final String? languageDailyUpdatedAt;
  final String? languageWeeklyUpdatedAt;
  final String? languageMonthlyUpdatedAt;

  LanguageUpdateParamModel({
    required this.languageId,
    this.languageName,
    this.languageTTSArtist,
    this.languageTTSArtistGender,
    this.languageDailyUpdatedAt,
    this.languageWeeklyUpdatedAt,
    this.languageMonthlyUpdatedAt
  });

  Map<String, dynamic> toJson() => {
    'languageId': languageId,
    'languageName': languageName,
    'languageTTSArtist': languageTTSArtist,
    'languageTTSArtistGender': languageTTSArtistGender,
    'languageDailyUpdatedAt': languageDailyUpdatedAt,
    'languageWeeklyUpdatedAt': languageWeeklyUpdatedAt,
    'languageMonthlyUpdatedAt': languageMonthlyUpdatedAt,
  };
}

class LanguageDeleteParamModel {
  final int languageId;

  LanguageDeleteParamModel({
    required this.languageId
  });

  Map<String, dynamic> toJson() => {
    'languageId': languageId
  };
}