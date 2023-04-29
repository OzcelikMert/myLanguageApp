import 'package:sqflite/sqflite.dart';

class DBTableWords {
  static const tableName = 'words';
  static const columnId = 'wordId';
  static const columnText = 'wordText';
  static const columnComment = 'wordComment';
  static const columnCreatedAt = 'wordCreatedAt';
  static const columnUpdatedAt = 'wordUpdatedAt';
  static const columnStatus = 'wordStatus';

  final Database db;
  DBTableWords(this.db);

  Future onCreate() async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnText TEXT NOT NULL,
        $columnCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT NOT NULL,
        $columnComment TEXT NOT NULL,
        $columnStatus INTEGER NOT NULL,
      )
      ''');
  }

  Future onUpgrade() async {
    await db.execute("DROP TABLE IF EXISTS $tableName");
    await onCreate();
  }
}