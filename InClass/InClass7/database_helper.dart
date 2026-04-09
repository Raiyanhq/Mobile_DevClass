import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static const String _databaseName = 'MyDatabase.db';
  static const int _databaseVersion = 1;

  static const String table = 'my_table';
  static const String columnId = '_id';
  static const String columnName = 'name';
  static const String columnAge = 'age';

  late Database _db;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
    _isInitialized = true;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnAge INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  Future<Map<String, dynamic>?> queryById(int id) async {
    final List<Map<String, dynamic>> rows = await _db.query(
      table,
      where: '$columnId = ?',
      whereArgs: <Object>[id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return rows.first;
  }

  Future<int> queryRowCount() async {
    final List<Map<String, Object?>> results = await _db.rawQuery(
      'SELECT COUNT(*) FROM $table',
    );
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<int> update(Map<String, dynamic> row) async {
    final int id = row[columnId] as int;
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: <Object>[id],
    );
  }

  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: <Object>[id],
    );
  }

  Future<int> deleteAll() async {
    return await _db.delete(table);
  }
}
