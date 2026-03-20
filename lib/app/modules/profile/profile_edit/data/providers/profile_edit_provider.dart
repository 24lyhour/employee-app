import 'dart:io';
import 'package:get/get.dart';
import '../../../../../core/services/base_provider.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../../auth/data/models/employee_model.dart';

class ProfileEditProvider extends BaseProvider {
  /// Update employee profile
  Future<ProfileUpdateResponse> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? gender,
    String? dateOfBirth,
    String? birthPlace,
    String? currentAddress,
    String? avatarPath,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (firstName != null) body['first_name'] = firstName;
      if (lastName != null) body['last_name'] = lastName;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;
      if (gender != null) body['gender'] = gender;
      if (dateOfBirth != null) body['date_of_birth'] = dateOfBirth;
      if (birthPlace != null) body['birth_place'] = birthPlace;
      if (currentAddress != null) body['current_address'] = currentAddress;

      // Handle file upload if avatar provided
      if (avatarPath != null && avatarPath.isNotEmpty) {
        final file = File(avatarPath);
        final fileName = avatarPath.split('/').last;

        // Debug: print file info
        print('Uploading avatar: $fileName, size: ${file.lengthSync()} bytes');

        final formData = FormData({
          ...body,
          'avatar': MultipartFile(
            file.readAsBytesSync(),
            filename: fileName,
            contentType: 'image/jpeg',
          ),
        });

        final response = await post(
          '/api/v1/employee/auth/update-profile',
          formData,
        );

        return _handleResponse(response);
      }

      final response = await post(
        '/api/v1/employee/auth/update-profile',
        body,
      );

      return _handleResponse(response);
    } catch (e) {
      return ProfileUpdateResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  ProfileUpdateResponse _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body as Map<String, dynamic>?;

      // Extract employee data - handle different API response structures
      EmployeeModel? employee;
      if (body?['employee'] != null) {
        employee = EmployeeModel.fromJson(body!['employee']);
      } else if (body?['data'] != null && body!['data']['employee'] != null) {
        employee = EmployeeModel.fromJson(body['data']['employee']);
      } else if (body?['data'] != null) {
        employee = EmployeeModel.fromJson(body!['data']);
      }

      // Update local storage with new employee data
      if (employee != null) {
        StorageService.saveEmployee(employee.toJson());
      }

      return ProfileUpdateResponse(
        success: true,
        message: body?['message'] ?? 'Profile updated successfully',
        employee: employee,
      );
    } else if (response.statusCode == 422) {
      final errors = response.body['errors'] as Map<String, dynamic>?;
      final message = errors?.values.first?.first ?? 'Validation failed';
      return ProfileUpdateResponse(success: false, message: message);
    } else if (response.statusCode == 401) {
      StorageService.clearAll();
      return ProfileUpdateResponse(
        success: false,
        message: 'Session expired. Please login again.',
      );
    } else {
      return ProfileUpdateResponse(
        success: false,
        message: response.body['message'] ?? 'Failed to update profile',
      );
    }
  }
}

/// Response model for profile update
class ProfileUpdateResponse {
  final bool success;
  final String? message;
  final EmployeeModel? employee;

  ProfileUpdateResponse({
    required this.success,
    this.message,
    this.employee,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'],
      employee: json['employee'] != null
          ? EmployeeModel.fromJson(json['employee'])
          : null,
    );
  }
}
