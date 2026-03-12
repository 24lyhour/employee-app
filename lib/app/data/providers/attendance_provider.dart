import 'package:get/get.dart';
import '../models/attendance_model.dart';

class AttendanceProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 30);
  }

  // Get today's attendance
  Future<AttendanceModel?> getTodayAttendance(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock: Return null if not checked in today
    return null;
  }

  // Check in
  Future<AttendanceModel> checkIn(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final isLate = now.hour >= 9; // After 9 AM is considered late

    return AttendanceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      date: DateTime(now.year, now.month, now.day),
      checkInTime: now,
      checkOutTime: null,
      status: isLate ? AttendanceStatus.late : AttendanceStatus.present,
    );
  }

  // Check out
  Future<AttendanceModel> checkOut(AttendanceModel attendance) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return attendance.copyWith(
      checkOutTime: DateTime.now(),
    );
  }

  // Get attendance history
  Future<List<AttendanceModel>> getAttendanceHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data
    return AttendanceModel.mockList();
  }

  // Get attendance stats
  Future<Map<String, int>> getAttendanceStats(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock stats
    return {
      'total': 22,
      'present': 18,
      'late': 3,
      'absent': 1,
    };
  }
}
