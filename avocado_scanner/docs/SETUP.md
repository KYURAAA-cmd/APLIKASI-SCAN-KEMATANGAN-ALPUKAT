# Avocado Ripeness Scanner - Setup Guide

## 📋 Tahap 1-3: Analisis, Arsitektur & Models (SELESAI ✅)

Dokumentasi lengkap telah dibuat untuk:
- ✅ Analisis kebutuhan aplikasi
- ✅ Desain arsitektur Clean Architecture
- ✅ Struktur folder lengkap
- ✅ Konfigurasi pubspec.yaml dengan semua dependencies
- ✅ Android configuration (AndroidManifest.xml, MainActivity.kt)
- ✅ Domain entities (AvocadoClass, Detection, ScanResult, UserSettings)
- ✅ Data models (DetectionModel, ScanResultModel, UserSettingsModel)
- ✅ App constants (AppConstants, ModelConstants, StringConstants)
- ✅ Utility extensions (StringExtensions, DoubleExtensions, IntExtensions)

---

## 🚀 Tahap Berikutnya: Setup Environment

### Prerequisites

Pastikan Anda sudah memiliki:

#### 1. **Flutter Installation**
```bash
# Check Flutter version (should be 3.13.0+)
flutter --version

# Update Flutter to latest
flutter upgrade

# Get packages info
flutter doctor
```

#### 2. **Android SDK**
```bash
# Verify Android SDK
flutter doctor -v

# Minimum SDK: 24 (Android 7.0)
# Target SDK: 34 (Android 14)
```

#### 3. **IDE Setup**
- **Android Studio 2022.1+** dengan Flutter plugin
- atau **VS Code** dengan Flutter extension

---

## 📦 Step-by-Step Setup

### Step 1: Clone / Setup Project

```bash
# Navigate ke project directory
cd avocado_scanner

# Get dependencies
flutter pub get

# Generate code (untuk json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Check errors
flutter analyze
```

### Step 2: Add Your ML Model

**PENTING**: Model YOLOv8 harus disiapkan terlebih dahulu!

#### Persiapan Model

1. **Training YOLOv8** (jika belum ada):
   ```bash
   # Menggunakan Ultralytics
   pip install ultralytics
   
   # Training
   yolo detect train data=avocado.yaml model=yolov8n.pt epochs=100 imgsz=640
   ```

2. **Konversi ke TFLite**:
   ```python
   from ultralytics import YOLO
   
   # Load trained model
   model = YOLO('runs/detect/train/weights/best.pt')
   
   # Export to TFLite (int8 quantized)
   model.export(format='tflite', imgsz=640, int8=True)
   
   # Output: best.tflite
   ```

3. **Prepare labels.txt**:
   ```
   Mentah
   Setengah Matang
   Matang
   Busuk
   ```

4. **Copy files ke project**:
   ```bash
   cp best.tflite assets/model/
   cp labels.txt assets/model/
   ```

### Step 3: Verify Project Structure

```bash
# Check project structure
flutter pub get

# Generate generated files
flutter pub run build_runner build

# Verify no errors
flutter analyze
```

### Step 4: Configure Android

#### Update build.gradle (android/app/build.gradle)

```gradle
android {
    namespace "com.example.avocado_scanner"
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.example.avocado_scanner"
        minSdkVersion 24
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### ProGuard Rules (android/app/proguard-rules.pro)

```proguard
# TensorFlow Lite
-keep class org.tensorflow.** { *; }
-keep interface org.tensorflow.** { *; }
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable

# Remove logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
```

### Step 5: Test on Device/Emulator

```bash
# List available devices
flutter devices

# Run app
flutter run

# Run dengan specific device
flutter run -d <device_id>

# Run release build
flutter run --release

# Run with profiling
flutter run --profile
```

---

## 📁 Project Structure Checklist

```
✅ lib/
   ✅ main.dart (entry point - belum dibuat)
   ✅ app/
      ✅ constants/ (AppConstants, ModelConstants, StringConstants)
   ✅ domain/entities/ (AvocadoClass, Detection, ScanResult, UserSettings)
   ✅ data/models/ (DetectionModel, ScanResultModel, UserSettingsModel)
   ✅ utils/extensions/ (StringExtensions, DoubleExtensions, IntExtensions)
   ⏭️ database/ (akan dibuat)
   ⏭️ services/ (akan dibuat)
   ⏭️ repositories/ (akan dibuat)
   ⏭️ providers/ (akan dibuat)
   ⏭️ screens/ (akan dibuat)
   ⏭️ widgets/ (akan dibuat)

✅ assets/
   ✅ model/ (perlu ditambah: best.tflite, labels.txt)
   ✅ images/ (perlu ditambah: logo, splash)
   ✅ icons/ (perlu ditambah: app icon)

✅ android/
   ✅ app/src/main/AndroidManifest.xml
   ✅ app/src/main/kotlin/MainActivity.kt
   ✅ app/build.gradle
   ✅ app/proguard-rules.pro

✅ Configuration Files
   ✅ pubspec.yaml
   ✅ analysis_options.yaml
   ✅ .gitignore
   ✅ README.md
```

---

## 🔧 Dependencies Summary

### Core Packages
- **flutter**: Framework
- **cupertino_icons**: Icons
- **provider**: State management

### UI & Design
- **google_fonts**: Custom fonts
- **flutter_staggered_animations**: Animations
- **shimmer**: Loading placeholders

### Camera & Image
- **camera**: Camera access
- **image_picker**: Gallery & camera picker
- **image**: Image processing
- **path_provider**: File system paths

### ML & Inference
- **tflite_flutter**: TensorFlow Lite runtime
- **tflite_flutter_helper**: TFLite preprocessing

### Database & Storage
- **sqflite**: SQLite database
- **sqflite_common_ffi**: FFI for desktop (dev)

### Permissions & Device
- **permission_handler**: Runtime permissions
- **device_info_plus**: Device information

### Dev Dependencies
- **build_runner**: Code generation
- **json_serializable**: JSON serialization
- **flutter_lints**: Linting
- **mocktail**: Mocking for tests

---

## ⚙️ Configuration Files

### pubspec.yaml
✅ **Sudah dibuat dengan semua dependencies**

Untuk menambahkan/update dependency:
```bash
flutter pub add package_name
flutter pub add --dev dev_package_name
```

### analysis_options.yaml
✅ **Sudah dikonfigurasi dengan linting rules**

### AndroidManifest.xml
✅ **Sudah dikonfigurasi dengan permissions:**
- Camera
- Storage (Read/Write)
- Internet
- Device Info

### MainActivity.kt
✅ **Sudah dibuat dengan channel communication**

---

## 📝 Building & Testing

### Run Tests
```bash
# All tests
flutter test

# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests
flutter test test/integration/

# With coverage
flutter test --coverage
```

### Build APK
```bash
# Debug APK
flutter build apk --debug

# Release APK (optimized)
flutter build apk --release

# Output: build/app/outputs/apk/release/app-release.apk
```

### Build App Bundle (for Play Store)
```bash
# Create App Bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

---

## 🐛 Troubleshooting

### Issue: `flutter pub get` gagal
```bash
flutter clean
flutter pub get
```

### Issue: Build runner gagal
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Analysis errors
```bash
flutter analyze
dart fix --apply
```

### Issue: Model not loading
- Verify file di `assets/model/best.tflite`
- Check `pubspec.yaml` sudah include assets
- Run `flutter clean && flutter pub get`

### Issue: Permissions error
- Check `AndroidManifest.xml`
- Grant permissions di device settings

---

## 📚 Next Steps (Tahap 4+)

### Tahap 4: Database & ML Services
- [ ] Implement SQLite database schema
- [ ] Create database DAOs
- [ ] Implement TFLite service
- [ ] Image preprocessing pipeline

### Tahap 5: Repositories & Providers
- [ ] Implement concrete repositories
- [ ] Create Provider state management
- [ ] Setup dependency injection

### Tahap 6: UI Screens
- [ ] Splash screen
- [ ] Home screen
- [ ] Camera scan screen
- [ ] Gallery scan screen
- [ ] Result screen
- [ ] History screens

### Tahap 7: Integration & Testing
- [ ] Camera integration
- [ ] Real-time inference
- [ ] Unit tests
- [ ] Widget tests

### Tahap 8: Optimization & Deployment
- [ ] Performance optimization
- [ ] Build APK/App Bundle
- [ ] Create release notes
- [ ] Deploy to Play Store

---

## 📞 Support & Debugging

### Enable Verbose Logging
```bash
flutter run -v
```

### Debug in Android Studio
```bash
flutter run -d <device_id>
# Then use Android Studio debugger
```

### Check Device Logs
```bash
adb logcat
# or
flutter logs
```

### Generate Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## ✅ Checklist Setup Selesai

- [ ] Flutter installed (3.13.0+)
- [ ] Android SDK configured (24+)
- [ ] Project directory created
- [ ] pubspec.yaml verified
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Code generation completed (`build_runner`)
- [ ] Android configuration done
- [ ] ML Model copied to `assets/model/`
- [ ] No analyze errors (`flutter analyze`)
- [ ] Test run successful (`flutter run`)

---

## 🎯 Siap untuk Tahap Berikutnya

Setelah setup ini selesai, Anda siap untuk:
1. ✅ Membuat Database Layer
2. ✅ Implementasi ML Services
3. ✅ Membuat UI Screens
4. ✅ Integrasi Camera
5. ✅ Testing & Deployment

---

**Total Setup Time**: ~30-45 menit
**Difficulty**: Intermediate
**Next Phase**: Database & ML Services

---

Dokumentasi lebih lengkap tersedia di folder `docs/`
