/// lib/ml/services/post_processing_service.dart
///
/// Service untuk post-processing hasil inferensi dari model YOLOv8.
/// Mengubah output mentah model menjadi daftar objek Detection.
library;

import 'dart:math';
import 'dart:ui';
import '../../app/constants/model_constants.dart';
import '../../domain/entities/avocado_class.dart';
import '../../domain/entities/detection.dart';

class PostProcessingService {
  /// Memproses output mentah dari model TFLite.
  ///
  /// [transposedOutput]: List dari output tensor model, ditranspose menjadi [8400, 8].
  /// [originalImageSize]: Ukuran gambar asli sebelum di-preprocess.
  /// Returns: List dari objek Detection.
  List<Detection> processOutput(
    List<List<double>> transposedOutput,
    Size originalImageSize,
  ) {
    final numBoxes = transposedOutput.length; // 8400
    if (numBoxes == 0) return [];

    const numClasses = ModelConstants.numClasses;

    final rects = <Rect>[];
    final confidences = <double>[];
    final classIndexes = <int>[];

    for (var i = 0; i < numBoxes; i++) {
      final boxData = transposedOutput[i];

      // Ambil confidence score dari semua class
      final classConfidences = boxData.sublist(4);

      // Cari class dengan confidence tertinggi
      var maxConfidence = 0.0;
      var maxClassIndex = -1;

      for (var j = 0; j < numClasses; j++) {
        if (classConfidences[j] > maxConfidence) {
          maxConfidence = classConfidences[j];
          maxClassIndex = j;
        }
      }

      // Filter berdasarkan confidence threshold
      if (maxConfidence > ModelConstants.confidenceThreshold) {
        final cx = boxData[0];
        final cy = boxData[1];
        final w = boxData[2];
        final h = boxData[3];

        // Konversi dari center (cx, cy, w, h) ke (x, y, w, h)
        final x = cx - w / 2;
        final y = cy - h / 2;

        rects.add(Rect.fromLTWH(x, y, w, h));
        confidences.add(maxConfidence);
        classIndexes.add(maxClassIndex);
      }
    }

    // Apply Non-Maximum Suppression (NMS)
    final nmsIndexes = _nonMaximumSuppression(
      rects,
      confidences,
      ModelConstants.iouThreshold,
    );

    // Scale bounding boxes and create Detection objects
    final detections = <Detection>[];
    for (final index in nmsIndexes) {
      final rect = rects[index];
      final confidence = confidences[index];
      final classIndex = classIndexes[index];

      final scaledRect = _scaleBoundingBox(
        rect,
        originalImageSize,
      );

      detections.add(
        Detection(
          x: scaledRect.left,
          y: scaledRect.top,
          width: scaledRect.width,
          height: scaledRect.height,
          confidence: confidence,
          classIndex: classIndex,
          classLabel: AvocadoClass.values[classIndex],
        ),
      );
    }

    return detections;
  }

  /// Melakukan Non-Maximum Suppression untuk menghilangkan bounding box yang tumpang tindih.
  List<int> _nonMaximumSuppression(
      List<Rect> boxes, List<double> scores, double iouThreshold) {
    if (boxes.isEmpty) return [];

    final sortedIndexes = List.generate(scores.length, (i) => i)
      ..sort((a, b) => scores[b].compareTo(scores[a]));

    final selectedIndexes = <int>[];
    final suppressed = List<bool>.filled(boxes.length, false);

    for (var i = 0; i < sortedIndexes.length; i++) {
      final index = sortedIndexes[i];
      if (suppressed[index]) continue;

      selectedIndexes.add(index);

      for (var j = i + 1; j < sortedIndexes.length; j++) {
        final otherIndex = sortedIndexes[j];
        if (suppressed[otherIndex]) continue;

        final iou = _calculateIoU(boxes[index], boxes[otherIndex]);
        if (iou > iouThreshold) {
          suppressed[otherIndex] = true;
        }
      }
    }
    return selectedIndexes;
  }

  double _calculateIoU(Rect a, Rect b) {
    final double intersectionLeft = max(a.left, b.left);
    final double intersectionTop = max(a.top, b.top);
    final double intersectionRight = min(a.right, b.right);
    final double intersectionBottom = min(a.bottom, b.bottom);
    final intersectionArea = max(0, intersectionRight - intersectionLeft) * max(0, intersectionBottom - intersectionTop);
    final unionArea = a.width * a.height + b.width * b.height - intersectionArea;
    return unionArea > 0 ? intersectionArea / unionArea : 0;
  }

  Rect _scaleBoundingBox(Rect box, Size originalImageSize) {
    final inputSize = ModelConstants.inputSize.toDouble();
    final double gain = min(inputSize / originalImageSize.width, inputSize / originalImageSize.height);
    final padX = (inputSize - originalImageSize.width * gain) / 2;
    final padY = (inputSize - originalImageSize.height * gain) / 2;
    final x1 = (box.left - padX) / gain;
    final y1 = (box.top - padY) / gain;
    final x2 = (box.right - padX) / gain;
    final y2 = (box.bottom - padY) / gain;
    return Rect.fromLTRB(
      x1.clamp(0, originalImageSize.width),
      y1.clamp(0, originalImageSize.height),
      x2.clamp(0, originalImageSize.width),
      y2.clamp(0, originalImageSize.height),
    );
  }
}