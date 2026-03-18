import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/models/permission_request_model.dart';
import '../controllers/staff_request_permission_controller.dart';
import 'status_badge_widget.dart';

class PermissionHistoryCard extends StatelessWidget {
  final PermissionRequestModel request;
  final String typeName;

  const PermissionHistoryCard({
    super.key,
    required this.request,
    required this.typeName,
  });

  static const _primaryColor = Color(0xFF5EA500);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailDialog(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _getTypeIcon(request.type),
                      size: 14,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.typeLabel ?? typeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          request.requestDateFormatted ??
                              '${'requested_on'.tr} ${DateFormat('dd MMM yyyy').format(request.requestDate)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: request.status),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.date_range,
                          size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${DateFormat('dd MMM').format(request.fromDate)} - ${DateFormat('dd MMM yyyy').format(request.toDate)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${request.totalDays} ${request.totalDays > 1 ? 'days'.tr : 'day'.tr}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notes, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          request.reason,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    final controller = Get.find<StaffRequestPermissionController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getTypeIcon(request.type),
                    size: 24,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.typeLabel ?? typeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        request.requestDateFormatted ??
                            '${'requested_on'.tr} ${DateFormat('dd MMM yyyy, HH:mm').format(request.requestDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: request.status),
              ],
            ),
            const SizedBox(height: 20),

            // Date Range
            _buildDetailItem(
              icon: Icons.date_range,
              label: 'date_range'.tr,
              value:
                  '${DateFormat('dd MMM yyyy').format(request.fromDate)} - ${DateFormat('dd MMM yyyy').format(request.toDate)}',
            ),
            const SizedBox(height: 12),

            // Duration
            _buildDetailItem(
              icon: Icons.timelapse,
              label: 'duration'.tr,
              value:
                  '${request.totalDays} ${request.totalDays > 1 ? 'days'.tr : 'day'.tr}',
            ),
            const SizedBox(height: 12),

            // Reason
            _buildDetailItem(
              icon: Icons.notes,
              label: 'reason'.tr,
              value: request.reason,
              isMultiLine: true,
            ),

            if (request.reviewNote != null &&
                request.reviewNote!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailItem(
                icon: Icons.comment,
                label: 'review_note'.tr,
                value: request.reviewNote!,
                isMultiLine: true,
              ),
            ],

            if (request.rejectedReason != null &&
                request.rejectedReason!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailItem(
                icon: Icons.cancel,
                label: 'rejected_reason'.tr,
                value: request.rejectedReason!,
                isMultiLine: true,
              ),
            ],

            if (request.reviewerName.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailItem(
                icon: Icons.person,
                label: 'reviewed_by'.tr,
                value: request.reviewerName,
              ),
            ],

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                // Cancel Button (only for pending)
                if (request.isPending && request.uuid != null)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showCancelConfirmation(context, controller);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'cancel_request'.tr,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                if (request.isPending && request.uuid != null)
                  const SizedBox(width: 12),

                // Close Button
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'close'.tr,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(
      BuildContext context, StaffRequestPermissionController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('cancel_request'.tr),
        content: Text('cancel_request_confirmation'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('no'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (request.uuid != null) {
                controller.cancelRequest(request.uuid!);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('yes'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isMultiLine = false,
  }) {
    return Row(
      crossAxisAlignment:
          isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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
