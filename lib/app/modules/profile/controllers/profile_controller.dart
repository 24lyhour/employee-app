import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/toast_helper.dart';
import '../../auth/data/models/employee_model.dart';
import '../../auth/data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthProvider authProvider;
  ProfileController({required this.authProvider});

  final employee = Rxn<EmployeeModel>();
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final avatarKey = 0.obs; // Key to force avatar refresh

  @override
  void onInit() {
    super.onInit();
    loadEmployee();
  }

  /// Load employee from storage or API
  Future<void> loadEmployee({bool clearCache = false}) async {
    isLoading.value = true;
    try {
      // Clear image cache if requested (e.g., after profile update)
      if (clearCache) {
        await _clearAvatarCache();
        avatarKey.value++; // Increment key to force widget rebuild
      }

      final emp = await authProvider.getCurrentEmployee();
      if (emp != null) {
        employee.value = emp;
      } else {
        // Not logged in, redirect to login
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      ToastHelper.showError('Failed to load profile');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh employee profile from API
  Future<void> refreshProfile() async {
    isRefreshing.value = true;
    try {
      // Clear image cache to get fresh avatar
      await _clearAvatarCache();
      avatarKey.value++;

      final response = await authProvider.getProfile();
      if (response.success && response.employee != null) {
        employee.value = response.employee;
        // Save updated employee to storage
        await StorageService.saveEmployee(response.employee!.toJson());
      } else {
        ToastHelper.showError(response.message ?? 'Failed to refresh profile');
      }
    } catch (e) {
      ToastHelper.showError('Connection error');
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Clear avatar image cache
  Future<void> _clearAvatarCache() async {
    // Clear Flutter's image cache
    imageCache.clear();
    imageCache.clearLiveImages();

    // Clear CachedNetworkImage cache
    await DefaultCacheManager().emptyCache();

    // Also evict specific avatar URL if exists
    final avatarUrl = employee.value?.avatarUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      await CachedNetworkImage.evictFromCache(avatarUrl);
    }
  }

  /// Logout current device
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await authProvider.logout();
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }
}
