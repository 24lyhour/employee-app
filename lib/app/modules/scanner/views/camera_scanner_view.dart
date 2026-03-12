import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/utils/toast_helper.dart';

class CameraScannerView extends StatefulWidget {
  const CameraScannerView({super.key});

  @override
  State<CameraScannerView> createState() => _CameraScannerViewState();
}

class _CameraScannerViewState extends State<CameraScannerView> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _isScanned = true;
        Get.back(result: barcode.rawValue);
        break;
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Analyze picked image for QR code
        final result = await controller.analyzeImage(image.path);
        if (result != null && result.barcodes.isNotEmpty) {
          final code = result.barcodes.first.rawValue;
          if (code != null) {
            Get.back(result: code);
            return;
          }
        }
        ToastHelper.showWarning('No QR code found in image');
      }
    } catch (e) {
      ToastHelper.showError('Failed to pick image');
    }
  }

  void _showManualInput() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter QR Code'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter code manually',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              if (textController.text.isNotEmpty) {
                Get.back(result: textController.text);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                return Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                );
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5EA500).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.no_photography,
                            color: Color(0xFF5EA500),
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Camera Not Available',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use Gallery or Manual input instead',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        const SizedBox(height: 32),
                        FilledButton.icon(
                          onPressed: _pickFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Upload from Gallery'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(220, 52),
                            backgroundColor: const Color(0xFF5EA500),
                            foregroundColor: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _showManualInput,
                          icon: const Icon(Icons.keyboard, color: Colors.white),
                          label: const Text('Enter Manually', style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(220, 52),
                            side: const BorderSide(color: Colors.white54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Scanner overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF5EA500),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Text(
              'Point camera at QR code',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        blurRadius: 8,
                        color: Colors.black,
                      ),
                    ],
                  ),
            ),
          ),
          // Bottom options
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _OptionButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: _pickFromGallery,
                ),
                _OptionButton(
                  icon: Icons.keyboard,
                  label: 'Manual',
                  onTap: _showManualInput,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
