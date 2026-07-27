/// lib/data/models/scan_result_model.dart
///
/// Model data untuk ScanResult yang berinteraksi dengan database.
/// Bertanggung jawab untuk konversi dari/ke format Map database dan JSON.
library;

import 'dart:convert';
import 'package:avocado_scanner/domain/entities/scan_result.dart';
import '../database/db_schema.dart';

/// Model yang merepresentasikan ScanResult di layer data.
class ScanResultModel extends ScanResult {
  const ScanResultModel({
    required super.scanDate, required super.imagePath, required super.detections, required super.mainClass, required super.mainConfidence, required super.inferenceTimeMs, required super.imageWidth, required super.imageHeight, super.id,
    super.fps,
    super.notes,
  });

  /// Factory constructor dari Map (data dari database).
  factory ScanResultModel.fromMap(Map<String, dynamic> map) {
    final detectionsList = jsonDecode(map[DbSchema.colDetections] as String) as List;
    final detections = detectionsList
        .map((item) => Detection.fromMap(item as Map<String, dynamic>))
        .toList();

    return ScanResultModel(
      id: map[DbSchema.colId] as int?,
      scanDate: DateTime.parse(map[DbSchema.colScanDate] as String),
      imagePath: map[DbSchema.colImagePath] as String,
      detections: detections,
      mainClass: AvocadoClassExtension.fromString(map[DbSchema.colMainClass] as String),
      mainConfidence: (map[DbSchema.colMainConfidence] as num).toDouble(),
      inferenceTimeMs: (map[DbSchema.colInferenceTimeMs] as num).toInt(),
      imageWidth: (map[DbSchema.colImageWidth] as num).toInt(),
      imageHeight: (map[DbSchema.colImageHeight] as num).toInt(),
      fps: map[DbSchema.colFps] == null ? null : (map[DbSchema.colFps] as num).toDouble(),
      notes: map[DbSchema.colNotes] as String?,
    );
  }
  
  /// Factory constructor dari JSON/Map.
  factory ScanResultModel.fromJson(Map<String, dynamic> json) => ScanResultModel.fromMap(json);
  
  /// Factory constructor dari domain entity ScanResult.
  factory ScanResultModel.fromEntity(ScanResult entity) => ScanResultModel(
      id: entity.id,
      scanDate: entity.scanDate,
      imagePath: entity.imagePath,
      detections: entity.detections,
      mainClass: entity.mainClass,
      mainConfidence: entity.mainConfidence,
      inferenceTimeMs: entity.inferenceTimeMs,
      imageWidth: entity.imageWidth,
      imageHeight: entity.imageHeight,
      fps: entity.fps,
      notes: entity.notes,
    );

  /// Konversi ke domain entity ScanResult.
  ScanResult toEntity() => ScanResult(
      id: id,
      scanDate: scanDate,
      imagePath: imagePath,
      detections: detections,
      mainClass: mainClass,
      mainConfidence: mainConfidence,
      inferenceTimeMs: inferenceTimeMs,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      fps: fps,
      notes: notes,
    );

  /// Konversi ke Map untuk disimpan ke database.
  Map<String, dynamic> toMap() => {
      DbSchema.colId: id,
      DbSchema.colScanDate: scanDate.toIso8601String(),
      DbSchema.colImagePath: imagePath,
      DbSchema.colDetections: jsonEncode(detections.map((d) => d.toMap()).toList()),
      DbSchema.colMainClass: mainClass.name,
      DbSchema.colMainConfidence: mainConfidence,
      DbSchema.colInferenceTimeMs: inferenceTimeMs,
      DbSchema.colImageWidth: imageWidth,
      DbSchema.colImageHeight: imageHeight,
      DbSchema.colFps: fps,
      DbSchema.colNotes: notes,
      DbSchema.colCreatedAt: DateTime.now().toIso8601String(),
    };
}