import 'package:get/get.dart';
import '../data/models/history_model.dart';
import '../data/providers/history_provider.dart';

class HistoryController extends GetxController {
  final AttendanceProvider provider;
  HistoryController({required this.provider});

  final attendanceList = <AttendanceModel>[].obs;
  final stats = Rxn<AttendanceStats>();
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
      final startDate = DateTime(selectedMonth.value.year, selectedMonth.value.month, 1);
      final endDate = DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0);

      final response = await provider.getHistory(
        startDate: startDate.toIso8601String().split('T')[0],
        endDate: endDate.toIso8601String().split('T')[0],
      );

      if (response.success) {
        attendanceList.assignAll(response.data);
        stats.value = response.stats;
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh history data
  Future<void> refresh() async {
    await _loadHistory();
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

  // Statistics getters
  int get totalDays => stats.value?.totalDays ?? 0;
  int get presentDays => stats.value?.presentDays ?? 0;
  int get lateDays => stats.value?.lateDays ?? 0;
  int get absentDays => stats.value?.absentDays ?? 0;
  double get totalWorkHours => stats.value?.totalWorkHours ?? 0;
  double get averageWorkHours => stats.value?.averageWorkHours ?? 0;
}
