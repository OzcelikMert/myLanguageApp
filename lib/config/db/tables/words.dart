import 'package:sqflite/sqflite.dart';

class DBTableWords {
  static const tableName = 'words';
  static const columnId = 'wordId';
  static const columnLanguageId = 'wordLanguageId';
  static const columnTextTarget = 'wordTextTarget';
  static const columnTextNative = 'wordTextNative';
  static const columnType = 'wordType';
  static const columnComment = 'wordComment';
  static const columnCreatedAt = 'wordCreatedAt';
  static const columnUpdatedAt = 'wordUpdatedAt';
  static const columnStudyType = 'wordStudyType';
  static const columnIsStudy = 'wordIsStudy';

  static const asColumnCount = 'wordCount';

  final Database db;
  DBTableWords(this.db);

  Future onCreate() async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnLanguageId INTEGER NOT NULL,
        $columnTextTarget TEXT NOT NULL,
        $columnTextNative TEXT NOT NULL,
        $columnCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT NOT NULL,
        $columnComment TEXT NOT NULL,
        $columnType INTEGER NOT NULL,
        $columnStudyType INTEGER NOT NULL,
        $columnIsStudy INTEGER NOT NULL
      )
      ''');
  }

  Future onUpgrade() async {
    /*await db.execute("DROP TABLE IF EXISTS $tableName");
    await onCreate();*/
  }
}