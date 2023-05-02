import 'package:my_language_app/config/db/conn.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/models/services/word.model.dart';

class WordService {
  static Future<List<Map<String, dynamic>>> get(WordGetParamModel params) async {
    String whereString = "";
    List<dynamic> whereArgs= [];

    if(params.wordId != null){
      whereString += "${DBTableWords.columnId} = ? AND ";
      whereArgs.add(params.wordId);
    }

    if(params.wordLanguageId != null){
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.wordLanguageId);
    }

    if(params.wordStudyType != null){
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.wordStudyType);
    }

    if(params.wordLanguageId != null){
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.wordLanguageId);
    }


    var db = await DBConn.instance.database;
    return (await db.query(DBTableWords.tableName,
        where: whereString.isNotEmpty ? whereString.substring(0, whereString.length - 4) : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null
    ));
  }

  static Future<int> add(WordAddParamModel params) async {
    var date = DateTime.now().toUtc().toString();

    var db = await DBConn.instance.database;
    return await db.insert(DBTableWords.tableName, {
      DBTableWords.columnLanguageId: params.wordLanguageId,
      DBTableWords.columnText: params.wordText,
      DBTableWords.columnComment: params.wordComment,
      DBTableWords.columnCreatedAt: date,
      DBTableWords.columnUpdatedAt: date,
      DBTableWords.columnStudyType: params.wordStudyType,
      DBTableWords.columnIsStudy: 0,
    });
  }

  static Future<int> update(WordUpdateParamModel params) async {
    var date = DateTime.now().toUtc().toString();
    String setString = "${DBTableWords.columnUpdatedAt} = ?,";
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