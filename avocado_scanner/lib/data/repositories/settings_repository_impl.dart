/// lib/data/repositories/settings_repository_impl.dart
/// 
/// Concrete implementation dari SettingsRepository
/// Mengelola user preferences dengan SharedPreferences
library;

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/constants/app_constants.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Concrete implementation dari SettingsRepository
class SettingsRepositoryImpl implements SettingsRepository {
  final Logger _logger = Logger();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  /// Initialize repository
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _logger.i('⚙️ Initializing SettingsRepositoryImpl...');

      _prefs = await SharedPreferences.getInstance();

      _isInitialized = true;
      _logger.i('✅ SettingsRepositoryImpl initialized');
    } catch (e) {
      _logger.e('❌ Error initializing SettingsRepositoryImpl: $e');
      rethrow;
    }
  }

  /// Get user settings
  @override
  Future<UserSettings> getUserSettings() async {
    try {
      if (!_isInitialized) {
        throw StateError(
          'Repository not initialized. Call initialize() first.',
        );
      }

      _logger.d('🔎 Getting user settings...');

      final jsonString =
          _prefs.getString(AppConstants.spKeyUserSettings);

      if (jsonString == null) {
        _logger.d('Using default settings');
        return UserSettings.defaultSettings;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final settings = UserSettings.fromMap(json);

      _logger.d('✓ Settings retrieved');
      return settings;
    } catch (e) {
      _logger.e('❌ Error getting settings: $e');
      return UserSettings.defaultSettings;
    }
  }

  /// Update settings
  @override
  Future<void> updateSettings(UserSettings settings) async {
    try {
      if (!_isInitialized) {
        throw StateError(
          'Repository not initialized. Call initialize() first.',
        );
      }

      _logger.i('✏️ Updating user settings...');

      final json = settings.toMap();
      final jsonString = jsonEncode(json);

      await _prefs.setString(AppConstants.spKeyUserSettings, jsonString);

      _logger.i('✅ Settings updated');
    } catch (e) {
      _logger.e('❌ Error updating settings: $e');
      rethrow;
    }
  }

  /// Get single setting value
  @override
  Future<dynamic> getSettingValue(String key) async {
    try {
      _logger.d('🔎 Getting setting value for key: $key');

      final settings = await getUserSettings();

      switch (key) {
        case 'confidenceThreshold':
          return settings.confidenceThreshold;
        case 'enableNotifications':
          return settings.enableNotifications;
        case 'autoSaveHistory':
          return settings.autoSaveHistory;
        case 'maxHistoryItems':
          return settings.maxHistoryItems;
        case 'themeMode':
          return settings.themeMode;
        case 'language':
          return settings.language;
        case 'enableVibration':
          return settings.enableVibration;
        case 'enableSound':
          return settings.enableSound;
        case 'cameraQuality':
          return settings.cameraQuality;
        case 'enableAutoFocus':
          return settings.enableAutoFocus;
        default:
          _logger.w('Unknown setting key: $key');
          return null;
      }
    } catch (e) {
      _logger.e('❌ Error getting setting value: $e');
      return null;
    }
  }

  /// Set single setting value
  @override
  Future<void> setSettingValue(String key, dynamic value) async {
    try {
      _logger.i('⚙️ Setting value for key: $key');

      final settings = await getUserSettings();

      final updated = switch (key) {
        'confidenceThreshold' =>
          settings.copyWith(confidenceThreshold: value as double),
        'enableNotifications' =>
          settings.copyWith(enableNotifications: value as bool),
        'autoSaveHistory' =>
          settings.copyWith(autoSaveHistory: value as bool),
        'maxHistoryItems' =>
          settings.copyWith(maxHistoryItems: value as int),
        'themeMode' => settings.copyWith(themeMode: value as String),
        'language' => settings.copyWith(language: value as String),
        'enableVibration' =>
          settings.copyWith(enableVibration: value as bool),
        'enableSound' => settings.copyWith(enableSound: value as bool),
        'cameraQuality' =>
          settings.copyWith(cameraQuality: value as String),
        'enableAutoFocus' =>
          settings.copyWith(enableAutoFocus: value as bool),
        _ => settings,
      };

      await updateSettings(updated);
    } catch (e) {
      _logger.e('❌ Error setting value: $e');
      rethrow;
    }
  }

  /// Reset to defaults
  @override
  Future<void> resetToDefaults() async {
    try {
      _logger.w('⚠️ Resetting settings to defaults...');

      await updateSettings(UserSettings.defaultSettings);

      _logger.i('✅ Settings reset to defaults');
    } catch (e) {
      _logger.e('❌ Error resetting settings: $e');
      rethrow;
    }
  }

  /// Export settings
  @override
  Future<String> exportSettings() async {
    try {
      _logger.i('📤 Exporting settings...');

      final settings = await getUserSettings();
      final json = settings.toMap();
      final jsonString = jsonEncode(json);

      _logger.i('✅ Settings exported');
      return jsonString;
    } catch (e) {
      _logger.e('❌ Error exporting settings: $e');
      rethrow;
    }
  }

  /// Import settings
  @override
  Future<void> importSettings(String jsonString) async {
    try {
      _logger.i('📥 Importing settings...');

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final settings = UserSettings.fromMap(json);

      await updateSettings(settings);

      _logger.i('✅ Settings imported');
    } catch (e) {
      _logger.e('❌ Error importing settings: $e');
      rethrow;
    }
  }

  /// Delete all settings
  @override
  Future<void> deleteAllSettings() async {
    try {
      _logger.w('⚠️ Deleting all settings...');

      await _prefs.remove(AppConstants.spKeyUserSettings);

      _logger.i('✅ All settings deleted');
    } catch (e) {
      _logger.e('❌ Error deleting settings: $e');
      rethrow;
    }
  }
}
