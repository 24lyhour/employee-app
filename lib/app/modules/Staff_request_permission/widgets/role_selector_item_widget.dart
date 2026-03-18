import 'package:flutter/material.dart';
import '../data/models/permission_request_model.dart';

class TypeSelectorItem extends StatelessWidget {
  final PermissionTypeModel type;
  final bool isSelected;
  final VoidCallback onTap;

  const TypeSelectorItem({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  static const _primaryColor = Color(0xFF5EA500);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? _primaryColor.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _primaryColor.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? _primaryColor.withValues(alpha: 0.15)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(type.value),
                size: 18,
                color: isSelected ? _primaryColor : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: TextStyle(
                      color: isSelected ? _primaryColor : Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type.description,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? _primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? _primaryColor : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String typeValue) {
    switch (typeValue) {
      case 'leave':
        return Icons.beach_access;
      case 'overtime':
        return Icons.more_time;
      case 'remote':
        return Icons.home_work;
      case 'early_leave':
        return Icons.exit_to_app;
      case 'late_arrival':
        return Icons.schedule;
      case 'other':
        return Icons.more_horiz;
      default:
        return Icons.help_outline;
    }
  }
}
