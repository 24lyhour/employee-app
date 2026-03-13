import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';

class SettingController extends GetxController {
  // Settings state
  final biometricEnabled = false.obs;
  final notificationsEnabled = true.obs;
  final darkModeEnabled = false.obs;
  final selectedLanguage = 'en_US'.obs;

  // Reset password flow
  final resetPasswordStep = 0.obs;

  // Get current language name for display
  String get currentLanguageName {
    switch (selectedLanguage.value) {
      case 'en_US':
        return 'English';
      case 'km_KH':
        return 'ភាសាខ្មែរ';
      case 'zh_CN':
        return '中文';
      default:
        return 'English';
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    // Load from storage (values only)
    biometricEnabled.value = StorageService.getBiometric();
    notificationsEnabled.value = StorageService.getNotifications();
    darkModeEnabled.value = StorageService.getDarkMode();
    selectedLanguage.value = StorageService.getLanguage();
  }

  // Toggle methods
  void toggleBiometric(bool value) {
    biometricEnabled.value = value;
    StorageService.setBiometric(value);
    _showToast(value ? 'biometric_enabled'.tr : 'biometric_disabled'.tr);
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    StorageService.setNotifications(value);
    _showToast(
        value ? 'notifications_enabled'.tr : 'notifications_disabled'.tr);
  }

  void toggleDarkMode(bool value) {
    darkModeEnabled.value = value;
    StorageService.setDarkMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    _showToast(value ? 'dark_mode_enabled'.tr : 'light_mode_enabled'.tr);
  }

  void setLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
    StorageService.setLanguage(languageCode);

    // Update app locale
    final parts = languageCode.split('_');
    final locale = Locale(parts[0], parts.length > 1 ? parts[1] : '');
    Get.updateLocale(locale);

    _showToast('${'language_changed_to'.tr} ${_getLanguageName(languageCode)}');
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en_US':
        return 'English';
      case 'km_KH':
        return 'ភាសាខ្មែរ';
      case 'zh_CN':
        return '中文';
      default:
        return 'English';
    }
  }

  // Password methods
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      // TODO: Implement API call to change password
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      _showToast('password_changed_success'.tr);
    } catch (e) {
      _showToast('password_change_failed'.tr, isError: true);
    }
  }

  Future<void> sendOtp(String email) async {
    try {
      // TODO: Implement API call to send OTP
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      resetPasswordStep.value = 1;
      _showToast('${'otp_sent_to'.tr} $email');
    } catch (e) {
      _showToast('otp_send_failed'.tr, isError: true);
    }
  }

  Future<void> verifyOtp(String otp) async {
    try {
      // TODO: Implement API call to verify OTP
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      resetPasswordStep.value = 2;
      _showToast('otp_verified'.tr);
    } catch (e) {
      _showToast('invalid_otp'.tr, isError: true);
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      // TODO: Implement API call to reset password
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      resetOtpStep();
      _showToast('password_reset_success'.tr);
    } catch (e) {
      _showToast('password_reset_failed'.tr, isError: true);
    }
  }

  void resetOtpStep() {
    resetPasswordStep.value = 0;
  }

  // Info dialog methods
  void openPrivacyPolicy() {
    Get.dialog(
      AlertDialog(
        title: Text('privacy_policy'.tr),
        content: const Text(
          'Our privacy policy outlines how we collect, use, and protect your personal information. '
          'We are committed to maintaining the confidentiality and security of your data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }

  void openTermsOfService() {
    Get.dialog(
      AlertDialog(
        title: Text('terms_of_service'.tr),
        content: const Text(
          'By using this application, you agree to comply with our terms of service. '
          'These terms govern your use of our services and outline your rights and responsibilities.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }

  // Account deletion
  Future<void> deleteAccount() async {
    try {
      // TODO: Implement API call to delete account
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      _showToast('account_deleted'.tr);
      // TODO: Navigate to login screen and clear user data
    } catch (e) {
      _showToast('account_delete_failed'.tr, isError: true);
    }
  }

  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
    );
  }
}
