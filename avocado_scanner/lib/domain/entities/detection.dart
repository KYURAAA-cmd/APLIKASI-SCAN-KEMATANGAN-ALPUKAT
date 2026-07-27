/// lib/domain/entities/detection.dart
/// 
/// Entity yang merepresentasikan satu deteksi objek dari model ML
/// Pure domain entity, no framework dependencies
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'avocado_class.dart';

part 'detection.g.dart';

/// Merepresentasikan satu detection result dari model
@JsonSerializable()
class Detection extends Equatable {

  const Detection({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.classLabel,
    required this.confidence,
    required this.classIndex,
  });

  /// Create from Map / JSON payload.
  factory Detection.fromMap(Map<String, dynamic> map) => Detection.fromJson(map);
  /// Create from JSON
  factory Detection.fromJson(Map<String, dynamic> json) =>
      _$DetectionFromJson(json);
  /// Bounding box dari deteksi
  final double x;      // Left coordinate
  final double y;      // Top coordinate
  final double width;  // Width
  final double height; // Height

  /// Klasifikasi alpukat
  final AvocadoClass classLabel;

  /// Confidence score (0.0 - 1.0)
  final double confidence;

  /// Class index dari model output
  final int classIndex;
  /// Dapatkan confidence dalam persen (0-100)
  double get confidencePercentage => confidence * 100;

  /// Dapatkan right coordinate
  double get right => x + width;

  /// Dapatkan bottom coordinate
  double get bottom => y + height;

  /// Dapatkan center x
  double get centerX => x + (width / 2);

  /// Dapatkan center y
  double get centerY => y + (height / 2);

  /// Check apakah detection valid
  bool get isValid => width > 0 &&
        height > 0 &&
        confidence >= 0 &&
        confidence <= 1 &&
        classLabel != AvocadoClass.unknown;

  /// Convert to rectangle coordinates (left, top, right, bottom)
  List<double> get rect => [x, y, right, bottom];

  /// Convert to center coordinates (cx, cy, w, h)
  List<double> get centerCoords => [centerX, centerY, width, height];

  /// Clone detection dengan perubahan
  Detection copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    AvocadoClass? classLabel,
    double? confidence,
    int? classIndex,
  }) => Detection(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      classLabel: classLabel ?? this.classLabel,
      confidence: confidence ?? this.confidence,
      classIndex: classIndex ?? this.classIndex,
    );

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$DetectionToJson(this);

  /// Convert to Map for storage and transport.
  Map<String, dynamic> toMap() => toJson();

  @override
  List<Object?> get props => [x, y, width, height, classLabel, confidence, classIndex];

  @override
  String toString() =>
      'Detection(x: $x, y: $y, w: $width, h: $height, class: ${classLabel.displayName}, conf: ${confidence.toStringAsFixed(2)})';
}
