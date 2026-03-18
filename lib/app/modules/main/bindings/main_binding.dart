import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../../attendance/data/providers/attendance_provider.dart';
import '../../history/controllers/history_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../auth/data/providers/auth_provider.dart';
import '../../../data/providers/attendance_provider.dart' as legacy;
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Providers - use Get.put to create immediately
    Get.put<AuthProvider>(AuthProvider());
    Get.put<AttendanceProvider>(AttendanceProvider());
    Get.put<legacy.LegacyAttendanceProvider>(legacy.LegacyAttendanceProvider());

    // Controllers
    Get.put<MainController>(MainController());
    Get.lazyPut<HomeController>(
      () => HomeController(provider: Get.find<legacy.LegacyAttendanceProvider>()),
    );
    Get.lazyPut<AttendanceController>(
      () => AttendanceController(provider: Get.find<AttendanceProvider>()),
    );
    Get.lazyPut<HistoryController>(
      () => HistoryController(provider: Get.find<AttendanceProvider>()),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(authProvider: Get.find<AuthProvider>()),
    );
  }
}
