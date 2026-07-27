import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../../app/constants/model_constants.dart';

class ImageProcessingService {
  /// Memproses gambar dari path file untuk inferensi.
  Float32List preprocessImageFile(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Gagal men-decode gambar.');
    }
    return _preprocessImage(image);
  }

  /// Memproses gambar dari CameraImage untuk inferensi real-time.
  /// Mengembalikan tensor input dan gambar asli yang telah di-decode.
  (Float32List, img.Image) preprocessCameraImage(CameraImage cameraImage) {
    // Konversi dari format YUV420 ke gambar RGB.
    final image = _convertYUV420ToImage(cameraImage);

    // Resize dan normalize gambar.
    final inputTensor = _preprocessImage(image);

    return (inputTensor, image);
  }

  /// Fungsi inti untuk resize, letterboxing, dan normalisasi.
  Float32List _preprocessImage(img.Image image) {
    const modelInputSize = ModelConstants.inputSize;

    // Resize gambar dengan letterboxing untuk menjaga rasio aspek.
    final resizedImage = img.copyResize(
      image,
      width: modelInputSize,
      height: modelInputSize,
      maintainAspect: true,
      backgroundColor: img.ColorRgb8(0, 0, 0),
    );

    // Konversi gambar yang sudah di-resize menjadi Float32List.
    final imageAsList = Float32List(modelInputSize * modelInputSize * 3);

    var pixelIndex = 0;
    for (var y = 0; y < modelInputSize; y++) {
      for (var x = 0; x < modelInputSize; x++) {
        final pixel = resizedImage.getPixel(x, y);
        // Normalisasi piksel ke rentang [0, 1]
        imageAsList[pixelIndex++] = pixel.r / 255.0;
        imageAsList[pixelIndex++] = pixel.g / 255.0;
        imageAsList[pixelIndex++] = pixel.b / 255.0;
      }
    }

    return imageAsList;
  }

  /// Mengonversi CameraImage (YUV420_888) ke img.Image (RGB).
  img.Image _convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final image = img.Image(width: width, height: height);

    final yPlane = cameraImage.planes[0];
    final uPlane = cameraImage.planes[1];
    final vPlane = cameraImage.planes[2];

    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;

    final yRowStride = yPlane.bytesPerRow;
    final uRowStride = uPlane.bytesPerRow;
    final vRowStride = vPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel!;

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final yIndex = y * yRowStride + x;
        final uvIndex = (y ~/ 2) * uRowStride + (x ~/ 2) * uvPixelStride;

        final yValue = yBuffer[yIndex];
        final uValue = uBuffer[uvIndex];
        final vValue = vBuffer[uvIndex];

        final r = (yValue + 1.402 * (vValue - 128)).round().clamp(0, 255);
        final g = (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128)).round().clamp(0, 255);
        final b = (yValue + 1.772 * (uValue - 128)).round().clamp(0, 255);

        image.setPixelRgb(x, y, r, g, b);
      }
    }
    return image;
  }
}
