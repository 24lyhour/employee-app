import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/user_model.dart';

class DashboardController extends GetxController {
  // Loading state
  final isLoading = true.obs;

  // Current user
  final user = Rxn<UserModel>();

  // Today's attendance
  final todayAttendance = Rxn<AttendanceModel>();

  // Monthly stats
  final totalWorkDays = 0.obs;
  final presentDays = 0.obs;
  final lateDays = 0.obs;
  final absentDays = 0.obs;
  final leaveDays = 0.obs;

  // Attendance percentage
  final attendancePercentage = 0.0.obs;

  // Total work hours this month
  final totalWorkHours = 0.0.obs;
  final averageWorkHours = 0.0.obs;

  // Weekly attendance data (Mon - Sun) for chart
  final weeklyStatus = <WeekDayStatus>[].obs;

  // Attendance history
  final attendanceHistory = <AttendanceModel>[].obs;

  // Selected time filter
  final selectedFilter = 'This Month'.obs;
  final filterOptions = ['This Week', 'This Month', 'Last Month'];

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Load current user
      user.value = UserModel.mock();

      // Load today's attendance
      final now = DateTime.now();
      todayAttendance.value = AttendanceModel(
        id: '1',
        userId: user.value!.id,
        date: DateTime(now.year, now.month, now.day),
        checkInTime: DateTime(now.year, now.month, now.day, 8, 32),
        checkOutTime: null,
        status: AttendanceStatus.present,
      );

      // Load attendance history
      attendanceHistory.value = _generateMockHistory();

      // Calculate monthly stats
      _calculateMonthlyStats();

      // Calculate weekly status for chart
      _calculateWeeklyStatus();
    } catch (e) {
      debugPrint('Error loading dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<AttendanceModel> _generateMockHistory() {
    final now = DateTime.now();
    final history = <AttendanceModel>[];

    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      // Skip weekends
      if (date.weekday == 6 || date.weekday == 7) continue;

      AttendanceStatus status;
      DateTime? checkIn;
      DateTime? checkOut;

      if (i == 0) {
        // Today
        status = AttendanceStatus.present;
        checkIn = DateTime(date.year, date.month, date.day, 8, 32);
        checkOut = null;
      } else if (i % 7 == 0) {
        // Some days late
        status = AttendanceStatus.late;
        checkIn = DateTime(date.year, date.month, date.day, 9, 15);
        checkOut = DateTime(date.year, date.month, date.day, 18, 0);
      } else if (i == 5) {
        // One day leave
        status = AttendanceStatus.leave;
        checkIn = null;
        checkOut = null;
      } else if (i == 10) {
        // One day absent
        status = AttendanceStatus.absent;
        checkIn = null;
        checkOut = null;
      } else {
        // Regular present days
        status = AttendanceStatus.present;
        checkIn = DateTime(date.year, date.month, date.day, 8, 30 + (i % 20));
        checkOut = DateTime(date.year, date.month, date.day, 17, 30 + (i % 30));
      }

      history.add(AttendanceModel(
        id: '${i + 1}',
        userId: '1',
        date: date,
        checkInTime: checkIn,
        checkOutTime: checkOut,
        status: status,
      ));
    }

    return history;
  }

  void _calculateMonthlyStats() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    final monthRecords = attendanceHistory
        .where((a) => a.date.isAfter(monthStart.subtract(const Duration(days: 1))))
        .toList();

    int present = 0;
    int late = 0;
    int absent = 0;
    int leave = 0;
    double totalHours = 0;

    for (final record in monthRecords) {
      switch (record.status) {
        case AttendanceStatus.present:
          present++;
          if (record.workDuration != null) {
            totalHours += record.workDuration!.inMinutes / 60;
          }
          break;
        case AttendanceStatus.late:
          late++;
          if (record.workDuration != null) {
            totalHours += record.workDuration!.inMinutes / 60;
          }
          break;
        case AttendanceStatus.absent:
          absent++;
          break;
        case AttendanceStatus.leave:
          leave++;
          break;
      }
    }

    totalWorkDays.value = monthRecords.length;
    presentDays.value = present;
    lateDays.value = late;
    absentDays.value = absent;
    leaveDays.value = leave;
    totalWorkHours.value = totalHours;
    averageWorkHours.value =
        (present + late) > 0 ? totalHours / (present + late) : 0;

    if (totalWorkDays.value > 0) {
      attendancePercentage.value =
          ((present + late) / totalWorkDays.value) * 100;
    }
  }

  void _calculateWeeklyStatus() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    weeklyStatus.value = List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      final dayName = DateFormat('EEE').format(date);

      // Find attendance for this day
      final record = attendanceHistory.firstWhereOrNull(
        (a) =>
            a.date.year == date.year &&
            a.date.month == date.month &&
            a.date.day == date.day,
      );

      WeekDayStatusType statusType;
      if (date.isAfter(now)) {
        statusType = WeekDayStatusType.future;
      } else if (date.weekday == 6 || date.weekday == 7) {
        statusType = WeekDayStatusType.weekend;
      } else if (record == null) {
        statusType = WeekDayStatusType.absent;
      } else {
        switch (record.status) {
          case AttendanceStatus.present:
            statusType = WeekDayStatusType.present;
            break;
          case AttendanceStatus.late:
            statusType = WeekDayStatusType.late;
            break;
          case AttendanceStatus.leave:
            statusType = WeekDayStatusType.leave;
            break;
          case AttendanceStatus.absent:
            statusType = WeekDayStatusType.absent;
            break;
        }
      }

      return WeekDayStatus(
        day: dayName,
        date: date,
        status: statusType,
        checkIn: record?.checkInTimeFormatted,
        checkOut: record?.checkOutTimeFormatted,
      );
    });
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    loadDashboardData();
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }

  // Format work hours
  String get formattedTotalHours {
    final hours = totalWorkHours.value.floor();
    final minutes = ((totalWorkHours.value - hours) * 60).round();
    return '${hours}h ${minutes}m';
  }

  String get formattedAverageHours {
    final hours = averageWorkHours.value.floor();
    final minutes = ((averageWorkHours.value - hours) * 60).round();
    return '${hours}h ${minutes}m';
  }

  // Today's status
  String get todayCheckInTime =>
      todayAttendance.value?.checkInTimeFormatted ?? '--:--';
  String get todayCheckOutTime =>
      todayAttendance.value?.checkOutTimeFormatted ?? '--:--';
  bool get isCheckedIn => todayAttendance.value?.isCheckedIn ?? false;
  bool get isCheckedOut => todayAttendance.value?.isCheckedOut ?? false;
}

enum WeekDayStatusType { present, late, absent, leave, weekend, future }

class WeekDayStatus {
  final String day;
  final DateTime date;
  final WeekDayStatusType status;
  final String? checkIn;
  final String? checkOut;

  WeekDayStatus({
    required this.day,
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
  });

  Color get color {
    switch (status) {
      case WeekDayStatusType.present:
        return const Color(0xFF22C55E);
      case WeekDayStatusType.late:
        return const Color(0xFFF59E0B);
      case WeekDayStatusType.absent:
        return const Color(0xFFEF4444);
      case WeekDayStatusType.leave:
        return const Color(0xFF8B5CF6);
      case WeekDayStatusType.weekend:
        return const Color(0xFF9CA3AF);
      case WeekDayStatusType.future:
        return const Color(0xFFE5E7EB);
    }
  }

  IconData get icon {
    switch (status) {
      case WeekDayStatusType.present:
        return Icons.check_circle;
      case WeekDayStatusType.late:
        return Icons.schedule;
      case WeekDayStatusType.absent:
        return Icons.cancel;
      case WeekDayStatusType.leave:
        return Icons.event_busy;
      case WeekDayStatusType.weekend:
        return Icons.weekend;
      case WeekDayStatusType.future:
        return Icons.circle_outlined;
    }
  }
}
