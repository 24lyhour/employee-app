import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../attendance/data/models/attendance_model.dart';
import '../../attendance/data/providers/attendance_provider.dart';
import '../../auth/data/models/employee_model.dart';

class HomeController extends GetxController {
  final AttendanceProvider _attendanceProvider;
  HomeController({required AttendanceProvider attendanceProvider})
      : _attendanceProvider = attendanceProvider;

  final employee = Rxn<EmployeeModel>();
  final todayAttendance = Rxn<AttendanceModel>();
  final stats = <String, int>{}.obs;
  final isLoading = false.obs;
  final canCheckIn = true.obs;
  final canCheckOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      // Load employee from storage
      final savedEmployee = StorageService.getEmployee();
      if (savedEmployee != null) {
        employee.value = EmployeeModel.fromJson(savedEmployee);
      }

      // Load today's attendance from API
      final todayResponse = await _attendanceProvider.getTodayAttendance();
      if (todayResponse.success) {
        todayAttendance.value = todayResponse.attendance;
        canCheckIn.value = todayResponse.canCheckIn;
        canCheckOut.value = todayResponse.canCheckOut;
      }

      // Load stats from history API
      final historyResponse = await _attendanceProvider.getHistory(perPage: 1);
      if (historyResponse.success && historyResponse.stats != null) {
        final apiStats = historyResponse.stats!;
        stats.assignAll({
          'total': apiStats.totalDays,
          'present': apiStats.presentDays,
          'late': apiStats.lateDays,
          'absent': apiStats.absentDays,
        });
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _loadData();
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get employeeName => employee.value?.fullName ?? 'Employee';
}
