import 'package:get/get.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/providers/attendance_provider.dart';

class HistoryController extends GetxController {
  final AttendanceProvider provider;
  HistoryController({required this.provider});

  final attendanceList = <AttendanceModel>[].obs;
  final isLoading = false.obs;
  final selectedMonth = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    isLoading.value = true;
    try {
      final history = await provider.getAttendanceHistory(
        userId: '1',
        startDate: DateTime(selectedMonth.value.year, selectedMonth.value.month, 1),
        endDate: DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0),
      );
      attendanceList.assignAll(history);
    } finally {
      isLoading.value = false;
    }
  }

  void previousMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );
    _loadHistory();
  }

  void nextMonth() {
    final now = DateTime.now();
    final next = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );
    if (next.isBefore(now) || next.month == now.month && next.year == now.year) {
      selectedMonth.value = next;
      _loadHistory();
    }
  }

  String get formattedMonth {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[selectedMonth.value.month - 1]} ${selectedMonth.value.year}';
  }

  bool get canGoNext {
    final now = DateTime.now();
    return selectedMonth.value.year < now.year ||
        (selectedMonth.value.year == now.year && selectedMonth.value.month < now.month);
  }
}
