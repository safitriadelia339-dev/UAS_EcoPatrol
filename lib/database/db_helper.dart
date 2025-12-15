import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    // Tabel Laporan (Report)
    await db.execute('''
      CREATE TABLE reports(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        imagePath TEXT,
        latitude REAL,
        longitude REAL,
        status TEXT,
        createdAt TEXT
      )
    ''');

    // Tabel Pengguna (User) untuk login
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    // Contoh pengguna untuk login
    await db.insert('users', {'username': 'user', 'password': 'password'});
  }

  // --- Operasi Report ---

  Future<int> insertReport(String table, Map<String, dynamic> data) async {
    final db = await database;
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getReports(String table) async {
    final db = await database;
    // Urutkan berdasarkan tanggal dibuat terbaru
    return db.query(table, orderBy: 'createdAt DESC');
  }

  // --- Operasi User/Auth ---

  Future<Map<String, dynamic>?> authenticateUser(
    String username,
    String password,
  ) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
