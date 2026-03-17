import 'package:get/get.dart';
import '../../../data/providers/attendance_provider.dart';
import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LegacyAttendanceProvider>(() => LegacyAttendanceProvider());
    Get.lazyPut<HistoryController>(
      () => HistoryController(provider: Get.find<LegacyAttendanceProvider>()),
    );
  }
}
