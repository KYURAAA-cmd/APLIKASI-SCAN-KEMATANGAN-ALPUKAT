/// lib/domain/entities/scan_result.dart
/// 
/// Entity yang merepresentasikan hasil scan dari aplikasi
/// Pure domain entity, no framework dependencies
library;

import 'package:equatable/equatable.dart';
import 'avocado_class.dart';
import 'detection.dart';

export 'avocado_class.dart';
export 'detection.dart';

/// Merepresentasikan hasil scan lengkap
class ScanResult extends Equatable {

  const ScanResult({
    required this.scanDate, required this.imagePath, required this.detections, required this.mainClass, required this.mainConfidence, required this.inferenceTimeMs, required this.imageWidth, required this.imageHeight, this.id,
    this.mainDetection,
    this.fps,
    this.notes,
  });
  /// ID hasil scan (null jika belum disimpan)
  final int? id;

  /// Waktu scan
  final DateTime scanDate;

  /// Path gambar yang di-scan (local path)
  final String imagePath;

  /// List deteksi yang ditemukan
  final List<Detection> detections;

  /// Deteksi utama (dengan confidence tertinggi)
  final Detection? mainDetection;

  /// Klasifikasi utama
  final AvocadoClass mainClass;

  /// Confidence score deteksi utama
  final double mainConfidence;

  /// Durasi inferensi (dalam millisecond)
  final int inferenceTimeMs;

  /// Ukuran gambar original (width, height)
  final int imageWidth;
  final int imageHeight;

  /// FPS pada saat scan
  final double? fps;

  /// Catatan atau tags tambahan
  final String? notes;

  /// Apakah ada deteksi
  bool get hasDetections => detections.isNotEmpty;

  /// Jumlah deteksi
  int get detectionCount => detections.length;

  /// Confidence dalam persen
  double get mainConfidencePercentage => mainConfidence * 100;

  /// Apakah hasil scan valid
  bool get isValid => hasDetections && mainClass != AvocadoClass.unknown;

  /// Dapatkan formatted timestamp
  String get formattedDate => scanDate.toString().split('.')[0];

  /// Dapatkan inferensi time dalam detik
  double get inferenceTimeSec => inferenceTimeMs / 1000.0;

  /// Clone dengan perubahan
  ScanResult copyWith({
    int? id,
    DateTime? scanDate,
    String? imagePath,
    List<Detection>? detections,
    Detection? mainDetection,
    AvocadoClass? mainClass,
    double? mainConfidence,
    int? inferenceTimeMs,
    int? imageWidth,
    int? imageHeight,
    double? fps,
    String? notes,
  }) => ScanResult(
      id: id ?? this.id,
      scanDate: scanDate ?? this.scanDate,
      imagePath: imagePath ?? this.imagePath,
      detections: detections ?? this.detections,
      mainDetection: mainDetection ?? this.mainDetection,
      mainClass: mainClass ?? this.mainClass,
      mainConfidence: mainConfidence ?? this.mainConfidence,
      inferenceTimeMs: inferenceTimeMs ?? this.inferenceTimeMs,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
      fps: fps ?? this.fps,
      notes: notes ?? this.notes,
    );

  @override
  List<Object?> get props => [
        id,
        scanDate,
        imagePath,
        detections,
        mainDetection,
        mainClass,
        mainConfidence,
        inferenceTimeMs,
        imageWidth,
        imageHeight,
        fps,
        notes,
      ];

  @override
  String toString() =>
      'ScanResult(id: $id, class: ${mainClass.displayName}, conf: ${mainConfidence.toStringAsFixed(2)}, detections: $detectionCount)';
}
