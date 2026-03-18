import 'package:get/get.dart';
import '../data/providers/history_provider.dart';
import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceProvider>(() => AttendanceProvider());
    Get.lazyPut<HistoryController>(
      () => HistoryController(provider: Get.find<AttendanceProvider>()),
    );
  }
}
