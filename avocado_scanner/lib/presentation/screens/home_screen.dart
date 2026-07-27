import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/routes/app_routes.dart';
import '../../domain/entities/avocado_class.dart';
import '../../domain/entities/scan_result.dart';
import '../providers/history_provider.dart';
import '../providers/scan_provider.dart';
import '../providers/view_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: const Text('Avocado Ripeness'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.SETTINGS),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Riwayat Terakhir',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.HISTORY),
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildHistoryList(context)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.CAMERA_SCAN),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Scan Sekarang'),
      ),
    );

  Widget _buildHeader(BuildContext context) => Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Siap mendeteksi kematangan alpukat hari ini?',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );

  Widget _buildActionButtons(BuildContext context) => Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.photo_library_outlined,
            label: 'Galeri',
            onTap: () => _scanFromGallery(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActionButton(
            icon: Icons.history,
            label: 'Riwayat',
            onTap: () => Navigator.pushNamed(context, AppRoutes.HISTORY),
          ),
        ),
      ],
    );

  Future<void> _scanFromGallery(BuildContext context) async {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final result = await scanProvider.scanImageFromGallery();

    if (result != null && context.mounted) {
      Navigator.pushNamed(
        context,
        AppRoutes.SCAN_RESULT_DETAIL,
        arguments: result,
      );
    } else if (scanProvider.state == ViewState.error && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(scanProvider.errorMessage)),
      );
    }
  }

  Widget _buildHistoryList(BuildContext context) => Consumer<HistoryProvider>(
      builder: (context, provider, child) {
        if (provider.state == ViewState.loading && provider.history.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.history.isEmpty) {
          return const Center(
            child: Text('Belum ada riwayat scan.'),
          );
        }

        final recentItems = provider.history.take(5).toList();

        return ListView.builder(
          itemCount: recentItems.length,
          itemBuilder: (context, index) {
            final item = recentItems[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Text(item.mainClass.icon),
                ),
                title: Text(item.mainClass.displayName),
                subtitle: Text(
                  '${(item.mainConfidence * 100).toStringAsFixed(1)}% • ${item.formattedDate}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.SCAN_RESULT_DETAIL,
                    arguments: item,
                  );
                },
              ),
            );
          },
        );
      },
    );
}

class _ActionButton extends StatelessWidget {

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
}
