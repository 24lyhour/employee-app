import 'package:get/get.dart';
import '../../config/flavor_config.dart';
import 'storage_service.dart';

/// Base provider class with common HTTP client configuration.
/// All API providers should extend this class to avoid code duplication.
abstract class BaseProvider extends GetConnect {
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
      // Don't override Content-Type - let GetX set it automatically
      // For FormData it will set multipart/form-data with boundary
      // For regular requests it will set application/json
      return request;
    });

    super.onInit();
  }
}
