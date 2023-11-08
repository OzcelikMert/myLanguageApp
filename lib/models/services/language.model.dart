import 'package:my_language_app/config/db/tables/languages.dart';

class LanguageGetResultModel {
  final int languageId;
  final String languageName;
  final String languageCreatedAt;
  final String languageUpdatedAt;
  final String languageTTSArtist;
  final String languageTTSGender;
  final String languageDailyWordUpdatedAt;
  final String languageWeeklyWordUpdatedAt;
  final String languageMonthlyWordUpdatedAt;
  final String languageDailySentenceUpdatedAt;
  final String languageWeeklySentenceUpdatedAt;
  final String languageMonthlySentenceUpdatedAt;
  final int languageIsSelected;
  final int languageDisplayedLanguage;
  final int languageIsAutoVoice;
  final int languageIsActiveSuccessVoice;

  LanguageGetResultModel({required this.languageId,
    required this.languageName,
    required this.languageCreatedAt,
    required this.languageUpdatedAt,
    required this.languageTTSArtist,
    required this.languageTTSGender,
    required this.languageDailyWordUpdatedAt,
    required this.languageWeeklyWordUpdatedAt,
    required this.languageMonthlyWordUpdatedAt,
    required this.languageDailySentenceUpdatedAt,
    required this.languageWeeklySentenceUpdatedAt,
    required this.languageMonthlySentenceUpdatedAt,
    required this.languageIsSelected,
    required this.languageDisplayedLanguage,
    required this.languageIsAutoVoice,
    required this.languageIsActiveSuccessVoice});

  Map<String, dynamic> toJson() {
    return {
      DBTableLanguages.columnId: languageId,
      DBTableLanguages.columnName: languageName,
      DBTableLanguages.columnCreatedAt: languageCreatedAt,
      DBTableLanguages.columnUpdatedAt: languageUpdatedAt,
      DBTableLanguages.columnTTSArtist: languageTTSArtist,
      DBTableLanguages.columnDailyWordUpdatedAt: languageDailyWordUpdatedAt,
      DBTableLanguages.columnWeeklyWordUpdatedAt: languageWeeklyWordUpdatedAt,
      DBTableLanguages.columnMonthlyWordUpdatedAt: languageMonthlyWordUpdatedAt,
      DBTableLanguages.columnDailySentenceUpdatedAt:
      languageDailySentenceUpdatedAt,
      DBTableLanguages.columnWeeklySentenceUpdatedAt:
      languageWeeklySentenceUpdatedAt,
      DBTableLanguages.columnMonthlySentenceUpdatedAt:
      languageMonthlySentenceUpdatedAt,
      DBTableLanguages.columnIsSelected: languageIsSelected,
      DBTableLanguages.columnDisplayedLanguage: languageDisplayedLanguage,
      DBTableLanguages.columnIsAutoVoice: languageIsAutoVoice,
      DBTableLanguages.columnIsActiveSuccessVoice: languageIsActiveSuccessVoice
    };
  }

  static LanguageGetResultModel fromJson(Map<String, dynamic> json) {
    return LanguageGetResultModel(
        languageId:
        int.tryParse(json[DBTableLanguages.columnId].toString()) ?? 0,
        languageName: json[DBTableLanguages.columnName].toString(),
        languageCreatedAt: json[DBTableLanguages.columnCreatedAt].toString(),
        languageUpdatedAt: json[DBTableLanguages.columnUpdatedAt].toString(),
        languageTTSArtist: json[DBTableLanguages.columnTTSArtist].toString(),
        languageTTSGender: json[DBTableLanguages.columnTTSGender].toString(),
        languageDailyWordUpdatedAt:
        json[DBTableLanguages.columnDailyWordUpdatedAt].toString(),
        languageWeeklyWordUpdatedAt:
        json[DBTableLanguages.columnWeeklyWordUpdatedAt].toString(),
        languageMonthlyWordUpdatedAt:
        json[DBTableLanguages.columnMonthlyWordUpdatedAt].toString(),
        languageDailySentenceUpdatedAt:
        json[DBTableLanguages.columnDailySentenceUpdatedAt].toString(),
        languageWeeklySentenceUpdatedAt:
        json[DBTableLanguages.columnWeeklySentenceUpdatedAt].toString(),
        languageMonthlySentenceUpdatedAt:
        json[DBTableLanguages.columnMonthlySentenceUpdatedAt].toString(),
        languageIsSelected:
        int.tryParse(json[DBTableLanguages.columnIsSelected].toString()) ??
            0,
        languageDisplayedLanguage: int.tryParse(
            json[DBTableLanguages.columnDisplayedLanguage].toString()) ??
            0,
        languageIsAutoVoice:
          int.tryParse(json[DBTableLanguages.columnIsAutoVoice].toString()) ??
            0,
        languageIsActiveSuccessVoice:
          int.tryParse(json[DBTableLanguages.columnIsActiveSuccessVoice].toString()) ??
            0
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
  String languageTTSGender;

  LanguageAddParamModel({required this.languageName,
    required this.languageTTSArtist,
    this.languageTTSGender = "male"});
}

class LanguageUpdateParamModel {
  final int whereLanguageId;
  final String? languageName;
  final String? languageTTSArtist;
  final String? languageTTSGender;
  final String? languageDailyWordUpdatedAt;
  final String? languageWeeklyWordUpdatedAt;
  final String? languageMonthlyWordUpdatedAt;
  final String? languageDailySentenceUpdatedAt;
  final String? languageWeeklySentenceUpdatedAt;
  final String? languageMonthlySentenceUpdatedAt;
  final int? languageIsSelected;
  final int? languageDisplayedLanguage;
  final int? languageIsAutoVoice;
  final int? languageIsActiveSuccessVoice;

  LanguageUpdateParamModel({required this.whereLanguageId,
    this.languageName,
    this.languageTTSArtist,
    this.languageTTSGender,
    this.languageDailyWordUpdatedAt,
    this.languageWeeklyWordUpdatedAt,
    this.languageMonthlyWordUpdatedAt,
    this.languageDailySentenceUpdatedAt,
    this.languageWeeklySentenceUpdatedAt,
    this.languageMonthlySentenceUpdatedAt,
    this.languageIsSelected,
    this.languageDisplayedLanguage,
    this.languageIsAutoVoice,
    this.languageIsActiveSuccessVoice});
}

class LanguageDeleteParamModel {
  final int languageId;

  LanguageDeleteParamModel({required this.languageId});
}
