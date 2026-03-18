import '../../../auth/data/models/employee_model.dart';

/// Attendance model matching backend AttendanceResource
class AttendanceModel {
  final int id;
  final String uuid;
  final String? attendanceDate;
  final String? checkInTime;
  final String? checkOutTime;
  final String status;
  final String? statusLabel;
  final String? checkInMethod;
  final String? checkOutMethod;
  final String? checkInLocation;
  final String? checkOutLocation;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final double? workHours;
  final String? workHoursFormatted;
  final double? overtimeHours;
  final String? notes;
  final bool hasCheckedIn;
  final bool hasCheckedOut;
  final DepartmentModel? department;
  final SchoolModel? school;
  final List<AttendanceScanModel>? scans;
  final String? createdAt;
  final String? updatedAt;

  AttendanceModel({
    required this.id,
    required this.uuid,
    this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.statusLabel,
    this.checkInMethod,
    this.checkOutMethod,
    this.checkInLocation,
    this.checkOutLocation,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.workHours,
    this.workHoursFormatted,
    this.overtimeHours,
    this.notes,
    required this.hasCheckedIn,
    required this.hasCheckedOut,
    this.department,
    this.school,
    this.scans,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      attendanceDate: json['attendance_date'],
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      status: json['status'] ?? 'pending',
      statusLabel: json['status_label'],
      checkInMethod: json['check_in_method'],
      checkOutMethod: json['check_out_method'],
      checkInLocation: json['check_in_location'],
      checkOutLocation: json['check_out_location'],
      checkInLatitude: json['check_in_latitude'] != null
          ? double.tryParse(json['check_in_latitude'].toString())
          : null,
      checkInLongitude: json['check_in_longitude'] != null
          ? double.tryParse(json['check_in_longitude'].toString())
          : null,
      checkOutLatitude: json['check_out_latitude'] != null
          ? double.tryParse(json['check_out_latitude'].toString())
          : null,
      checkOutLongitude: json['check_out_longitude'] != null
          ? double.tryParse(json['check_out_longitude'].toString())
          : null,
      workHours: json['work_hours'] != null
          ? double.tryParse(json['work_hours'].toString())
          : null,
      workHoursFormatted: json['work_hours_formatted'],
      overtimeHours: json['overtime_hours'] != null
          ? double.tryParse(json['overtime_hours'].toString())
          : null,
      notes: json['notes'],
      hasCheckedIn: json['has_checked_in'] ?? false,
      hasCheckedOut: json['has_checked_out'] ?? false,
      department: json['department'] != null
          ? DepartmentModel.fromJson(json['department'])
          : null,
      school:
          json['school'] != null ? SchoolModel.fromJson(json['school']) : null,
      scans: json['scans'] != null
          ? (json['scans'] as List)
              .map((s) => AttendanceScanModel.fromJson(s))
              .toList()
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'attendance_date': attendanceDate,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'status': status,
      'status_label': statusLabel,
      'check_in_method': checkInMethod,
      'check_out_method': checkOutMethod,
      'check_in_location': checkInLocation,
      'check_out_location': checkOutLocation,
      'check_in_latitude': checkInLatitude,
      'check_in_longitude': checkInLongitude,
      'check_out_latitude': checkOutLatitude,
      'check_out_longitude': checkOutLongitude,
      'work_hours': workHours,
      'work_hours_formatted': workHoursFormatted,
      'overtime_hours': overtimeHours,
      'notes': notes,
      'has_checked_in': hasCheckedIn,
      'has_checked_out': hasCheckedOut,
      'department': department?.toJson(),
      'school': school?.toJson(),
      'scans': scans?.map((s) => s.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Check if employee can check in
  bool get canCheckIn => !hasCheckedIn;

  /// Check if employee can check out
  bool get canCheckOut => hasCheckedIn && !hasCheckedOut;

  /// Get status color
  String get statusColor {
    switch (status) {
      case 'present':
        return '#22c55e'; // green
      case 'late':
        return '#f59e0b'; // amber
      case 'absent':
        return '#ef4444'; // red
      case 'leave':
        return '#3b82f6'; // blue
      default:
        return '#6b7280'; // gray
    }
  }

  /// Formatted check-in time for display
  String get checkInTimeFormatted => checkInTime ?? '--:--';

  /// Formatted check-out time for display
  String get checkOutTimeFormatted => checkOutTime ?? '--:--';

  /// Formatted work duration for display
  String get workDurationFormatted => workHoursFormatted ?? '0h 0m';
}

/// Attendance scan model for check-in/out scans
class AttendanceScanModel {
  final int id;
  final String uuid;
  final String scanType; // check_in, check_out
  final String? scannedAt;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? scanMethod; // qr, nfc, manual, gps
  final bool isVerified;
  final bool withinGeofence;
  final double? distanceFromLocation;
  final String? verificationStatus;
  final String? verificationNote;

  AttendanceScanModel({
    required this.id,
    required this.uuid,
    required this.scanType,
    this.scannedAt,
    this.latitude,
    this.longitude,
    this.address,
    this.scanMethod,
    required this.isVerified,
    required this.withinGeofence,
    this.distanceFromLocation,
    this.verificationStatus,
    this.verificationNote,
  });

  factory AttendanceScanModel.fromJson(Map<String, dynamic> json) {
    return AttendanceScanModel(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      scanType: json['scan_type'] ?? '',
      scannedAt: json['scanned_at'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      address: json['address'],
      scanMethod: json['scan_method'],
      isVerified: json['is_verified'] ?? false,
      withinGeofence: json['within_geofence'] ?? false,
      distanceFromLocation: json['distance_from_location'] != null
          ? double.tryParse(json['distance_from_location'].toString())
          : null,
      verificationStatus: json['verification_status'],
      verificationNote: json['verification_note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'scan_type': scanType,
      'scanned_at': scannedAt,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'scan_method': scanMethod,
      'is_verified': isVerified,
      'within_geofence': withinGeofence,
      'distance_from_location': distanceFromLocation,
      'verification_status': verificationStatus,
      'verification_note': verificationNote,
    };
  }

  bool get isCheckIn => scanType == 'check_in';
  bool get isCheckOut => scanType == 'check_out';
}

/// Response for today's attendance
class TodayAttendanceResponse {
  final bool success;
  final String? message;
  final AttendanceModel? attendance;
  final bool canCheckIn;
  final bool canCheckOut;

  TodayAttendanceResponse({
    required this.success,
    this.message,
    this.attendance,
    required this.canCheckIn,
    required this.canCheckOut,
  });

  factory TodayAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return TodayAttendanceResponse(
      success: json['success'] ?? false,
      message: json['message'],
      attendance: json['attendance'] != null
          ? AttendanceModel.fromJson(json['attendance'])
          : null,
      canCheckIn: json['can_check_in'] ?? true,
      canCheckOut: json['can_check_out'] ?? false,
    );
  }
}

/// Response for check-in/check-out
class ScanResponse {
  final bool success;
  final String message;
  final AttendanceModel? attendance;
  final AttendanceScanModel? scan;
  final GeofenceVerification? geofence;

  ScanResponse({
    required this.success,
    required this.message,
    this.attendance,
    this.scan,
    this.geofence,
  });

  factory ScanResponse.fromJson(Map<String, dynamic> json) {
    return ScanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      attendance: json['attendance'] != null
          ? AttendanceModel.fromJson(json['attendance'])
          : null,
      scan: json['scan'] != null
          ? AttendanceScanModel.fromJson(json['scan'])
          : null,
      geofence: json['geofence'] != null
          ? GeofenceVerification.fromJson(json['geofence'])
          : null,
    );
  }
}

/// Geofence verification result
class GeofenceVerification {
  final bool withinGeofence;
  final double? distance;
  final double? allowedRadius;
  final bool enforced;

  GeofenceVerification({
    required this.withinGeofence,
    this.distance,
    this.allowedRadius,
    required this.enforced,
  });

  factory GeofenceVerification.fromJson(Map<String, dynamic> json) {
    return GeofenceVerification(
      withinGeofence: json['within_geofence'] ?? false,
      distance: json['distance'] != null
          ? double.tryParse(json['distance'].toString())
          : null,
      allowedRadius: json['allowed_radius'] != null
          ? double.tryParse(json['allowed_radius'].toString())
          : null,
      enforced: json['enforced'] ?? false,
    );
  }
}

/// Response for attendance history
class AttendanceHistoryResponse {
  final bool success;
  final List<AttendanceModel> data;
  final AttendanceStats? stats;
  final PaginationMeta? meta;

  AttendanceHistoryResponse({
    required this.success,
    required this.data,
    this.stats,
    this.meta,
  });

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
    // API returns nested structure: { data: { data: [...], meta: {...} } }
    final dataWrapper = json['data'];
    List<dynamic>? dataList;
    Map<String, dynamic>? metaData;

    if (dataWrapper is Map<String, dynamic>) {
      // Nested structure from Laravel Resource collection
      dataList = dataWrapper['data'] as List<dynamic>?;
      metaData = dataWrapper['meta'] as Map<String, dynamic>?;
    } else if (dataWrapper is List) {
      // Direct list (fallback)
      dataList = dataWrapper;
      metaData = json['meta'] as Map<String, dynamic>?;
    }

    return AttendanceHistoryResponse(
      success: json['success'] ?? false,
      data: dataList != null
          ? dataList.map((a) => AttendanceModel.fromJson(a)).toList()
          : [],
      stats: json['stats'] != null
          ? AttendanceStats.fromJson(json['stats'])
          : null,
      meta: metaData != null ? PaginationMeta.fromJson(metaData) : null,
    );
  }
}

/// Attendance statistics
class AttendanceStats {
  final int totalDays;
  final int presentDays;
  final int lateDays;
  final int absentDays;
  final int leaveDays;
  final double totalWorkHours;
  final double averageWorkHours;

  AttendanceStats({
    required this.totalDays,
    required this.presentDays,
    required this.lateDays,
    required this.absentDays,
    required this.leaveDays,
    required this.totalWorkHours,
    required this.averageWorkHours,
  });

  factory AttendanceStats.fromJson(Map<String, dynamic> json) {
    return AttendanceStats(
      totalDays: json['total_days'] ?? 0,
      presentDays: json['present_days'] ?? 0,
      lateDays: json['late_days'] ?? 0,
      absentDays: json['absent_days'] ?? 0,
      leaveDays: json['leave_days'] ?? 0,
      totalWorkHours: json['total_work_hours'] != null
          ? double.tryParse(json['total_work_hours'].toString()) ?? 0.0
          : 0.0,
      averageWorkHours: json['average_work_hours'] != null
          ? double.tryParse(json['average_work_hours'].toString()) ?? 0.0
          : 0.0,
    );
  }

  double get attendanceRate =>
      totalDays > 0 ? (presentDays + lateDays) / totalDays * 100 : 0.0;
}

/// Pagination metadata
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
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }

  bool get hasMorePages => currentPage < lastPage;
}
