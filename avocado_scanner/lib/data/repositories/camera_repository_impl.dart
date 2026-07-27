/// lib/data/repositories/camera_repository_impl.dart
/// 
/// Concrete implementation dari CameraRepository
/// Delegasi ke CameraService untuk operasi kamera
library;
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import '../../domain/repositories/camera_repository.dart';
import '../../ml/services/camera_service.dart';

/// Concrete implementation dari CameraRepository
class CameraRepositoryImpl implements CameraRepository {

  CameraRepositoryImpl({required CameraService cameraService})
      : _cameraService = cameraService;
  final CameraService _cameraService;
  final Logger _logger = Logger();

  @override
  Future<bool> hasCameraPermission() async {
    try {
      return await _cameraService.hasCameraPermission();
    } catch (e) {
      _logger.e('❌ Error checking camera permission: $e');
      return false;
    }
  }

  @override
  Future<bool> requestCameraPermission() async {
    try {
      return await _cameraService.requestCameraPermission();
    } catch (e) {
      _logger.e('❌ Error requesting camera permission: $e');
      return false;
    }
  }

  @override
  Future<bool> initializeCamera() async {
    try {
      return await _cameraService.initializeCamera();
    } catch (e) {
      _logger.e('❌ Error initializing camera: $e');
      return false;
    }
  }

  @override
  CameraController? get cameraController => _cameraService.controller;

  @override
  List<String> getAvailableResolutions() {
    try {
      return _cameraService.getAvailableResolutions();
    } catch (e) {
      _logger.e('❌ Error getting available resolutions: $e');
      return [];
    }
  }

  @override
  Future<bool> setCameraResolution(String resolution) async {
    try {
      return await _cameraService.setCameraResolution(resolution);
    } catch (e) {
      _logger.e('❌ Error setting camera resolution: $e');
      return false;
    }
  }

  @override
  String getCurrentResolution() {
    try {
      return _cameraService.getCurrentResolution();
    } catch (e) {
      _logger.e('❌ Error getting current resolution: $e');
      return '1080x1920';
    }
  }

  @override
  List<int> getAvailableFPS() {
    try {
      return _cameraService.getAvailableFPS();
    } catch (e) {
      _logger.e('❌ Error getting available FPS: $e');
      return [24, 30];
    }
  }

  @override
  Future<bool> toggleFlash(bool enable) async {
    try {
      return await _cameraService.toggleFlash(enable);
    } catch (e) {
      _logger.e('❌ Error toggling flash: $e');
      return false;
    }
  }

  @override
  Future<bool> focusOnPoint(double x, double y) async {
    try {
      return await _cameraService.focusOnPoint(x, y);
    } catch (e) {
      _logger.e('❌ Error focusing on point: $e');
      return false;
    }
  }

  @override
  Future<Map<String, double>> getZoomLevels() async {
    try {
      return await _cameraService.getZoomLevels();
    } catch (e) {
      _logger.e('❌ Error getting zoom levels: $e');
      return {'minZoom': 1.0, 'maxZoom': 1.0, 'currentZoom': 1.0};
    }
  }

  @override
  Future<bool> setZoomLevel(double zoomLevel) async {
    try {
      return await _cameraService.setZoomLevel(zoomLevel);
    } catch (e) {
      _logger.e('❌ Error setting zoom level: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getCameraInfo() async {
    try {
      return await _cameraService.getCameraInfo();
    } catch (e) {
      _logger.e('❌ Error getting camera info: $e');
      return {'error': e.toString()};
    }
  }

  @override
  Future<bool> isCameraAvailable() async {
    try {
      return await _cameraService.isCameraAvailable();
    } catch (e) {
      _logger.e('❌ Error checking camera availability: $e');
      return false;
    }
  }

  @override
  Future<void> closeCamera() async {
    try {
      await _cameraService.closeCamera();
    } catch (e) {
      _logger.e('❌ Error closing camera: $e');
      rethrow;
    }
  }

  @override
  Future<bool> healthCheck() async {
    try {
      return await _cameraService.healthCheck();
    } catch (e) {
      _logger.e('❌ Error in camera health check: $e');
      return false;
    }
  }
}
