import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Section
            _SectionHeader(title: 'security'.tr),
            const SizedBox(height: 12),
            _SettingItem(
              icon: Icons.lock_outline,
              title: 'change_password'.tr,
              subtitle: 'change_password_subtitle'.tr,
              onTap: () => _showChangePasswordDialog(context),
            ),
            const SizedBox(height: 8),
            _SettingItem(
              icon: Icons.password_outlined,
              title: 'reset_password'.tr,
              subtitle: 'reset_password_subtitle'.tr,
              onTap: () => _showResetPasswordDialog(context),
            ),
            const SizedBox(height: 8),
            _SettingItem(
              icon: Icons.fingerprint,
              title: 'biometric_login'.tr,
              subtitle: 'biometric_login_subtitle'.tr,
              trailing: Obx(() => Switch(
                    value: controller.biometricEnabled.value,
                    onChanged: controller.toggleBiometric,
                    activeTrackColor: AppColors.primary,
                  )),
            ),

            const SizedBox(height: 24),

            // Preferences Section
            _SectionHeader(title: 'preferences'.tr),
            const SizedBox(height: 12),
            Obx(() => _SettingItem(
                  icon: Icons.language_outlined,
                  title: 'language'.tr,
                  subtitle: controller.currentLanguageName,
                  onTap: () => _showLanguageDialog(context),
                )),
            const SizedBox(height: 8),
            _SettingItem(
              icon: Icons.notifications_outlined,
              title: 'notifications'.tr,
              subtitle: 'notifications_subtitle'.tr,
              trailing: Obx(() => Switch(
                    value: controller.notificationsEnabled.value,
                    onChanged: controller.toggleNotifications,
                    activeTrackColor: AppColors.primary,
                  )),
            ),
            const SizedBox(height: 8),
            _SettingItem(
              icon: Icons.dark_mode_outlined,
              title: 'dark_mode'.tr,
              subtitle: 'dark_mode_subtitle'.tr,
              trailing: Obx(() => Switch(
                    value: controller.darkModeEnabled.value,
                    onChanged: controller.toggleDarkMode,
                    activeTrackColor: AppColors.primary,
                  )),
            ),

            const SizedBox(height: 24),

            // About Section
            _SectionHeader(title: 'about'.tr),
            const SizedBox(height: 12),
            _SettingItem(
              icon: Icons.privacy_tip_outlined,
              title: 'privacy_policy'.tr,
              subtitle: 'privacy_policy_subtitle'.tr,
              onTap: () => controller.openPrivacyPolicy(),
            ),
            const SizedBox(height: 8),
            _SettingItem(
              icon: Icons.description_outlined,
              title: 'terms_of_service'.tr,
              subtitle: 'terms_of_service_subtitle'.tr,
              onTap: () => controller.openTermsOfService(),
            ),
            const SizedBox(height: 8),
            _SettingItem(
              icon: Icons.info_outline,
              title: 'app_version'.tr,
              subtitle: '1.0.0',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Danger Zone
            _SectionHeader(title: 'account'.tr, color: AppColors.error),
            const SizedBox(height: 12),
            _SettingItem(
              icon: Icons.delete_outline,
              title: 'delete_account'.tr,
              subtitle: 'delete_account_subtitle'.tr,
              iconColor: AppColors.error,
              textColor: AppColors.error,
              onTap: () => _showDeleteAccountDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'change_password'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'enter_current_new_password'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'current_password'.tr,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_current_password'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'new_password'.tr,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_new_password'.tr;
                  }
                  if (value.length < 8) {
                    return 'password_min_length'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'confirm_new_password'.tr,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'passwords_not_match'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.changePassword(
                        currentPasswordController.text,
                        newPasswordController.text,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('update_password'.tr),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final otpController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Form(
              key: formKey,
              child: Obx(() {
                final step = controller.resetPasswordStep.value;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      step == 0
                          ? 'reset_password'.tr
                          : step == 1
                              ? 'enter_otp'.tr
                              : 'new_password'.tr,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step == 0
                          ? 'enter_email_receive_otp'.tr
                          : step == 1
                              ? 'enter_6_digit_code'.tr
                              : 'create_new_password'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Step 0: Email Input
                    if (step == 0) ...[
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'email_address'.tr,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please_enter_email'.tr;
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'please_enter_valid_email'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              controller.sendOtp(emailController.text);
                            }
                          },
                          child: Text('send_otp'.tr),
                        ),
                      ),
                    ],

                    // Step 1: OTP Input
                    if (step == 1) ...[
                      TextFormField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'otp_code'.tr,
                          prefixIcon: const Icon(Icons.pin_outlined),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.length != 6) {
                            return 'please_enter_6_digit_otp'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'didnt_receive_code'.tr,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                          TextButton(
                            onPressed: () =>
                                controller.sendOtp(emailController.text),
                            child: Text('resend'.tr),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              controller.verifyOtp(otpController.text);
                            }
                          },
                          child: Text('verify_otp'.tr),
                        ),
                      ),
                    ],

                    // Step 2: New Password
                    if (step == 2) ...[
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'new_password'.tr,
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please_enter_new_password'.tr;
                          }
                          if (value.length < 8) {
                            return 'password_min_length'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'confirm_password'.tr,
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value != newPasswordController.text) {
                            return 'passwords_not_match'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              controller.resetPassword(
                                emailController.text,
                                newPasswordController.text,
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: Text('reset_password'.tr),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                );
              }),
            ),
          );
        },
      ),
    ).whenComplete(() => controller.resetOtpStep());
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'select_language'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Obx(() => _LanguageOption(
                  title: 'English',
                  subtitle: 'english'.tr,
                  isSelected: controller.selectedLanguage.value == 'en_US',
                  onTap: () {
                    controller.setLanguage('en_US');
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 8),
            Obx(() => _LanguageOption(
                  title: 'ភាសាខ្មែរ',
                  subtitle: 'khmer'.tr,
                  isSelected: controller.selectedLanguage.value == 'km_KH',
                  onTap: () {
                    controller.setLanguage('km_KH');
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 8),
            Obx(() => _LanguageOption(
                  title: '中文',
                  subtitle: 'chinese'.tr,
                  isSelected: controller.selectedLanguage.value == 'zh_CN',
                  onTap: () {
                    controller.setLanguage('zh_CN');
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_account'.tr),
        content: Text('delete_account_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteAccount();
            },
            child: Text(
              'delete'.tr,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;

  const _SectionHeader({required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? textColor;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? AppColors.primaryLight : null,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppColors.primary)
            : null,
        onTap: onTap,
      ),
    );
  }
}
