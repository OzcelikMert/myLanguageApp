import 'dart:developer';

import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBConn {
  static const _databaseName = 'myLanguageApp.db';
  static const _databaseVersion = 3;

  DBConn._privateConstructor();
  static final DBConn instance = DBConn._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, _databaseName);
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