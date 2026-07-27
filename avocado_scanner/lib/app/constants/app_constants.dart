/// lib/app/constants/app_constants.dart
/// 
/// Konstanta aplikasi global
library;

class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // App Info
  static const String appName = 'Avocado Ripeness Scanner';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API & Network
  static const int connectionTimeout = 30000; // ms
  static const int receiveTimeout = 30000; // ms

  // Database
  static const String databaseName = 'avocado_scanner.db';
  static const int databaseVersion = 1;

  // Shared Preferences
  static const String spKeyConfidenceThreshold = 'confidence_threshold';
  static const String spKeyThemeMode = 'theme_mode';
  static const String spKeyLanguage = 'language';
  static const String spKeyEnableNotifications = 'enable_notifications';
  static const String spKeyUserSettings = 'user_settings';
  static const String spKeyLastScanDate = 'last_scan_date';

  // Default values
  static const double defaultConfidenceThreshold = 0.5;
  static const int defaultMaxHistoryItems = 100;

  // UI Constants
  static const double defaultBorderRadius = 16;
  static const double defaultPadding = 16;
  static const double defaultMargin = 16;
  static const double defaultElevation = 4;

  // Animation & Duration
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // Splash Screen
  static const Duration splashScreenDuration = Duration(seconds: 3);

  // Camera
  static const double cameraAspectRatio = 9 / 16;
  static const int cameraFps = 30;

  // ML Model
  static const int mlModelInputSize = 640;
  static const double mlModelConfidenceThreshold = 0.25;
  static const double mlModelIouThreshold = 0.5;

  // Error Messages
  static const String cameraPermissionDenied = 'Camera permission denied';
  static const String modelLoadingFailed = 'Failed to load ML model';
  static const String imageLoadingFailed = 'Failed to load image';
  static const String inferenceTimeout = 'Inference timeout';
  static const String noAvocadoDetected = 'No avocado detected';
  static const String databaseError = 'Database error occurred';

  // Success Messages
  static const String scanSuccessful = 'Scan successful';
  static const String historySaved = 'History saved successfully';
  static const String historyDeleted = 'History deleted successfully';

  // Regex & Validation
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // File sizes
  static const int maxImageSize = 10 * 1024 * 1024; // 10 MB

  // Common paths
  static const String assetsPath = 'assets/';
  static const String imagesPath = 'assets/images/';
  static const String modelsPath = 'assets/model/';
  static const String iconsPath = 'assets/icons/';
}
