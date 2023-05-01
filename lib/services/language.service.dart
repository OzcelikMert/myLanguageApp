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
    var db = await DBConn.instance.database;
    return await db.insert(DBTableLanguages.tableName, params.toJson());
  }

  static Future<List<Object?>> addMulti(List<LanguageAddParamModel> listParams) async {
    var db = await DBConn.instance.database;
    final Batch batch = db.batch();
    for (var params in listParams) {
      batch.insert(DBTableLanguages.tableName, params.toJson());
    }
    return await batch.commit();
  }

  static Future<int> update(LanguageAddParamModel params) async {
    var db = await DBConn.instance.database;
    return await db.update(DBTableLanguages.tableName, params.toJson());
  }

  static Future<int> delete(LanguageDeleteParamModel params) async {
    var db = await DBConn.instance.database;
    return await db.delete(DBTableLanguages.tableName, where: "${DBTableLanguages.columnId} = ?}", whereArgs: [params]);
  }
}