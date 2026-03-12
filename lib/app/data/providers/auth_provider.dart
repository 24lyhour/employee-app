import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    // Configure base URL from flavor config
    // httpClient.baseUrl = AppFlavorConfig.baseUrl;
    httpClient.timeout = const Duration(seconds: 30);
  }

  // Mock login - replace with actual API call
  Future<UserModel?> login(String email, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email == 'test@test.com' && password == '123456') {
      return UserModel.mock();
    }

    // For demo, accept any email/password
    if (email.isNotEmpty && password.length >= 6) {
      return UserModel(
        id: '1',
        name: email.split('@').first,
        email: email,
        employeeId: 'EMP001',
        department: 'Engineering',
        createdAt: DateTime.now(),
      );
    }

    return null;
  }

  // Mock register - replace with actual API call
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // For demo, always succeed
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      employeeId: 'EMP${DateTime.now().millisecond}',
      department: 'General',
      createdAt: DateTime.now(),
    );
  }

  // Mock logout
  Future<bool> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // Check if user is logged in (mock)
  Future<UserModel?> getCurrentUser() async {
    // In real app, check local storage/secure storage for token
    // and validate with server
    return null;
  }
}
