import 'package:get/get.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../data/models/employee_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthProvider authProvider;
  ProfileController({required this.authProvider});

  final employee = Rxn<EmployeeModel>();
  final isLoading = false.obs;
  final isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadEmployee();
  }

  /// Load employee from storage or API
  Future<void> loadEmployee() async {
    isLoading.value = true;
    try {
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
      final response = await authProvider.getProfile();
      if (response.success && response.employee != null) {
        employee.value = response.employee;
        ToastHelper.showSuccess('Profile updated');
      } else {
        ToastHelper.showError(response.message ?? 'Failed to refresh profile');
      }
    } catch (e) {
      ToastHelper.showError('Connection error');
    } finally {
      isRefreshing.value = false;
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

  /// Logout from all devices
  Future<void> logoutAll() async {
    isLoading.value = true;
    try {
      await authProvider.logoutAll();
      ToastHelper.showSuccess('Logged out from all devices');
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }
}
