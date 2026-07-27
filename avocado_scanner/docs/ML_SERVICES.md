# ML Services Pipeline - Documentation

## 📊 TAHAP 5: ML Services Pipeline - ✅ COMPLETE

Complete implementation of machine learning inference pipeline including preprocessing, TFLite inference, and post-processing with NMS.

---

## 🏗️ Architecture Overview

```
┌──────────────────────────────────────────┐
│  MLInferenceService (Orchestrator)       │
└──────────────────────────────────────────┘
              │
    ┌─────────┼─────────┐
    │         │         │
    ▼         ▼         ▼
┌─────────┐ ┌──────┐ ┌────────────┐
│ Image   │ │TFLite│ │Postprocess │
│Preprocess│ │Service│ │& NMS       │
└─────────┘ └──────┘ └────────────┘
    │         │         │
    └─────────┼─────────┘
              │
              ▼
    ┌──────────────────┐
    │ InferenceResult  │
    └──────────────────┘
```

---

## 📁 Files Created (5 files)

### 1. **image_preprocessing_service.dart**
Image preprocessing untuk ML model preparation:

**Loading Images:**
```dart
final preprocessor = ImagePreprocessingService();
final image = preprocessor.loadImageFromBytes(imageBytes);
```

**Image Operations:**
```dart
// Resize
final resized = preprocessor.resizeImage(
  image,
  width: 640,
  height: 640,
  maintainAspectRatio: true,
);

// Normalize
final normalized = preprocessor.normalizeImage(resized);

// Convert to RGB
final rgb = preprocessor.convertToRGB(image);

// Rotate
final rotated = preprocessor.rotateImage(image, 90);

// Enhance contrast
final enhanced = preprocessor.enhanceContrast(image, factor: 1.5);

// Convert to grayscale
final gray = preprocessor.toGrayscale(image);

// Get image info
final info = preprocessor.getImageInfo(image);
// Returns: {width, height, numChannels, hasAlpha, aspectRatio, pixelCount}

// Validate image
final isValid = preprocessor.validateImage(image, minWidth: 100, minHeight: 100);
```

**Key Features:**
- ✅ Aspect ratio preservation with padding
- ✅ Normalization to 0-1 range
- ✅ Image format conversion (RGB, grayscale)
- ✅ Contrast enhancement
- ✅ Image validation
- ✅ Rotation & flipping support

### 2. **tflite_service.dart** (Singleton)
TensorFlow Lite model management:

**Usage:**
```dart
final tflite = TFLiteService();

// Get interpreter
final interp = await tflite.interpreter;

// Run inference
final output = await tflite.runInference(inputTensor);

// Get model info
final inputShape = await tflite.getInputShape();     // [1, 640, 640, 3]
final outputShape = await tflite.getOutputShape();   // [1, 25200, 85]
final inputType = await tflite.getInputDataType();
final outputType = await tflite.getOutputDataType();

// Benchmark
final avgTime = await tflite.benchmarkInference(input);

// Get memory info
final memInfo = tflite.getMemoryInfo();

// Reload model
await tflite.reloadModel();

// Close
await tflite.close();
```

**Key Features:**
- ✅ Model loading from assets
- ✅ GPU delegate support
- ✅ NNAPI delegate support
- ✅ Multi-threaded inference (4 threads)
- ✅ Memory usage tracking
- ✅ Model benchmarking

### 3. **inference_postprocessing_service.dart**
YOLOv8 output post-processing dengan NMS:

**Usage:**
```dart
final postprocessor = InferencePostprocessingService();

// Post-process YOLOv8 output
final detections = postprocessor.postProcessYOLOv8(
  inferenceOutput,
  imageWidth: 640,
  imageHeight: 480,
  modelInputWidth: 640,
  modelInputHeight: 640,
);

// Filter by confidence
final filtered = postprocessor.filterByConfidence(detections, 0.7);

// Filter by class
final ripe = postprocessor.filterByClass(detections, 'Matang');

// Get best detection
final best = postprocessor.getBestDetection(detections);

// Get statistics
final stats = postprocessor.getStatistics(detections);
// Returns: {totalDetections, avgConfidence, maxConfidence, minConfidence, classDistribution}

// Get debug info
final debug = postprocessor.getDebugInfo(detections);
```

**Key Features:**
- ✅ YOLO output parsing
- ✅ Non-Maximum Suppression (NMS) dengan IOU threshold
- ✅ Per-class confidence filtering
- ✅ Coordinate mapping to original image
- ✅ Bounding box validation
- ✅ Statistics & analytics

### 4. **ml_inference_service.dart** (Orchestrator)
Complete ML pipeline orchestration:

**Usage:**
```dart
final ml = MLInferenceService();

// Initialize
await ml.initialize();

// Run inference
final result = await ml.runInference(
  imageBytes,
  imageWidth: 640,
  imageHeight: 480,
);

// Access results
print('Detections: ${result.detections.length}');
print('Inference time: ${result.inferenceTimeMs}ms');
print('FPS: ${result.fps.toStringAsFixed(2)}');
print('Total time: ${result.totalTimeMs}ms');
print('Best detection: ${result.bestDetection}');
print('Meets target: ${result.meetPerformanceTarget}');

// Get performance stats
final stats = ml.getPerformanceStats();
// Returns: {totalInferences, averageTimeMs, averageFps, lastFps, totalTimeMs}

// Benchmark
final benchmark = await ml.benchmarkPerformance(
  testImageBytes,
  imageWidth: 640,
  imageHeight: 480,
  iterations: 10,
);
print('Benchmark: $benchmark');

// Get model info
final modelInfo = await ml.getModelInfo();

// Health check
final isHealthy = await ml.healthCheck();

// Close
await ml.close();
```

**InferenceResult:**
```dart
class InferenceResult {
  List<Detection> detections;         // Detected objects
  int inferenceTimeMs;                // Model inference time only
  int totalTimeMs;                    // Total pipeline time
  double fps;                         // Frames per second
  int imageWidth;                     // Original image width
  int imageHeight;                    // Original image height
  
  Detection? get bestDetection;       // Highest confidence
  bool get meetPerformanceTarget;     // <500ms, >30 FPS check
}
```

**Key Features:**
- ✅ Complete pipeline orchestration
- ✅ Performance monitoring (FPS, latency)
- ✅ Benchmark functionality
- ✅ Model lifecycle management
- ✅ Health checks
- ✅ Error handling & recovery

### 5. **camera_service.dart**
Camera operations & permission management:

**Usage:**
```dart
final camera = CameraService();

// Check permission
final hasPermission = await camera.hasCameraPermission();

// Request permission
final granted = await camera.requestCameraPermission();

// Initialize camera
await camera.initializeCamera();

// Get available resolutions
final resolutions = camera.getAvailableResolutions();

// Set resolution
await camera.setCameraResolution('1080x1920');

// Get resolution dimensions
final dims = camera.getResolutionDimensions('1080x1920');
// Returns: {width: 1080, height: 1920}

// Get camera info
final info = await camera.getCameraInfo();

// Check availability
final available = await camera.isCameraAvailable();

// Flash control
await camera.toggleFlash(true);

// Focus on point
await camera.focusOnPoint(0.5, 0.5);

// Zoom control
final zoomLevels = await camera.getZoomLevels();
await camera.setZoomLevel(2.0);

// Health check
await camera.healthCheck();

// Close
await camera.closeCamera();
```

**Key Features:**
- ✅ Permission handling
- ✅ Resolution management (480x640, 720x1280, 1080x1920)
- ✅ FPS support (15, 24, 30)
- ✅ Flash/torch control
- ✅ Auto-focus support
- ✅ Zoom management
- ✅ Health checks

---

## 🔄 Inference Pipeline Flow

```
Input Image (JPEG/PNG)
        │
        ▼
   Load Image
   (loadImageFromBytes)
        │
        ▼
   Validate Image
        │
        ▼
   Resize to 640x640
   (maintainAspectRatio + padding)
        │
        ▼
   Normalize (0-1)
        │
        ▼
   Create tensor
        │
        ▼
   TFLite Inference
   (GPU/NNAPI delegates)
        │
        ▼
   Parse YOLOv8 Output
   [x, y, w, h, conf, class...]
        │
        ▼
   Apply NMS
   (IOU threshold 0.5)
        │
        ▼
   Filter by confidence
   (per-class thresholds)
        │
        ▼
   Map coordinates to original
        │
        ▼
   InferenceResult
   (detections, FPS, timing)
```

---

## 📊 Performance Metrics

### Target Performance
- **Inference Latency**: < 500ms total
- **Model Inference**: < 300ms
- **FPS**: ≥ 30 FPS
- **Memory**: < 500MB

### Components Timing
| Component | Est. Time |
|-----------|-----------|
| Loading image | 20ms |
| Preprocessing | 50ms |
| Inference | 150-200ms |
| Post-processing | 30ms |
| NMS | 20ms |
| **Total** | **~270-320ms** |

---

## 🎯 YOLOv8 Configuration

### Model Input
- **Size**: 640x640 pixels
- **Format**: RGB, normalized 0-1
- **Channels**: 3
- **Type**: Float32

### Model Output
- **Format**: [x, y, w, h, confidence, class0, class1, class2, class3]
- **Coordinates**: Normalized (0-1)
- **Per-detection**: 9 values
- **Classes**: 4 (Mentah=0, Setengah Matang=1, Matang=2, Busuk=3)

### Confidence Thresholds
- Mentah: 0.3
- Setengah Matang: 0.4
- Matang: 0.5
- Busuk: 0.45
- Base: 0.25

### NMS Parameters
- **IOU Threshold**: 0.5
- **Max Detections**: 10

---

## 🛠️ Usage Examples

### Complete Inference Pipeline

```dart
void main() async {
  // Initialize
  final ml = MLInferenceService();
  await ml.initialize();
  
  // Load image
  final imageBytes = await File('/path/to/image.jpg').readAsBytes();
  
  // Run inference
  final result = await ml.runInference(
    imageBytes,
    imageWidth: 640,
    imageHeight: 480,
  );
  
  // Process results
  print('Found ${result.detections.length} objects');
  print('Inference: ${result.inferenceTimeMs}ms');
  print('Total: ${result.totalTimeMs}ms (${result.fps.toStringAsFixed(1)} FPS)');
  
  for (final detection in result.detections) {
    print('${detection.classLabel}: ${(detection.confidence * 100).toStringAsFixed(1)}%');
  }
  
  // Save best result
  final best = result.bestDetection;
  if (best != null) {
    print('Best detection: ${best.classLabel} (${best.confidence})');
  }
  
  // Check performance
  if (result.meetPerformanceTarget) {
    print('✅ Performance target met!');
  }
  
  // Cleanup
  await ml.close();
}
```

### Camera + Inference

```dart
void initializeCamera() async {
  final camera = CameraService();
  
  // Request permission
  if (!await camera.requestCameraPermission()) {
    print('Camera permission denied');
    return;
  }
  
  // Initialize
  await camera.initializeCamera();
  
  // Set resolution
  await camera.setCameraResolution('1080x1920');
  
  // Get info
  final info = await camera.getCameraInfo();
  print('Camera ready: $info');
}
```

### Performance Monitoring

```dart
void monitorPerformance() async {
  final ml = MLInferenceService();
  await ml.initialize();
  
  // Run multiple inferences
  for (int i = 0; i < 5; i++) {
    await ml.runInference(imageBytes, imageWidth: 640, imageHeight: 480);
  }
  
  // Get stats
  final stats = ml.getPerformanceStats();
  print('Average inference: ${stats['averageTimeMs']}ms');
  print('Average FPS: ${stats['averageFps'].toStringAsFixed(2)}');
  
  // Benchmark
  final benchmark = await ml.benchmarkPerformance(
    imageBytes,
    imageWidth: 640,
    imageHeight: 480,
    iterations: 10,
  );
  print('Benchmark: $benchmark');
}
```

---

## 📈 Key Technologies

- **tflite_flutter**: TensorFlow Lite integration
- **tflite_flutter_helper**: TFLite utilities
- **image**: Image processing library
- **permission_handler**: Permission management
- **Logger**: Advanced logging

---

## 🧪 Testing

### Unit Test Example

```dart
test('Image preprocessing', () async {
  final preprocessor = ImagePreprocessingService();
  
  final image = preprocessor.loadImageFromBytes(imageBytes);
  expect(image, isNotNull);
  
  final resized = preprocessor.resizeImage(image!);
  expect(resized.width, 640);
  expect(resized.height, 640);
  
  final normalized = preprocessor.normalizeImage(resized);
  expect(normalized.length, 640);
});

test('Inference result', () async {
  final ml = MLInferenceService();
  await ml.initialize();
  
  final result = await ml.runInference(imageBytes, imageWidth: 640, imageHeight: 480);
  
  expect(result.detections, isNotEmpty);
  expect(result.fps, greaterThan(0));
  expect(result.totalTimeMs, lessThan(1000));
});
```

---

## ⚠️ Important Notes

1. **Model Path**: `assets/model/best.tflite` must exist
2. **Input Format**: RGB normalized 0-1
3. **Async Operations**: All ML operations are async
4. **Singleton Pattern**: Services use singleton for efficiency
5. **GPU/NNAPI**: Automatically enabled if available
6. **Performance**: Target <500ms with 30 FPS on mid-range devices

---

## 🚀 Tahap Berikutnya

### TAHAP 6: Repository Implementation
Database + ML integration ready for:
- ✅ Preprocessing images
- ✅ Running inference
- ✅ Saving results
- ✅ Retrieving history

---

## 📊 Summary Statistics

| Item | Value |
|------|-------|
| Files Created | 5 |
| Total LOC | 1,500+ |
| Services | 5 |
| Methods | 50+ |
| Error Handling | ✅ Complete |
| Performance Monitoring | ✅ Full |
| Documentation | ✅ Extensive |

---

**Status**: ✅ **ML SERVICES PIPELINE COMPLETE**
**Next Phase**: Repository Integration & State Management
