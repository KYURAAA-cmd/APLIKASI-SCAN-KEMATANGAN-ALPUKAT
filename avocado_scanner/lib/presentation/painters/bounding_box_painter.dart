import 'package:flutter/material.dart';

import '../../domain/entities/avocado_class.dart';
import '../../domain/entities/detection.dart';

class BoundingBoxPainter extends CustomPainter {

  BoundingBoxPainter({
    required this.detections,
    required this.originalImageSize,
    required this.renderedImageSize,
  });
  final List<Detection> detections;
  final Size originalImageSize;
  final Size renderedImageSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (originalImageSize.width == 0 || originalImageSize.height == 0) return;

    final scaleX = renderedImageSize.width / originalImageSize.width;
    final scaleY = renderedImageSize.height / originalImageSize.height;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    for (final detection in detections) {
      final rect = Rect.fromLTRB(
        detection.x * scaleX,
        detection.y * scaleY,
        detection.right * scaleX,
        detection.bottom * scaleY,
      );

      paint.color = _getColorForClass(detection.classLabel.displayName);
      canvas.drawRect(rect, paint);

      _drawText(canvas, rect, '${detection.classLabel.displayName} ${(detection.confidence * 100).toStringAsFixed(0)}%');
    }
  }

  Color _getColorForClass(String label) {
    switch (label.toLowerCase()) {
      case 'matang':
        return Colors.green;
      case 'setengah matang':
        return Colors.orange;
      case 'mentah':
        return Colors.blue;
      case 'busuk':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  void _drawText(Canvas canvas, Rect rect, String text) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        backgroundColor: Colors.black54,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Draw background for text
    final textBackground = Paint()..color = Colors.black54;
    canvas.drawRect(
      Rect.fromLTWH(rect.left, rect.top - textPainter.height, textPainter.width, textPainter.height),
      textBackground
    );

    textPainter.paint(canvas, Offset(rect.left, rect.top - textPainter.height));
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) => oldDelegate.detections != detections ||
        oldDelegate.renderedImageSize != renderedImageSize;
}
