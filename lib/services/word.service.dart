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

  static Future<int> getCount(
      WordGetCountParamModel params) async {
    String whereString = "";
    List<dynamic> whereArgs = [];

    if (params.wordLanguageId != null) {
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.wordLanguageId);
    }

    if (params.wordIsStudy != null) {
      whereString += "${DBTableWords.columnIsStudy} = ? AND ";
      whereArgs.add(params.wordIsStudy);
    }

    if (params.wordStudyType != null) {
      whereString += "${DBTableWords.columnStudyType} = ? AND ";
      whereArgs.add(params.wordStudyType);
    }

    var db = await DBConn.instance.database;

    var words = (await db.query(
      DBTableWords.tableName,
      columns: ["COUNT(*) AS ${DBTableWords.asColumnCount}"],
      where: whereString.isNotEmpty
          ? whereString.substring(0, whereString.length - 4)
          : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    ));

    int? count = int.tryParse(words[0][DBTableWords.asColumnCount].toString());

    return count ?? 0;
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
          "COUNT(*) AS ${DBTableWords.asColumnCount}"
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
    Map<String, dynamic> setMap = {
      DBTableWords.columnUpdatedAt: date
    };
    String whereString = "";
    List<dynamic> whereArgs = [];

    if (params.whereWordLanguageId != null) {
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.whereWordLanguageId);
    }

    if (params.whereWordId != null) {
      whereString += "${DBTableWords.columnId} = ? AND ";
      whereArgs.add(params.whereWordId);
    }

    if (params.whereWordStudyType != null) {
      whereString += "${DBTableWords.columnStudyType} = ? AND ";
      whereArgs.add(params.whereWordStudyType);
    }

    if (params.wordTextTarget != null) {
      setMap[DBTableWords.columnTextTarget] = params.wordTextTarget;
    }

    if (params.wordTextNative != null) {
      setMap[DBTableWords.columnTextNative] = params.wordTextNative;
    }

    if (params.wordComment != null) {
      setMap[DBTableWords.columnComment] = params.wordComment;
    }

    if (params.wordStudyType != null) {
      setMap[DBTableWords.columnStudyType] = params.wordStudyType;
    }

    if (params.wordIsStudy != null) {
      setMap[DBTableWords.columnIsStudy] = params.wordIsStudy;
    }

    var db = await DBConn.instance.database;
    return await db.update(
      DBTableWords.tableName,
      setMap,
      where: whereString.isNotEmpty
          ? whereString.substring(0, whereString.length - 4)
          : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );
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
