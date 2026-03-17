import 'package:get/get.dart';

/// Local attendance status enum for tracking service
enum TrackingAttendanceStatus { present, late, absent, leave }

/// Local attendance record for tracking service (mock data)
class TrackingAttendanceRecord {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final TrackingAttendanceStatus status;
  final String? note;

  TrackingAttendanceRecord({
    required this.id,
    required this.userId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.note,
  });

  TrackingAttendanceRecord copyWith({
    String? id,
    String? userId,
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    TrackingAttendanceStatus? status,
    String? note,
  }) {
    return TrackingAttendanceRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }
}

class AttendanceTrackingService extends GetxService {
  // All employees attendance records
  final allAttendance = <TrackingAttendanceRecord>[].obs;

  // Employee list (mock for now)
  final employees = <EmployeeData>[].obs;

  Future<AttendanceTrackingService> init() async {
    await loadMockData();
    return this;
  }

  Future<void> loadMockData() async {
    // Mock employees
    employees.value = [
      EmployeeData(id: '1', name: 'John Doe', department: 'Engineering'),
      EmployeeData(id: '2', name: 'Jane Smith', department: 'Engineering'),
      EmployeeData(id: '3', name: 'Mike Johnson', department: 'Marketing'),
      EmployeeData(id: '4', name: 'Sarah Wilson', department: 'Marketing'),
      EmployeeData(id: '5', name: 'Tom Brown', department: 'Sales'),
      EmployeeData(id: '6', name: 'Emily Davis', department: 'Sales'),
      EmployeeData(id: '7', name: 'Chris Lee', department: 'HR'),
      EmployeeData(id: '8', name: 'Anna White', department: 'HR'),
      EmployeeData(id: '9', name: 'David Kim', department: 'Finance'),
      EmployeeData(id: '10', name: 'Lisa Chen', department: 'Finance'),
    ];

    // Generate mock attendance for today
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    allAttendance.value = [
      // Present employees
      TrackingAttendanceRecord(
        id: '1',
        userId: '1',
        date: today,
        checkInTime: DateTime(now.year, now.month, now.day, 8, 30),
        status: TrackingAttendanceStatus.present,
      ),
      TrackingAttendanceRecord(
        id: '2',
        userId: '2',
        date: today,
        checkInTime: DateTime(now.year, now.month, now.day, 8, 45),
        status: TrackingAttendanceStatus.present,
      ),
      TrackingAttendanceRecord(
        id: '3',
        userId: '3',
        date: today,
        checkInTime: DateTime(now.year, now.month, now.day, 8, 50),
        status: TrackingAttendanceStatus.present,
      ),
      TrackingAttendanceRecord(
        id: '4',
        userId: '4',
        date: today,
        checkInTime: DateTime(now.year, now.month, now.day, 8, 55),
        status: TrackingAttendanceStatus.present,
      ),
      // Late employees
      TrackingAttendanceRecord(
        id: '5',
        userId: '5',
        date: today,
        checkInTime: DateTime(now.year, now.month, now.day, 9, 15),
        status: TrackingAttendanceStatus.late,
      ),
      TrackingAttendanceRecord(
        id: '6',
        userId: '6',
        date: today,
        checkInTime: DateTime(now.year, now.month, now.day, 9, 30),
        status: TrackingAttendanceStatus.late,
      ),
      // On leave
      TrackingAttendanceRecord(
        id: '7',
        userId: '7',
        date: today,
        status: TrackingAttendanceStatus.leave,
      ),
      // Absent (no record yet)
      TrackingAttendanceRecord(
        id: '8',
        userId: '8',
        date: today,
        status: TrackingAttendanceStatus.absent,
      ),
      TrackingAttendanceRecord(
        id: '9',
        userId: '9',
        date: today,
        checkInTime: DateTime(now.year, now.month, now.day, 8, 40),
        status: TrackingAttendanceStatus.present,
      ),
      TrackingAttendanceRecord(
        id: '10',
        userId: '10',
        date: today,
        checkInTime: DateTime(now.year, now.month, now.day, 8, 35),
        status: TrackingAttendanceStatus.present,
      ),
    ];
  }

  // Get today's stats
  AttendanceStats getTodayStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayRecords = allAttendance.where((a) =>
        a.date.year == today.year &&
        a.date.month == today.month &&
        a.date.day == today.day);

    int present = 0;
    int late = 0;
    int absent = 0;
    int onLeave = 0;

    for (final record in todayRecords) {
      switch (record.status) {
        case TrackingAttendanceStatus.present:
          present++;
          break;
        case TrackingAttendanceStatus.late:
          late++;
          break;
        case TrackingAttendanceStatus.absent:
          absent++;
          break;
        case TrackingAttendanceStatus.leave:
          onLeave++;
          break;
      }
    }

    return AttendanceStats(
      totalEmployees: employees.length,
      present: present,
      late: late,
      absent: absent,
      onLeave: onLeave,
    );
  }

  // Get weekly stats
  List<DailyStats> getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return List.generate(7, (index) {
      final day = weekStart.add(Duration(days: index));
      final dayRecords = allAttendance.where((a) =>
          a.date.year == day.year &&
          a.date.month == day.month &&
          a.date.day == day.day);

      int present = 0;
      int late = 0;
      int absent = 0;

      for (final record in dayRecords) {
        switch (record.status) {
          case TrackingAttendanceStatus.present:
            present++;
            break;
          case TrackingAttendanceStatus.late:
            late++;
            break;
          case TrackingAttendanceStatus.absent:
          case TrackingAttendanceStatus.leave:
            absent++;
            break;
        }
      }

      // If it's today or past, use real data; otherwise, simulate weekend lower attendance
      if (day.isAfter(now)) {
        return DailyStats(date: day, present: 0, late: 0, absent: 0);
      }

      // Simulate data for past days
      if (index == now.weekday - 1) {
        // Today - use actual
        return DailyStats(date: day, present: present, late: late, absent: absent);
      } else if (index < 5) {
        // Weekday simulation
        return DailyStats(
          date: day,
          present: employees.length - 2,
          late: 1,
          absent: 1,
        );
      } else {
        // Weekend
        return DailyStats(date: day, present: 2, late: 0, absent: employees.length - 2);
      }
    });
  }

  // Get department stats
  List<DepartmentStats> getDepartmentStats() {
    final departments = <String, List<String>>{};

    // Group employees by department
    for (final emp in employees) {
      departments.putIfAbsent(emp.department, () => []);
      departments[emp.department]!.add(emp.id);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return departments.entries.map((entry) {
      final deptEmployees = entry.value;
      final presentCount = allAttendance.where((a) {
        return deptEmployees.contains(a.userId) &&
            a.date.year == today.year &&
            a.date.month == today.month &&
            a.date.day == today.day &&
            (a.status == TrackingAttendanceStatus.present ||
                a.status == TrackingAttendanceStatus.late);
      }).length;

      return DepartmentStats(
        name: entry.key,
        present: presentCount,
        total: deptEmployees.length,
      );
    }).toList();
  }

  // Get recent activities
  List<ActivityLog> getRecentActivities() {
    final now = DateTime.now();
    final activities = <ActivityLog>[];

    for (final attendance in allAttendance) {
      final employee = employees.firstWhere(
        (e) => e.id == attendance.userId,
        orElse: () => EmployeeData(id: '', name: 'Unknown', department: ''),
      );

      if (attendance.checkInTime != null) {
        activities.add(ActivityLog(
          employeeName: employee.name,
          action: attendance.status == TrackingAttendanceStatus.late
              ? 'Checked in late'
              : 'Checked in',
          time: attendance.checkInTime!,
          type: attendance.status == TrackingAttendanceStatus.late
              ? ActivityType.late
              : ActivityType.checkIn,
        ));
      }

      if (attendance.checkOutTime != null) {
        activities.add(ActivityLog(
          employeeName: employee.name,
          action: 'Checked out',
          time: attendance.checkOutTime!,
          type: ActivityType.checkOut,
        ));
      }

      if (attendance.status == TrackingAttendanceStatus.leave) {
        activities.add(ActivityLog(
          employeeName: employee.name,
          action: 'On leave',
          time: now,
          type: ActivityType.leave,
        ));
      }
    }

    // Sort by time, most recent first
    activities.sort((a, b) => b.time.compareTo(a.time));

    return activities.take(10).toList();
  }

  // Record check-in
  void recordCheckIn(String userId) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isLate = now.hour >= 9;

    final existing = allAttendance.indexWhere(
      (a) =>
          a.userId == userId &&
          a.date.year == today.year &&
          a.date.month == today.month &&
          a.date.day == today.day,
    );

    final newRecord = TrackingAttendanceRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      date: today,
      checkInTime: now,
      status: isLate ? TrackingAttendanceStatus.late : TrackingAttendanceStatus.present,
    );

    if (existing >= 0) {
      allAttendance[existing] = newRecord;
    } else {
      allAttendance.add(newRecord);
    }
  }

  // Record check-out
  void recordCheckOut(String userId) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final index = allAttendance.indexWhere(
      (a) =>
          a.userId == userId &&
          a.date.year == today.year &&
          a.date.month == today.month &&
          a.date.day == today.day,
    );

    if (index >= 0) {
      allAttendance[index] = allAttendance[index].copyWith(
        checkOutTime: now,
      );
    }
  }
}

class EmployeeData {
  final String id;
  final String name;
  final String department;

  EmployeeData({
    required this.id,
    required this.name,
    required this.department,
  });
}

class AttendanceStats {
  final int totalEmployees;
  final int present;
  final int late;
  final int absent;
  final int onLeave;

  AttendanceStats({
    required this.totalEmployees,
    required this.present,
    required this.late,
    required this.absent,
    required this.onLeave,
  });

  double get attendancePercentage =>
      totalEmployees > 0 ? ((present + late) / totalEmployees) * 100 : 0;
}

class DailyStats {
  final DateTime date;
  final int present;
  final int late;
  final int absent;

  DailyStats({
    required this.date,
    required this.present,
    required this.late,
    required this.absent,
  });
}

class DepartmentStats {
  final String name;
  final int present;
  final int total;

  DepartmentStats({
    required this.name,
    required this.present,
    required this.total,
  });

  double get percentage => total > 0 ? (present / total) * 100 : 0;
}

enum ActivityType { checkIn, checkOut, late, leave, absent }

class ActivityLog {
  final String employeeName;
  final String action;
  final DateTime time;
  final ActivityType type;

  ActivityLog({
    required this.employeeName,
    required this.action,
    required this.time,
    required this.type,
  });

  String get formattedTime {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }
}
