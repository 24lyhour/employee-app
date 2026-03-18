import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../data/models/employee_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthProvider provider;
  AuthController({required this.provider});

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // State
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final currentEmployee = Rxn<EmployeeModel>();
  final loginMethod = 'email'.obs; // 'email' or 'phone'

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void setLoginMethod(String method) {
    loginMethod.value = method;
  }

  // Validators using FormBuilderValidators
  String? validateEmail(String? value) {
    if (loginMethod.value != 'email') return null;
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Email is required'),
      FormBuilderValidators.email(errorText: 'Please enter a valid email'),
    ])(value);
  }

  String? validatePhone(String? value) {
    if (loginMethod.value != 'phone') return null;
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Phone number is required'),
      FormBuilderValidators.minLength(8,
          errorText: 'Please enter a valid phone number'),
    ])(value);
  }

  String? Function(String?) get validatePassword => FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Password is required'),
        FormBuilderValidators.minLength(6,
            errorText: 'Password must be at least 6 characters'),
      ]);

  String? Function(String?) get validateName => FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Name is required'),
        FormBuilderValidators.minLength(2,
            errorText: 'Name must be at least 2 characters'),
      ]);

  String? validateConfirmPassword(String? value) {
    final requiredCheck = FormBuilderValidators.required(
        errorText: 'Please confirm your password')(value);
    if (requiredCheck != null) return requiredCheck;

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Login
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await provider.login(
        email: loginMethod.value == 'email' ? emailController.text.trim() : null,
        phone: loginMethod.value == 'phone' ? phoneController.text.trim() : null,
        password: passwordController.text,
      );

      if (response.success && response.employee != null) {
        currentEmployee.value = response.employee;
        _clearFields();
        ToastHelper.showSuccess(response.message);
        Get.offAllNamed(Routes.MAIN);
      } else {
        ToastHelper.showError(response.message);
      }
    } catch (e) {
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Register (Employee registration might not be available via app)
  Future<void> register() async {
    ToastHelper.showError('Registration is not available. Please contact admin.');
  }

  // Logout
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await provider.logout();
      currentEmployee.value = null;
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  // Logout from all devices
  Future<void> logoutAll() async {
    isLoading.value = true;
    try {
      await provider.logoutAll();
      currentEmployee.value = null;
      ToastHelper.showSuccess('Logged out from all devices');
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user is already logged in
  Future<void> checkAuth() async {
    final employee = await provider.getCurrentEmployee();
    if (employee != null) {
      currentEmployee.value = employee;
      Get.offAllNamed(Routes.MAIN);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // Refresh profile
  Future<void> refreshProfile() async {
    final response = await provider.getProfile();
    if (response.success && response.employee != null) {
      currentEmployee.value = response.employee;
    }
  }

  void _clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void goToRegister() {
    _clearFields();
    Get.toNamed(Routes.REGISTER);
  }

  void goToLogin() {
    _clearFields();
    Get.back();
  }
}
