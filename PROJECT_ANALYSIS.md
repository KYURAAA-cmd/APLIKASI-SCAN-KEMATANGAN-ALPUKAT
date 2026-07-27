# Avocado Ripeness Scanner - Analisis Kebutuhan & Desain Arsitektur

## 1. ANALISIS KEBUTUHAN

### 1.1 Tujuan Aplikasi
Membangun aplikasi mobile Android yang dapat mendeteksi tingkat kematangan buah alpukat secara real-time menggunakan Computer Vision (YOLOv8).

### 1.2 User Stories
```
1. Sebagai pengguna, saya ingin membuka kamera dan melihat deteksi alpukat secara real-time
2. Sebagai pengguna, saya ingin memilih gambar dari galeri untuk dianalisis
3. Sebagai pengguna, saya ingin melihat hasil deteksi dengan confidence score
4. Sebagai pengguna, saya ingin menyimpan history scan untuk referensi nanti
5. Sebagai pengguna, saya ingin melihat detail history scan sebelumnya
```

### 1.3 Fitur Fungsional
- ✅ Splash Screen
- ✅ Home Screen dengan navigasi
- ✅ Scan Realtime Kamera (Camera Input)
- ✅ Scan dari Galeri (Gallery Input)
- ✅ Inference YOLOv8 TFLite
- ✅ Visualisasi Bounding Box + Metadata
- ✅ History Management (CRUD dengan SQLite)
- ✅ Settings/About Screen

### 1.4 Non-Functional Requirements
- **Performance**: Latency < 500ms per frame (target 30 FPS)
- **Memory**: Optimize untuk device dengan RAM minimal 2GB
- **Compatibility**: Android SDK 24+
- **UI/UX**: Material Design 3
- **Reliability**: Error handling untuk semua edge case

---

## 2. DESAIN ARSITEKTUR

### 2.1 Arsitektur Keseluruhan: Clean Architecture (3 Layers)

```
┌─────────────────────────────────────────┐
│      PRESENTATION LAYER (UI)            │
│  Screens, Widgets, State Management     │
├─────────────────────────────────────────┤
│      DOMAIN LAYER (Business Logic)      │
│  Use Cases, Entities, Repositories      │
├─────────────────────────────────────────┤
│      DATA LAYER (Data Sources)          │
│  Local DB, APIs, File Storage           │
├─────────────────────────────────────────┤
│      ML LAYER (Model Inference)         │
│  TFLite Model, Image Processing         │
└─────────────────────────────────────────┘
```

### 2.2 Component Architecture

```
┌────────────────────────────────────────────────────────┐
│                   PRESENTATION                         │
│  ┌─────────────┐  ┌────────────┐  ┌─────────────────┐ │
│  │   Screens   │  │  Widgets   │  │ State Mgmt      │ │
│  │  (BLoC/     │  │ (Reusable) │  │ (Provider/BLoC) │ │
│  │ Provider)   │  │            │  │                 │ │
│  └──────┬──────┘  └────────────┘  └────────┬────────┘ │
└─────────┼──────────────────────────────────┼───────────┘
          │                                  │
┌─────────┼──────────────────────────────────┼───────────┐
│         │        DOMAIN                    │           │
│  ┌──────┴────────┐         ┌──────────────┴────────┐  │
│  │   Repositories│         │    Use Cases / Models │  │
│  │  (Abstract)   │         │                       │  │
│  └──────┬────────┘         └──────────┬────────────┘  │
└─────────┼──────────────────────────────┼───────────────┘
          │                              │
┌─────────┼──────────────────────────────┼───────────────┐
│         │        DATA                  │               │
│  ┌──────┴────────┐  ┌─────────────────┴────────────┐  │
│  │   Repositories│  │  Data Sources (DB, Camera,   │  │
│  │  (Impl)       │  │  Gallery, File System)       │  │
│  └───────────────┘  └──────────────────────────────┘  │
└────────────────────────────────────────────────────────┘
          │
          │ Uses
          ↓
┌────────────────────────────────────────────────────────┐
│                   ML LAYER                             │
│  ┌──────────────┐  ┌──────────────┐ ┌──────────────┐  │
│  │ ML Service   │  │  TFLite Model│ │Image         │  │
│  │              │  │  Inference   │ │Processing    │  │
│  └──────────────┘  └──────────────┘ └──────────────┘  │
└────────────────────────────────────────────────────────┘
```

### 2.3 Data Flow untuk Kamera Scan

```
Camera Input
    ↓
[Frame Buffer]
    ↓
[Image Preprocessing]
  - Resize ke 640x640
  - Normalisasi pixel
    ↓
[TFLite Inference] (on Isolate/Thread)
    ↓
[Output Processing]
  - Extract predictions
  - Apply NMS
  - Filter by confidence
    ↓
[Post Processing]
  - Create Detection objects
  - Map to UI data
    ↓
[UI Rendering]
  - Draw bounding boxes
  - Display labels
  - Show FPS/confidence
```

### 2.4 Data Flow untuk Galeri Scan

```
Gallery Image
    ↓
[Load Image File]
    ↓
[Image Preprocessing]
    ↓
[TFLite Inference]
    ↓
[Result Processing]
    ↓
[Save to History]
    ↓
[Display Result Screen]
```

### 2.5 History Management

```
User Scan
    ↓
[Create ScanResult Object]
    ↓
[Save to SQLite]
  - Store image
  - Store metadata
  - Timestamp
    ↓
[Update UI]
    ↓
[User View History]
    ↓
[Load from SQLite]
    ↓
[Display List]
```

---

## 3. TEKNOLOGI STACK

### 3.1 Backend Technologies
| Komponen | Teknologi | Alasan |
|----------|-----------|--------|
| ML Model | YOLOv8 Nano | Lightweight, akurat, cepat |
| Model Format | TensorFlow Lite | On-device inference, offline |
| Image Processing | image package | Manipulasi gambar, preprocessing |
| TFLite Runtime | tflite_flutter | Binding Flutter ke TFLite |
| Database | SQLite (sqflite) | Local persistence, lightweight |
| State Management | Provider + BLoC | Scalable, reactive |
| Threading | Isolate | Non-blocking inference |

### 3.2 Frontend Technologies
| Komponen | Teknologi | Alasan |
|----------|-----------|--------|
| Framework | Flutter | Cross-platform, fast dev |
| Language | Dart | Type-safe, OOP |
| Camera | camera plugin | Native camera integration |
| UI Design | Material Design 3 | Modern, consistent |
| Image Selection | image_picker | Gallery & camera access |
| File Handling | path_provider | Secure path management |

### 3.3 Development Tools
- Android Studio + Flutter SDK
- Dart Analyzer (linting)
- Xcode (Build runner)
- Device/Emulator (Testing)

---

## 4. MODEL MACHINE LEARNING

### 4.1 Model Specifications
```
Model Name: YOLOv8 Nano (best.pt)
Input Size: 640x640 (RGB)
Output: Detections with bounding boxes
Classes:
  0. Mentah (Unripe)
  1. Setengah Matang (Half-ripe)
  2. Matang (Ripe)
  3. Busuk (Rotten)

Conversion:
best.pt (PyTorch) → best.onnx (ONNX) → best.tflite (TFLite)
```

### 4.2 Preprocessing Pipeline
```
Raw Frame (variable)
    ↓
Resize (letterbox to 640x640)
    ↓
Convert to RGB (if needed)
    ↓
Normalize (divide by 255, or use mean/std)
    ↓
Convert to Float32 tensor
```

### 4.3 Post-processing Pipeline
```
Raw Output (1, 25200, 85) or similar
    ↓
Extract bounding boxes [x, y, w, h]
    ↓
Extract confidence scores
    ↓
Extract class probabilities
    ↓
Filter by confidence threshold (0.5)
    ↓
Apply NMS (IOU threshold 0.5)
    ↓
Convert to screen coordinates
    ↓
Return Detection objects
```

---

## 5. DATABASE SCHEMA (SQLite)

### 5.1 ScanHistory Table
```sql
CREATE TABLE scan_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  scan_date TEXT NOT NULL,           -- ISO 8601 datetime
  image_path TEXT NOT NULL,          -- Local path to image file
  detection_class TEXT NOT NULL,     -- e.g., "Matang", "Mentah"
  confidence REAL NOT NULL,          -- 0.0 - 100.0
  bounding_boxes TEXT NOT NULL,      -- JSON array of bbox data
  inference_time INTEGER,            -- milliseconds
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_scan_date ON scan_history(scan_date DESC);
```

### 5.2 Data Models
```dart
class ScanResult {
  final int? id;
  final DateTime scanDate;
  final String imagePath;
  final String detectionClass;
  final double confidence;
  final List<BoundingBox> boundingBoxes;
  final int inferenceTime;
}

class Detection {
  final String label;
  final double confidence;
  final Rect boundingBox;
}

class BoundingBox {
  final double x, y, w, h;
  final String label;
  final double confidence;
}
```

---

## 6. STATE MANAGEMENT DESIGN

### 6.1 Provider Architecture
```
root
  ├── CameraProvider
  │   ├── CameraController
  │   ├── Stream frames
  │   └── Permissions
  │
  ├── MLProvider
  │   ├── Model loading state
  │   ├── Inference results
  │   └── Error handling
  │
  ├── ScanHistoryProvider
  │   ├── List of scans
  │   ├── Database operations
  │   └── Cache management
  │
  └── SettingsProvider
      ├── Confidence threshold
      ├── UI preferences
      └── App settings
```

### 6.2 BLoC Pattern (Alternative)
```
ScanBloc:
  - Events: StartCamera, StopCamera, TakePicture, ProcessImage
  - States: Loading, CameraReady, Scanning, ResultReady, Error

HistoryBloc:
  - Events: FetchHistory, DeleteScan, ClearHistory
  - States: HistoryLoading, HistoryLoaded, HistoryError
```

---

## 7. ERROR HANDLING STRATEGY

```
Kamera tidak tersedia
  → Handle: Check permissions, show dialog, use gallery fallback

Izin kamera ditolak
  → Handle: Request again, guide user to settings

Model gagal dimuat
  → Handle: Offline mode, show error, retry mechanism

Gambar kosong / null
  → Handle: Validate input, show user feedback

Tidak ada objek terdeteksi
  → Handle: Show "No avocado detected", ask to reposition

File rusak
  → Handle: Graceful loading error, retry

Low memory
  → Handle: Clear cache, reduce resolution, warn user

Inference timeout
  → Handle: Cancel operation, show timeout error
```

---

## 8. PERFORMANCE TARGETS

| Metrik | Target | Strategy |
|--------|--------|----------|
| Frame Rate | 30 FPS | Use Isolate, GPU delegate |
| Inference Latency | < 500ms | Model quantization, GPU |
| Memory Usage | < 500MB peak | Image pooling, cache mgmt |
| App Startup | < 3s | Lazy load model, async init |
| UI Responsiveness | 60 FPS | Offload ML to isolate |

---

## 9. SECURITY CONSIDERATIONS

1. **Permissions**: Implement proper runtime permissions (Android 6+)
2. **Data Privacy**: Images stored locally, no cloud upload
3. **Model Security**: Bundle model securely, no network download
4. **Input Validation**: Validate all user inputs and files
5. **Crash Reporting**: Implement error logging (local or Firebase)

---

## 10. TESTING STRATEGY

### 10.1 Unit Tests
- ML utility functions (image preprocessing, NMS)
- Database operations (CRUD)
- Data model validations

### 10.2 Widget Tests
- UI component rendering
- User interactions
- Navigation

### 10.3 Integration Tests
- End-to-end scan flow
- Camera + inference
- History save/load

---

## 11. DEPLOYMENT CHECKLIST

- [ ] Model conversion complete (best.tflite)
- [ ] Labels file prepared (labels.txt)
- [ ] Dependencies configured in pubspec.yaml
- [ ] Android permissions in AndroidManifest.xml
- [ ] Proguard rules for tflite_flutter
- [ ] Build APK and test on devices
- [ ] Create App Bundle for Play Store
- [ ] Prepare release notes and app store listing

---

## 12. TIMELINE ESTIMATE

| Fase | Durasi | Prioritas |
|------|--------|-----------|
| Setup Project | 1-2 hari | 🔴 High |
| UI Implementation | 2-3 hari | 🔴 High |
| ML Integration | 2-3 hari | 🔴 High |
| Inference Pipeline | 2-3 hari | 🔴 High |
| History & DB | 1-2 hari | 🟡 Medium |
| Testing & Optimization | 2-3 hari | 🟡 Medium |
| Documentation | 1 hari | 🟢 Low |

**Total Estimate: 11-17 hari** (dapat disesuaikan)

---

## 13. ARSITEKTUR FOLDER PREVIEW

```
lib/
  ├── main.dart
  ├── app/
  │   ├── app.dart
  │   ├── routes/
  │   ├── themes/
  │   └── constants/
  ├── presentation/
  │   ├── screens/
  │   ├── widgets/
  │   ├── providers/
  │   └── pages/
  ├── domain/
  │   ├── entities/
  │   ├── repositories/
  │   └── usecases/
  ├── data/
  │   ├── datasources/
  │   ├── models/
  │   ├── repositories/
  │   └── database/
  ├── ml/
  │   ├── models/
  │   ├── services/
  │   ├── preprocessing/
  │   └── postprocessing/
  └── utils/
      ├── extensions/
      ├── helpers/
      └── validators/

assets/
  ├── model/
  │   ├── best.tflite
  │   └── labels.txt
  ├── images/
  └── icons/
```

---

## KESIMPULAN

Aplikasi akan dibangun menggunakan **Clean Architecture** dengan pemisahan yang jelas antara:
- **Presentation Layer**: UI responsif dengan Provider/BLoC
- **Domain Layer**: Business logic dan entities
- **Data Layer**: SQLite, file system, camera
- **ML Layer**: TFLite inference dengan optimasi performa

Desain ini memastikan **scalability**, **maintainability**, dan **testability** aplikasi.

---

**Next Step**: Buat struktur folder lengkap dan konfigurasi pubspec.yaml
