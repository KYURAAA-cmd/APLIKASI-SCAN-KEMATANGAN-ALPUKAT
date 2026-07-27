/// lib/presentation/screens/detail/widgets/detection_image_widget.dart
///
/// Widget untuk menampilkan gambar dengan bounding box deteksi.

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../domain/entities/scan_result.dart';
import '../../../painters/bounding_box_painter.dart';

class DetectionImageWidget extends StatelessWidget {
  final ScanResult scanResult;

  const DetectionImageWidget({
    Key? key,
    required this.scanResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageFile = File(scanResult.imagePath);

    if (!imageFile.existsSync()) {
      return _buildImageError(context);
    }

    return AspectRatio(
      aspectRatio: scanResult.imageWidth / scanResult.imageHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final renderedSize = Size(constraints.maxWidth, constraints.maxHeight);
          return CustomPaint(
            painter: BoundingBoxPainter(
              detections: scanResult.detections,
              originalImageSize: Size(
                scanResult.imageWidth.toDouble(),
                scanResult.imageHeight.toDouble(),
              ),
              renderedImageSize: renderedSize,
            ),
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageError(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: theme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Gambar tidak ditemukan',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}