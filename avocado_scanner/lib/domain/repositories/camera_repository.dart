/// lib/domain/repositories/camera_repository.dart
/// 
/// Abstract repository untuk camera operations
/// Interface untuk camera access dan permissions
library;

import 'package:camera/camera.dart';

/// Abstract repository untuk camera
abstract class CameraRepository {
  /// Check camera permission
  Future<bool> hasCameraPermission();

  /// Request camera permission
  Future<bool> requestCameraPermission();

  /// Initialize camera
  Future<bool> initializeCamera();

  /// Get the native camera controller.
  CameraController? get cameraController;

  /// Get available resolutions
  List<String> getAvailableResolutions();

  /// Set camera resolution
  Future<bool> setCameraResolution(String resolution);

  /// Get current resolution
  String getCurrentResolution();

  /// Get available FPS
  List<int> getAvailableFPS();

  /// Toggle flash
  Future<bool> toggleFlash(bool enable);

  /// Focus on point
  Future<bool> focusOnPoint(double x, double y);

  /// Get zoom levels
  Future<Map<String, double>> getZoomLevels();

  /// Set zoom level
  Future<bool> setZoomLevel(double zoomLevel);

  /// Get camera info
  Future<Map<String, dynamic>> getCameraInfo();

  /// Check if camera is available
  Future<bool> isCameraAvailable();

  /// Close camera
  Future<void> closeCamera();

  /// Health check
  Future<bool> healthCheck();
}
