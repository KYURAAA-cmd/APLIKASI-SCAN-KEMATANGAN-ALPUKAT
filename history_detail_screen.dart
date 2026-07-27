/// lib/presentation/screens/detail/history_detail_screen.dart
///
/// Screen untuk menampilkan detail dari satu riwayat scan.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/constants/string_constants.dart';
import '../../../domain/entities/avocado_class.dart';
import '../../../domain/entities/scan_result.dart';
import 'widgets/detection_image_widget.dart';
import 'widgets/info_card_widget.dart';

class HistoryDetailScreen extends StatelessWidget {
  final ScanResult scanResult;

  const HistoryDetailScreen({
    Key? key,
    required this.scanResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.detailedResultsTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with Bounding Boxes
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: DetectionImageWidget(scanResult: scanResult),
              ),
              const SizedBox(height: 24),

              // Main Result Card
              _buildMainResultCard(theme),
              const SizedBox(height: 24),

              // Details Section
              Text(
                StringConstants.detectionDetailsTitle,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDetailsGrid(context),
              const SizedBox(height: 24),

              // Recommendation
              Text(
                StringConstants.recommendationTitle,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                scanResult.mainClass.recommendation,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainResultCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: scanResult.mainClass.color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              scanResult.mainClass.icon,
              size: 48,
              color: scanResult.mainClass.color,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.ripenesStatusTitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    scanResult.mainClass.displayName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scanResult.mainClass.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${scanResult.mainConfidencePercentage.toStringAsFixed(1)}% Confidence',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scanResult.mainClass.color.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        InfoCardWidget(
          icon: Icons.calendar_today_outlined,
          title: StringConstants.scanDateTimeTitle,
          value: DateFormat('d MMM y, HH:mm').format(scanResult.scanDate),
        ),
        InfoCardWidget(
          icon: Icons.timer_outlined,
          title: StringConstants.inferenceTimeTitle,
          value: '${scanResult.inferenceTimeMs} ms',
        ),
        InfoCardWidget(
          icon: Icons.aspect_ratio_outlined,
          title: 'Image Size',
          value: '${scanResult.imageWidth} x ${scanResult.imageHeight}',
        ),
        InfoCardWidget(
          icon: Icons.center_focus_strong_outlined,
          title: StringConstants.detectionsTitle,
          value: '${scanResult.detectionCount}',
        ),
      ],
    );
  }
}