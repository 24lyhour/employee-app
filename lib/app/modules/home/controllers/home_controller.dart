import 'package:get/get.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/attendance_provider.dart';

class HomeController extends GetxController {
  final LegacyAttendanceProvider provider;
  HomeController({required this.provider});

  final user = Rxn<UserModel>();
  final todayAttendance = Rxn<LegacyAttendanceModel>();
  final stats = <String, int>{}.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      // Mock user for now
      user.value = UserModel.mock();

      // Load today's attendance
      todayAttendance.value = await provider.getTodayAttendance(user.value!.id);

      // Load stats
      final statsData = await provider.getAttendanceStats(user.value!.id);
      stats.assignAll(statsData);
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
}
