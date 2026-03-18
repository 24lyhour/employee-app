import '../../../../core/services/base_provider.dart';
import '../../../../core/services/storage_service.dart';
import '../models/permission_request_model.dart';

class PermissionRequestProvider extends BaseProvider {
  /// Get available permission request types
  Future<PermissionTypesResponse> getTypes() async {
    try {
      final response = await get('/api/v1/employee/permission-requests/types');

      if (response.statusCode == 200) {
        return PermissionTypesResponse.fromJson(response.body);
      } else if (response.statusCode == 401) {
        await StorageService.clearAll();
        return PermissionTypesResponse(
          success: false,
          message: 'Session expired. Please login again.',
          data: [],
        );
      } else {
        return PermissionTypesResponse(
          success: false,
          message: response.body['message'] ?? 'Failed to get types',
          data: [],
        );
      }
    } catch (e) {
      return PermissionTypesResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
        data: [],
      );
    }
  }

  /// Get permission requests list
  Future<PermissionRequestListResponse> getRequests({
    String? status,
    String? type,
    int perPage = 15,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'per_page': perPage.toString(),
        'page': page.toString(),
      };

      if (status != null) {
        queryParams['status'] = status;
      }
      if (type != null) {
        queryParams['type'] = type;
      }

      final queryString =
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

      final response =
          await get('/api/v1/employee/permission-requests?$queryString');

      if (response.statusCode == 200) {
        return PermissionRequestListResponse.fromJson(response.body);
      } else if (response.statusCode == 401) {
        await StorageService.clearAll();
        return PermissionRequestListResponse(success: false, data: []);
      } else {
        return PermissionRequestListResponse(success: false, data: []);
      }
    } catch (e) {
      return PermissionRequestListResponse(success: false, data: []);
    }
  }

  /// Create a new permission request
  Future<CreatePermissionResponse> createRequest({
    required String type,
    required String reason,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final body = {
        'type': type,
        'reason': reason,
        'from_date': fromDate,
        'to_date': toDate,
      };

      final response = await post('/api/v1/employee/permission-requests', body);

      // Accept both 200 and 201 as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreatePermissionResponse.fromJson(response.body);
      } else if (response.statusCode == 422) {
        final errors = response.body['errors'] as Map<String, dynamic>?;
        String message = response.body['message'] ?? 'Validation failed';

        if (errors != null && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            message = firstError.first.toString();
          }
        }

        return CreatePermissionResponse(success: false, message: message);
      } else if (response.statusCode == 401) {
        await StorageService.clearAll();
        return CreatePermissionResponse(
          success: false,
          message: 'Session expired. Please login again.',
        );
      } else {
        return CreatePermissionResponse(
          success: false,
          message: response.body['message'] ?? 'Failed to submit request',
        );
      }
    } catch (e) {
      return CreatePermissionResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  /// Get permission request detail
  Future<PermissionDetailResponse> getRequestDetail(String uuid) async {
    try {
      final response = await get('/api/v1/employee/permission-requests/$uuid');

      if (response.statusCode == 200) {
        return PermissionDetailResponse.fromJson(response.body);
      } else if (response.statusCode == 404) {
        return PermissionDetailResponse(
          success: false,
          message: 'Request not found',
        );
      } else if (response.statusCode == 401) {
        await StorageService.clearAll();
        return PermissionDetailResponse(
          success: false,
          message: 'Session expired. Please login again.',
        );
      } else {
        return PermissionDetailResponse(
          success: false,
          message: response.body['message'] ?? 'Failed to get request detail',
        );
      }
    } catch (e) {
      return PermissionDetailResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  /// Cancel a pending permission request
  Future<CancelPermissionResponse> cancelRequest(String uuid) async {
    try {
      final response =
          await delete('/api/v1/employee/permission-requests/$uuid');

      if (response.statusCode == 200) {
        return CancelPermissionResponse.fromJson(response.body);
      } else if (response.statusCode == 422) {
        return CancelPermissionResponse(
          success: false,
          message: response.body['message'] ?? 'Cannot cancel this request',
        );
      } else if (response.statusCode == 404) {
        return CancelPermissionResponse(
          success: false,
          message: 'Request not found',
        );
      } else if (response.statusCode == 401) {
        await StorageService.clearAll();
        return CancelPermissionResponse(
          success: false,
          message: 'Session expired. Please login again.',
        );
      } else {
        return CancelPermissionResponse(
          success: false,
          message: response.body['message'] ?? 'Failed to cancel request',
        );
      }
    } catch (e) {
      return CancelPermissionResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }
}
