/// lib/data/database/scan_history_dao.dart
/// 
/// Data Access Object untuk tabel scan_history
/// Menangani semua operasi database untuk scan history
/// 
/// Responsibilities:
/// - Insert, Read, Update, Delete scan results
/// - Query filtering dan sorting
/// - Batch operations
/// - Transaction management
library;

import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/models/scan_result_model.dart';
import 'database_service.dart';
import 'db_schema.dart';

/// Data Access Object untuk scan_history table
class ScanHistoryDao {
  final DatabaseService _databaseService = DatabaseService();
  final Logger _logger = Logger();

  /// Insert scan result ke database
  Future<int> insertScanResult(ScanResultModel scanResult) async {
    try {
      final db = await _databaseService.database;

      final id = await db.insert(
        DbSchema.tableScanHistory,
        _scanResultToMap(scanResult),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _logger.d('✓ Inserted scan result with id: $id');
      return id;
    } catch (e) {
      _logger.e('❌ Error inserting scan result: $e');
      rethrow;
    }
  }

  /// Get scan result by id
  Future<ScanResultModel?> getScanResultById(int id) async {
    try {
      final db = await _databaseService.database;

      final maps = await db.query(
        DbSchema.tableScanHistory,
        where: '${DbSchema.colId} = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        _logger.d('No scan result found with id: $id');
        return null;
      }

      return ScanResultModel.fromMap(maps.first);
    } catch (e) {
      _logger.e('❌ Error getting scan result by id: $e');
      rethrow;
    }
  }

  /// Get all scan results
  Future<List<ScanResultModel>> getAllScanResults() async {
    try {
      final db = await _databaseService.database;

      final maps = await db.query(
        DbSchema.tableScanHistory,
        orderBy: '${DbSchema.colScanDate} DESC',
      );

      _logger.d('✓ Retrieved ${maps.length} scan results');
      return List.generate(maps.length, (i) => ScanResultModel.fromMap(maps[i]));
    } catch (e) {
      _logger.e('❌ Error getting all scan results: $e');
      rethrow;
    }
  }

  /// Get scan results dengan pagination
  Future<List<ScanResultModel>> getScanResultsPaginated({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final db = await _databaseService.database;

      final maps = await db.query(
        DbSchema.tableScanHistory,
        orderBy: '${DbSchema.colScanDate} DESC',
        limit: limit,
        offset: offset,
      );

      _logger.d('✓ Retrieved ${maps.length} scan results (limit: $limit, offset: $offset)');
      return List.generate(maps.length, (i) => ScanResultModel.fromMap(maps[i]));
    } catch (e) {
      _logger.e('❌ Error getting paginated scan results: $e');
      rethrow;
    }
  }

  /// Filter scan results by class
  Future<List<ScanResultModel>> getScanResultsByClass(String mainClass) async {
    try {
      final db = await _databaseService.database;

      final maps = await db.query(
        DbSchema.tableScanHistory,
        where: '${DbSchema.colMainClass} = ?',
        whereArgs: [mainClass],
        orderBy: '${DbSchema.colScanDate} DESC',
      );

      _logger.d('✓ Retrieved ${maps.length} scan results for class: $mainClass');
      return List.generate(maps.length, (i) => ScanResultModel.fromMap(maps[i]));
    } catch (e) {
      _logger.e('❌ Error getting scan results by class: $e');
      rethrow;
    }
  }

  /// Filter scan results by confidence threshold
  Future<List<ScanResultModel>> getScanResultsByConfidence({
    required double minConfidence,
    double? maxConfidence,
  }) async {
    try {
      final db = await _databaseService.database;

      var where = '${DbSchema.colMainConfidence} >= ?';
      final whereArgs = <Object?>[minConfidence];

      if (maxConfidence != null) {
        where += ' AND ${DbSchema.colMainConfidence} <= ?';
        whereArgs.add(maxConfidence);
      }

      final maps = await db.query(
        DbSchema.tableScanHistory,
        where: where,
        whereArgs: whereArgs,
        orderBy: '${DbSchema.colMainConfidence} DESC',
      );

      _logger.d('✓ Retrieved ${maps.length} scan results with confidence >= $minConfidence');
      return List.generate(maps.length, (i) => ScanResultModel.fromMap(maps[i]));
    } catch (e) {
      _logger.e('❌ Error getting scan results by confidence: $e');
      rethrow;
    }
  }

  /// Filter scan results by date range
  Future<List<ScanResultModel>> getScanResultsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final db = await _databaseService.database;

      final maps = await db.query(
        DbSchema.tableScanHistory,
        where:
            '${DbSchema.colScanDate} >= ? AND ${DbSchema.colScanDate} <= ?',
        whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
        orderBy: '${DbSchema.colScanDate} DESC',
      );

      _logger.d(
        '✓ Retrieved ${maps.length} scan results between ${startDate.toLocal()} and ${endDate.toLocal()}',
      );
      return List.generate(maps.length, (i) => ScanResultModel.fromMap(maps[i]));
    } catch (e) {
      _logger.e('❌ Error getting scan results by date range: $e');
      rethrow;
    }
  }

  /// Update scan result
  Future<int> updateScanResult(ScanResultModel scanResult) async {
    try {
      final db = await _databaseService.database;

      if (scanResult.id == null) {
        throw ArgumentError('Scan result id cannot be null for update');
      }

      final rowsAffected = await db.update(
        DbSchema.tableScanHistory,
        _scanResultToMap(scanResult),
        where: '${DbSchema.colId} = ?',
        whereArgs: [scanResult.id],
      );

      _logger.d('✓ Updated $rowsAffected scan result(s)');
      return rowsAffected;
    } catch (e) {
      _logger.e('❌ Error updating scan result: $e');
      rethrow;
    }
  }

  /// Delete scan result by id
  Future<int> deleteScanResultById(int id) async {
    try {
      final db = await _databaseService.database;

      final rowsAffected = await db.delete(
        DbSchema.tableScanHistory,
        where: '${DbSchema.colId} = ?',
        whereArgs: [id],
      );

      _logger.d('✓ Deleted $rowsAffected scan result(s)');
      return rowsAffected;
    } catch (e) {
      _logger.e('❌ Error deleting scan result: $e');
      rethrow;
    }
  }

  /// Delete multiple scan results by ids
  Future<int> deleteScanResultsByIds(List<int> ids) async {
    try {
      final db = await _databaseService.database;

      if (ids.isEmpty) return 0;

      final placeholders = List.filled(ids.length, '?').join(',');

      final rowsAffected = await db.delete(
        DbSchema.tableScanHistory,
        where: '${DbSchema.colId} IN ($placeholders)',
        whereArgs: ids,
      );

      _logger.d('✓ Deleted $rowsAffected scan result(s)');
      return rowsAffected;
    } catch (e) {
      _logger.e('❌ Error deleting multiple scan results: $e');
      rethrow;
    }
  }

  /// Delete all scan results (use with caution!)
  Future<int> deleteAllScanResults() async {
    try {
      final db = await _databaseService.database;

      final rowsAffected = await db.delete(DbSchema.tableScanHistory);

      _logger.w('⚠️ Deleted all $rowsAffected scan results');
      return rowsAffected;
    } catch (e) {
      _logger.e('❌ Error deleting all scan results: $e');
      rethrow;
    }
  }

  /// Get total scan result count
  Future<int> getScanResultCount() async {
    try {
      final db = await _databaseService.database;

      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${DbSchema.tableScanHistory}',
      );

      final count = (result.first['count'] as int?) ?? 0;
      _logger.d('✓ Total scan results: $count');
      return count;
    } catch (e) {
      _logger.e('❌ Error getting scan result count: $e');
      rethrow;
    }
  }

  /// Get most recent scan result
  Future<ScanResultModel?> getMostRecentScanResult() async {
    try {
      final db = await _databaseService.database;

      final maps = await db.query(
        DbSchema.tableScanHistory,
        orderBy: '${DbSchema.colScanDate} DESC',
        limit: 1,
      );

      if (maps.isEmpty) {
        return null;
      }

      return ScanResultModel.fromJson(maps.first);
    } catch (e) {
      _logger.e('❌ Error getting most recent scan result: $e');
      rethrow;
    }
  }

  /// Clear old scan results (keep only recent N items)
  Future<int> clearOldScanResults(int keepCount) async {
    try {
      final db = await _databaseService.database;

      final result = await db.rawQuery(
        '''
        SELECT ${DbSchema.colId} FROM ${DbSchema.tableScanHistory}
        ORDER BY ${DbSchema.colScanDate} DESC
        LIMIT -1 OFFSET $keepCount
        ''',
      );

      if (result.isEmpty) {
        _logger.d('✓ No old scan results to clear');
        return 0;
      }

      final ids = result.map((e) => e[DbSchema.colId]! as int).toList();
      return await deleteScanResultsByIds(ids);
    } catch (e) {
      _logger.e('❌ Error clearing old scan results: $e');
      rethrow;
    }
  }

  /// Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final db = await _databaseService.database;

      final totalResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${DbSchema.tableScanHistory}',
      );

      final classDistribution = await db.rawQuery(
        '''
        SELECT ${DbSchema.colMainClass} as class, COUNT(*) as count
        FROM ${DbSchema.tableScanHistory}
        GROUP BY ${DbSchema.colMainClass}
        ''',
      );

      final avgConfidence = await db.rawQuery(
        'SELECT AVG(${DbSchema.colMainConfidence}) as avg FROM ${DbSchema.tableScanHistory}',
      );

      final totalRecords = (totalResult.first['count'] as int?) ?? 0;
      final avgConf = (avgConfidence.first['avg'] as num?)?.toDouble() ?? 0.0;

      final distribution = <String, int>{};
      for (final row in classDistribution) {
        final className = row[DbSchema.colMainClass]! as String;
        final count = row['count']! as int;
        distribution[className] = count;
      }

      return {
        'totalRecords': totalRecords,
        'averageConfidence': avgConf,
        'classDistribution': distribution,
      };
    } catch (e) {
      _logger.e('❌ Error getting statistics: $e');
      rethrow;
    }
  }

  /// Convert ScanResultModel to map untuk database
  Map<String, dynamic> _scanResultToMap(ScanResultModel scanResult) {
    final map = scanResult.toMap();
    map.remove(DbSchema.colId);
    return map;
  }
}
