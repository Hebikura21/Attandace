import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'my_database.db';
  static final _databaseVersion = 1;
  static final _tableName = 'tokens';

  static final columnId = '_id';
  static final columnToken = 'token';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $columnId INTEGER PRIMARY KEY,
        $columnToken TEXT
      )
      ''');
  }

  Future<int> insertToken(String token) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {columnToken: token};
    return await db.insert(_tableName, row);
  }

  Future<String?> getToken() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rows = await db.query(_tableName,
        columns: [columnToken], orderBy: '$columnId DESC', limit: 1);
    if (rows.isNotEmpty) {
      return rows.first[columnToken];
    } else {
      return null;
    }
  }

  Future<void> deleteToken() async {
    Database db = await instance.database;
    await db.delete(_tableName);
  }
}
