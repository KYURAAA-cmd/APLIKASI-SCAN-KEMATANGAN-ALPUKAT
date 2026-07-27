# Repository Layer - Documentation

## 📊 TAHAP 6: Repository Layer - ✅ COMPLETE

Complete implementation of repository layer integrating ML services, database, and camera operations.

---

## 🏗️ Architecture Overview

```
Domain Layer (Abstract Repositories)
        │
        ├─ ScanRepository
        ├─ SettingsRepository  
        └─ CameraRepository
        │
        ▼
Data Layer (Concrete Implementations)
        │
        ├─ ScanRepositoryImpl (+ ML Integration)
        ├─ SettingsRepositoryImpl
        └─ CameraRepositoryImpl
        │
        ├─ Services Layer
        │  ├─ MLInferenceService
        │  ├─ CameraService
        │  └─ DatabaseHelper
        │
        └─ Database Layer
           └─ SQLite (scan_history)
```

---

## 📁 Files Created (5 files)

### 1. **lib/domain/repositories/scan_repository.dart**
Abstract repository interface untuk scan operations (sudah ada dari Tahap 4).

**Key Methods:**
- performScan() - Run ML inference
- saveScanResult() - Save to database
- getScanResultById/getAllScanResults() - Query
- getScanResultsByClass/Confidence/DateRange() - Filtering
- updateScanResult() - Update
- deleteScanResult(s)() - Delete
- getStatistics() - Analytics

### 2. **lib/domain/repositories/settings_repository.dart** (NEW)
Abstract repository untuk user settings/preferences:

```dart
abstract class SettingsRepository {
  Future<UserSettings> getUserSettings();
  Future<void> updateSettings(UserSettings settings);
  Future<dynamic> getSettingValue(String key);
  Future<void> setSettingValue(String key, dynamic value);
  Future<void> resetToDefaults();
  Future<String> exportSettings();
  Future<void> importSettings(String jsonString);
  Future<void> deleteAllSettings();
}
```

### 3. **lib/domain/repositories/camera_repository.dart** (NEW)
Abstract repository untuk camera operations:

```dart
abstract class CameraRepository {
  Future<bool> hasCameraPermission();
  Future<bool> requestCameraPermission();
  Future<bool> initializeCamera();
  List<String> getAvailableResolutions();
  Future<bool> setCameraResolution(String resolution);
  String getCurrentResolution();
  List<int> getAvailableFPS();
  Future<bool> toggleFlash(bool enable);
  Future<bool> focusOnPoint(double x, double y);
  Future<Map<String, double>> getZoomLevels();
  Future<bool> setZoomLevel(double zoomLevel);
  Future<Map<String, dynamic>> getCameraInfo();
  Future<bool> isCameraAvailable();
  Future<void> closeCamera();
  Future<bool> healthCheck();
}
```

### 4. **lib/data/repositories/scan_repository_impl.dart** (UPDATED)
Updated ScanRepositoryImpl dengan ML service integration:

**Key Changes:**
- Added `MLInferenceService` integration
- Updated `performScan()` to use actual ML inference
- Added `initialize()` method for setup
- Added ML performance tracking
- Added `getMLPerformanceStats()` method
- Added `getModelInfo()` method
- Added `healthCheck()` method
- Added `cleanup()` method

**Usage:**
```dart
final repo = ScanRepositoryImpl();
await repo.initialize();  // Initialize ML + Database

// Run inference
final scanResult = await repo.performScan(imageBytes, imagePath);

// Save result
final id = await repo.saveScanResult(scanResult);

// Get ML stats
final stats = repo.getMLPerformanceStats();

// Health check
final isHealthy = await repo.healthCheck();

// Cleanup
await repo.cleanup();
```

### 5. **lib/data/repositories/settings_repository_impl.dart** (NEW)
Concrete SettingsRepository dengan SharedPreferences:

**Features:**
- Get/update user settings
- Get/set individual settings
- Reset to defaults
- Import/export settings
- Delete all settings
- Persistent storage dengan SharedPreferences

**Usage:**
```dart
final settingsRepo = SettingsRepositoryImpl();
await settingsRepo.initialize();

// Get all settings
final settings = await settingsRepo.getUserSettings();

// Update settings
final updated = settings.copyWith(confidenceThreshold: 0.7);
await settingsRepo.updateSettings(updated);

// Get single value
final threshold = await settingsRepo.getSettingValue('confidenceThreshold');

// Set single value
await settingsRepo.setSettingValue('themeMode', 'dark');

// Reset to defaults
await settingsRepo.resetToDefaults();

// Export/Import
final json = await settingsRepo.exportSettings();
await settingsRepo.importSettings(json);
```

### 6. **lib/data/repositories/camera_repository_impl.dart** (NEW)
Concrete CameraRepository wrapper untuk CameraService:

**Features:**
- Permission management
- Camera initialization
- Resolution & FPS management
- Flash & focus control
- Zoom levels
- Camera info & health checks

**Usage:**
```dart
final cameraRepo = CameraRepositoryImpl();

// Request permission
final granted = await cameraRepo.requestCameraPermission();

// Initialize
await cameraRepo.initializeCamera();

// Get available resolutions
final resolutions = cameraRepo.getAvailableResolutions();

// Set resolution
await cameraRepo.setCameraResolution('1080x1920');

// Toggle flash
await cameraRepo.toggleFlash(true);

// Set zoom
await cameraRepo.setZoomLevel(2.0);

// Get info
final info = await cameraRepo.getCameraInfo();

// Health check
final isHealthy = await cameraRepo.healthCheck();

// Close
await cameraRepo.closeCamera();
```

---

## 🔄 Data Flow

```
┌─────────────────────────────────┐
│  Presentation Layer (Providers) │
└────────────────┬────────────────┘
                 │
┌────────────────┴────────────────┐
│  Domain Layer (Repositories)    │
│ - ScanRepository (abstract)     │
│ - SettingsRepository (abstract) │
│ - CameraRepository (abstract)   │
└────────────────┬────────────────┘
                 │
┌────────────────┴────────────────┐
│ Data Layer (Implementations)    │
│ - ScanRepositoryImpl             │
│ - SettingsRepositoryImpl         │
│ - CameraRepositoryImpl           │
└────────────────┬────────────────┘
                 │
      ┌──────────┼──────────┐
      │          │          │
      ▼          ▼          ▼
┌──────────┐ ┌──────┐ ┌──────────┐
│ML        │ │Camera│ │Database  │
│Services  │ │Service│ │Services  │
└──────────┘ └──────┘ └──────────┘
```

---

## 🎯 Repository Responsibilities

### ScanRepository
- Orchestrate ML inference pipeline
- Manage scan history CRUD
- Provide analytics & filtering
- Handle image processing
- Track performance metrics

### SettingsRepository
- Persist user preferences
- Provide setting defaults
- Support import/export
- Individual setting management
- Reset functionality

### CameraRepository
- Manage camera permissions
- Handle camera lifecycle
- Provide camera configuration
- Control hardware features
- Monitor camera health

---

## 💾 Integration Points

### ML Services Integration
```dart
// ScanRepositoryImpl uses MLInferenceService
final mlResult = await _mlService.runInference(
  imageData,
  imageWidth: 640,
  imageHeight: 480,
);

// Returns detections with performance metrics
// Automatically saves to database via saveScanResult()
```

### Database Integration
```dart
// All scan results saved to SQLite
final id = await _databaseHelper.scanHistoryDao.insertScanResult(model);

// Query via repository methods
final results = await repo.getScanResultsByClass('Matang');
```

### Settings Storage
```dart
// SharedPreferences for user preferences
_prefs.setString(AppConstants.spKeyUserSettings, jsonString);

// Automatic persistence
final settings = await settingsRepo.getUserSettings();
```

---

## 🛠️ Usage Examples

### Complete Scan Pipeline

```dart
void main() async {
  // Initialize repositories
  final scanRepo = ScanRepositoryImpl();
  await scanRepo.initialize();

  final settingsRepo = SettingsRepositoryImpl();
  await settingsRepo.initialize();

  final cameraRepo = CameraRepositoryImpl();

  // Check permissions
  final hasPermission = await cameraRepo.requestCameraPermission();
  if (!hasPermission) {
    print('Camera permission denied');
    return;
  }

  // Load image and perform scan
  final imageBytes = await File('/path/to/image.jpg').readAsBytes();
  final result = await scanRepo.performScan(imageBytes, '/path/to/image.jpg');

  // Save to database
  final id = await scanRepo.saveScanResult(result);
  print('Saved with ID: $id');

  // Get ML performance
  final mlStats = scanRepo.getMLPerformanceStats();
  print('ML Stats: $mlStats');

  // Get scan statistics
  final stats = await scanRepo.getStatistics();
  print('Total scans: ${stats['totalRecords']}');

  // Update settings
  var settings = await settingsRepo.getUserSettings();
  settings = settings.copyWith(confidenceThreshold: 0.7);
  await settingsRepo.updateSettings(settings);

  // Cleanup
  await scanRepo.cleanup();
}
```

### Camera Configuration

```dart
Future<void> setupCamera() async {
  final cameraRepo = CameraRepositoryImpl();

  // Initialize
  await cameraRepo.initializeCamera();

  // Get available configs
  final resolutions = cameraRepo.getAvailableResolutions();
  final fps = cameraRepo.getAvailableFPS();

  // Configure
  await cameraRepo.setCameraResolution('1080x1920');
  await cameraRepo.toggleFlash(true);
  await cameraRepo.setZoomLevel(1.5);

  // Monitor
  final isHealthy = await cameraRepo.healthCheck();
  print('Camera healthy: $isHealthy');
}
```

### Settings Management

```dart
Future<void> manageSettings() async {
  final settingsRepo = SettingsRepositoryImpl();
  await settingsRepo.initialize();

  // Get current settings
  final current = await settingsRepo.getUserSettings();

  // Update confidence
  await settingsRepo.setSettingValue('confidenceThreshold', 0.75);

  // Export for backup
  final backup = await settingsRepo.exportSettings();
  await File('settings.json').writeAsString(backup);

  // Reset to defaults
  await settingsRepo.resetToDefaults();
}
```

---

## 📈 Key Features

### ScanRepositoryImpl
- ✅ Real ML inference integration
- ✅ Automatic result persistence
- ✅ Performance monitoring
- ✅ Model info tracking
- ✅ Health checks
- ✅ Proper initialization
- ✅ Resource cleanup

### SettingsRepositoryImpl
- ✅ Persistent storage
- ✅ JSON serialization
- ✅ Default values
- ✅ Import/export
- ✅ Individual setting access
- ✅ Reset functionality
- ✅ Error handling

### CameraRepositoryImpl
- ✅ Permission management
- ✅ Camera initialization
- ✅ Resolution selection
- ✅ Flash control
- ✅ Focus management
- ✅ Zoom support
- ✅ Health monitoring

---

## 🧪 Testing

### Unit Test Example

```dart
test('Perform scan and save', () async {
  final repo = ScanRepositoryImpl();
  await repo.initialize();

  final imageBytes = await File('/test/image.jpg').readAsBytes();
  final result = await repo.performScan(imageBytes, '/test/image.jpg');

  expect(result, isNotNull);
  expect(result.detections, isNotEmpty);

  final id = await repo.saveScanResult(result);
  expect(id, isNotNull);

  final retrieved = await repo.getScanResultById(id);
  expect(retrieved, isNotNull);
  expect(retrieved?.mainClass, result.mainClass);

  await repo.cleanup();
});

test('Settings persistence', () async {
  final repo = SettingsRepositoryImpl();
  await repo.initialize();

  var settings = await repo.getUserSettings();
  settings = settings.copyWith(confidenceThreshold: 0.8);
  await repo.updateSettings(settings);

  final retrieved = await repo.getUserSettings();
  expect(retrieved.confidenceThreshold, 0.8);
});
```

---

## 📊 Summary Statistics

| Item | Value |
|------|-------|
| Abstract Repositories | 3 |
| Concrete Implementations | 3 |
| Total Methods | 50+ |
| Error Handling | ✅ Complete |
| Logging | ✅ Comprehensive |
| Documentation | ✅ Extensive |

---

## 🚀 Ready for Next Phase

**TAHAP 7: State Management**
Repositories now ready to integrate with:
- ✅ Provider-based state management
- ✅ ChangeNotifier patterns
- ✅ Stream management
- ✅ UI providers

---

**Status**: ✅ **REPOSITORY LAYER COMPLETE**
**Next Phase**: State Management Implementation
