/// lib/domain/repositories/settings_repository.dart
/// 
/// Abstract repository untuk user settings
/// Interface untuk preferences management
library;

import '../entities/user_settings.dart';

/// Abstract repository untuk settings
abstract class SettingsRepository {
  /// Get user settings
  Future<UserSettings> getUserSettings();

  /// Update settings
  Future<void> updateSettings(UserSettings settings);

  /// Get single setting value
  Future<dynamic> getSettingValue(String key);

  /// Set single setting value
  Future<void> setSettingValue(String key, dynamic value);

  /// Reset to defaults
  Future<void> resetToDefaults();

  /// Export settings
  Future<String> exportSettings();

  /// Import settings
  Future<void> importSettings(String jsonString);

  /// Delete all settings
  Future<void> deleteAllSettings();
}
