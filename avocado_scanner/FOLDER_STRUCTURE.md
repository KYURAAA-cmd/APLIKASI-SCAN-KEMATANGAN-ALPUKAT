# Avocado Ripeness Scanner - Struktur Folder Lengkap

## 📁 Struktur Directory Tree

```
avocado_scanner/
│
├── lib/                          # Dart source code
│   ├── main.dart                # Entry point aplikasi
│   ├── app.dart                 # Root widget & konfigurasi app
│   │
│   ├── app/                      # App configuration & setup
│   │   ├── app.dart             # Main app widget
│   │   ├── routes/              # Route management
│   │   │   ├── app_routes.dart  # Named routes constants
│   │   │   └── router.dart      # Route configuration
│   │   ├── themes/              # Theme & styling
│   │   │   ├── app_theme.dart   # Material Design 3 theme
│   │   │   ├── colors.dart      # Color constants
│   │   │   ├── text_styles.dart # Text styling
│   │   │   └── dimensions.dart  # Size & padding constants
│   │   └── constants/           # App constants
│   │       ├── app_constants.dart
│   │       ├── model_constants.dart
│   │       └── string_constants.dart
│   │
│   ├── presentation/             # UI Layer
│   │   ├── screens/             # Full screens
│   │   │   ├── splash_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── camera_scan_screen.dart
│   │   │   ├── gallery_scan_screen.dart
│   │   │   ├── scan_result_screen.dart
│   │   │   ├── history_screen.dart
│   │   │   ├── history_detail_screen.dart
│   │   │   ├── settings_screen.dart
│   │   │   └── about_screen.dart
│   │   ├── widgets/             # Reusable widgets
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_card.dart
│   │   │   ├── detection_box.dart
│   │   │   ├── loading_indicator.dart
│   │   │   ├── error_widget.dart
│   │   │   ├── confidence_badge.dart
│   │   │   ├── history_item.dart
│   │   │   └── result_display.dart
│   │   └── providers/           # State management (Provider/BLoC)
│   │       ├── camera_provider.dart
│   │       ├── ml_provider.dart
│   │       ├── history_provider.dart
│   │       ├── settings_provider.dart
│   │       └── ui_provider.dart
│   │
│   ├── domain/                   # Domain Layer (Business Logic)
│   │   ├── entities/            # Business objects
│   │   │   ├── scan_result.dart
│   │   │   ├── detection.dart
│   │   │   ├── avocado_class.dart
│   │   │   └── user_settings.dart
│   │   ├── repositories/        # Abstract repositories
│   │   │   ├── scan_repository.dart
│   │   │   ├── history_repository.dart
│   │   │   ├── settings_repository.dart
│   │   │   └── camera_repository.dart
│   │   └── usecases/            # Use case logic
│   │       ├── perform_scan_usecase.dart
│   │       ├── get_scan_history_usecase.dart
│   │       ├── save_scan_usecase.dart
│   │       ├── delete_scan_usecase.dart
│   │       └── get_settings_usecase.dart
│   │
│   ├── data/                     # Data Layer
│   │   ├── datasources/         # Data source abstractions
│   │   │   ├── local_datasource.dart    (abstract)
│   │   │   ├── local_datasource_impl.dart
│   │   │   ├── camera_datasource.dart   (abstract)
│   │   │   └── camera_datasource_impl.dart
│   │   ├── models/              # Data models (serializable)
│   │   │   ├── scan_result_model.dart
│   │   │   ├── detection_model.dart
│   │   │   ├── avocado_class_model.dart
│   │   │   └── user_settings_model.dart
│   │   ├── repositories/        # Concrete repository implementations
│   │   │   ├── scan_repository_impl.dart
│   │   │   ├── history_repository_impl.dart
│   │   │   ├── settings_repository_impl.dart
│   │   │   └── camera_repository_impl.dart
│   │   └── database/            # Local database
│   │       ├── database_service.dart    (Singleton)
│   │       ├── scan_history_dao.dart
│   │       ├── migrations.dart
│   │       └── db_schema.dart
│   │
│   ├── ml/                       # Machine Learning Layer
│   │   ├── models/              # ML model classes
│   │   │   ├── yolov8_model.dart     (TFLite model wrapper)
│   │   │   ├── detection_result.dart
│   │   │   └── model_config.dart
│   │   ├── services/            # ML services
│   │   │   ├── ml_service.dart      (Main ML service)
│   │   │   ├── tflite_service.dart  (TFLite wrapper)
│   │   │   └── model_loader.dart    (Model loading)
│   │   ├── preprocessing/       # Image preprocessing
│   │   │   ├── image_preprocessor.dart
│   │   │   ├── normalizer.dart
│   │   │   ├── resizer.dart
│   │   │   └── tensor_converter.dart
│   │   └── postprocessing/      # Result processing
│   │       ├── nms_processor.dart           (Non-Maximum Suppression)
│   │       ├── confidence_filter.dart
│   │       ├── coordinate_mapper.dart
│   │       └── result_formatter.dart
│   │
│   └── utils/                    # Utility functions
│       ├── extensions/          # Dart extensions
│       │   ├── string_extensions.dart
│       │   ├── double_extensions.dart
│       │   ├── list_extensions.dart
│       │   └── datetime_extensions.dart
│       ├── helpers/             # Helper functions
│       │   ├── logger_helper.dart
│       │   ├── error_handler.dart
│       │   ├── file_helper.dart
│       │   ├── permission_helper.dart
│       │   └── device_info_helper.dart
│       └── validators/          # Input validators
│           ├── image_validator.dart
│           ├── input_validator.dart
│           └── model_validator.dart
│
├── assets/                       # Static assets
│   ├── model/
│   │   ├── best.tflite          # ⭐ TFLite model (PUT HERE)
│   │   ├── labels.txt           # ⭐ Class labels (PUT HERE)
│   │   └── model_info.json      # Model metadata
│   ├── images/                  # App images
│   │   ├── logo.png
│   │   ├── splash.png
│   │   ├── avocado_icon.png
│   │   └── placeholder.png
│   └── icons/                   # App icons
│       └── app_icon.png
│
├── test/                         # Testing
│   ├── unit/                    # Unit tests
│   │   ├── ml/
│   │   │   ├── preprocessing_test.dart
│   │   │   ├── postprocessing_test.dart
│   │   │   └── ml_service_test.dart
│   │   ├── utils/
│   │   │   ├── validators_test.dart
│   │   │   └── extensions_test.dart
│   │   └── data/
│   │       ├── models_test.dart
│   │       └── database_test.dart
│   ├── widget/                  # Widget tests
│   │   ├── screens/
│   │   │   ├── home_screen_test.dart
│   │   │   ├── camera_scan_screen_test.dart
│   │   │   └── scan_result_screen_test.dart
│   │   └── widgets/
│   │       ├── detection_box_test.dart
│   │       ├── custom_button_test.dart
│   │       └── confidence_badge_test.dart
│   └── integration/             # Integration tests
│       ├── scan_flow_test.dart
│       ├── history_flow_test.dart
│       └── camera_flow_test.dart
│
├── android/                      # Android native code
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   ├── kotlin/
│   │   │   │   └── com/example/avocado_scanner/
│   │   │   │       └── MainActivity.kt
│   │   │   └── res/
│   │   │       ├── values/
│   │   │       │   ├── styles.xml
│   │   │       │   └── colors.xml
│   │   │       └── drawable/
│   │   ├── build.gradle
│   │   └── proguard-rules.pro   # ProGuard rules for TFLite
│   ├── settings.gradle
│   └── gradle.properties
│
├── ios/                          # iOS native code (optional)
│   └── Runner/
│       └── Info.plist
│
├── docs/                         # Documentation
│   ├── SETUP.md                 # Setup instructions
│   ├── ARCHITECTURE.md          # Architecture details
│   ├── ML_TRAINING.md           # YOLOv8 training guide
│   ├── MODEL_CONVERSION.md      # TFLite conversion guide
│   ├── INTEGRATION_GUIDE.md     # Integration steps
│   ├── BUILD_GUIDE.md           # Build & deployment guide
│   ├── API.md                   # API documentation
│   ├── DEPLOYMENT.md            # Deployment checklist
│   └── TROUBLESHOOTING.md       # Common issues & fixes
│
├── .github/
│   └── workflows/
│       ├── build.yml            # CI/CD for build
│       ├── tests.yml            # CI/CD for tests
│       └── analysis.yml         # CI/CD for code analysis
│
├── pubspec.yaml                 # Dart dependencies
├── pubspec.lock                 # Lock file (auto-generated)
├── analysis_options.yaml        # Linting configuration
├── .gitignore                   # Git ignore rules
├── .env                         # Environment variables (local, git-ignored)
├── README.md                    # Project readme
└── LICENSE                      # License file


## 📋 File Purpose Summary

### Configuration Files
- **pubspec.yaml**: Package dependencies & assets
- **analysis_options.yaml**: Lint rules
- **AndroidManifest.xml**: Android permissions & config
- **.gitignore**: Git ignore rules

### Core Application Files
- **main.dart**: Application entry point
- **app.dart**: Root Material App widget

### Layer Descriptions

#### 🎨 Presentation Layer
- **Screens**: Full-page widgets (e.g., CameraScanScreen, HistoryScreen)
- **Widgets**: Reusable UI components (e.g., DetectionBox, CustomButton)
- **Providers**: State management using Provider/BLoC

#### 💼 Domain Layer
- **Entities**: Pure business objects (no framework dependencies)
- **Repositories**: Abstract interfaces
- **UseCases**: Business logic/operations

#### 🗄️ Data Layer
- **DataSources**: Implementations (SQLite, Camera, File System)
- **Models**: Serializable versions of entities
- **Repositories**: Concrete implementations

#### 🤖 ML Layer
- **Models**: YOLOv8 model wrapper & configuration
- **Services**: TFLite inference service
- **Preprocessing**: Image resizing, normalization, tensor conversion
- **Postprocessing**: NMS, filtering, coordinate mapping

#### 🛠️ Utils Layer
- **Extensions**: Dart extension methods
- **Helpers**: Reusable utility functions
- **Validators**: Input validation logic

---

## 📦 Key Assets Location

```
assets/model/
  ├── best.tflite         ⭐ CRITICAL: Put your trained YOLOv8 TFLite model here
  ├── labels.txt          ⭐ CRITICAL: Put your class labels (one per line)
  └── model_info.json     Optional: Model metadata (input size, classes, etc)

Format of labels.txt:
Mentah
Setengah Matang
Matang
Busuk
```

---

## 🔄 Data Flow Diagram

```
┌─────────────┐
│   Camera    │
│   / Gallery │
└──────┬──────┘
       │
       ▼
┌──────────────────────────────────┐
│    Presentation Layer            │
│  (CameraScanScreen /             │
│   GalleryScanScreen)             │
└──────┬───────────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│    State Management              │
│  (MLProvider / Camera Provider)  │
└──────┬───────────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│    Domain Layer                  │
│  (Repositories & UseCases)       │
└──────┬───────────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│    Data Layer                    │
│  (Local DB, Camera DS)           │
└──────┬───────────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│    ML Layer                      │
│  (TFLite Inference)              │
│    ├─ Preprocessing              │
│    ├─ Inference                  │
│    └─ Postprocessing             │
└──────┬───────────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│    Detection Results             │
│  (BoundingBoxes, Confidence)     │
└──────────────────────────────────┘
```

---

## 🚀 Next Steps

1. ✅ Create complete folder structure (DONE)
2. ⏭️ Create base entities and models
3. ⏭️ Setup database schema and DAOs
4. ⏭️ Create ML preprocessing/postprocessing
5. ⏭️ Create ML service wrapper
6. ⏭️ Create repository implementations
7. ⏭️ Create state management providers
8. ⏭️ Create UI screens and widgets
9. ⏭️ Integrate everything together
10. ⏭️ Add tests and documentation

---

## 📝 Notes

- **Models**: Place your `best.tflite` and `labels.txt` in `assets/model/`
- **Database**: SQLite will be initialized automatically on first run
- **Permissions**: All required permissions are defined in `AndroidManifest.xml`
- **Concurrency**: ML inference runs on Isolate for non-blocking UI
- **Error Handling**: All layers have error handling and logging

---

**Last Updated**: 2024
