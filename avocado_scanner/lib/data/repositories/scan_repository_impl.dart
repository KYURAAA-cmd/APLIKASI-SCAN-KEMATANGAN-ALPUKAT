/// lib/data/repositories/scan_repository_impl.dart
/// 
/// Concrete implementation dari ScanRepository dengan ML Integration
/// Mengintegrasikan ML service, preprocessing, database, dan file storage
library;


import 'package:logger/logger.dart';

import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scan_repository.dart';
import '../../ml/services/ml_inference_service.dart';
import '../database/database_helper.dart';
import '../models/scan_result_model.dart';

/// Concrete implementation dari ScanRepository dengan ML integration
class ScanRepositoryImpl implements ScanRepository {
  ScanRepositoryImpl({
    required MLInferenceService mlService,
  })  : _mlService = mlService;

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final MLInferenceService _mlService;
  final Logger _logger = Logger();

  bool _isInitialized = false;

  /// Initialize repository
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _logger.i('🚀 Initializing ScanRepositoryImpl...');

      // Initialize ML service
      await _mlService.initialize();

      _isInitialized = true;
      _logger.i('✅ ScanRepositoryImpl initialized');
    } catch (e) {
      _logger.e('❌ Error initializing ScanRepositoryImpl: $e');
      rethrow;
    }
  }

  @override
  Future<ScanResult> performScan(
    List<int> imageBytes,
    String imagePath,
  ) async {
    try {
      if (!_isInitialized) {
        throw StateError(
          'Repository not initialized. Call initialize() first.',
        );
      }

      _logger.i('🔍 Performing scan on: $imagePath');

      // Run ML inference on image file
      final inferenceResult = await _mlService.runInferenceOnImage(imagePath);

      _logger.d(
        '✓ ML inference completed: ${inferenceResult.detections.length} detections',
      );

      _logger.i(
        '✅ Scan completed: ${inferenceResult.mainClass} (${(inferenceResult.mainConfidence * 100).toStringAsFixed(1)}%)',
      );

      return inferenceResult;
    } catch (e) {
      _logger.e('❌ Error performing scan: $e');
      rethrow;
    }
  }

  @override
  Future<int> saveScanResult(ScanResult scanResult) async {
    try {
      _logger.i('💾 Saving scan result...');

      final model = ScanResultModel.fromEntity(scanResult);
      final id = await _databaseHelper.scanHistoryDao.insertScanResult(model);

      _logger.i('✅ Scan result saved with id: $id');
      return id;
    } catch (e) {
      _logger.e('❌ Error saving scan result: $e');
      rethrow;
    }
  }

  @override
  Future<ScanResult?> getScanResultById(int id) async {
    try {
      _logger.d('🔎 Getting scan result with id: $id');

      final model = await _databaseHelper.scanHistoryDao.getScanResultById(id);
      return model?.toEntity();
    } catch (e) {
      _logger.e('❌ Error getting scan result: $e');
      rethrow;
    }
  }

  @override
  Future<List<ScanResult>> getAllScanResults() async {
    try {
      _logger.d('📋 Fetching all scan results...');

      final models =
          await _databaseHelper.scanHistoryDao.getAllScanResults();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      _logger.e('❌ Error getting all scan results: $e');
      rethrow;
    }
  }

  @override
  Future<List<ScanResult>> getScanResultsPaginated({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      _logger.d('📄 Fetching paginated scan results (limit: $limit, offset: $offset)');

      final models = await _databaseHelper.scanHistoryDao
          .getScanResultsPaginated(limit: limit, offset: offset);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      _logger.e('❌ Error getting paginated scan results: $e');
      rethrow;
    }
  }

  @override
  Future<List<ScanResult>> getScanResultsByClass(String ripenessClass) async {
    try {
      _logger.d('🔎 Filtering scan results by class: $ripenessClass');

      final models =
          await _databaseHelper.scanHistoryDao.getScanResultsByClass(ripenessClass);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      _logger.e('❌ Error filtering by class: $e');
      rethrow;
    }
  }

  @override
  Future<List<ScanResult>> getScanResultsByConfidence({
    required double minConfidence,
    double? maxConfidence,
  }) async {
    try {
      _logger.d(
        '🔎 Filtering by confidence: min=$minConfidence, max=$maxConfidence',
      );

      final models = await _databaseHelper.scanHistoryDao
          .getScanResultsByConfidence(
        minConfidence: minConfidence,
        maxConfidence: maxConfidence,
      );
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      _logger.e('❌ Error filtering by confidence: $e');
      rethrow;
    }
  }

  @override
  Future<List<ScanResult>> getScanResultsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      _logger.d(
        '🔎 Filtering by date range: ${startDate.toLocal()} to ${endDate.toLocal()}',
      );

      final models = await _databaseHelper.scanHistoryDao
          .getScanResultsByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      _logger.e('❌ Error filtering by date range: $e');
      rethrow;
    }
  }

  @override
  Future<int> updateScanResult(ScanResult scanResult) async {
    try {
      _logger.i('✏️ Updating scan result id: ${scanResult.id}');

      final model = ScanResultModel.fromEntity(scanResult);
      final rowsAffected =
          await _databaseHelper.scanHistoryDao.updateScanResult(model);

      _logger.i('✅ Updated $rowsAffected scan result(s)');
      return rowsAffected;
    } catch (e) {
      _logger.e('❌ Error updating scan result: $e');
      rethrow;
    }
  }

  @override
  Future<int> deleteScanResult(int id) async {
    try {
      _logger.i('🗑️ Deleting scan result id: $id');

      final rowsAffected =
          await _databaseHelper.scanHistoryDao.deleteScanResultById(id);

      _logger.i('✅ Deleted $rowsAffected scan result(s)');
      return rowsAffected;
    } catch (e) {
      _logger.e('❌ Error deleting scan result: $e');
      rethrow;
    }
  }

  @override
  Future<int> deleteScanResults(List<int> ids) async {
    try {
      _logger.i('🗑️ Deleting ${ids.length} scan results...');

      final rowsAffected =
          await _databaseHelper.scanHistoryDao.deleteScanResultsByIds(ids);

      _logger.i('✅ Deleted $rowsAffected scan result(s)');
      return rowsAffected;
    } catch (e) {
      _logger.e('❌ Error deleting multiple scan results: $e');
      rethrow;
    }
  }

  @override
  Future<int> deleteAllScanResults() async {
    try {
      _logger.w('⚠️ Deleting ALL scan results...');

      final rowsAffected =
          await _databaseHelper.scanHistoryDao.deleteAllScanResults();

      _logger.w('✅ Deleted all $rowsAffected scan results');
      return rowsAffected;
    } catch (e) {
      _logger.e('❌ Error deleting all scan results: $e');
      rethrow;
    }
  }

  @override
  Future<int> getScanResultCount() async {
    try {
      final count = await _databaseHelper.scanHistoryDao.getScanResultCount();
      _logger.d('📊 Total scan results: $count');
      return count;
    } catch (e) {
      _logger.e('❌ Error getting count: $e');
      rethrow;
    }
  }

  @override
  Future<ScanResult?> getMostRecentScanResult() async {
    try {
      _logger.d('🔎 Fetching most recent scan result...');

      final model =
          await _databaseHelper.scanHistoryDao.getMostRecentScanResult();
      return model?.toEntity();
    } catch (e) {
      _logger.e('❌ Error getting most recent scan result: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      _logger.d('📊 Fetching statistics...');

      final stats = await _databaseHelper.scanHistoryDao.getStatistics();
      return stats;
    } catch (e) {
      _logger.e('❌ Error getting statistics: $e');
      rethrow;
    }
  }

  /// Get ML performance statistics
  Map<String, dynamic> getMLPerformanceStats() {
    try {
      // Return basic stats based on logger
      return {
        'status': _isInitialized ? 'ready' : 'not_initialized',
        'message': 'ML Service is ${_isInitialized ? 'ready' : 'not ready'}',
      };
    } catch (e) {
      _logger.e('❌ Error getting ML stats: $e');
      return {};
    }
  }

  /// Get model info
  Future<Map<String, dynamic>> getModelInfo() async {
    try {
      return {
        'status': 'available',
        'message': 'Model is loaded and initialized',
      };
    } catch (e) {
      _logger.e('❌ Error getting model info: $e');
      return {};
    }
  }

  /// Health check
  Future<bool> healthCheck() async {
    try {
      if (!_isInitialized) return false;

      // Basic health check - just verify initialization status
      return _isInitialized;
    } catch (e) {
      _logger.e('❌ Error in health check: $e');
      return false;
    }
  }

  /// Cleanup
  Future<void> cleanup() async {
    try {
      _mlService.dispose();
      await _databaseHelper.close();
      _isInitialized = false;
      _logger.i('✅ Cleanup completed');
    } catch (e) {
      _logger.e('❌ Error during cleanup: $e');
      rethrow;
    }
  }
}

