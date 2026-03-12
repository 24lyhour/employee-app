import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class QuickStatsCard extends StatelessWidget {
  final Map<String, int> stats;

  const QuickStatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                label: 'Total',
                value: stats['total'] ?? 0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: AppStrings.present,
                value: stats['present'] ?? 0,
                color: AppColors.success,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: AppStrings.late,
                value: stats['late'] ?? 0,
                color: AppColors.warning,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: AppStrings.absent,
                value: stats['absent'] ?? 0,
                color: AppColors.error,
              ),
            ),
          ],
        ),
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
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$value',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
