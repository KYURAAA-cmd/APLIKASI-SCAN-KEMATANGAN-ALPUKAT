/// lib/presentation/providers/scan_provider.dart
///
/// Provider untuk mengelola state dan logika bisnis terkait proses scanning.
library;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/scan_result.dart';
import '../../ml/services/ml_inference_service.dart';
import 'history_provider.dart';
import 'view_state.dart';

class ScanProvider extends ChangeNotifier {

  ScanProvider({
    required MLInferenceService mlService,
    required HistoryProvider historyProvider,
  })  : _mlService = mlService,
        _historyProvider = historyProvider;
  final MLInferenceService _mlService;
  final HistoryProvider _historyProvider;
  final ImagePicker _imagePicker = ImagePicker();
  final Logger _logger = Logger();

  // Private state
  ViewState _state = ViewState.idle;
  String _errorMessage = '';
  ScanResult? _lastScanResult;

  // Public getters
  ViewState get state => _state;
  String get errorMessage => _errorMessage;
  ScanResult? get lastScanResult => _lastScanResult;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Memilih gambar dari galeri, menjalankan inferensi, dan menyimpan hasilnya.
  /// Mengembalikan [ScanResult] jika berhasil, atau `null` jika gagal atau dibatalkan.
  Future<ScanResult?> scanImageFromGallery() async {
    _setState(ViewState.loading);
    try {
      final imageFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );

      if (imageFile == null) {
        _setState(ViewState.idle);
        return null; // User cancelled the picker
      }

      _logger.i('🖼️ Image picked from gallery: ${imageFile.path}');

      final scanResult = await _mlService.runInferenceOnImage(imageFile.path);
      _lastScanResult = scanResult;

      // Simpan ke riwayat hanya jika deteksi valid
      if (scanResult.isValid) {
        await _historyProvider.saveHistoryItem(scanResult);
        _logger.i('✅ Scan result saved to history.');
      }

      _setState(ViewState.success);
      return scanResult;
    } catch (e, stackTrace) {
      _logger.e('❌ Error during gallery scan', error: e, stackTrace: stackTrace);
      _errorMessage = 'Gagal menganalisis gambar: ${e.toString()}';
      _setState(ViewState.error);
      return null;
    }
  }

  /// Menjalankan inferensi pada gambar dari path yang diberikan.
  /// Mengembalikan [ScanResult] jika berhasil, atau `null` jika gagal.
  Future<ScanResult?> scanImageFromPath(String imagePath) async {
    _setState(ViewState.loading);
    try {
      _logger.i('🖼️ Menganalisis gambar dari path: $imagePath');

      final scanResult = await _mlService.runInferenceOnImage(imagePath);
      _lastScanResult = scanResult;

      // Simpan ke riwayat hanya jika deteksi valid
      if (scanResult.isValid) {
        await _historyProvider.saveHistoryItem(scanResult);
        _logger.i('✅ Hasil pindaian disimpan ke riwayat.');
      }

      _setState(ViewState.success);
      return scanResult;
    } catch (e, stackTrace) {
      _logger.e('❌ Error saat pindaian dari path', error: e, stackTrace: stackTrace);
      _errorMessage = 'Gagal menganalisis gambar: ${e.toString()}';
      _setState(ViewState.error);
      return null;
    }
  }
}