import 'package:get/get.dart';
import '../../../data/providers/attendance_provider.dart';
import '../controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LegacyAttendanceProvider>(() => LegacyAttendanceProvider());
    Get.lazyPut<AttendanceController>(
      () => AttendanceController(provider: Get.find<LegacyAttendanceProvider>()),
    );
  }
}
