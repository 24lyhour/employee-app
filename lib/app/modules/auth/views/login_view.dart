import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // Logo
                Icon(
                  Icons.access_time_filled,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                // Email field
                CustomTextField(
                  controller: controller.emailController,
                  labelText: AppStrings.email,
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: 16),
                // Password field
                Obx(() => CustomTextField(
                      controller: controller.passwordController,
                      labelText: AppStrings.password,
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outlined,
                      obscureText: !controller.isPasswordVisible.value,
                      validator: controller.validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    )),
                const SizedBox(height: 8),
                // Remember me & Forgot password row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember me
                    Obx(() => GestureDetector(
                          onTap: controller.toggleRememberMe,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: (_) => controller.toggleRememberMe(),
                                  activeColor: const Color(0xFF5EA500),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF9CA3AF),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Remember me',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF6B7280),
                                    ),
                              ),
                            ],
                          ),
                        )),
                    // Forgot password
                    TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(AppStrings.forgotPassword),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Login button
                Obx(() => CustomButton(
                      text: AppStrings.login,
                      onPressed: controller.login,
                      isLoading: controller.isLoading.value,
                    )),
                const SizedBox(height: 24),
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: controller.goToRegister,
                      child: const Text(AppStrings.register),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
