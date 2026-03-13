import 'package:get/get.dart';

import '../controllers/staff_request_permission_controller.dart';

class StaffRequestPermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffRequestPermissionController>(
      () => StaffRequestPermissionController(),
    );
  }
}
