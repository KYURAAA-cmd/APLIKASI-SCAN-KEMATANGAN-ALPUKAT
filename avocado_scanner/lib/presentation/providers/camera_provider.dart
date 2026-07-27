/// lib/presentation/providers/camera_provider.dart
///
/// Provider untuk mengelola state dan logika bisnis terkait kamera dan
/// inferensi real-time.
library;

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/detection.dart';
import '../../domain/repositories/camera_repository.dart';
import '../../ml/services/ml_inference_service.dart';
import 'view_state.dart';

class CameraProvider extends ChangeNotifier {

  CameraProvider({
    required CameraRepository cameraRepository,
    required MLInferenceService mlService,
  })  : _cameraRepository = cameraRepository,
        _mlService = mlService;
  final CameraRepository _cameraRepository;
  final MLInferenceService _mlService;
  final Logger _logger = Logger();

  // State
  ViewState _state = ViewState.idle;
  String _errorMessage = '';
  List<Detection> _detections = [];
  Size _imageSize = Size.zero;
  double _fps = 0;
  int _inferenceTimeMs = 0;
  bool _isDetecting = false;

  // Getters
  ViewState get state => _state;
  String get errorMessage => _errorMessage;
  CameraController? get cameraController => _cameraRepository.cameraController;
  List<Detection> get detections => _detections;
  Size get imageSize => _imageSize;
  double get fps => _fps;
  int get inferenceTimeMs => _inferenceTimeMs;
  bool get isCameraInitialized => cameraController?.value.isInitialized ?? false;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Menginisialisasi kamera dan service ML.
  Future<void> initialize() async {
    if (isCameraInitialized) return;

    _setState(ViewState.loading);
    try {
      await _mlService.initialize();
      final cameraInitialized = await _cameraRepository.initializeCamera();

      if (cameraInitialized) {
        _setState(ViewState.success);
        _logger.i('✅ CameraProvider berhasil diinisialisasi.');
      } else {
        _errorMessage = 'Gagal menginisialisasi kamera. Pastikan izin telah diberikan.';
        _setState(ViewState.error);
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _logger.e('❌ Gagal menginisialisasi CameraProvider: $e');
      _setState(ViewState.error);
    }
  }

  /// Memulai stream kamera dan deteksi real-time.
  Future<void> startStreaming() async {
    if (!isCameraInitialized || (cameraController?.value.isStreamingImages ?? false)) {
      return;
    }

    _isDetecting = false;
    await cameraController!.startImageStream((image) {
      if (_isDetecting) return;

      _isDetecting = true;
      try {
        final result = _mlService.runInferenceOnFrame(image);
        if (result != null) {
          _detections = result.$1;
          _imageSize = result.$2;
          _inferenceTimeMs = result.$3;
          _fps = 1000 / (result.$3 == 0 ? 1 : result.$3); // Hindari pembagian dengan nol
          notifyListeners();
        }
      } catch (e) {
        _logger.e('❌ Error saat inferensi frame: $e');
      } finally {
        _isDetecting = false;
      }
    });
    _logger.i('🎥 Stream kamera dimulai.');
    notifyListeners();
  }

  /// Menghentikan stream kamera.
  Future<void> stopStreaming() async {
    if (!isCameraInitialized || !(cameraController?.value.isStreamingImages ?? false)) {
      return;
    }
    await cameraController!.stopImageStream();
    _detections = [];
    _fps = 0.0;
    _logger.i('🛑 Stream kamera dihentikan.');
    notifyListeners();
  }

  @override
  void dispose() {
    stopStreaming();
    _cameraRepository.closeCamera();
    _logger.i('CameraProvider dibersihkan.');
    super.dispose();
  }
}