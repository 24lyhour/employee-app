import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/attendance_controller.dart';
import '../widgets/check_button.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('attendance'.tr),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  controller.formattedTime,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.formattedDate,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 48),
                if (controller.canCheckIn.value)
                  CheckButton(
                    label: 'check_in'.tr,
                    icon: Icons.login,
                    color: AppColors.checkIn,
                    onPressed: controller.isLoading.value ? null : controller.checkIn,
                    isLoading: controller.isLoading.value,
                  )
                else if (controller.canCheckOut.value)
                  CheckButton(
                    label: 'check_out'.tr,
                    icon: Icons.logout,
                    color: AppColors.checkOut,
                    onPressed: controller.isLoading.value ? null : controller.checkOut,
                    isLoading: controller.isLoading.value,
                  )
                else
                  _CompletedCard(attendance: controller.todayAttendance.value),
                if (!controller.isCheckedOut) ...[
                  const SizedBox(height: 16),
                  Text(
                    controller.canCheckIn.value ? 'tap_to_check_in'.tr : 'tap_to_check_out'.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
                const SizedBox(height: 32),
                if (controller.todayAttendance.value != null)
                  _TodayStatusCard(
                    checkInTime: controller.todayAttendance.value!.checkInTimeFormatted,
                    checkOutTime: controller.todayAttendance.value!.checkOutTimeFormatted,
                    isCheckedIn: controller.isCheckedIn,
                    isCheckedOut: controller.isCheckedOut,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _CompletedCard extends StatelessWidget {
  final dynamic attendance;

  const _CompletedCard({this.attendance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.success, width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 48,
            color: AppColors.success,
          ),
          const SizedBox(height: 8),
          Text(
            'completed'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
          ),
          if (attendance != null) ...[
            const SizedBox(height: 4),
            Text(
              attendance.workDurationFormatted,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.success,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TodayStatusCard extends StatelessWidget {
  final String checkInTime;
  final String checkOutTime;
  final bool isCheckedIn;
  final bool isCheckedOut;

  const _TodayStatusCard({
    required this.checkInTime,
    required this.checkOutTime,
    required this.isCheckedIn,
    required this.isCheckedOut,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _StatusItem(
                label: 'check_in'.tr,
                time: checkInTime,
                icon: Icons.login,
                isActive: isCheckedIn,
                color: AppColors.checkIn,
              ),
            ),
            Container(
              width: 1,
              height: 60,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Expanded(
              child: _StatusItem(
                label: 'check_out'.tr,
                time: checkOutTime,
                icon: Icons.logout,
                isActive: isCheckedOut,
                color: AppColors.checkOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final bool isActive;
  final Color color;

  const _StatusItem({
    required this.label,
    required this.time,
    required this.icon,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: isActive ? color : Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isActive ? color : Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }
}
