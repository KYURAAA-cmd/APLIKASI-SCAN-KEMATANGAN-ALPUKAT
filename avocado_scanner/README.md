# 🥑 Avocado Ripeness Scanner 🥑

Real-time avocado ripeness detection using YOLOv8 and TensorFlow Lite on Flutter

![License](https://img.shields.io/badge/license-MIT-green)
![Flutter](https://img.shields.io/badge/flutter-3.13.0+-blue)
![Dart](https://img.shields.io/badge/dart-3.0.0+-blue)
![Android SDK](https://img.shields.io/badge/android%20sdk-24%2B-green)

## 📱 Features

- 📷 **Real-time Camera Detection** - Detect avocado ripeness using device camera
- 🖼️ **Gallery Image Support** - Analyze avocado images from device gallery
- 🎯 **YOLOv8 Object Detection** - Fast and accurate detection model
- ✨ **Live Bounding Boxes** - Visualize detection results with confidence scores
- 📊 **Ripeness Classification** - 4 classes: Mentah, Setengah Matang, Matang, Busuk
- 💾 **Local History** - Save and view scan history with SQLite
- 🎨 **Material Design 3** - Modern and intuitive UI
- ⚡ **Optimized Performance** - 30 FPS detection with < 500ms latency
- 🔒 **Privacy First** - All processing happens locally, no cloud upload

## 🎓 Ripeness Classes

| Class | Description | Best For |
|-------|-------------|----------|
| **Mentah** | Unripe avocado | Ripening needed |
| **Setengah Matang** | Half-ripe avocado | 1-2 days before consumption |
| **Matang** | Ripe avocado | Ready to eat |
| **Busuk** | Rotten avocado | Discard |

## 🚀 Quick Start

### Prerequisites

- Flutter 3.13.0 or higher
- Dart 3.0.0 or higher
- Android SDK 24+ or iOS 11.0+
- Android Studio / Xcode
- A trained YOLOv8 TFLite model

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/avocado_scanner.git
   cd avocado_scanner
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add your ML model**
   - Place your `best.tflite` model in `assets/model/best.tflite`
   - Place your `labels.txt` in `assets/model/labels.txt`
   
   **labels.txt format:**
   ```
   Mentah
   Setengah Matang
   Matang
   Busuk
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
avocado_scanner/
├── lib/
│   ├── main.dart
│   ├── app/                  # App configuration
│   ├── presentation/         # UI Screens & Widgets
│   ├── domain/              # Business Logic
│   ├── data/                # Data Sources & Repositories
│   ├── ml/                  # Machine Learning Layer
│   └── utils/               # Utilities & Helpers
├── assets/
│   └── model/
│       ├── best.tflite      # ⭐ Place your model here
│       └── labels.txt       # ⭐ Place your labels here
├── android/                 # Android configuration
├── test/                    # Unit, Widget, Integration tests
└── docs/                    # Documentation

For detailed structure, see [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md)
```

## 🔧 Configuration

### Android Configuration

**Minimum SDK**: 24 (Android 7.0)
**Target SDK**: 34 (Android 14)

Permissions (automatically handled):
- `android.permission.CAMERA`
- `android.permission.READ_EXTERNAL_STORAGE`
- `android.permission.WRITE_EXTERNAL_STORAGE`

### Required Dependencies

```yaml
Key packages:
- camera: for device camera access
- image: for image processing
- tflite_flutter: for TensorFlow Lite
- sqflite: for local database
- provider: for state management
- permission_handler: for runtime permissions
```

For full dependencies, see [pubspec.yaml](pubspec.yaml)

## 📊 Performance Targets

| Metric | Target |
|--------|--------|
| Frame Rate | 30 FPS |
| Inference Latency | < 500ms |
| Memory Usage | < 500MB peak |
| Startup Time | < 3 seconds |
| UI Responsiveness | 60 FPS |

## 🤖 Machine Learning

### Model Specifications
- **Architecture**: YOLOv8 Nano
- **Input Size**: 640 × 640 (RGB)
- **Output Format**: Bounding boxes with confidence scores
- **Classes**: 4 (Mentah, Setengah Matang, Matang, Busuk)

### Model Conversion

To convert your YOLOv8 model to TFLite:

```bash
# From your YOLOv8 training environment
from ultralytics import YOLO

# Load trained model
model = YOLO('path/to/best.pt')

# Export to TFLite (int8 quantized)
model.export(format='tflite', imgsz=640, int8=True)
```

For detailed conversion guide, see [docs/MODEL_CONVERSION.md](docs/MODEL_CONVERSION.md)

## 📚 Documentation

- [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md) - Complete folder structure
- [PROJECT_ANALYSIS.md](../PROJECT_ANALYSIS.md) - Architecture & design
- [docs/SETUP.md](docs/SETUP.md) - Setup instructions
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - Architecture details
- [docs/ML_TRAINING.md](docs/ML_TRAINING.md) - YOLOv8 training guide
- [docs/MODEL_CONVERSION.md](docs/MODEL_CONVERSION.md) - TFLite conversion guide
- [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md) - Build & deployment guide
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Common issues & solutions

## 🧪 Testing

### Run all tests
```bash
flutter test
```

### Run specific test type
```bash
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/
```

### Generate coverage report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🏗️ Architecture

The app follows **Clean Architecture** with clear separation of concerns:

```
Presentation Layer (UI)
        ↓
Domain Layer (Business Logic)
        ↓
Data Layer (Data Sources)
        ↓
ML Layer (Inference)
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for details

## 🚢 Build & Deployment

### Build APK
```bash
flutter build apk --release
```

### Build App Bundle (for Google Play)
```bash
flutter build appbundle --release
```

### Create signing key
```bash
keytool -genkey -v -keystore ~/key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload-key
```

See [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md) for detailed build instructions

## 🔍 Code Quality

### Run analysis
```bash
flutter analyze
```

### Format code
```bash
dart format lib/ test/
```

### Fix issues
```bash
dart fix --apply
```

## 🐛 Troubleshooting

### Camera not working?
- Check permissions (Settings > App Permissions > Camera)
- Ensure device has camera hardware
- Restart the app

### Model not loading?
- Verify model path is correct
- Check model file size (should be ~10-20 MB)
- Ensure labels.txt is in same directory

### Low FPS?
- Close background apps
- Reduce image resolution
- Enable GPU acceleration if available

For more troubleshooting, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Flutter best practices
- Use meaningful variable names
- Add comments for complex logic
- Write unit tests for new features
- Keep functions small and focused

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- [YOLOv8](https://github.com/ultralytics/ultralytics) - Object detection framework
- [TensorFlow Lite](https://www.tensorflow.org/lite) - On-device ML inference
- [Flutter](https://flutter.dev) - UI framework
- [OpenAI](https://openai.com) - AI assistance

## 📧 Contact

For questions or feedback, please open an issue on GitHub.

---

**Last Updated**: 2024
**Version**: 1.0.0
**Status**: Under Development 🚀

---

## 📈 Project Roadmap

### Phase 1: MVP (Current)
- ✅ Real-time camera detection
- ✅ Gallery image scanning
- ✅ Local history storage
- ✅ Material Design 3 UI

### Phase 2: Enhancement
- 🔄 Firebase Analytics
- 🔄 Cloud backup for history
- 🔄 Batch processing
- 🔄 Advanced statistics

### Phase 3: Advanced
- 🔄 Multi-language support
- 🔄 Model fine-tuning
- 🔄 AR visualization
- 🔄 Export reports

---

Feel free to star ⭐ this repository if you find it helpful!
