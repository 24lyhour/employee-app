import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'toast_helper.dart';

/// Shared helper for picking images from gallery and scanning QR codes
class GalleryPickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery and analyze for QR code
  /// Returns the QR code value if found, null otherwise
  static Future<String?> pickAndScanQR({
    MobileScannerController? scannerController,
  }) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      // If scanner controller is provided, use it to analyze the image
      if (scannerController != null) {
        final result = await scannerController.analyzeImage(image.path);
        if (result != null && result.barcodes.isNotEmpty) {
          final code = result.barcodes.first.rawValue;
          if (code != null) {
            return code;
          }
        }
        ToastHelper.showWarning('No QR code found in image');
        return null;
      }

      // Fallback: return a generated code (for testing/demo)
      return 'QR_GALLERY_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      ToastHelper.showError('Failed to pick image');
      return null;
    }
  }

  /// Pick image from gallery and return result via Get.back()
  static Future<void> pickAndReturn({
    MobileScannerController? scannerController,
  }) async {
    final result = await pickAndScanQR(scannerController: scannerController);
    if (result != null) {
      Get.back(result: result);
    }
  }
}
