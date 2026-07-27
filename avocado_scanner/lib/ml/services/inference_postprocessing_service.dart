/// lib/ml/services/inference_postprocessing_service.dart
///
/// Service untuk post-processing output dari model TFLite.
///
/// Tanggung Jawab:
/// - Mem-parsing format output YOLOv8.
/// - Melakukan Non-Maximum Suppression (NMS) untuk menghilangkan deteksi yang tumpang tindih.
/// - Melakukan filter berdasarkan confidence score.
/// - Memetakan koordinat dari ukuran model ke ukuran gambar asli.
/// - Mengonversi hasil mentah menjadi List<Detection>.
library;

import 'dart:math';
import 'package:logger/logger.dart';
import '../../app/constants/model_constants.dart';
import '../../domain/entities/avocado_class.dart';
import '../../domain/entities/detection.dart';

/// Service untuk post-processing hasil inferensi.
class InferencePostprocessingService {
  final Logger _logger = Logger();

  /// Threshold untuk NMS (Intersection over Union).
  static const double iouThreshold = 0.5;

  /// Threshold confidence dasar.
  static const double confidenceThreshold = 0.25;

  /// Melakukan post-process pada output inferensi YOLOv8.
  List<Detection> postProcessYOLOv8(
    List<dynamic> inferenceOutput, {
    required int imageWidth,
    required int imageHeight,
    required int modelInputWidth,
    required int modelInputHeight,
  }) {
    try {
      _logger.d('🔄 Memulai post-processing output YOLOv8...');

      final detections = <Detection>[];

      // Parse output mentah. Asumsi output shape [1, 8400, 8] untuk model dengan 4 kelas.
      final rawOutput = inferenceOutput[0] as List<List<dynamic>>;

      for (final row in rawOutput) {
        // Format output YOLOv8 diasumsikan: [x, y, w, h, score_class_0, score_class_1, ...]
        // Dapatkan semua skor kelas.
        final classScores = <double>[];
        // Skor kelas dimulai dari indeks ke-4.
        for (var i = 4; i < row.length; i++) {
          classScores.add((row[i] as num).toDouble());
        }

        // Jika tidak ada skor kelas, lewati deteksi ini.
        if (classScores.isEmpty) {
          continue;
        }

        // Cari kelas dengan skor tertinggi dari semua kelas yang ada.
        var bestClassScore = classScores[0];
        var bestClassIndex = 0;
        for (var i = 1; i < classScores.length; i++) {
          if (classScores[i] > bestClassScore) {
            bestClassScore = classScores[i];
            bestClassIndex = i; // Indeks relatif terhadap classScores
          }
        }

        // Filter berdasarkan confidence score tertinggi yang ditemukan.
        if (bestClassScore < confidenceThreshold) {
          continue;
        }

        // Terapkan threshold confidence spesifik per kelas jika ada.
        final classThreshold =
            ModelConstants.classConfidenceThresholds[bestClassIndex] ??
                confidenceThreshold;
        if (bestClassScore < classThreshold) {
          continue;
        }

        // Konversi koordinat YOLO ke koordinat piksel
        // YOLO: [center_x, center_y, width, height] (ternormalisasi)
        final centerX = (row[0] as num).toDouble();
        final centerY = (row[1] as num).toDouble();
        final w = (row[2] as num).toDouble();
        final h = (row[3] as num).toDouble();

        // Konversi ke bounding box [x, y, w, h] (piksel, relatif terhadap input model)
        final left = (centerX - w / 2) * modelInputWidth;
        final top = (centerY - h / 2) * modelInputHeight;
        final detWidth = w * modelInputWidth;
        final detHeight = h * modelInputHeight;

        // Skalakan ke ukuran gambar asli, dengan mempertimbangkan letterboxing
        final scale = min(modelInputWidth / imageWidth, modelInputHeight / imageHeight);
        final scaledW = detWidth / scale;
        final scaledH = detHeight / scale;
        final scaledX = (left - (modelInputWidth - imageWidth * scale) / 2) / scale;
        final scaledY = (top - (modelInputHeight - imageHeight * scale) / 2) / scale;

        // Buat objek Detection
        final detection = Detection(
          x: scaledX,
          y: scaledY,
          width: scaledW.clamp(0, imageWidth).toDouble(),
          height: scaledH.clamp(0, imageHeight).toDouble(),
          classLabel: AvocadoClassExtension.fromString(_getClassName(bestClassIndex)),
          confidence: bestClassScore,
          classIndex: bestClassIndex,
        );

        if (detection.isValid) {
          detections.add(detection);
        }
      }

      _logger.d('✓ Menemukan ${detections.length} deteksi mentah.');

      // Terapkan Non-Maximum Suppression
      final finalDetections = _applyNMS(detections);

      _logger.d('✅ Post-processing selesai, ${finalDetections.length} deteksi final.');
      return finalDetections;
    } catch (e, stacktrace) {
      _logger.e('❌ Error saat post-processing output: $e', stackTrace: stacktrace);
      return [];
    }
  }

  /// Menerapkan Non-Maximum Suppression untuk menghilangkan bounding box yang tumpang tindih.
  List<Detection> _applyNMS(List<Detection> detections, {double threshold = iouThreshold}) {
    if (detections.isEmpty) return [];

    _logger.d('🔍 Menerapkan NMS dengan threshold: $threshold');

    // Urutkan berdasarkan confidence secara menurun
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));

    final keptDetections = <Detection>[];
    final suppressed = List<bool>.filled(detections.length, false);

    for (var i = 0; i < detections.length; i++) {
      if (suppressed[i]) continue;

      keptDetections.add(detections[i]);

      for (var j = i + 1; j < detections.length; j++) {
        if (suppressed[j]) continue;

        final iou = _calculateIoU(detections[i], detections[j]);
        if (iou > threshold) {
          suppressed[j] = true;
        }
      }
    }

    _logger.d('✓ NMS memfilter menjadi ${keptDetections.length} deteksi.');
    return keptDetections;
  }

  /// Menghitung Intersection over Union (IoU) antara dua deteksi.
  double _calculateIoU(Detection det1, Detection det2) {
    // Hitung area interseksi
    final ix1 = max(det1.x, det2.x);
    final iy1 = max(det1.y, det2.y);
    final ix2 = min(det1.right, det2.right);
    final iy2 = min(det1.bottom, det2.bottom);

    final intersectionWidth = max(0, ix2 - ix1);
    final intersectionHeight = max(0, iy2 - iy1);
    final intersectionArea = intersectionWidth * intersectionHeight;

    // Hitung area union
    final box1Area = det1.width * det1.height;
    final box2Area = det2.width * det2.height;
    final unionArea = box1Area + box2Area - intersectionArea;

    if (unionArea == 0) return 0;

    return intersectionArea / unionArea;
  }

  /// Mendapatkan nama kelas dari indeksnya.
  String _getClassName(int classIndex) {
    const labels = ModelConstants.classLabels;
    if (classIndex >= 0 && classIndex < labels.length) {
      return labels[classIndex];
    }
    return 'Unknown';
  }

  /// Memfilter deteksi berdasarkan confidence.
  List<Detection> filterByConfidence(List<Detection> detections, double minConfidence) {
    _logger.d('🔎 Memfilter deteksi dengan confidence >= $minConfidence');
    final filtered = detections.where((d) => d.confidence >= minConfidence).toList();
    _logger.d('✓ Difilter menjadi ${filtered.length} deteksi.');
    return filtered;
  }

  /// Memfilter deteksi berdasarkan kelas.
  List<Detection> filterByClass(List<Detection> detections, String className) {
    _logger.d('🔎 Memfilter deteksi berdasarkan kelas: $className');
    final filtered = detections.where((d) => d.classLabel.name == className).toList();
    _logger.d('✓ Difilter menjadi ${filtered.length} deteksi.');
    return filtered;
  }

  /// Mendapatkan deteksi terbaik (confidence tertinggi).
  Detection? getBestDetection(List<Detection> detections) {
    if (detections.isEmpty) return null;
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));
    return detections.first;
  }

  /// Mendapatkan statistik dari deteksi.
  Map<String, dynamic> getStatistics(List<Detection> detections) {
    if (detections.isEmpty) {
      return {
        'totalDetections': 0,
        'avgConfidence': 0.0,
        'maxConfidence': 0.0,
        'minConfidence': 0.0,
        'classDistribution': <String, int>{},
      };
    }

    final totalConf = detections.fold<double>(0, (sum, d) => sum + d.confidence);
    final avgConf = totalConf / detections.length;

    final distribution = <String, int>{};
    for (final detection in detections) {
      final key = detection.classLabel.displayName;
      distribution[key] = (distribution[key] ?? 0) + 1;
    }

    return {
      'totalDetections': detections.length,
      'avgConfidence': avgConf,
      'maxConfidence': detections.map((d) => d.confidence).reduce(max),
      'minConfidence': detections.map((d) => d.confidence).reduce(min),
      'classDistribution': distribution,
    };
  }
}