import 'package:my_language_app/config/db/conn.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:sqflite/sqflite.dart';

class LanguageService {
  static Future<List<Map<String, dynamic>>> get() async {
    var db = await DBConn.instance.database;
    return (await db.query(DBTableLanguages.tableName));
  }

  static Future<int> add(LanguageAddParamModel params) async {
    var date = DateTime.now().toUtc().toString();

    var db = await DBConn.instance.database;
    return await db.insert(DBTableLanguages.tableName, {
      'languageName': params.languageName,
      'languageCreatedAt': date,
      'languageUpdatedAt': date,
      'languageTTSArtist': "",
      'languageTTSArtistGender': "",
      'languageDailyUpdatedAt': date,
      'languageWeeklyUpdatedAt': date,
      'languageMonthlyUpdatedAt': date
    });
  }

  static Future<int> update(LanguageUpdateParamModel params) async {
    String set = "";
    List<dynamic> setArgs= [];

    if(params.languageName != null){
      set += "${DBTableLanguages.columnName} = ?,";
      setArgs.add(params.languageName);
    }

    if(params.languageTTSArtist != null){
      set += "${DBTableLanguages.columnTTSArtist} = ?,";
      setArgs.add(params.languageTTSArtist);
    }

    if(params.languageTTSGender != null){
      set += "${DBTableLanguages.columnTTSGender} = ?,";
      setArgs.add(params.languageTTSGender);
    }

    if(params.languageDailyUpdatedAt != null){
      set += "${DBTableLanguages.columnDailyUpdatedAt} = ?,";
      setArgs.add(params.languageDailyUpdatedAt);
    }

    if(params.languageWeeklyUpdatedAt != null){
      set += "${DBTableLanguages.columnWeeklyUpdatedAt} = ?,";
      setArgs.add(params.languageWeeklyUpdatedAt);
    }

    if(params.languageMonthlyUpdatedAt != null){
      set += "${DBTableLanguages.columnMonthlyUpdatedAt} = ?,";
      setArgs.add(params.languageMonthlyUpdatedAt);
    }

    set = set.substring(0, -1);

    var db = await DBConn.instance.database;
    return await db.rawUpdate("UPDATE ${DBTableLanguages.tableName} SET ${set} WHERE ${DBTableLanguages.columnId} = ?",  [...setArgs, params.languageId]);
  }

  static Future<int> delete(LanguageDeleteParamModel params) async {
    var db = await DBConn.instance.database;
    return await db.delete(DBTableLanguages.tableName, where: "${DBTableLanguages.columnId} = ?", whereArgs: [params.languageId]);
  }
}