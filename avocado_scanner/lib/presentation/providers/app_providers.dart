/// lib/presentation/providers/app_providers.dart
///
/// Mendaftarkan semua provider aplikasi untuk digunakan di MultiProvider.
library;

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// Jalur impor diubah untuk menunjuk ke lokasi service locator yang benar.
import '../../data/database/service_locator.dart';
import '../../domain/repositories/camera_repository.dart';
import '../../domain/usecases/clear_all_history.dart';
import '../../domain/usecases/delete_scan_result.dart';
import '../../domain/usecases/get_scan_history.dart';
import '../../domain/usecases/save_scan_result.dart';
import '../../ml/services/ml_inference_service.dart';
import '../../presentation/providers/history_provider.dart';
import '../../presentation/providers/scan_provider.dart';
import 'camera_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
      ChangeNotifierProvider(
        create: (context) => HistoryProvider(
          getScanHistory: sl<GetScanHistory>(),
          saveScanResult: sl<SaveScanResult>(),
          deleteScanResult: sl<DeleteScanResult>(),
          clearAllHistory: sl<ClearAllHistory>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => ScanProvider(
          mlService: sl<MLInferenceService>(),
          historyProvider: Provider.of<HistoryProvider>(context, listen: false),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => CameraProvider(
          cameraRepository: sl<CameraRepository>(),
          mlService: sl<MLInferenceService>(),
        ),
      ),
    ];
}