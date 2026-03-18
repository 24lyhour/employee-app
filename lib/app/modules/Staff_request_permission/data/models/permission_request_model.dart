class PermissionRequestModel {
  final int? id;
  final String? uuid;
  final String type;
  final String? typeLabel;
  final String? typeDescription;
  final String reason;
  final DateTime fromDate;
  final DateTime toDate;
  final int totalDays;
  final DateTime requestDate;
  final String? requestDateFormatted;
  final PermissionStatus status;
  final String? statusLabel;
  final bool isPending;
  final bool isApproved;
  final bool isRejected;
  final String? reviewedAt;
  final String? reviewedAtFormatted;
  final String? reviewNote;
  final String? rejectedReason;
  final Map<String, dynamic>? reviewer;

  PermissionRequestModel({
    this.id,
    this.uuid,
    required this.type,
    this.typeLabel,
    this.typeDescription,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    this.totalDays = 0,
    required this.requestDate,
    this.requestDateFormatted,
    this.status = PermissionStatus.pending,
    this.statusLabel,
    this.isPending = true,
    this.isApproved = false,
    this.isRejected = false,
    this.reviewedAt,
    this.reviewedAtFormatted,
    this.reviewNote,
    this.rejectedReason,
    this.reviewer,
  });

  factory PermissionRequestModel.fromJson(Map<String, dynamic> json) {
    return PermissionRequestModel(
      id: json['id'] as int?,
      uuid: json['uuid'] as String?,
      type: json['type'] as String? ?? '',
      typeLabel: json['type_label'] as String?,
      typeDescription: json['type_description'] as String?,
      reason: json['reason'] as String? ?? '',
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      totalDays: json['total_days'] as int? ?? 0,
      requestDate: DateTime.parse(json['request_date'] as String),
      requestDateFormatted: json['request_date_formatted'] as String?,
      status: PermissionStatus.fromString(json['status'] as String? ?? 'pending'),
      statusLabel: json['status_label'] as String?,
      isPending: json['is_pending'] as bool? ?? false,
      isApproved: json['is_approved'] as bool? ?? false,
      isRejected: json['is_rejected'] as bool? ?? false,
      reviewedAt: json['reviewed_at'] as String?,
      reviewedAtFormatted: json['reviewed_at_formatted'] as String?,
      reviewNote: json['review_note'] as String?,
      rejectedReason: json['rejected_reason'] as String?,
      reviewer: json['reviewer'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'reason': reason,
      'from_date': fromDate.toIso8601String().split('T')[0],
      'to_date': toDate.toIso8601String().split('T')[0],
    };
  }

  String get reviewerName => reviewer?['name'] as String? ?? '';
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

class PermissionTypeModel {
  final String value;
  final String label;
  final String description;

  const PermissionTypeModel({
    required this.value,
    required this.label,
    required this.description,
  });

  factory PermissionTypeModel.fromJson(Map<String, dynamic> json) {
    return PermissionTypeModel(
      value: json['value'] as String? ?? '',
      label: json['label'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class PermissionStats {
  final int total;
  final int pending;
  final int approved;
  final int rejected;

  const PermissionStats({
    this.total = 0,
    this.pending = 0,
    this.approved = 0,
    this.rejected = 0,
  });

  factory PermissionStats.fromJson(Map<String, dynamic> json) {
    return PermissionStats(
      total: json['total'] as int? ?? 0,
      pending: json['pending'] as int? ?? 0,
      approved: json['approved'] as int? ?? 0,
      rejected: json['rejected'] as int? ?? 0,
    );
  }
}

// API Response Classes
class PermissionTypesResponse {
  final bool success;
  final String? message;
  final List<PermissionTypeModel> data;

  PermissionTypesResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory PermissionTypesResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return PermissionTypesResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: dataList
          .map((e) => PermissionTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PermissionRequestListResponse {
  final bool success;
  final String? message;
  final PermissionStats? stats;
  final List<PermissionRequestModel> data;
  final PaginationMeta? meta;

  PermissionRequestListResponse({
    required this.success,
    this.message,
    this.stats,
    required this.data,
    this.meta,
  });

  factory PermissionRequestListResponse.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure from Laravel Resource collection
    final dataWrapper = json['data'];
    List<dynamic>? dataList;
    Map<String, dynamic>? metaData;

    if (dataWrapper is Map<String, dynamic>) {
      dataList = dataWrapper['data'] as List<dynamic>?;
      metaData = dataWrapper['meta'] as Map<String, dynamic>?;
    } else if (dataWrapper is List) {
      dataList = dataWrapper;
      metaData = json['meta'] as Map<String, dynamic>?;
    }

    return PermissionRequestListResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      stats: json['stats'] != null
          ? PermissionStats.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
      data: (dataList ?? [])
          .map((e) =>
              PermissionRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: metaData != null ? PaginationMeta.fromJson(metaData) : null,
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
    );
  }

  bool get hasMorePages => currentPage < lastPage;
}

class CreatePermissionResponse {
  final bool success;
  final String? message;
  final PermissionRequestModel? data;

  CreatePermissionResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory CreatePermissionResponse.fromJson(Map<String, dynamic> json) {
    return CreatePermissionResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null
          ? PermissionRequestModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PermissionDetailResponse {
  final bool success;
  final String? message;
  final PermissionRequestModel? data;

  PermissionDetailResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory PermissionDetailResponse.fromJson(Map<String, dynamic> json) {
    return PermissionDetailResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null
          ? PermissionRequestModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CancelPermissionResponse {
  final bool success;
  final String? message;

  CancelPermissionResponse({
    required this.success,
    this.message,
  });

  factory CancelPermissionResponse.fromJson(Map<String, dynamic> json) {
    return CancelPermissionResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}
