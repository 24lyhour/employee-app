import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/attendance_model.dart';

class AttendanceStatusCard extends StatelessWidget {
  final AttendanceModel? attendance;

  const AttendanceStatusCard({
    super.key,
    this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final isCheckedIn = attendance?.isCheckedIn ?? false;
    final isCheckedOut = attendance?.isCheckedOut ?? false;

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
