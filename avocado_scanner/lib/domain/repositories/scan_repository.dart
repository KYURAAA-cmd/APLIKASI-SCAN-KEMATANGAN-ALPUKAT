/// lib/domain/repositories/scan_repository.dart
/// 
/// Abstract repository untuk scan operations
/// Menyediakan interface untuk data access
library;

import '../entities/scan_result.dart';

/// Abstract repository untuk scan operations
abstract class ScanRepository {
  /// Perform scan dengan image bytes
  Future<ScanResult> performScan(
    List<int> imageBytes,
    String imagePath,
  );

  /// Save scan result
  Future<int> saveScanResult(ScanResult scanResult);

  /// Get scan result by id
  Future<ScanResult?> getScanResultById(int id);

  /// Get all scan results
  Future<List<ScanResult>> getAllScanResults();

  /// Get scan results dengan pagination
  Future<List<ScanResult>> getScanResultsPaginated({
    int limit = 20,
    int offset = 0,
  });

  /// Filter by ripeness class
  Future<List<ScanResult>> getScanResultsByClass(String ripenessClass);

  /// Filter by confidence
  Future<List<ScanResult>> getScanResultsByConfidence({
    required double minConfidence,
    double? maxConfidence,
  });

  /// Filter by date range
  Future<List<ScanResult>> getScanResultsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Update scan result
  Future<int> updateScanResult(ScanResult scanResult);

  /// Delete scan result
  Future<int> deleteScanResult(int id);

  /// Delete multiple results
  Future<int> deleteScanResults(List<int> ids);

  /// Delete all results (use with caution)
  Future<int> deleteAllScanResults();

  /// Get total count
  Future<int> getScanResultCount();

  /// Get most recent result
  Future<ScanResult?> getMostRecentScanResult();

  /// Get statistics
  Future<Map<String, dynamic>> getStatistics();
}

/// Abstract repository untuk history operations
abstract class HistoryRepository {
  /// Get scan history
  Future<List<ScanResult>> getHistory();

  /// Save to history
  Future<int> saveToHistory(ScanResult scanResult);

  /// Delete from history
  Future<int> deleteFromHistory(int id);

  /// Clear history
  Future<int> clearHistory();

  /// Export history
  Future<String> exportHistory();
}
