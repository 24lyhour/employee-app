import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
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
    debugPrint('Navigating to LOGIN...');

    try {
      Get.offAllNamed(Routes.LOGIN);
      debugPrint('Navigation successful');
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }
}
