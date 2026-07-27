/// lib/data/database/service_locator.dart
///
/// Mengkonfigurasi dan menyediakan semua dependensi aplikasi menggunakan GetIt.
/// Ini adalah implementasi dari pola Service Locator.
library;

import 'package:get_it/get_it.dart';

import '../../data/database/database_service.dart';
import '../../data/datasources/local/scan_history_local_data_source.dart';
import '../../data/repositories/camera_repository_impl.dart';
import '../../data/repositories/scan_history_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/camera_repository.dart';
import '../../domain/repositories/scan_history_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/clear_all_history.dart';
import '../../domain/usecases/delete_scan_result.dart';
import '../../domain/usecases/get_scan_history.dart';
import '../../domain/usecases/save_scan_result.dart';
import '../../ml/services/camera_service.dart';
import '../../ml/services/image_processing_service.dart';
import '../../ml/services/inference_postprocessing_service.dart';
import '../../ml/services/ml_inference_service.dart';

/// Instance global dari GetIt service locator.
final sl = GetIt.instance;

/// Fungsi untuk menginisialisasi dan mendaftarkan semua dependensi.
Future<void> initializeDependencies() async {
  // =======================================================================
  // CORE
  // =======================================================================
  // Database Service
  sl.registerLazySingleton<DatabaseService>(DatabaseService.new);

  // =======================================================================
  // DATA LAYER
  // =======================================================================
  // Data Sources
  sl.registerLazySingleton<ScanHistoryLocalDataSource>(
    () => ScanHistoryLocalDataSourceImpl(databaseService: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ScanHistoryRepository>(
    () => ScanHistoryRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    SettingsRepositoryImpl.new,
  );
  sl.registerLazySingleton<CameraRepository>(
    () => CameraRepositoryImpl(cameraService: sl()),
  );

  // =======================================================================
  // DOMAIN LAYER (Use Cases)
  // =======================================================================
  sl.registerLazySingleton(() => GetScanHistory(sl()));
  sl.registerLazySingleton(() => SaveScanResult(sl()));
  sl.registerLazySingleton(() => DeleteScanResult(sl()));
  sl.registerLazySingleton(() => ClearAllHistory(sl()));

  // =======================================================================
  // ML LAYER
  // =======================================================================
  // Services
  sl.registerLazySingleton<ImageProcessingService>(ImageProcessingService.new);
  sl.registerLazySingleton<CameraService>(CameraService.new);
  sl.registerLazySingleton<InferencePostprocessingService>(
    InferencePostprocessingService.new,
  );
  sl.registerLazySingleton<MLInferenceService>(
    () => MLInferenceService(
      imageProcessor: sl(),
      postProcessor: sl(),
    ),
  );
}