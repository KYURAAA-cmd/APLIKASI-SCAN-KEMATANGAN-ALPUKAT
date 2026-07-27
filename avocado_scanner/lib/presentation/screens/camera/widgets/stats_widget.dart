import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {

  const StatsWidget({
    required this.inferenceTimeMs, required this.fps, super.key,
  });
  final int inferenceTimeMs;
  final double fps;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inference: $inferenceTimeMs ms',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            'FPS: ${fps.toStringAsFixed(1)}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
}
