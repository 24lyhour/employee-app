import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToastHelper {
  static void showSuccess(String message) {
    _showToast(
      title: 'Success!',
      message: message,
      icon: Icons.check,
      iconBgColor: const Color(0xFFDCFCE7),
      iconColor: const Color(0xFF22C55E),
      titleColor: const Color(0xFF166534),
    );
  }

  static void showError(String message) {
    _showToast(
      title: 'Error!',
      message: message,
      icon: Icons.close,
      iconBgColor: const Color(0xFFFEE2E2),
      iconColor: const Color(0xFFEF4444),
      titleColor: const Color(0xFFB91C1C),
    );
  }

  static void showInfo(String message) {
    _showToast(
      title: 'Info',
      message: message,
      icon: Icons.info_outline,
      iconBgColor: const Color(0xFFDBEAFE),
      iconColor: const Color(0xFF3B82F6),
      titleColor: const Color(0xFF1E40AF),
    );
  }

  static void showWarning(String message) {
    _showToast(
      title: 'Warning!',
      message: message,
      icon: Icons.warning_amber_rounded,
      iconBgColor: const Color(0xFFFEF3C7),
      iconColor: const Color(0xFFF59E0B),
      titleColor: const Color(0xFFB45309),
    );
  }

  static void _showToast({
    required String title,
    required String message,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required Color titleColor,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, color: Color(0xFF9CA3AF), size: 22),
              ),
            ),
          ],
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      borderRadius: 0,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.zero,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }
}
