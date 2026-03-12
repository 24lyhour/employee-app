import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthProvider authProvider;
  ProfileController({required this.authProvider});

  final user = Rxn<UserModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    // Mock user for now
    user.value = UserModel.mock();
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await authProvider.logout();
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }
}
