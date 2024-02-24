import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static final int version = 1;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final String path =
        join(await getDatabasesPath(), 'com.abhibhut.abhibhut_db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onUpgrade: _upgradeTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    print('entered inside create tables');
    // Create APP_DATA TABLE
    await db.execute(
      '''CREATE TABLE APP_DATA (
          APP_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          PACKAGE_NM TEXT,
          APP_LABEL TEXT,     
          BLOCKED BOOLEAN,
          START_TIME INTEGER,
          END_TIME INTEGER
      )''',
    );

    // Create Meta Data Table
    await db.execute(
      '''CREATE TABLE BLOCK_META_DATA (
          APP_ID INTEGER,
          URL TEXT,
          MEDIA_TYPE TEXT
      )''',
    );

    await db.execute(
      '''CREATE TABLE USAGE_STATS (
          APP_ID INTEGER,
          WEEKLY_USGAE integer,
          MONTHLY_USAGE integer,
          SAVED_HOURS  integer,
          AVERAGE_USAGE INTEGER
      )''',
    );

    await db.execute(
      '''CREATE TABLE HISTORY (
          APP_NAME TEXT,
          START_TIME integer,
          END_TIME  integer
      )''',
    );
  }

  Future<void> _upgradeTables(
      Database db, int oldVersion, int newVersion) async {
    // Implement table upgrade logic if needed
  }

/*Below query will be used to get all data from the table as a list 
  all the clauses mentioned are optional arguments for the query
*/
  Future<List<Map<String, dynamic>>> queryData(String sql,
      [List<Object?>? args]) async {
    final Database? db = await database;
    return await db!.rawQuery(sql, args);
  }

  Future<int> InsertData(String sql, [List<Object?>? args]) async {
    final Database? db = await database;
    print('${args} inserted');
    return await db!.rawInsert(sql, args);
  }

  Future<int> UpdateData(String sql, [List<Object?>? args]) async {
    final Database? db = await database;
    return await db!.rawUpdate(sql, args);
  }
}
