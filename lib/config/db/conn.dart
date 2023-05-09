import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/lib/file.lib.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBConn {
  static const _databaseName = 'myLanguageApp.db';
  static const _databaseVersion = 12;

  DBConn._privateConstructor();
  static final DBConn instance = DBConn._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var path = join((await FileLib.applicationDocumentDirectory).path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    var tableLanguages = DBTableLanguages(db);
    tableLanguages.onCreate();

    var tableWords = DBTableWords(db);
    tableWords.onCreate();
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    var tableLanguages = DBTableLanguages(db);
    tableLanguages.onUpgrade();

    var tableWords = DBTableWords(db);
    tableWords.onUpgrade();
  }
}