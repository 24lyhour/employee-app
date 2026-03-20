import '../models/employee_model.dart';
import '../../../../core/services/base_provider.dart';
import '../../../../core/services/storage_service.dart';

class AuthProvider extends BaseProvider {
  /// Login with email/phone and password
  Future<LoginResponse> login({
    String? email,
    String? phone,
    required String password,
  }) async {
    try {
      final body = <String, dynamic>{
        'password': password,
      };

      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      } else if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }

      final response = await post(
        '/api/v1/employee/auth/login',
        body,
      );

      // Check if response body is null
      if (response.body == null) {
        return LoginResponse(
          success: false,
          message: 'Server error: Empty response',
        );
      }

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.body);

        // Save token to storage
        if (loginResponse.accessToken != null) {
          await StorageService.saveToken(loginResponse.accessToken!);
        }

        // Save employee data to storage
        if (loginResponse.employee != null) {
          await StorageService.saveEmployee(loginResponse.employee!.toJson());
        }

        return loginResponse;
      } else if (response.statusCode == 422) {
        // Validation error
        final body = response.body as Map<String, dynamic>?;
        final errors = body?['errors'] as Map<String, dynamic>?;
        final message = errors?.values.first?.first ?? body?['message'] ?? 'Validation failed';
        return LoginResponse(success: false, message: message.toString());
      } else {
        final body = response.body as Map<String, dynamic>?;
        return LoginResponse(
          success: false,
          message: body?['message']?.toString() ?? 'Login failed',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  /// Logout (revoke current token)
  Future<bool> logout() async {
    try {
      final response = await post('/api/v1/employee/auth/logout', {});

      // Clear local storage regardless of response
      await StorageService.clearAll();

      return response.statusCode == 200;
    } catch (e) {
      // Clear local storage even if request fails
      await StorageService.clearAll();
      return false;
    }
  }

  /// Logout from all devices
  Future<bool> logoutAll() async {
    try {
      final response = await post('/api/v1/employee/auth/logout-all', {});

      // Clear local storage regardless of response
      await StorageService.clearAll();

      return response.statusCode == 200;
    } catch (e) {
      await StorageService.clearAll();
      return false;
    }
  }

  /// Get current employee profile
  Future<ProfileResponse> getProfile() async {
    try {
      final response = await get('/api/v1/employee/auth/me');

      // Check if response body is null
      if (response.body == null) {
        return ProfileResponse(
          success: false,
          message: 'Server error: Empty response',
        );
      }

      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(response.body);
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        await StorageService.clearAll();
        return ProfileResponse(
          success: false,
          message: 'Session expired. Please login again.',
        );
      } else {
        final body = response.body as Map<String, dynamic>?;
        return ProfileResponse(
          success: false,
          message: body?['message']?.toString() ?? 'Failed to get profile',
        );
      }
    } catch (e) {
      return ProfileResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  /// Check if user is logged in and get current employee
  Future<EmployeeModel?> getCurrentEmployee() async {
    final token = StorageService.getToken();
    if (token == null) return null;

    // Try to get from local storage first
    final savedEmployee = StorageService.getEmployee();
    if (savedEmployee != null) {
      return EmployeeModel.fromJson(savedEmployee);
    }

    // If not in storage, fetch from API
    final response = await getProfile();
    if (response.success && response.employee != null) {
      await StorageService.saveEmployee(response.employee!.toJson());
      return response.employee;
    }

    return null;
  }
}
