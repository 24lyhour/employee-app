import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProvider>(() => AuthProvider());
    Get.lazyPut<ProfileController>(
      () => ProfileController(authProvider: Get.find<AuthProvider>()),
    );
  }
}
