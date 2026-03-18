import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    debugPrint('SplashController onInit');
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('SplashController onReady');
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    debugPrint('Starting navigation delay...');
    await Future.delayed(AppDurations.splash);

    // Check if user is logged in
    final isLoggedIn = StorageService.isLoggedIn();
    debugPrint('Is logged in: $isLoggedIn');

    try {
      if (isLoggedIn) {
        debugPrint('Navigating to MAIN...');
        Get.offAllNamed(Routes.MAIN);
      } else {
        debugPrint('Navigating to LOGIN...');
        Get.offAllNamed(Routes.LOGIN);
      }
      debugPrint('Navigation successful');
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }
}
