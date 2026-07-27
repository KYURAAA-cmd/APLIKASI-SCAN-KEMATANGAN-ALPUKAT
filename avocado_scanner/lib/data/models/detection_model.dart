/// lib/data/models/detection_model.dart
/// 
/// Serializable model untuk Detection
/// Extends domain entity untuk serialization
library;

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/avocado_class.dart';
import '../../domain/entities/detection.dart';

part 'detection_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DetectionModel {

  DetectionModel({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.classLabel,
    required this.confidence,
    required this.classIndex,
  });

  /// Create dari domain entity
  factory DetectionModel.fromEntity(Detection entity) => DetectionModel(
      x: entity.x,
      y: entity.y,
      width: entity.width,
      height: entity.height,
      classLabel: entity.classLabel.name,
      confidence: entity.confidence,
      classIndex: entity.classIndex,
    );

  factory DetectionModel.fromJson(Map<String, dynamic> json) =>
      _$DetectionModelFromJson(json);
  @JsonKey(name: 'x')
  final double x;

  @JsonKey(name: 'y')
  final double y;

  @JsonKey(name: 'width')
  final double width;

  @JsonKey(name: 'height')
  final double height;

  @JsonKey(name: 'class_label')
  final String classLabel;

  @JsonKey(name: 'confidence')
  final double confidence;

  @JsonKey(name: 'class_index')
  final int classIndex;

  /// Convert to domain entity
  Detection toEntity() => Detection(
      x: x,
      y: y,
      width: width,
      height: height,
      classLabel: AvocadoClassExtension.fromString(classLabel),
      confidence: confidence,
      classIndex: classIndex,
    );

  Map<String, dynamic> toJson() => _$DetectionModelToJson(this);

  @override
  String toString() =>
      'DetectionModel(class: $classLabel, conf: ${confidence.toStringAsFixed(2)})';
}
