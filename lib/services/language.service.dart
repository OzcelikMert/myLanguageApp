import 'package:flutter/cupertino.dart';
import 'package:my_language_app/config/db/conn.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/models/providers/language.provider.model.dart';
import 'package:my_language_app/models/services/language.model.dart';

class LanguageService {
  static Future<List<LanguageGetResultModel>> get(
      LanguageGetParamModel params) async {
    List<LanguageGetResultModel> returnItems = [];
    String whereString = "";
    List<dynamic> whereArgs = [];

    if (params.languageId != null) {
      whereString += "${DBTableLanguages.columnId} = ? AND ";
      whereArgs.add(params.languageId);
    }

    if (params.languageIsSelected != null) {
      whereString += "${DBTableLanguages.columnIsSelected} = ? AND ";
      whereArgs.add(params.languageIsSelected);
    }

    var db = await DBConn.instance.database;
    var result = (await db.query(DBTableLanguages.tableName,
        where: whereString.isNotEmpty
            ? whereString.substring(0, whereString.length - 4)
            : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null));

    for (var item in result) {
      returnItems.add(LanguageGetResultModel.fromJson(item));
    }

    return returnItems;
  }

  static Future<int> add(LanguageAddParamModel params) async {
    var date = DateTime.now().toUtc().toString();

    var db = await DBConn.instance.database;
    return await db.insert(DBTableLanguages.tableName, {
      DBTableLanguages.columnName: params.languageName,
      DBTableLanguages.columnCreatedAt: date,
      DBTableLanguages.columnUpdatedAt: date,
      DBTableLanguages.columnTTSArtist: params.languageTTSArtist,
      DBTableLanguages.columnTTSGender: params.languageTTSGender,
      DBTableLanguages.columnDailyWordUpdatedAt: date,
      DBTableLanguages.columnWeeklyWordUpdatedAt: date,
      DBTableLanguages.columnMonthlyWordUpdatedAt: date,
      DBTableLanguages.columnDailySentenceUpdatedAt: date,
      DBTableLanguages.columnWeeklySentenceUpdatedAt: date,
      DBTableLanguages.columnMonthlySentenceUpdatedAt: date,
      DBTableLanguages.columnIsSelected: 0,
      DBTableLanguages.columnDisplayedLanguage: 0,
      DBTableLanguages.columnIsAutoVoice: 0,
      DBTableLanguages.columnIsActiveSuccessVoice: 1
    });
  }

  static Future<int> update(
      LanguageUpdateParamModel params, BuildContext? context) async {
    var date = DateTime.now().toUtc().toString();
    Map<String, dynamic> setMap = {DBTableLanguages.columnUpdatedAt: date};
    String whereString = "";
    List<dynamic> whereArgs = [];

    if (params.whereLanguageId != null) {
      whereString += "${DBTableLanguages.columnId} = ? AND ";
      whereArgs.add(params.whereLanguageId);
    }

    if (params.languageName != null) {
      setMap[DBTableLanguages.columnName] = params.languageName;
    }

    if (params.languageTTSArtist != null) {
      setMap[DBTableLanguages.columnTTSArtist] = params.languageTTSArtist;
    }

    if (params.languageTTSGender != null) {
      setMap[DBTableLanguages.columnTTSGender] = params.languageTTSGender;
    }

    if (params.languageDailyWordUpdatedAt != null) {
      setMap[DBTableLanguages.columnDailyWordUpdatedAt] =
          params.languageDailyWordUpdatedAt;
    }

    if (params.languageWeeklyWordUpdatedAt != null) {
      setMap[DBTableLanguages.columnWeeklyWordUpdatedAt] =
          params.languageWeeklyWordUpdatedAt;
    }

    if (params.languageMonthlyWordUpdatedAt != null) {
      setMap[DBTableLanguages.columnMonthlyWordUpdatedAt] =
          params.languageMonthlyWordUpdatedAt;
    }

    if (params.languageDailySentenceUpdatedAt != null) {
      setMap[DBTableLanguages.columnDailySentenceUpdatedAt] =
          params.languageDailySentenceUpdatedAt;
    }

    if (params.languageWeeklySentenceUpdatedAt != null) {
      setMap[DBTableLanguages.columnWeeklySentenceUpdatedAt] =
          params.languageWeeklySentenceUpdatedAt;
    }

    if (params.languageMonthlySentenceUpdatedAt != null) {
      setMap[DBTableLanguages.columnMonthlySentenceUpdatedAt] =
          params.languageMonthlySentenceUpdatedAt;
    }

    if (params.languageIsSelected != null) {
      setMap[DBTableLanguages.columnIsSelected] = params.languageIsSelected;
    }

    if (params.languageDisplayedLanguage != null) {
      setMap[DBTableLanguages.columnDisplayedLanguage] =
          params.languageDisplayedLanguage;
    }

    if (params.languageIsAutoVoice != null) {
      setMap[DBTableLanguages.columnIsAutoVoice] = params.languageIsAutoVoice;
    }

    var db = await DBConn.instance.database;
    var update = await db.update(
      DBTableLanguages.tableName,
      setMap,
      where: whereString.isNotEmpty
          ? whereString.substring(0, whereString.length - 4)
          : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    if (update > 0 && context != null) {
      final languageProviderModel =
          ProviderLib.get<LanguageProviderModel>(context);

      if (languageProviderModel.selectedLanguage != null) {
        languageProviderModel.setSelectedLanguage(LanguageGetResultModel.fromJson({...languageProviderModel.selectedLanguage.toJson(), ...setMap}));
      }
    }

    return update;
  }

  static Future<int> delete(LanguageDeleteParamModel params) async {
    var db = await DBConn.instance.database;
    return await db.delete(DBTableLanguages.tableName,
        where: "${DBTableLanguages.columnId} = ?",
        whereArgs: [params.languageId]);
  }
}
