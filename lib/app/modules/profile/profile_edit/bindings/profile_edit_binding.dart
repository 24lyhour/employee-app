import 'package:get/get.dart';
import '../controllers/profile_edit_controller.dart';
import '../data/providers/profile_edit_provider.dart';

class ProfileEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileEditProvider>(() => ProfileEditProvider());
    Get.lazyPut<ProfileEditController>(
      () => ProfileEditController(provider: Get.find<ProfileEditProvider>()),
    );
  }
}
