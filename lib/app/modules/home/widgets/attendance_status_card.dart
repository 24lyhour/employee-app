import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../attendance/data/models/attendance_model.dart';

class AttendanceStatusCard extends StatelessWidget {
  final AttendanceModel? attendance;
  final Map<String, int> stats;

  const AttendanceStatusCard({
    super.key,
    this.attendance,
    this.stats = const {},
  });

  @override
  Widget build(BuildContext context) {
    final isCheckedIn = attendance?.hasCheckedIn ?? false;
    final isCheckedOut = attendance?.hasCheckedOut ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "Today's Attendance",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _TimeCard(
                    title: AppStrings.checkIn,
                    time: attendance?.checkInTimeFormatted ?? '--:--',
                    icon: Icons.login,
                    color: AppColors.checkIn,
                    isActive: isCheckedIn,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimeCard(
                    title: AppStrings.checkOut,
                    time: attendance?.checkOutTimeFormatted ?? '--:--',
                    icon: Icons.logout,
                    color: AppColors.checkOut,
                    isActive: isCheckedOut,
                  ),
                ),
              ],
            ),
            if (attendance != null && isCheckedIn && isCheckedOut) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total: ${attendance!.workDurationFormatted}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Monthly Stats Section
            if (stats.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'monthly_summary'.tr,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      label: 'total'.tr,
                      value: stats['total'] ?? 0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'present'.tr,
                      value: stats['present'] ?? 0,
                      color: AppColors.checkIn,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'late'.tr,
                      value: stats['late'] ?? 0,
                      color: Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'absent'.tr,
                      value: stats['absent'] ?? 0,
                      color: AppColors.checkOut,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final Color color;
  final bool isActive;

  const _TimeCard({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive
            ? color.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: isActive ? Border.all(color: color, width: 1) : null,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? color : Theme.of(context).colorScheme.outline,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive ? color : Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
