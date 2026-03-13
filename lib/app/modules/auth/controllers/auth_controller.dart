import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthProvider provider;
  AuthController({required this.provider});

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
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
  final currentUser = Rxn<UserModel>();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
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

  // Validators
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
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
      final user = await provider.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (user != null) {
        currentUser.value = user;
        _clearFields();
        Get.offAllNamed(Routes.MAIN);
      } else {
        ToastHelper.showError('Invalid email or password');
      }
    } catch (e) {
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Register
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final user = await provider.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (user != null) {
        currentUser.value = user;
        _clearFields();
        Get.offAllNamed(Routes.MAIN);
      } else {
        ToastHelper.showError('Registration failed. Please try again.');
      }
    } catch (e) {
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await provider.logout();
      currentUser.value = null;
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  void _clearFields() {
    nameController.clear();
    emailController.clear();
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
