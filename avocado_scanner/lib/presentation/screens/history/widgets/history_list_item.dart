import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../domain/entities/scan_result.dart';

class HistoryListItem extends StatelessWidget {

  const HistoryListItem({
    required this.scanResult, required this.onDelete, super.key,
  });
  final ScanResult scanResult;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColor(scanResult.mainClass.displayName).withValues(alpha: 0.2),
          child: Text(scanResult.mainClass.icon),
        ),
        title: Text(scanResult.mainClass.displayName),
        subtitle: Text(
          '${(scanResult.mainConfidence * 100).toStringAsFixed(1)}% • ${scanResult.formattedDate}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.SCAN_RESULT_DETAIL,
            arguments: scanResult,
          );
        },
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
