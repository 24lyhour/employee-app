import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/attendance_model.dart';

class HistoryCard extends StatelessWidget {
  final AttendanceModel attendance;

  const HistoryCard({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Date
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${attendance.date.day}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  Text(
                    _getWeekday(attendance.date.weekday),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Times
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.login,
                        size: 16,
                        color: AppColors.checkIn,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        attendance.checkInTimeFormatted,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.logout,
                        size: 16,
                        color: AppColors.checkOut,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        attendance.checkOutTimeFormatted,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: ${attendance.workDurationFormatted}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            // Status Badge
            _StatusBadge(status: attendance.status),
          ],
        ),
      ),
    );
  }

  String _getWeekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}

class _StatusBadge extends StatelessWidget {
  final AttendanceStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case AttendanceStatus.present:
        color = AppColors.success;
        label = AppStrings.present;
        break;
      case AttendanceStatus.late:
        color = AppColors.warning;
        label = AppStrings.late;
        break;
      case AttendanceStatus.absent:
        color = AppColors.error;
        label = AppStrings.absent;
        break;
      case AttendanceStatus.leave:
        color = AppColors.info;
        label = AppStrings.leave;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
