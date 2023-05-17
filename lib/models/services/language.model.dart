import 'package:my_language_app/config/db/tables/languages.dart';

class LanguageGetResultModel {
  final int languageId;
  final String languageName;
  final String languageCreatedAt;
  final String languageUpdatedAt;
  final String languageTTSArtist;
  final String languageTTSGender;
  final String languageDailyUpdatedAt;
  final String languageWeeklyUpdatedAt;
  final String languageMonthlyUpdatedAt;
  final int languageIsSelected;
  final int languageDisplayedLanguage;
  final int languageIsAutoVoice;

  LanguageGetResultModel({
    required this.languageId,
    required this.languageName,
    required this.languageCreatedAt,
    required this.languageUpdatedAt,
    required this.languageTTSArtist,
    required this.languageTTSGender,
    required this.languageDailyUpdatedAt,
    required this.languageWeeklyUpdatedAt,
    required this.languageMonthlyUpdatedAt,
    required this.languageIsSelected,
    required this.languageDisplayedLanguage,
    required this.languageIsAutoVoice});

  Map<String, dynamic> toJson() {
    return {
      DBTableLanguages.columnId: languageId,
      DBTableLanguages.columnName: languageName,
      DBTableLanguages.columnCreatedAt: languageCreatedAt,
      DBTableLanguages.columnUpdatedAt: languageUpdatedAt,
      DBTableLanguages.columnTTSArtist: languageTTSArtist,
      DBTableLanguages.columnDailyUpdatedAt: languageDailyUpdatedAt,
      DBTableLanguages.columnWeeklyUpdatedAt: languageWeeklyUpdatedAt,
      DBTableLanguages.columnMonthlyUpdatedAt: languageMonthlyUpdatedAt,
      DBTableLanguages.columnIsSelected: languageIsSelected,
      DBTableLanguages.columnDisplayedLanguage: languageDisplayedLanguage,
      DBTableLanguages.columnIsAutoVoice: languageIsAutoVoice,
    };
  }

  static LanguageGetResultModel fromJson(Map<String, dynamic> json) {
    return LanguageGetResultModel(
        languageId: int.tryParse(json[DBTableLanguages.columnId].toString()) ?? 0,
        languageName: json[DBTableLanguages.columnName].toString(),
        languageCreatedAt: json[DBTableLanguages.columnCreatedAt].toString(),
        languageUpdatedAt: json[DBTableLanguages.columnUpdatedAt].toString(),
        languageTTSArtist: json[DBTableLanguages.columnTTSArtist].toString(),
        languageTTSGender: json[DBTableLanguages.columnTTSGender].toString(),
        languageDailyUpdatedAt: json[DBTableLanguages.columnDailyUpdatedAt].toString(),
        languageWeeklyUpdatedAt: json[DBTableLanguages.columnWeeklyUpdatedAt].toString(),
        languageMonthlyUpdatedAt: json[DBTableLanguages.columnMonthlyUpdatedAt].toString(),
        languageIsSelected: int.tryParse(json[DBTableLanguages.columnIsSelected].toString()) ?? 0,
        languageDisplayedLanguage: int.tryParse(json[DBTableLanguages.columnDisplayedLanguage].toString()) ?? 0,
        languageIsAutoVoice: int.tryParse(json[DBTableLanguages.columnIsAutoVoice].toString()) ?? 0
    );
  }
}

class LanguageGetParamModel {
  final int? languageId;
  final int? languageIsSelected;

  LanguageGetParamModel({this.languageId, this.languageIsSelected});
}

class LanguageAddParamModel {
  final String languageName;
  final String languageTTSArtist;
  final String languageTTSGender;

  LanguageAddParamModel(
      {required this.languageName,
      required this.languageTTSArtist,
      required this.languageTTSGender});
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
  final int? languageIsAutoVoice;

  LanguageUpdateParamModel(
      {required this.whereLanguageId,
      this.languageName,
      this.languageTTSArtist,
      this.languageTTSGender,
      this.languageDailyUpdatedAt,
      this.languageWeeklyUpdatedAt,
      this.languageMonthlyUpdatedAt,
      this.languageIsSelected,
      this.languageDisplayedLanguage,
      this.languageIsAutoVoice});
}

class LanguageDeleteParamModel {
  final int languageId;

  LanguageDeleteParamModel({required this.languageId});
}
