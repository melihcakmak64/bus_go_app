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
  static const int _dbVersion = 6;

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
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS User (
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
      CREATE TABLE IF NOT EXISTS Category (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Name TEXT NOT NULL,
        IconCode TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS cities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        terminal TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Campaign (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Title TEXT NOT NULL,
        Subtitle TEXT,
        IconCode TEXT,
        BgColor TEXT,
        ImageName TEXT
      )
    ''');

    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    final existingCategories = await db.query('Category', limit: 1);
    if (existingCategories.isEmpty) {
      const categories = [
        {'Name': 'Otobüs', 'IconCode': 'directions_bus'},
        {'Name': 'Uçak', 'IconCode': 'flight'},
        {'Name': 'Otel', 'IconCode': 'hotel'},
        {'Name': 'Araç Kirala', 'IconCode': 'directions_car'},
      ];
      for (final item in categories) {
        await db.insert('Category', item);
      }
    }

    final existingCities = await db.query('cities', limit: 1);
    if (existingCities.isEmpty) {
      const cities = [
        {'name': 'İstanbul', 'terminal': 'Esenler'},
        {'name': 'Ankara', 'terminal': 'AŞTİ'},
        {'name': 'İzmir', 'terminal': 'Otogar'},
        {'name': 'Bursa', 'terminal': 'Şehirlerarası'},
        {'name': 'Antalya', 'terminal': 'Merkez'},
        {'name': 'Eskişehir', 'terminal': 'Otogar'},
      ];
      for (final city in cities) {
        await db.insert('cities', city);
      }
    }

    final existingCampaigns = await db.query('Campaign', limit: 1);
    if (existingCampaigns.isEmpty) {
      await db.rawInsert(
        "INSERT INTO Campaign (Title, Subtitle, ImageName) VALUES ('Tüm biletlerde %15 indirim!', 'Kupon: BUSGO15', 'kampanya1.png')",
      );
      await db.rawInsert(
        "INSERT INTO Campaign (Title, Subtitle, ImageName) VALUES ('Yeni rota: İstanbul → Trabzon', 'Hemen keşfet', 'kampanya2.png')",
      );
      await db.rawInsert(
        "INSERT INTO Campaign (Title, Subtitle, ImageName) VALUES ('Öğrencilere özel %20', 'Öğrenci belgenle', 'kampanya3.png')",
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS posts');
    await db.execute('DROP TABLE IF EXISTS categories');
    await db.execute('DROP TABLE IF EXISTS Category');
    await db.execute('DROP TABLE IF EXISTS cities');
    await db.execute('DROP TABLE IF EXISTS Campaign');
    await _createTables(db);
  }
}
