import 'package:flutter/material.dart';
import '../../domain/entities/scan_result.dart';
import '../../presentation/screens/camera/camera_scan_screen.dart';
import '../../presentation/screens/history/history_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/result/scan_result_detail_screen.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.HOME:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.HISTORY:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case AppRoutes.CAMERA_SCAN:
        return MaterialPageRoute(builder: (_) => const CameraScanScreen());
      case AppRoutes.SCAN_RESULT_DETAIL:
        final scanResult = settings.arguments as ScanResult?;
        if (scanResult != null) {
          return MaterialPageRoute(
            builder: (_) => ScanResultDetailScreen(scanResult: scanResult),
          );
        }
        return _errorRoute(settings.name);
      case AppRoutes.SETTINGS:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Pengaturan')),
            body: const Center(child: Text('Fitur pengaturan akan segera hadir')),
          ),
        );
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? name) => MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Halaman tidak ditemukan: $name')),
      ),
    );
}
