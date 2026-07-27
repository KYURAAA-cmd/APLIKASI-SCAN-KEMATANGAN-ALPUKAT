/// lib/data/database/database_service.dart
///
/// Service untuk mengelola koneksi dan siklus hidup database SQLite.
/// Menggunakan pola singleton untuk memastikan hanya ada satu instance koneksi database.
library;

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_schema.dart';

class DatabaseService {
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  // Singleton instance
  static final DatabaseService _instance = DatabaseService._internal();

  static Database? _database;
  final Logger _logger = Logger();

  /// Getter untuk instance database.
  /// Akan menginisialisasi database jika belum ada.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inisialisasi database.
  Future<Database> _initDatabase() async {
    _logger.i('🗄️ Initializing database...');
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, DbSchema.databaseName);

      return await openDatabase(
        path,
        version: DbSchema.databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      _logger.e('❌ Error initializing database: $e');
      rethrow;
    }
  }

  /// Dipanggil saat database dibuat untuk pertama kalinya.
  Future<void> _onCreate(Database db, int version) async {
    _logger.i('📖 Creating database tables for version $version...');
    final batch = db.batch();
    for (final script in DbSchema.getCreationScripts()) {
      batch.execute(script);
      _logger.d('  -> Executed: ${script.split('(').first.trim()}');
    }
    await batch.commit(noResult: true);
    _logger.i('✅ Database tables created successfully.');
  }

  /// Dipanggil saat database di-upgrade.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _logger.w('⬆️ Upgrading database from version $oldVersion to $newVersion...');
    // TODO: Implement migration logic here if schema changes in the future.
    final batch = db.batch();
    batch.execute(DbSchema.dropScanHistoryTable);
    await batch.commit(noResult: true);
    await _onCreate(db, newVersion);
    _logger.i('✅ Database upgraded.');
  }

  /// Menutup koneksi database.
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      _logger.i('🚪 Database connection closed.');
    }
  }

  /// Mendapatkan informasi database untuk debugging.
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    final db = await database;
    final path = db.path;
    final version = await db.getVersion();
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'android_%' AND name NOT LIKE 'sqlite_%'",
    );

    var totalRecords = 0;
    try {
      final countResult = await db.rawQuery('SELECT COUNT(*) FROM scan_history');
      totalRecords = Sqflite.firstIntValue(countResult) ?? 0;
    } catch (_) {}

    return {
      'path': path,
      'version': version,
      'tables': tables.map((e) => e['name']).toList(),
      'totalRecords': totalRecords,
    };
  }
}
