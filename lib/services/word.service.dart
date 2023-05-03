import 'package:my_language_app/config/db/conn.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/models/services/word.model.dart';

class WordService {
  static Future<List<Map<String, dynamic>>> get(
      WordGetParamModel params) async {
    String whereString = "";
    List<dynamic> whereArgs = [];

    if (params.wordId != null) {
      whereString += "${DBTableWords.columnId} = ? AND ";
      whereArgs.add(params.wordId);
    }

    if (params.wordLanguageId != null) {
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.wordLanguageId);
    }

    if (params.wordStudyType != null) {
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.wordStudyType);
    }

    if (params.wordLanguageId != null) {
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.wordLanguageId);
    }

    var db = await DBConn.instance.database;
    return (await db.query(DBTableWords.tableName,
        where: whereString.isNotEmpty
            ? whereString.substring(0, whereString.length - 4)
            : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null));
  }

  static Future<List<Map<String, dynamic>>> getCountReport(
      WordGetCountReportParamModel params) async {
    String whereString = "";
    List<dynamic> whereArgs = [];

    if (params.wordLanguageId != null) {
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.wordLanguageId);
    }

    var db = await DBConn.instance.database;
    return (await db.query(DBTableWords.tableName,
        columns: [
          DBTableWords.columnStudyType,
          DBTableWords.columnIsStudy,
          "COUNT(*) AS wordCount"
        ],
        where: whereString.isNotEmpty
            ? whereString.substring(0, whereString.length - 4)
            : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
        groupBy: "WordStudyType, WordIsStudy"));
  }

  static Future<int> add(WordAddParamModel params) async {
    var date = DateTime.now().toUtc().toString();

    var db = await DBConn.instance.database;
    return await db.insert(DBTableWords.tableName, {
      DBTableWords.columnLanguageId: params.wordLanguageId,
      DBTableWords.columnTextTarget: params.wordTextTarget,
      DBTableWords.columnTextNative: params.wordTextNative,
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

    if (params.wordTextTarget != null) {
      setString += "${DBTableWords.columnTextTarget} = ?,";
      setArgs.add(params.wordTextTarget);
    }

    if (params.wordTextNative != null) {
      setString += "${DBTableWords.columnTextNative} = ?,";
      setArgs.add(params.wordTextNative);
    }

    if (params.wordComment != null) {
      setString += "${DBTableWords.columnComment} = ?,";
      setArgs.add(params.wordComment);
    }

    if (params.wordStudyType != null) {
      setString += "${DBTableWords.columnStudyType} = ?,";
      setArgs.add(params.wordStudyType);
    }

    if (params.wordIsStudy != null) {
      setString += "${DBTableWords.columnIsStudy} = ?,";
      setArgs.add(params.wordIsStudy);
    }

    var db = await DBConn.instance.database;
    return await db.rawUpdate(
        "UPDATE ${DBTableWords.tableName} SET ${setString.substring(0, setString.length - 1)} WHERE ${DBTableWords.columnId} = ?",
        [...setArgs, params.wordId]);
  }

  static Future<int> delete(WordDeleteParamModel params) async {
    String whereString = "";
    List<dynamic> whereArgs = [];

    if (params.wordId != null) {
      whereString += "${DBTableWords.columnId} = ? AND ";
      whereArgs.add(params.wordId);
    }

    if (params.wordLanguageId != null) {
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.wordLanguageId);
    }

    var db = await DBConn.instance.database;
    return await db.delete(DBTableWords.tableName,
        where: whereString.isNotEmpty
            ? whereString.substring(0, whereString.length - 4)
            : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null);
  }
}
