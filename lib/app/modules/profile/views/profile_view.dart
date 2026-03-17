import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/clock_loading_widget.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('profile'.tr),
        actions: [
          Obx(() => controller.isRefreshing.value
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: controller.refreshProfile,
                )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: ClockLoadingWidget(size: 50));
        }

        final employee = controller.employee.value;
        if (employee == null) {
          return const Center(child: ClockLoadingWidget(size: 50));
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  backgroundImage: employee.avatarUrl != null
                      ? NetworkImage(employee.avatarUrl!)
                      : null,
                  child: employee.avatarUrl == null
                      ? Text(
                          employee.fullName.isNotEmpty
                              ? employee.fullName[0].toUpperCase()
                              : 'E',
                          style:
                              Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  employee.fullName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                // Job Title
                if (employee.jobTitle != null)
                  Text(
                    employee.jobTitle!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                const SizedBox(height: 4),
                // Department
                if (employee.department != null)
                  Text(
                    employee.department!.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                const SizedBox(height: 32),

                // Info Cards
                _InfoCard(
                  icon: Icons.badge_outlined,
                  label: 'employee_id'.tr,
                  value: employee.employeeCode,
                ),
                const SizedBox(height: 12),
                if (employee.email != null)
                  _InfoCard(
                    icon: Icons.email_outlined,
                    label: 'email'.tr,
                    value: employee.email!,
                  ),
                if (employee.email != null) const SizedBox(height: 12),
                if (employee.phoneNumber != null)
                  _InfoCard(
                    icon: Icons.phone_outlined,
                    label: 'phone'.tr,
                    value: employee.phoneNumber!,
                  ),
                if (employee.phoneNumber != null) const SizedBox(height: 12),
                if (employee.school != null)
                  _InfoCard(
                    icon: Icons.business_outlined,
                    label: 'school'.tr,
                    value: employee.school!.name,
                  ),
                if (employee.school != null) const SizedBox(height: 12),
                if (employee.department != null)
                  _InfoCard(
                    icon: Icons.apartment_outlined,
                    label: 'department'.tr,
                    value: employee.department!.name,
                  ),
                const SizedBox(height: 32),

                // Menu Items - Primary Actions
                _MenuItem(
                  icon: Icons.dashboard_outlined,
                  label: 'my_dashboard'.tr,
                  onTap: () => Get.toNamed(Routes.DASHBOARD),
                ),
                _MenuItem(
                  icon: Icons.assignment_outlined,
                  label: 'request_permission'.tr,
                  onTap: () => Get.toNamed(Routes.STAFF_REQUEST_PERMISSION),
                ),
                const SizedBox(height: 8),

                // Account Settings
                _MenuItem(
                  icon: Icons.edit_outlined,
                  label: 'edit_profile'.tr,
                  onTap: () {
                    // TODO: Navigate to edit profile
                  },
                ),
                _MenuItem(
                  icon: Icons.settings_outlined,
                  label: 'settings'.tr,
                  onTap: () => Get.toNamed(Routes.SETTING),
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'notifications'.tr,
                  onTap: () {
                    // TODO: Navigate to notifications settings
                  },
                ),
                const SizedBox(height: 8),

                // Support
                _MenuItem(
                  icon: Icons.help_outline,
                  label: 'help_support'.tr,
                  onTap: () {
                    // TODO: Navigate to help
                  },
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  label: 'about'.tr,
                  onTap: () {
                    // TODO: Show about dialog
                  },
                ),
                const SizedBox(height: 16),

                // Logout options
                _MenuItem(
                  icon: Icons.logout,
                  label: 'logout'.tr,
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () => _showLogoutDialog(context),
                ),
                _MenuItem(
                  icon: Icons.logout,
                  label: 'logout_all_devices'.tr,
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () => _showLogoutAllDialog(context),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout'.tr),
        content: Text('logout_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.logout();
            },
            child: Text(
              'logout'.tr,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout_all_devices'.tr),
        content: Text('logout_all_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.logoutAll();
            },
            child: Text(
              'logout'.tr,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          label,
          style: TextStyle(color: textColor),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
