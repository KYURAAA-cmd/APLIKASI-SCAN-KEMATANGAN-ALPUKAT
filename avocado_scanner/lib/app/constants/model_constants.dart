/// lib/app/constants/model_constants.dart
/// 
/// Konstanta untuk ML Model
library;

class ModelConstants {
  // Prevent instantiation
  ModelConstants._();

  // Model files
  static const String modelFileName = 'best_int8.tflite';
  static const String labelsFileName = 'labels.txt';
  static const String modelPath = 'assets/model/$modelFileName';
  static const String labelsPath = 'assets/model/$labelsFileName';

  // Model Configuration
  static const int inputSize = 640;
  static const int inputChannels = 3; // RGB
  static const String inputType = 'uint8'; // or 'float32'
  static const int numClasses = 4;

  // Inference settings
  static const double confidenceThreshold = 0.25;
  static const double iouThreshold = 0.5; // NMS threshold
  static const int maxDetections = 10;

  // Performance
  static const bool useGpuDelegate = true;
  static const bool useNnApiDelegate = true;
  static const int numThreads = 4;

  // Image preprocessing
  static const bool normalizeInput = true;
  static const double meanNormalization = 0; // 0 = divide by 255
  static const double stdNormalization = 1; // 1 / 255
  static const String resizeMethod = 'letterbox'; // letterbox or standard

  // Output processing
  static const String outputFormat = 'xywh'; // or 'xyxy'
  static const bool sortByConfidence = true;
  static const bool applyNms = true;

  // Class labels (harus sesuai urutan di labels.txt dan training model)
  static const List<String> classLabels = [
    'Mentah',
    'Setengah Matang',
    'Matang',
    'Busuk',
  ];

  // Model metadata
  static const String modelType = 'yolov8';
  static const String modelSize = 'nano';
  static const String trainedDataset = 'avocado_ripeness';
  static const double accuracy = 0.95; // Expected accuracy (example)

  // Confidence thresholds per class
  static const Map<int, double> classConfidenceThresholds = {
    0: 0.3, // Mentah - lower threshold
    1: 0.4, // Setengah Matang
    2: 0.5, // Matang - default
    3: 0.45, // Busuk
  };
}
