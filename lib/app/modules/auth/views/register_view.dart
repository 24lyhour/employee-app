import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('register'.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'create_account'.tr,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'fill_details'.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: controller.nameController,
                  labelText: 'name'.tr,
                  hintText: 'enter_name'.tr,
                  prefixIcon: Icons.person_outlined,
                  keyboardType: TextInputType.name,
                  validator: controller.validateName,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.emailController,
                  labelText: 'email'.tr,
                  hintText: 'enter_email'.tr,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: 16),
                Obx(() => CustomTextField(
                      controller: controller.passwordController,
                      labelText: 'password'.tr,
                      hintText: 'enter_password'.tr,
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
                const SizedBox(height: 16),
                Obx(() => CustomTextField(
                      controller: controller.confirmPasswordController,
                      labelText: 'confirm_password'.tr,
                      hintText: 'confirm_your_password'.tr,
                      prefixIcon: Icons.lock_outlined,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      validator: controller.validateConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    )),
                const SizedBox(height: 32),
                Obx(() => CustomButton(
                      text: 'register'.tr,
                      onPressed: controller.register,
                      isLoading: controller.isLoading.value,
                    )),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already_have_account'.tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: controller.goToLogin,
                      child: Text('login'.tr),
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
