/// lib/ml/services/ml_inference_service.dart
///
/// Service utama untuk inferensi model ML.
/// Menggabungkan TFLite, preprocessing, dan post-processing.
library;

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../app/constants/model_constants.dart';
import '../../domain/entities/scan_result.dart';
import 'image_processing_service.dart';
import 'inference_postprocessing_service.dart';

class MLInferenceService {
  MLInferenceService({
    required ImageProcessingService imageProcessor,
    required InferencePostprocessingService postProcessor,
  })  : _imageProcessor = imageProcessor,
        _postProcessor = postProcessor;
  final ImageProcessingService _imageProcessor;
  final InferencePostprocessingService _postProcessor;
  final Logger _logger = Logger();
  Interpreter? _interpreter;
  List<String>? _labels;

  /// Inisialisasi service: memuat model dan label.
  Future<void> initialize() async {
    if (_interpreter != null && _labels != null) {
      _logger.d('🤖 MLInferenceService already initialized.');
      return;
    }
    _logger.i('🤖 Initializing MLInferenceService...');
    try {
      await _loadModel();
      await _loadLabels();
      _logger.i('✅ MLInferenceService initialized successfully.');
    } catch (e) {
      _logger.e('❌ Failed to initialize MLInferenceService: $e');
      rethrow;
    }
  }

  Future<void> _loadModel() async {
    try {
      final options = InterpreterOptions()..threads = ModelConstants.numThreads;
      if (ModelConstants.useGpuDelegate) {
        try {
          options.addDelegate(GpuDelegate());
          _logger.i('⚡ GPU Delegate enabled.');
        } catch (e) {
          _logger.w('⚠️ GPU Delegate not available: $e');
        }
      }
      /*
      if (ModelConstants.useNnApiDelegate) {
        try {
          options.addDelegate(NnApiDelegate());
          _logger.i('⚡ NNAPI Delegate enabled.');
        } catch (e) {
          _logger.w('⚠️ NNAPI Delegate not available: $e');
        }
      }
      */
      _interpreter = await Interpreter.fromAsset(ModelConstants.modelPath, options: options);
      _interpreter!.allocateTensors();
      _logger.i('✅ TFLite model loaded and tensors allocated.');
      _logModelInfo();
    } catch (e) {
      _logger.e('❌ Error loading TFLite model: $e');
      rethrow;
    }
  }

  void _logModelInfo() {
    if (_interpreter == null) return;
    final input = _interpreter!.getInputTensor(0);
    final output = _interpreter!.getOutputTensor(0);
    _logger.d('Input tensor: ${input.name}, shape: ${input.shape}, type: ${input.type}');
    _logger.d('Output tensor: ${output.name}, shape: ${output.shape}, type: ${output.type}');
  }

  Future<void> _loadLabels() async {
    try {
      final labelsData = await rootBundle.loadString(ModelConstants.labelsPath);
      _labels = labelsData.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      _logger.i('✅ Labels loaded: $_labels');
    } catch (e) {
      _logger.e('❌ Error loading labels: $e');
      rethrow;
    }
  }

  /// Menjalankan inferensi pada gambar.
  Future<ScanResult> runInferenceOnImage(String imagePath) async {
    if (_interpreter == null || _labels == null) {
      throw Exception('ML Service not initialized. Call initialize() first.');
    }

    final stopwatch = Stopwatch()..start();
    final imageBytes = await File(imagePath).readAsBytes();
    final originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) throw Exception('Failed to decode image: $imagePath');

    final originalSize = Size(originalImage.width.toDouble(), originalImage.height.toDouble());
    final inputTensor = _imageProcessor.preprocessImageFile(imageBytes);
    final preprocessTime = stopwatch.elapsedMilliseconds;
    stopwatch.reset();
    stopwatch.start();

    // Input shape: [1, 640, 640, 3], Output shape: [1, 8400, 8]
    // Reshape input tensor untuk batch size 1
    final batchedInput = inputTensor.reshape([1, ModelConstants.inputSize, ModelConstants.inputSize, 3]);
    final outputShape = _interpreter!.getOutputTensor(0).shape;
    final outputBuffer = List.filled(outputShape.reduce((a, b) => a * b), 0).reshape(outputShape);

    _interpreter!.run(batchedInput, outputBuffer);
    final inferenceTime = stopwatch.elapsedMilliseconds;

    // Output shape is [1, 8400, 8], kita hanya perlu batch pertama.
    final detections = _postProcessor.postProcessYOLOv8(
      outputBuffer[0],
      imageWidth: originalSize.width.toInt(),
      imageHeight: originalSize.height.toInt(),
      modelInputWidth: ModelConstants.inputSize,
      modelInputHeight: ModelConstants.inputSize,
    );

    final scanResult = _createScanResult(
      imagePath: imagePath,
      detections: detections,
      inferenceTimeMs: inferenceTime,
      imageSize: originalSize,
    );

    _logger.i('📊 Inference complete in ${inferenceTime}ms (preprocess: ${preprocessTime}ms)');
    _logger.d('Found ${scanResult.detectionCount} objects.');

    return scanResult;
  }

  /// Menjalankan inferensi pada satu frame dari stream kamera.
  /// Ini dioptimalkan untuk menghindari I/O file.
  ///
  /// Mengembalikan tuple dari (List Deteksi, ukuran gambar asli).
  (List<Detection>, Size, int)? runInferenceOnFrame(CameraImage cameraImage) {
    if (_interpreter == null) {
      _logger.w('Interpreter belum siap, melewati frame.');
      return null;
    }

    final stopwatch = Stopwatch()..start();

    // Pra-pemrosesan gambar
    final (inputTensor, originalImage) =
        _imageProcessor.preprocessCameraImage(cameraImage);

    final originalSize = Size(originalImage.width.toDouble(), originalImage.height.toDouble());

    // Siapkan input dan output
    final batchedInput = inputTensor.reshape([1, ModelConstants.inputSize, ModelConstants.inputSize, 3]);
    final outputShape = _interpreter!.getOutputTensor(0).shape;
    final outputBuffer = List.filled(outputShape.reduce((a, b) => a * b), 0).reshape(outputShape);

    // Jalankan inferensi
    _interpreter!.run(batchedInput, outputBuffer);
    final inferenceTime = stopwatch.elapsedMilliseconds;

    // Pasca-pemrosesan output
    final detections = _postProcessor.postProcessYOLOv8(
      outputBuffer[0],
      imageWidth: originalSize.width.toInt(),
      imageHeight: originalSize.height.toInt(),
      modelInputWidth: ModelConstants.inputSize,
      modelInputHeight: ModelConstants.inputSize,
    );

    return (detections, originalSize, inferenceTime);
  }

  ScanResult _createScanResult({
    required String imagePath,
    required List<Detection> detections,
    required int inferenceTimeMs,
    required Size imageSize,
  }) {
    Detection? mainDetection;
    if (detections.isNotEmpty) {
      mainDetection = detections.reduce((a, b) => a.confidence > b.confidence ? a : b);
    }

    return ScanResult(
      scanDate: DateTime.now(),
      imagePath: imagePath,
      detections: detections,
      mainDetection: mainDetection,
      mainClass: mainDetection?.classLabel ?? AvocadoClass.unknown,
      mainConfidence: mainDetection?.confidence ?? 0.0,
      inferenceTimeMs: inferenceTimeMs,
      imageWidth: imageSize.width.toInt(),
      imageHeight: imageSize.height.toInt(),
    );
  }

  void dispose() {
    if (_interpreter != null) {
      _interpreter!.close();
      _interpreter = null;
      _logger.i('MLInferenceService disposed.');
    }
  }
}