/// lib/data/database/db_schema.dart
///
/// Mendefinisikan skema database, termasuk nama tabel, kolom, dan query pembuatan tabel.
library;

class DbSchema {
  DbSchema._();

  // Database info
  static const String databaseName = 'avocado_scanner.db';
  static const int databaseVersion = 1;

  // Tabel Scan History
  static const String tableScanHistory = 'scan_history';
  static const String colId = 'id';
  static const String colScanDate = 'scan_date';
  static const String colImagePath = 'image_path';
  static const String colDetections = 'detections'; // JSON String
  static const String colMainClass = 'main_class';
  static const String colMainConfidence = 'main_confidence';
  static const String colInferenceTimeMs = 'inference_time_ms';
  static const String colImageWidth = 'image_width';
  static const String colImageHeight = 'image_height';
  static const String colFps = 'fps';
  static const String colNotes = 'notes';
  static const String colCreatedAt = 'created_at';

  // Query pembuatan tabel
  static const String createScanHistoryTable = '''
    CREATE TABLE $tableScanHistory (
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colScanDate TEXT NOT NULL,
      $colImagePath TEXT NOT NULL,
      $colDetections TEXT NOT NULL,
      $colMainClass TEXT NOT NULL,
      $colMainConfidence REAL NOT NULL,
      $colInferenceTimeMs INTEGER NOT NULL,
      $colImageWidth INTEGER NOT NULL,
      $colImageHeight INTEGER NOT NULL,
      $colFps REAL,
      $colNotes TEXT,
      $colCreatedAt TEXT NOT NULL
    )
  ''';

  // Query penghapusan tabel
  static const String dropScanHistoryTable = 'DROP TABLE IF EXISTS $tableScanHistory';

  // Index
  static const String indexScanDate = 'idx_scan_date';
  static const String createScanDateIndex =
      'CREATE INDEX $indexScanDate ON $tableScanHistory($colScanDate DESC)';

  /// Mendapatkan semua skrip pembuatan tabel dan index
  static List<String> getCreationScripts() => [
      createScanHistoryTable,
      createScanDateIndex,
    ];
}