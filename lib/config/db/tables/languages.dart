import 'package:sqflite/sqflite.dart';

class DBTableLanguages {
  static const tableName = 'languages';
  static const columnId = 'languageId';
  static const columnName = 'languageName';
  static const columnCreatedAt = 'languageCreatedAt';
  static const columnUpdatedAt = 'languageUpdatedAt';
  static const columnTTSArtist = 'languageTTSArtist';
  static const columnTTSGender = 'languageTTSArtistGender';
  static const columnDailyUpdatedAt = 'languageDailyUpdatedAt';
  static const columnWeeklyUpdatedAt = 'languageWeeklyUpdatedAt';
  static const columnMonthlyUpdatedAt = 'languageMonthlyUpdatedAt';

  final Database db;
  DBTableLanguages(this.db);

  Future onCreate() async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT NOT NULL,
        $columnTTSArtist TEXT NOT NULL,
        $columnTTSGender TEXT NOT NULL,
        $columnDailyUpdatedAt TEXT NOT NULL,
        $columnWeeklyUpdatedAt TEXT NOT NULL,
        $columnMonthlyUpdatedAt TEXT NOT NULL
      )
      ''');
  }

  Future onUpgrade() async {
    await db.execute("DROP TABLE IF EXISTS $tableName");
    await onCreate();
  }
}