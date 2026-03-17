import 'package:get/get.dart';
import '../models/attendance_model.dart';
import '../../../../config/flavor_config.dart';
import '../../../../core/services/storage_service.dart';

class AttendanceProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppFlavorConfig.baseUrl;
    httpClient.timeout = const Duration(seconds: 30);

    // Add auth header for protected routes
    httpClient.addRequestModifier<dynamic>((request) async {
      final token = StorageService.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      return request;
    });
  }

  /// Get today's attendance status
  Future<TodayAttendanceResponse> getTodayAttendance() async {
    try {
      final response = await get('/api/v1/employee/attendance/today');

      if (response.statusCode == 200) {
        return TodayAttendanceResponse.fromJson(response.body);
      } else if (response.statusCode == 401) {
        await StorageService.clearAll();
        return TodayAttendanceResponse(
          success: false,
          message: 'Session expired. Please login again.',
          canCheckIn: false,
          canCheckOut: false,
        );
      } else {
        return TodayAttendanceResponse(
          success: false,
          message: response.body['message'] ?? 'Failed to get attendance',
          canCheckIn: false,
          canCheckOut: false,
        );
      }
    } catch (e) {
      return TodayAttendanceResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
        canCheckIn: false,
        canCheckOut: false,
      );
    }
  }

  /// Check-in with QR scan
  Future<ScanResponse> checkIn({
    required int departmentId,
    required double latitude,
    required double longitude,
    String? address,
    String scanMethod = 'qr',
    String? deviceInfo,
    String? notes,
  }) async {
    try {
      final body = {
        'department_id': departmentId,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'scan_method': scanMethod,
        'device_info': deviceInfo,
        'notes': notes,
      };

      // Remove null values
      body.removeWhere((key, value) => value == null);

      final response = await post(
        '/api/v1/employee/attendance/check-in',
        body,
      );

      if (response.statusCode == 200) {
        return ScanResponse.fromJson(response.body);
      } else if (response.statusCode == 422) {
        // Validation or geofence error
        return ScanResponse(
          success: false,
          message: response.body['message'] ?? 'Check-in failed',
          geofence: response.body['geofence'] != null
              ? GeofenceVerification.fromJson(response.body['geofence'])
              : null,
        );
      } else if (response.statusCode == 401) {
        await StorageService.clearAll();
        return ScanResponse(
          success: false,
          message: 'Session expired. Please login again.',
        );
      } else {
        return ScanResponse(
          success: false,
          message: response.body['message'] ?? 'Check-in failed',
        );
      }
    } catch (e) {
      return ScanResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  /// Check-out with QR scan
  Future<ScanResponse> checkOut({
    required int departmentId,
    required double latitude,
    required double longitude,
    String? address,
    String scanMethod = 'qr',
    String? deviceInfo,
    String? notes,
  }) async {
    try {
      final body = {
        'department_id': departmentId,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'scan_method': scanMethod,
        'device_info': deviceInfo,
        'notes': notes,
      };

      // Remove null values
      body.removeWhere((key, value) => value == null);

      final response = await post(
        '/api/v1/employee/attendance/check-out',
        body,
      );

      if (response.statusCode == 200) {
        return ScanResponse.fromJson(response.body);
      } else if (response.statusCode == 422) {
        // Validation or geofence error
        return ScanResponse(
          success: false,
          message: response.body['message'] ?? 'Check-out failed',
          geofence: response.body['geofence'] != null
              ? GeofenceVerification.fromJson(response.body['geofence'])
              : null,
        );
      } else if (response.statusCode == 401) {
        await StorageService.clearAll();
        return ScanResponse(
          success: false,
          message: 'Session expired. Please login again.',
        );
      } else {
        return ScanResponse(
          success: false,
          message: response.body['message'] ?? 'Check-out failed',
        );
      }
    } catch (e) {
      return ScanResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  /// Get attendance history with optional date range
  Future<AttendanceHistoryResponse> getHistory({
    String? startDate,
    String? endDate,
    int perPage = 15,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'per_page': perPage.toString(),
        'page': page.toString(),
      };

      if (startDate != null) {
        queryParams['start_date'] = startDate;
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate;
      }

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      final response =
          await get('/api/v1/employee/attendance/history?$queryString');

      if (response.statusCode == 200) {
        return AttendanceHistoryResponse.fromJson(response.body);
      } else if (response.statusCode == 401) {
        await StorageService.clearAll();
        return AttendanceHistoryResponse(
          success: false,
          data: [],
        );
      } else {
        return AttendanceHistoryResponse(
          success: false,
          data: [],
        );
      }
    } catch (e) {
      return AttendanceHistoryResponse(
        success: false,
        data: [],
      );
    }
  }
}
