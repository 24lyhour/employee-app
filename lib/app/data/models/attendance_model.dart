// Re-export from new module location
export '../../modules/attendance/data/models/attendance_model.dart';

/// Legacy AttendanceStatus enum for backward compatibility
/// Used by: dashboard_controller, history_controller, home_controller, widgets
enum AttendanceStatus { present, late, absent, leave }

/// Legacy AttendanceModel for backward compatibility with old code
/// New code should use AttendanceModel from modules/attendance/data/models/
class LegacyAttendanceModel {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final AttendanceStatus status;
  final String? note;

  LegacyAttendanceModel({
    required this.id,
    required this.userId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.note,
  });

  factory LegacyAttendanceModel.fromJson(Map<String, dynamic> json) {
    return LegacyAttendanceModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time'])
          : null,
      checkOutTime: json['check_out_time'] != null
          ? DateTime.parse(json['check_out_time'])
          : null,
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AttendanceStatus.absent,
      ),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'status': status.name,
      'note': note,
    };
  }

  LegacyAttendanceModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    AttendanceStatus? status,
    String? note,
  }) {
    return LegacyAttendanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  bool get isCheckedIn => checkInTime != null;
  bool get isCheckedOut => checkOutTime != null;

  String get checkInTimeFormatted {
    if (checkInTime == null) return '--:--';
    return '${checkInTime!.hour.toString().padLeft(2, '0')}:${checkInTime!.minute.toString().padLeft(2, '0')}';
  }

  String get checkOutTimeFormatted {
    if (checkOutTime == null) return '--:--';
    return '${checkOutTime!.hour.toString().padLeft(2, '0')}:${checkOutTime!.minute.toString().padLeft(2, '0')}';
  }

  Duration? get workDuration {
    if (checkInTime == null || checkOutTime == null) return null;
    return checkOutTime!.difference(checkInTime!);
  }

  String get workDurationFormatted {
    final duration = workDuration;
    if (duration == null) return '--:--';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  // Mock data for testing
  static List<LegacyAttendanceModel> mockList() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      final date = now.subtract(Duration(days: index));
      final checkIn = DateTime(date.year, date.month, date.day, 8, 30 + index);
      final checkOut = DateTime(date.year, date.month, date.day, 17, 30);
      return LegacyAttendanceModel(
        id: '${index + 1}',
        userId: '1',
        date: date,
        checkInTime: index == 0 ? null : checkIn,
        checkOutTime: index == 0 ? null : checkOut,
        status: index == 0
            ? AttendanceStatus.absent
            : (index > 5 ? AttendanceStatus.late : AttendanceStatus.present),
      );
    });
  }
}
