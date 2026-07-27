/// lib/domain/entities/user_settings.dart
/// 
/// Entity untuk user settings
/// Pure domain entity, no framework dependencies
library;

import 'package:equatable/equatable.dart';

/// User settings dan preferences
class UserSettings extends Equatable {

  const UserSettings({
    this.confidenceThreshold = 0.5,
    this.enableNotifications = true,
    this.autoSaveHistory = true,
    this.maxHistoryItems = 100,
    this.themeMode = 'auto',
    this.language = 'id',
    this.enableVibration = true,
    this.enableSound = true,
    this.cameraQuality = 'high',
    this.enableAutoFocus = true,
  });

  /// Create dari map
  factory UserSettings.fromMap(Map<String, dynamic> map) => UserSettings(
      confidenceThreshold:
          (map['confidenceThreshold'] as num?)?.toDouble() ?? 0.5,
      enableNotifications: (map['enableNotifications'] as bool?) ?? true,
      autoSaveHistory: (map['autoSaveHistory'] as bool?) ?? true,
      maxHistoryItems: (map['maxHistoryItems'] as num?)?.toInt() ?? 100,
      themeMode: (map['themeMode'] as String?) ?? 'auto',
      language: (map['language'] as String?) ?? 'id',
      enableVibration: (map['enableVibration'] as bool?) ?? true,
      enableSound: (map['enableSound'] as bool?) ?? true,
      cameraQuality: (map['cameraQuality'] as String?) ?? 'high',
      enableAutoFocus: (map['enableAutoFocus'] as bool?) ?? true,
    );
  /// Confidence threshold untuk filtering (0.0 - 1.0)
  final double confidenceThreshold;

  /// Enable notifikasi
  final bool enableNotifications;

  /// Save scan history secara otomatis
  final bool autoSaveHistory;

  /// Max history items disimpan
  final int maxHistoryItems;

  /// Theme mode (light/dark/auto)
  final String themeMode;

  /// Language setting
  final String language;

  /// Enable vibration feedback
  final bool enableVibration;

  /// Enable sound feedback
  final bool enableSound;

  /// Camera resolution quality (low/medium/high)
  final String cameraQuality;

  /// Auto-focus enabled
  final bool enableAutoFocus;

  /// Create default settings
  static const UserSettings defaultSettings = UserSettings();

  /// Clone dengan perubahan
  UserSettings copyWith({
    double? confidenceThreshold,
    bool? enableNotifications,
    bool? autoSaveHistory,
    int? maxHistoryItems,
    String? themeMode,
    String? language,
    bool? enableVibration,
    bool? enableSound,
    String? cameraQuality,
    bool? enableAutoFocus,
  }) => UserSettings(
      confidenceThreshold: confidenceThreshold ?? this.confidenceThreshold,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      autoSaveHistory: autoSaveHistory ?? this.autoSaveHistory,
      maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      enableVibration: enableVibration ?? this.enableVibration,
      enableSound: enableSound ?? this.enableSound,
      cameraQuality: cameraQuality ?? this.cameraQuality,
      enableAutoFocus: enableAutoFocus ?? this.enableAutoFocus,
    );

  /// Convert ke map
  Map<String, dynamic> toMap() => {
      'confidenceThreshold': confidenceThreshold,
      'enableNotifications': enableNotifications,
      'autoSaveHistory': autoSaveHistory,
      'maxHistoryItems': maxHistoryItems,
      'themeMode': themeMode,
      'language': language,
      'enableVibration': enableVibration,
      'enableSound': enableSound,
      'cameraQuality': cameraQuality,
      'enableAutoFocus': enableAutoFocus,
    };

  @override
  List<Object?> get props => [
        confidenceThreshold,
        enableNotifications,
        autoSaveHistory,
        maxHistoryItems,
        themeMode,
        language,
        enableVibration,
        enableSound,
        cameraQuality,
        enableAutoFocus,
      ];

  @override
  String toString() =>
      'UserSettings(confidenceThreshold: $confidenceThreshold, theme: $themeMode, language: $language)';
}
