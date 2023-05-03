import 'package:my_language_app/config/db/conn.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/models/services/language.model.dart';

class LanguageService {
  static Future<List<Map<String, dynamic>>> get(LanguageGetParamModel params) async {
    String whereString = "";
    List<dynamic> whereArgs= [];

    if(params.languageId != null){
      whereString += "${DBTableLanguages.columnId} = ? AND ";
      whereArgs.add(params.languageId);
    }

    if(params.languageIsSelected != null){
      whereString += "${DBTableLanguages.columnIsSelected} = ? AND ";
      whereArgs.add(params.languageIsSelected);
    }

    var db = await DBConn.instance.database;
    return (await db.query(DBTableLanguages.tableName,
        where: whereString.isNotEmpty ? whereString.substring(0, whereString.length - 4) : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null
    ));
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
      DBTableLanguages.columnDailyUpdatedAt: date,
      DBTableLanguages.columnWeeklyUpdatedAt: date,
      DBTableLanguages.columnMonthlyUpdatedAt: date,
      DBTableLanguages.columnIsSelected: 0
    });
  }

  static Future<int> update(LanguageUpdateParamModel params) async {
    var date = DateTime.now().toUtc().toString();
    String setString = "${DBTableLanguages.columnUpdatedAt} = ?,";
    List<dynamic> setArgs = [date];

    if(params.languageName != null){
      setString += "${DBTableLanguages.columnName} = ?,";
      setArgs.add(params.languageName);
    }

    if(params.languageTTSArtist != null){
      setString += "${DBTableLanguages.columnTTSArtist} = ?,";
      setArgs.add(params.languageTTSArtist);
    }

    if(params.languageTTSGender != null){
      setString += "${DBTableLanguages.columnTTSGender} = ?,";
      setArgs.add(params.languageTTSGender);
    }

    if(params.languageDailyUpdatedAt != null){
      setString += "${DBTableLanguages.columnDailyUpdatedAt} = ?,";
      setArgs.add(params.languageDailyUpdatedAt);
    }

    if(params.languageWeeklyUpdatedAt != null){
      setString += "${DBTableLanguages.columnWeeklyUpdatedAt} = ?,";
      setArgs.add(params.languageWeeklyUpdatedAt);
    }

    if(params.languageMonthlyUpdatedAt != null){
      setString += "${DBTableLanguages.columnMonthlyUpdatedAt} = ?,";
      setArgs.add(params.languageMonthlyUpdatedAt);
    }

    if(params.languageIsSelected != null){
      setString += "${DBTableLanguages.columnIsSelected} = ?,";
      setArgs.add(params.languageIsSelected);
    }

    var db = await DBConn.instance.database;
    return await db.rawUpdate("UPDATE ${DBTableLanguages.tableName} SET ${setString.substring(0, setString.length - 1)} WHERE ${DBTableLanguages.columnId} = ?",  [...setArgs, params.languageId]);
  }

  static Future<int> delete(LanguageDeleteParamModel params) async {
    var db = await DBConn.instance.database;
    return await db.delete(DBTableLanguages.tableName, where: "${DBTableLanguages.columnId} = ?", whereArgs: [params.languageId]);
  }
}