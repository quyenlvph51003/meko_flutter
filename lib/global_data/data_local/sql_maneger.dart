import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteManager {
  static final SQLiteManager _instance = SQLiteManager._internal();

  factory SQLiteManager() => _instance;

  factory SQLiteManager.instance() => _instance;
  SQLiteManager._internal();

  static Database? _database;

  /// Khởi tạo database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('meko_database.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Tạo bảng ví dụ
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS key_value (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE,
        value TEXT
      )
    ''');
  }

  /// Thêm hoặc cập nhật dữ liệu
  Future<void> put<T>(String key, T value) async {
    final db = await database;
    final jsonValue = jsonEncode(value); // Chuyển object -> JSON
    await db.insert('key_value', {
      'key': key,
      'value': jsonValue,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Lấy dữ liệu
  Future<T?> get<T>(String key) async {
    final db = await database;
    final result = await db.query(
      'key_value',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isNotEmpty) {
      final value = result.first['value'] as String;
      return jsonDecode(value) as T;
    }
    return null;
  }

  /// Xóa dữ liệu
  Future<void> delete(String key) async {
    final db = await database;
    await db.delete('key_value', where: 'key = ?', whereArgs: [key]);
  }

  /// Xóa tất cả dữ liệu
  Future<void> clear() async {
    final db = await database;
    await db.delete('key_value');
  }
}
