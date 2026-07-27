/// lib/ml/services/camera_service.dart
///
/// Service untuk mengelola semua operasi kamera, termasuk inisialisasi,
/// kontrol, dan manajemen izin.
library;

import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  final Logger _logger = Logger();
  CameraController? _controller;
  String _currentResolution = '1080x1920';
  double _currentZoom = 1;

  static const List<String> supportedResolutions = [
    '480x640',
    '720x1280',
    '1080x1920',
  ];

  static const List<int> supportedFPS = [15, 24, 30];

  CameraController? get controller => _controller;

  /// Memeriksa apakah izin kamera telah diberikan.
  Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Meminta izin kamera kepada pengguna.
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _logger.i('✅ Izin kamera diberikan.');
      return true;
    } else {
      _logger.w('⚠️ Izin kamera ditolak.');
      return false;
    }
  }

  /// Menginisialisasi controller kamera.
  Future<bool> initializeCamera() async {
    if (_controller != null) {
      _logger.d('Kamera sudah diinisialisasi.');
      return true;
    }

    if (!await hasCameraPermission()) {
      if (!await requestCameraPermission()) {
        return false;
      }
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _logger.e('❌ Tidak ada kamera yang tersedia.');
        return false;
      }

      final camera = cameras.first; // Gunakan kamera belakang utama

      _controller = CameraController(
        camera,
        ResolutionPreset.high, // Resolusi default
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();
      _logger.i('✅ Kamera berhasil diinisialisasi.');
      return true;
    } catch (e) {
      _logger.e('❌ Gagal menginisialisasi kamera: $e');
      _controller = null;
      return false;
    }
  }

  /// Available resolutions supported by the application.
  List<String> getAvailableResolutions() => supportedResolutions;

  /// Get current active resolution.
  String getCurrentResolution() => _currentResolution;

  /// Available FPS options.
  List<int> getAvailableFPS() => supportedFPS;

  /// Get camera info.
  Future<Map<String, dynamic>> getCameraInfo() async => {
      'isInitialized': _controller?.value.isInitialized ?? false,
      'hasPermission': await hasCameraPermission(),
      'currentResolution': _currentResolution,
      'supportedResolutions': supportedResolutions,
      'supportedFPS': supportedFPS,
      'zoomLevel': _currentZoom,
    };

  /// Check if camera is available.
  Future<bool> isCameraAvailable() async => _controller != null && (_controller?.value.isInitialized ?? false);

  /// Camera health check.
  Future<bool> healthCheck() async {
    try {
      final available = await isCameraAvailable();
      if (!available) return false;
      final info = await getCameraInfo();
      return info['hasPermission'] == true;
    } catch (e) {
      _logger.e('❌ Camera health check failed: $e');
      return false;
    }
  }

  /// Mengatur resolusi kamera.
  Future<bool> setCameraResolution(String resolution) async {
    // TODO: Implement logic to change resolution preset
    _logger.d('Mengatur resolusi kamera ke: $resolution (TODO)');
    _currentResolution = resolution;
    return true;
  }

  /// Mengaktifkan atau menonaktifkan flash.
  Future<bool> toggleFlash(bool enable) async {
    if (_controller == null) return false;
    await _controller!.setFlashMode(enable ? FlashMode.torch : FlashMode.off);
    _logger.d('Flash diatur ke: ${enable ? "ON" : "OFF"}');
    return true;
  }

  /// Mengatur fokus pada titik tertentu di layar.
  Future<bool> focusOnPoint(double x, double y) async {
    if (_controller == null) return false;
    await _controller!.setFocusPoint(Offset(x, y));
    _logger.d('Fokus diatur ke titik: ($x, $y)');
    return true;
  }

  /// Get supported zoom level range.
  Future<Map<String, double>> getZoomLevels() async => {
      'minZoom': 1.0,
      'maxZoom': 5.0,
      'currentZoom': _currentZoom,
    };

  /// Set zoom level.
  Future<bool> setZoomLevel(double zoomLevel) async {
    if (zoomLevel < 1.0 || zoomLevel > 5.0) {
      _logger.w('Zoom level $zoomLevel is out of range');
      return false;
    }
    _currentZoom = zoomLevel;
    _logger.d('Zoom level set to $zoomLevel');
    return true;
  }

  /// Menutup dan melepaskan resource kamera.
  Future<void> closeCamera() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
      _logger.i('Kamera ditutup dan resource dilepaskan.');
    }
  }
}