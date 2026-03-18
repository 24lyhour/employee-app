import 'package:get/get.dart';

import '../controllers/staff_request_permission_controller.dart';
import '../data/providers/permission_request_provider.dart';

class StaffRequestPermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionRequestProvider>(
      () => PermissionRequestProvider(),
    );
    Get.lazyPut<StaffRequestPermissionController>(
      () => StaffRequestPermissionController(),
    );
  }
}
