import 'package:flutter/material.dart';

import '../../../domain/entities/scan_result.dart';
import 'widgets/detection_image_widget.dart';

class ScanResultDetailScreen extends StatelessWidget {

  const ScanResultDetailScreen({
    required this.scanResult, super.key,
  });
  final ScanResult scanResult;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Detail Scan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DetectionImageWidget(scanResult: scanResult),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Hasil Deteksi'),
                  const SizedBox(height: 12),
                  _buildResultCard(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Informasi Tambahan'),
                  const SizedBox(height: 12),
                  _buildInfoRow('Waktu Scan', scanResult.formattedDate),
                  _buildInfoRow('Waktu Inferensi', '${scanResult.inferenceTimeMs} ms'),
                  _buildInfoRow('Dimensi Gambar', '${scanResult.imageWidth}x${scanResult.imageHeight}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildSectionTitle(BuildContext context, String title) => Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );

  Widget _buildResultCard(BuildContext context) => Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: _getColor(scanResult.mainClass.displayName).withValues(alpha: 0.2),
              child: Text(
                scanResult.mainClass.icon,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scanResult.mainClass.displayName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getColor(scanResult.mainClass.displayName),
                        ),
                  ),
                  Text(
                    'Confidence: ${(scanResult.mainConfidence * 100).toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildInfoRow(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );

  Color _getColor(String label) {
    switch (label.toLowerCase()) {
      case 'matang': return Colors.green;
      case 'setengah matang': return Colors.orange;
      case 'mentah': return Colors.blue;
      case 'busuk': return Colors.red;
      default: return Colors.grey;
    }
  }
}
