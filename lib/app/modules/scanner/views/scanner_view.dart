import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_scanner_view.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  Future<void> _openCameraScanner() async {
    final result = await Get.to<String>(() => const CameraScannerView());
    if (result != null) {
      Get.back(result: result);
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // In a real app, you would decode the QR from the image
        // For now, simulate successful scan
        Get.back(result: 'QR_GALLERY_${DateTime.now().millisecondsSinceEpoch}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showManualInput(BuildContext context) {
    final textController = TextEditingController(text: 'QR_CODE_123');
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

  void _quickSubmit() {
    Get.back(result: 'QR_${DateTime.now().millisecondsSinceEpoch}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Scan QR Code'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF5EA500).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  size: 80,
                  color: Color(0xFF5EA500),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Scan QR Code',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose how to scan your QR code',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 40),

              // Live camera scanner button
              FilledButton.icon(
                onPressed: _openCameraScanner,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan with Camera'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(250, 56),
                  backgroundColor: const Color(0xFF5EA500),
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Gallery button
              FilledButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('Upload from Gallery'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(250, 56),
                ),
              ),
              const SizedBox(height: 16),

              // Manual input button
              OutlinedButton.icon(
                onPressed: () => _showManualInput(context),
                icon: const Icon(Icons.keyboard),
                label: const Text('Enter Code Manually'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(250, 56),
                ),
              ),
              const SizedBox(height: 16),

              // Quick submit for testing
              TextButton.icon(
                onPressed: _quickSubmit,
                icon: const Icon(Icons.flash_on),
                label: const Text('Quick Submit (Test)'),
              ),

              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
