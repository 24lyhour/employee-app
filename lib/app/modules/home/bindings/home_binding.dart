import 'package:get/get.dart';
import '../../attendance/data/providers/attendance_provider.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceProvider>(() => AttendanceProvider());
    Get.lazyPut<HomeController>(
      () => HomeController(attendanceProvider: Get.find<AttendanceProvider>()),
    );
  }
}
