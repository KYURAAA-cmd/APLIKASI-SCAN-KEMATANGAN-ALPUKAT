import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/history_provider.dart';
import '../../providers/view_state.dart';
import 'widgets/empty_history_widget.dart';
import 'widgets/history_list_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HistoryProvider>(context, listen: false).fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Scan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => _confirmClearHistory(context),
          ),
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, provider, child) {
          if (provider.state == ViewState.loading && provider.history.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.history.isEmpty) {
            return const EmptyHistoryWidget();
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchHistory(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.history.length,
              itemBuilder: (context, index) {
                final item = provider.history[index];
                return HistoryListItem(
                  scanResult: item,
                  onDelete: () => provider.deleteHistoryItem(item.id!),
                );
              },
            ),
          );
        },
      ),
    );

  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Riwayat?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<HistoryProvider>(context, listen: false).clearHistory();
              Navigator.pop(context);
            },
            child: const Text('HAPUS SEMUA', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
