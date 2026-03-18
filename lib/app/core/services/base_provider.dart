import 'package:get/get.dart';
import '../../config/flavor_config.dart';
import 'storage_service.dart';

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
      return request;
    });

    super.onInit();
  }
}
