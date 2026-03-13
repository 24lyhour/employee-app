import 'package:get/get.dart';
import '../../../data/providers/attendance_provider.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceProvider>(() => AttendanceProvider());
    Get.lazyPut<HomeController>(
      () => HomeController(provider: Get.find<AttendanceProvider>()),
    );
  }
}
