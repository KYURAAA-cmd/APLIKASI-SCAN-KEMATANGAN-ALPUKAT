import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/constants/string_constants.dart';
import '../../painters/bounding_box_painter.dart';
import '../../providers/camera_provider.dart';
import '../../providers/view_state.dart';
import 'widgets/stats_widget.dart';

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CameraProvider>(context, listen: false);
      provider.initialize().then((_) {
        if (provider.state == ViewState.success) {
          provider.startStreaming();
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Use a small delay or ensure provider is still valid if needed,
    // but usually calling it directly is fine if we don't listen.
    Future.microtask(() {
       if (mounted) {
         Provider.of<CameraProvider>(context, listen: false).stopStreaming();
       }
    });
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    if (!cameraProvider.isCameraInitialized) return;

    if (state == AppLifecycleState.inactive) {
      cameraProvider.stopStreaming();
    } else if (state == AppLifecycleState.resumed) {
      cameraProvider.startStreaming();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text(StringConstants.cameraScanTitle)),
      backgroundColor: Colors.black,
      body: Consumer<CameraProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case ViewState.loading:
              return const Center(child: CircularProgressIndicator());
            case ViewState.error:
              return _buildInfoMessage(
                context: context,
                message: provider.errorMessage,
                icon: Icons.error_outline,
                buttonText: 'Coba Lagi',
                onPressed: () => provider.initialize(),
              );
            case ViewState.success:
              return _buildCameraPreview(context, provider);
            case ViewState.idle:
            default:
              return const Center(child: Text('Menunggu inisialisasi...', style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );

  Widget _buildCameraPreview(BuildContext context, CameraProvider provider) {
    final controller = provider.cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: LayoutBuilder(builder: (context, constraints) {
          final renderedSize = constraints.biggest;
          return Stack(
            children: [
              CameraPreview(controller),
              if (provider.detections.isNotEmpty && provider.imageSize != Size.zero)
                CustomPaint(
                  size: renderedSize,
                  painter: BoundingBoxPainter(
                    detections: provider.detections,
                    originalImageSize: provider.imageSize,
                    renderedImageSize: renderedSize,
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: StatsWidget(
                    inferenceTimeMs: provider.inferenceTimeMs,
                    fps: provider.fps,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInfoMessage({
    required BuildContext context,
    required String message,
    required IconData icon,
    required String buttonText,
    required VoidCallback onPressed,
  }) => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 60),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
          ],
        ),
      ),
    );
}
