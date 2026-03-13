class PermissionRequestModel {
  final String? id;
  final String role;
  final String reason;
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime requestDate;
  final PermissionStatus status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewNote;

  PermissionRequestModel({
    this.id,
    required this.role,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.requestDate,
    this.status = PermissionStatus.pending,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNote,
  });

  int get totalDays => toDate.difference(fromDate).inDays + 1;

  factory PermissionRequestModel.fromJson(Map<String, dynamic> json) {
    return PermissionRequestModel(
      id: json['id'] as String?,
      role: json['role'] as String,
      reason: json['reason'] as String,
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      requestDate: DateTime.parse(json['request_date'] as String),
      status: PermissionStatus.fromString(json['status'] as String),
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      reviewNote: json['review_note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'reason': reason,
      'from_date': fromDate.toIso8601String(),
      'to_date': toDate.toIso8601String(),
      'request_date': requestDate.toIso8601String(),
      'status': status.value,
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'review_note': reviewNote,
    };
  }

  PermissionRequestModel copyWith({
    String? id,
    String? role,
    String? reason,
    DateTime? fromDate,
    DateTime? toDate,
    DateTime? requestDate,
    PermissionStatus? status,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNote,
  }) {
    return PermissionRequestModel(
      id: id ?? this.id,
      role: role ?? this.role,
      reason: reason ?? this.reason,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewNote: reviewNote ?? this.reviewNote,
    );
  }
}

enum PermissionStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  final String value;
  const PermissionStatus(this.value);

  static PermissionStatus fromString(String value) {
    return PermissionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PermissionStatus.pending,
    );
  }
}

class RoleOption {
  final String id;
  final String name;
  final String description;

  const RoleOption({
    required this.id,
    required this.name,
    required this.description,
  });

  static const List<RoleOption> availableRoles = [
    RoleOption(
      id: 'leave',
      name: 'Leave Request',
      description: 'Request time off or vacation leave',
    ),
    RoleOption(
      id: 'overtime',
      name: 'Overtime',
      description: 'Request to work extra hours',
    ),
    RoleOption(
      id: 'remote',
      name: 'Work From Home',
      description: 'Request to work remotely',
    ),
    RoleOption(
      id: 'early_leave',
      name: 'Early Leave',
      description: 'Request to leave early',
    ),
    RoleOption(
      id: 'late_arrival',
      name: 'Late Arrival',
      description: 'Request permission for late arrival',
    ),
    RoleOption(
      id: 'other',
      name: 'Other',
      description: 'Other permission requests',
    ),
  ];
}
