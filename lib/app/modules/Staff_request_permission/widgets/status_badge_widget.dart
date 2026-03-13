import 'package:flutter/material.dart';
import '../data/models/permission_request_model.dart';

class StatusBadge extends StatelessWidget {
  final PermissionStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 14, color: config.textColor),
          const SizedBox(width: 4),
          Text(
            config.text,
            style: TextStyle(
              fontSize: 12,
              color: config.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.approved:
        return _StatusConfig(
          bgColor: const Color(0xFF5EA500).withValues(alpha: 0.1),
          textColor: const Color(0xFF5EA500),
          text: 'Approved',
          icon: Icons.check_circle_outline,
        );
      case PermissionStatus.rejected:
        return _StatusConfig(
          bgColor: Colors.red.shade50,
          textColor: Colors.red.shade700,
          text: 'Rejected',
          icon: Icons.cancel_outlined,
        );
      case PermissionStatus.pending:
        return _StatusConfig(
          bgColor: Colors.orange.shade50,
          textColor: Colors.orange.shade700,
          text: 'Pending',
          icon: Icons.access_time,
        );
    }
  }
}

class _StatusConfig {
  final Color bgColor;
  final Color textColor;
  final String text;
  final IconData icon;

  _StatusConfig({
    required this.bgColor,
    required this.textColor,
    required this.text,
    required this.icon,
  });
}
