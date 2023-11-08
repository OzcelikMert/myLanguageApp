import 'package:sqflite/sqflite.dart';

class DBTableLanguages {
  static const tableName = 'languages';
  static const columnId = 'languageId';
  static const columnName = 'languageName';
  static const columnCreatedAt = 'languageCreatedAt';
  static const columnUpdatedAt = 'languageUpdatedAt';
  static const columnTTSArtist = 'languageTTSArtist';
  static const columnTTSGender = 'languageTTSGender';
  static const columnDailyWordUpdatedAt = 'languageDailyWordUpdatedAt';
  static const columnWeeklyWordUpdatedAt = 'languageWeeklyWordUpdatedAt';
  static const columnMonthlyWordUpdatedAt = 'languageMonthlyWordUpdatedAt';
  static const columnDailySentenceUpdatedAt = 'languageDailySentenceUpdatedAt';
  static const columnWeeklySentenceUpdatedAt = 'languageWeeklySentenceUpdatedAt';
  static const columnMonthlySentenceUpdatedAt = 'languageMonthlySentenceUpdatedAt';
  static const columnIsSelected = 'languageIsSelected';
  static const columnDisplayedLanguage = 'languageDisplayedLanguage';
  static const columnIsAutoVoice = 'languageIsAutoVoice';
  static const columnIsActiveSuccessVoice = 'languageIsActiveSuccessVoice';

  final Database db;
  DBTableLanguages(this.db);

  Future onCreate() async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnCreatedAt TEXT  NOT NULL,
        $columnUpdatedAt TEXT NOT NULL,
        $columnTTSArtist TEXT NOT NULL,
        $columnTTSGender TEXT NOT NULL,
        $columnDailyWordUpdatedAt TEXT NOT NULL,
        $columnWeeklyWordUpdatedAt TEXT NOT NULL,
        $columnMonthlyWordUpdatedAt TEXT NOT NULL,
        $columnDailySentenceUpdatedAt TEXT NOT NULL,
        $columnWeeklySentenceUpdatedAt TEXT NOT NULL,
        $columnMonthlySentenceUpdatedAt TEXT NOT NULL,
        $columnIsSelected INTEGER NOT NULL,
        $columnDisplayedLanguage INTEGER NOT NULL,
        $columnIsAutoVoice INTEGER NOT NULL,
        $columnIsActiveSuccessVoice INTEGER NOT NULL
      )
      ''');
  }

  Future onUpgrade() async {
    /*await db.execute("DROP TABLE IF EXISTS $tableName");
    await onCreate();*/
  }
}