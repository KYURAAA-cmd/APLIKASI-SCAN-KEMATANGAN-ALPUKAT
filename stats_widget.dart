/// lib/presentation/screens/camera/widgets/stats_widget.dart
///
/// Widget untuk menampilkan statistik inferensi (FPS dan waktu).

import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  final int inferenceTimeMs;
  final double fps;

  const StatsWidget({
    Key? key,
    required this.inferenceTimeMs,
    required this.fps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
          children: [
            TextSpan(text: 'Waktu Inferensi: $inferenceTimeMs ms\n'),
            TextSpan(text: 'FPS: ${fps.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );
  }
}