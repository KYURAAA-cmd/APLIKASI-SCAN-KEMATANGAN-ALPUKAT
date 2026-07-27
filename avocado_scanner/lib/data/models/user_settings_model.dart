/// lib/data/models/user_settings_model.dart
/// 
/// Serializable model untuk UserSettings
library;

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_settings.dart';

part 'user_settings_model.g.dart';

@JsonSerializable()
class UserSettingsModel {

  UserSettingsModel({
    required this.confidenceThreshold,
    required this.enableNotifications,
    required this.autoSaveHistory,
    required this.maxHistoryItems,
    required this.themeMode,
    required this.language,
    required this.enableVibration,
    required this.enableSound,
    required this.cameraQuality,
    required this.enableAutoFocus,
  });

  /// Create dari domain entity
  factory UserSettingsModel.fromEntity(UserSettings entity) => UserSettingsModel(
      confidenceThreshold: entity.confidenceThreshold,
      enableNotifications: entity.enableNotifications,
      autoSaveHistory: entity.autoSaveHistory,
      maxHistoryItems: entity.maxHistoryItems,
      themeMode: entity.themeMode,
      language: entity.language,
      enableVibration: entity.enableVibration,
      enableSound: entity.enableSound,
      cameraQuality: entity.cameraQuality,
      enableAutoFocus: entity.enableAutoFocus,
    );

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);
  @JsonKey(name: 'confidence_threshold')
  final double confidenceThreshold;

  @JsonKey(name: 'enable_notifications')
  final bool enableNotifications;

  @JsonKey(name: 'auto_save_history')
  final bool autoSaveHistory;

  @JsonKey(name: 'max_history_items')
  final int maxHistoryItems;

  @JsonKey(name: 'theme_mode')
  final String themeMode;

  @JsonKey(name: 'language')
  final String language;

  @JsonKey(name: 'enable_vibration')
  final bool enableVibration;

  @JsonKey(name: 'enable_sound')
  final bool enableSound;

  @JsonKey(name: 'camera_quality')
  final String cameraQuality;

  @JsonKey(name: 'enable_auto_focus')
  final bool enableAutoFocus;

  /// Convert to domain entity
  UserSettings toEntity() => UserSettings(
      confidenceThreshold: confidenceThreshold,
      enableNotifications: enableNotifications,
      autoSaveHistory: autoSaveHistory,
      maxHistoryItems: maxHistoryItems,
      themeMode: themeMode,
      language: language,
      enableVibration: enableVibration,
      enableSound: enableSound,
      cameraQuality: cameraQuality,
      enableAutoFocus: enableAutoFocus,
    );

  Map<String, dynamic> toJson() => _$UserSettingsModelToJson(this);

  @override
  String toString() =>
      'UserSettingsModel(confidenceThreshold: $confidenceThreshold, theme: $themeMode)';
}
