import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:sqflite/sqflite.dart';

class LanguageService {
  Future<List<LanguageResultModel>> get(Database db) async {
    return (await db.query(DBTableLanguages.tableName)) as List<LanguageResultModel>;
  }

  Future<int> add(Database db, LanguageAddParamModel params) async {
    return await db.insert(DBTableLanguages.tableName, params.toJson());
  }

  Future<List<Object?>> addMulti(Database db, List<LanguageAddParamModel> listParams) async {
    final Batch batch = db.batch();
    for (var params in listParams) {
      batch.insert(DBTableLanguages.tableName, params.toJson());
    }
    return await batch.commit();
  }
}