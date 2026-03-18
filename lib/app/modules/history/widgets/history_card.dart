import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/models/history_model.dart';

class HistoryCard extends StatelessWidget {
  final AttendanceModel attendance;

  const HistoryCard({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final date = _parseDate(attendance.attendanceDate);

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
                    date != null ? '${date.day}' : '--',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  Text(
                    date != null ? _getWeekday(date.weekday) : '--',
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
                        size: 14,
                        color: AppColors.checkIn,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        attendance.checkInTimeFormatted,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.logout,
                        size: 14,
                        color: AppColors.checkOut,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          attendance.checkOutTimeFormatted,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
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
            _StatusBadge(status: attendance.status, statusLabel: attendance.statusLabel),
          ],
        ),
      ),
    );
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  String _getWeekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final String? statusLabel;

  const _StatusBadge({required this.status, this.statusLabel});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'present':
        color = AppColors.success;
        label = statusLabel ?? AppStrings.present;
        break;
      case 'late':
        color = AppColors.warning;
        label = statusLabel ?? AppStrings.late;
        break;
      case 'absent':
        color = AppColors.error;
        label = statusLabel ?? AppStrings.absent;
        break;
      case 'leave':
      case 'on_leave':
        color = AppColors.info;
        label = statusLabel ?? AppStrings.leave;
        break;
      default:
        color = Colors.grey;
        label = statusLabel ?? status;
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
