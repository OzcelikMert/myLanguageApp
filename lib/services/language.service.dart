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
    Map<String, dynamic> setMap = {
      DBTableLanguages.columnUpdatedAt: date
    };
    String whereString = "";
    List<dynamic> whereArgs = [];

    if (params.whereLanguageId != null) {
      whereString += "${DBTableLanguages.columnId} = ? AND ";
      whereArgs.add(params.whereLanguageId);
    }

    if(params.languageName != null){
      setMap[DBTableLanguages.columnName] = params.languageName;
    }

    if(params.languageTTSArtist != null){
      setMap[DBTableLanguages.columnTTSArtist] = params.languageTTSArtist;
    }

    if(params.languageTTSGender != null){
      setMap[DBTableLanguages.columnTTSGender] = params.languageTTSGender;
    }

    if(params.languageDailyUpdatedAt != null){
      setMap[DBTableLanguages.columnDailyUpdatedAt] = params.languageDailyUpdatedAt;
    }

    if(params.languageWeeklyUpdatedAt != null){
      setMap[DBTableLanguages.columnWeeklyUpdatedAt] = params.languageWeeklyUpdatedAt;
    }

    if(params.languageMonthlyUpdatedAt != null){
      setMap[DBTableLanguages.columnMonthlyUpdatedAt] = params.languageMonthlyUpdatedAt;
    }

    if(params.languageIsSelected != null){
      setMap[DBTableLanguages.columnIsSelected] = params.languageIsSelected;
    }

    var db = await DBConn.instance.database;
    return await db.update(
      DBTableLanguages.tableName,
      setMap,
      where: whereString.isNotEmpty
          ? whereString.substring(0, whereString.length - 4)
          : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );
  }

  static Future<int> delete(LanguageDeleteParamModel params) async {
    var db = await DBConn.instance.database;
    return await db.delete(DBTableLanguages.tableName, where: "${DBTableLanguages.columnId} = ?", whereArgs: [params.languageId]);
  }
}