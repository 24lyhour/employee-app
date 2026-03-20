import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/clock_loading_widget.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
        actions: [
          Obx(() => controller.isRefreshing.value
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: ClockLoadingWidget(size: 20),
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
                // Avatar with CachedNetworkImage
                Obx(() {
                  final emp = controller.employee.value;
                  final avatarUrl = emp?.avatarUrl ?? '';
                  final initial = emp?.fullName.isNotEmpty == true
                      ? emp!.fullName[0].toUpperCase()
                      : 'E';

                  return CachedNetworkImage(
                    key: ValueKey('avatar_${controller.avatarKey.value}_$avatarUrl'),
                    imageUrl: avatarUrl,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: const ClockLoadingWidget(size: 24),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        initial,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ),
                  );
                }),
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

                // Info Cards - Always show all fields
                _InfoCard(
                  icon: Icons.badge_outlined,
                  label: 'employee_id'.tr,
                  value: employee.employeeCode,
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  icon: Icons.email_outlined,
                  label: 'email'.tr,
                  value: employee.email ?? '-',
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  icon: Icons.phone_outlined,
                  label: 'phone_number'.tr,
                  value: employee.phoneNumber ?? '-',
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  icon: Icons.business_outlined,
                  label: 'school'.tr,
                  value: employee.school?.name ?? '-',
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  icon: Icons.apartment_outlined,
                  label: 'department'.tr,
                  value: employee.department?.name ?? '-',
                ),
                const SizedBox(height: 24),

                // Professional Information Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      'professional_info'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                _InfoCard(
                  icon: Icons.work_outline,
                  label: 'job_title'.tr,
                  value: employee.jobTitle ?? '-',
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  icon: Icons.category_outlined,
                  label: 'employee_type'.tr,
                  value: employee.employeeType ?? '-',
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'hire_date'.tr,
                  value: employee.hireDate ?? '-',
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  icon: Icons.hourglass_empty_outlined,
                  label: 'probation_status'.tr,
                  value: employee.isOnProbation ? 'on_probation'.tr : 'permanent'.tr,
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
                  onTap: () async {
                    final result = await Get.toNamed(Routes.PROFILE_EDIT);
                    // Refresh profile if updated (clear cache to refresh avatar)
                    if (result == true) {
                      controller.loadEmployee(clearCache: true);
                    }
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

                // Logout
                _MenuItem(
                  icon: Icons.logout,
                  label: 'logout'.tr,
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () => _showLogoutDialog(context),
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
