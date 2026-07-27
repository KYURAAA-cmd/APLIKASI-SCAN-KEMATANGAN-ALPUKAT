/// lib/data/database/database_helper.dart
/// 
/// Helper class untuk common database operations
/// Menyediakan high-level functions untuk database management
library;

import 'package:logger/logger.dart';
import 'database_service.dart';
import 'scan_history_dao.dart';

/// Database helper untuk common operations
class DatabaseHelper {

  DatabaseHelper._();
  static DatabaseHelper? _instance;
  final Logger _logger = Logger();

  late DatabaseService _databaseService;
  late ScanHistoryDao _scanHistoryDao;

  /// Get singleton instance
  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  /// Initialize helper
  Future<void> initialize() async {
    try {
      _databaseService = DatabaseService();
      _scanHistoryDao = ScanHistoryDao();

      // Ensure database is initialized
      await _databaseService.database;

      _logger.i('✅ DatabaseHelper initialized');
    } catch (e) {
      _logger.e('❌ Failed to initialize DatabaseHelper: $e');
      rethrow;
    }
  }

  /// Get scan history DAO
  ScanHistoryDao get scanHistoryDao => _scanHistoryDao;

  /// Get database service
  DatabaseService get databaseService => _databaseService;

  /// Reset database (delete all data)
  Future<void> resetDatabase() async {
    try {
      _logger.w('⚠️ Resetting database...');

      final count = await _scanHistoryDao.deleteAllScanResults();
      _logger.i('✅ Database reset - deleted $count records');
    } catch (e) {
      _logger.e('❌ Error resetting database: $e');
      rethrow;
    }
  }

  /// Backup database info
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      return await _databaseService.getDatabaseInfo();
    } catch (e) {
      _logger.e('❌ Error getting database info: $e');
      rethrow;
    }
  }

  /// Close database
  Future<void> close() async {
    try {
      await _databaseService.close();
      _logger.i('✅ Database closed');
    } catch (e) {
      _logger.e('❌ Error closing database: $e');
      rethrow;
    }
  }

  /// Get database statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      return await _scanHistoryDao.getStatistics();
    } catch (e) {
      _logger.e('❌ Error getting statistics: $e');
      rethrow;
    }
  }

  /// Clear cache (delete old records keeping recent ones)
  Future<int> clearCache({int keepRecent = 100}) async {
    try {
      _logger.i('🧹 Clearing cache - keeping $keepRecent recent records...');

      final deleted = await _scanHistoryDao.clearOldScanResults(keepRecent);
      _logger.i('✅ Cache cleared - deleted $deleted old records');
      return deleted;
    } catch (e) {
      _logger.e('❌ Error clearing cache: $e');
      rethrow;
    }
  }

  /// Get database health check
  Future<bool> healthCheck() async {
    try {
      // Try to access database
      final info = await getDatabaseInfo();
      _logger.i('✅ Database health check passed');
      return true;
    } catch (e) {
      _logger.e('❌ Database health check failed: $e');
      return false;
    }
  }

  /// Export statistics
  Future<String> exportStatistics() async {
    try {
      final stats = await getStatistics();
      final info = await getDatabaseInfo();

      final export = '''
📊 AVOCADO SCANNER - DATABASE STATISTICS
==========================================
Generated: ${DateTime.now()}

Database Info:
- Path: ${info['path']}
- Version: ${info['version']}
- Tables: ${info['tables']}
- Total Records: ${info['totalRecords']}

Scan Statistics:
- Total Scans: ${stats['totalRecords']}
- Average Confidence: ${(stats['averageConfidence'] as double).toStringAsFixed(2)}%
- Class Distribution: ${stats['classDistribution']}

==========================================
      ''';

      _logger.d('📄 Statistics exported');
      return export;
    } catch (e) {
      _logger.e('❌ Error exporting statistics: $e');
      rethrow;
    }
  }
}
