import 'package:my_language_app/config/db/conn.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/models/services/word.model.dart';

class WordService {
  static Future<List<WordGetResultModel>> get(WordGetParamModel params) async {
    List<WordGetResultModel> returnItems = [];
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
      whereString += "${DBTableWords.columnStudyType} = ? AND ";
      whereArgs.add(params.wordStudyType);
    }

    if (params.wordType != null) {
      whereString += "${DBTableWords.columnType} = ? AND ";
      whereArgs.add(params.wordType);
    }

    if (params.wordIsStudy != null) {
      whereString += "${DBTableWords.columnIsStudy} = ? AND ";
      whereArgs.add(params.wordIsStudy);
    }

    if (params.wordTextTarget != null) {
      whereString += "${DBTableWords.columnTextTarget} LIKE ? AND ";
      whereArgs.add('%${params.wordTextTarget}%');
    }

    if (params.wordTextNative != null) {
      whereString += "${DBTableWords.columnTextNative} LIKE ? AND ";
      whereArgs.add('%${params.wordTextNative}%');
    }

    var db = await DBConn.instance.database;
    var result = (await db.query(DBTableWords.tableName,
        where: whereString.isNotEmpty
            ? whereString.substring(0, whereString.length - 4)
            : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null));

    for (var item in result) {
      returnItems.add(WordGetResultModel.fromJson(item));
    }

    return returnItems;
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

    if (params.wordType != null) {
      whereString += "${DBTableWords.columnType} = ? AND ";
      whereArgs.add(params.wordType);
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

  static Future<List<WordGetCountReportResultModel>> getCountReport(
      WordGetCountReportParamModel params) async {
    List<WordGetCountReportResultModel> returnItems = [];
    String whereString = "";
    List<dynamic> whereArgs = [];

    if (params.wordLanguageId != null) {
      whereString += "${DBTableWords.columnLanguageId} = ? AND ";
      whereArgs.add(params.wordLanguageId);
    }

    if (params.wordStudyType != null) {
      whereString += "${DBTableWords.columnStudyType} = ? AND ";
      whereArgs.add(params.wordStudyType);
    }

    if (params.wordType != null) {
      whereString += "${DBTableWords.columnType} = ? AND ";
      whereArgs.add(params.wordType);
    }

    var db = await DBConn.instance.database;
    var result = (await db.query(DBTableWords.tableName,
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

    for (var item in result) {
      returnItems.add(WordGetCountReportResultModel.fromJson(item));
    }

    return returnItems;
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
      DBTableWords.columnType: params.wordType,
      DBTableWords.columnIsStudy: params.wordIsStudy,
    });
  }

  static Future<int> addMulti(List<WordAddParamModel> paramsList) async {
    var date = DateTime.now().toUtc().toString();

    var db = await DBConn.instance.database;
    final batch = db.batch();

    for(var params in paramsList) {
      batch.insert(DBTableWords.tableName, {
        DBTableWords.columnLanguageId: params.wordLanguageId,
        DBTableWords.columnTextTarget: params.wordTextTarget,
        DBTableWords.columnTextNative: params.wordTextNative,
        DBTableWords.columnComment: params.wordComment,
        DBTableWords.columnCreatedAt: date,
        DBTableWords.columnUpdatedAt: date,
        DBTableWords.columnStudyType: params.wordStudyType,
        DBTableWords.columnType: params.wordType,
        DBTableWords.columnIsStudy: params.wordIsStudy,
      });
    }

    return (await batch.commit()).length;
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

    if (params.whereWordType != null) {
      whereString += "${DBTableWords.columnType} = ? AND ";
      whereArgs.add(params.whereWordType);
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

    if (params.wordType != null) {
      setMap[DBTableWords.columnType] = params.wordType;
    }

    if (params.wordIsStudy != null) {
      setMap[DBTableWords.columnIsStudy] = params.wordIsStudy;
    }

    var db = await DBConn.instance.database;
    var update = await db.update(
      DBTableWords.tableName,
      setMap,
      where: whereString.isNotEmpty
          ? whereString.substring(0, whereString.length - 4)
          : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    return update;
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
