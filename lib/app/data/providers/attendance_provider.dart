// Re-export new provider from module location
export '../../modules/attendance/data/providers/attendance_provider.dart';

import 'package:get/get.dart';
import '../models/attendance_model.dart';

/// Legacy AttendanceProvider for backward compatibility with old code
/// New code should use AttendanceProvider from modules/attendance/data/providers/
class LegacyAttendanceProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 30);
  }

  // Get today's attendance (mock)
  Future<LegacyAttendanceModel?> getTodayAttendance(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock: Return null if not checked in today
    return null;
  }

  // Check in (mock)
  Future<LegacyAttendanceModel> checkIn(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final isLate = now.hour >= 9; // After 9 AM is considered late

    return LegacyAttendanceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      date: DateTime(now.year, now.month, now.day),
      checkInTime: now,
      checkOutTime: null,
      status: isLate ? AttendanceStatus.late : AttendanceStatus.present,
    );
  }

  // Check out (mock)
  Future<LegacyAttendanceModel> checkOut(LegacyAttendanceModel attendance) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return attendance.copyWith(
      checkOutTime: DateTime.now(),
    );
  }

  // Get attendance history (mock)
  Future<List<LegacyAttendanceModel>> getAttendanceHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data
    return LegacyAttendanceModel.mockList();
  }

  // Get attendance stats (mock)
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
