import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const String _dbName = 'app_database.db';
  static const int _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        FirstName TEXT NOT NULL,
        LastName TEXT NOT NULL,
        Email TEXT NOT NULL UNIQUE,
        Phone TEXT,
        Password TEXT NOT NULL,
        MarketingOptIn INTEGER NOT NULL DEFAULT 0,
        CreatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL
      )
    ''');

    // İlk kurulumda ana sayfa için örnek kayıtlar
    await db.insert('posts', {
      'title': 'SQLite + MVVM Hazır',
      'body': 'Kayıt ve giriş işlemleri doğrudan yerel SQLite veritabanı üzerinden çalışıyor.',
    });
    await db.insert('posts', {
      'title': 'DB Browser ile Kontrol',
      'body': 'Cihazdan veya emülatörden app_database.db dosyasını çekip users tablosunu görebilirsin.',
    });
  }
}