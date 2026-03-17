# Flutter Module Pattern

This document describes the module architecture pattern used in the Employee App.

## Module Structure

Each feature module follows this consistent structure:

```
lib/app/modules/{module_name}/
├── bindings/
│   └── {module}_binding.dart     # Dependency injection
├── controllers/
│   └── {module}_controller.dart  # Business logic (GetX)
├── data/
│   ├── models/
│   │   └── {module}_model.dart   # Data models & API responses
│   └── providers/
│       └── {module}_provider.dart # API calls (GetConnect)
├── views/
│   └── {module}_view.dart        # UI pages
└── widgets/                      # Module-specific widgets (optional)
    └── *.dart
```

## Example Modules

### Auth Module
```
modules/auth/
├── bindings/auth_binding.dart
├── controllers/auth_controller.dart
├── data/
│   ├── models/employee_model.dart     # EmployeeModel, LoginResponse, ProfileResponse
│   └── providers/auth_provider.dart   # login(), logout(), getProfile()
└── views/
    ├── login_view.dart
    └── register_view.dart
```

### Attendance Module
```
modules/attendance/
├── bindings/attendance_binding.dart
├── controllers/attendance_controller.dart
├── data/
│   ├── models/attendance_model.dart   # AttendanceModel, ScanResponse, etc.
│   └── providers/attendance_provider.dart # checkIn(), checkOut(), getHistory()
├── views/attendance_view.dart
└── widgets/check_button.dart
```

## Data Layer Pattern

### Models
- Match backend Laravel API Resource response structure
- Include `fromJson()` and `toJson()` methods
- Response wrappers: `{Action}Response` classes

```dart
// Example: attendance_model.dart
class AttendanceModel {
  final int id;
  final String uuid;
  // ... fields matching API response

  factory AttendanceModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}

class TodayAttendanceResponse {
  final bool success;
  final AttendanceModel? attendance;
  // ...
}
```

### Providers
- Extend `GetConnect` for HTTP client
- Configure base URL from `AppFlavorConfig`
- Add auth headers via request modifier
- Return typed response objects

```dart
class AttendanceProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppFlavorConfig.baseUrl;
    httpClient.addRequestModifier<dynamic>((request) async {
      final token = StorageService.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }

  Future<TodayAttendanceResponse> getTodayAttendance() async { ... }
  Future<ScanResponse> checkIn({...}) async { ... }
}
```

## Import Pattern

### Within Same Module
```dart
// In attendance_provider.dart
import '../models/attendance_model.dart';
```

### Cross-Module Imports
```dart
// In attendance_model.dart, importing from auth module
import '../../../auth/data/models/employee_model.dart';
```

### Global Services
```dart
import '../../../../config/flavor_config.dart';
import '../../../../core/services/storage_service.dart';
```

## Binding Setup

Register providers and controllers in bindings:

```dart
class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceProvider>(() => AttendanceProvider());
    Get.lazyPut<AttendanceController>(
      () => AttendanceController(
        attendanceProvider: Get.find(),
      ),
    );
  }
}
```

## API Endpoints Mapping

| Flutter Provider Method | Laravel API Endpoint |
|------------------------|---------------------|
| `AuthProvider.login()` | `POST /api/v1/employee/auth/login` |
| `AuthProvider.logout()` | `POST /api/v1/employee/auth/logout` |
| `AuthProvider.getProfile()` | `GET /api/v1/employee/auth/me` |
| `AttendanceProvider.getTodayAttendance()` | `GET /api/v1/employee/attendance/today` |
| `AttendanceProvider.checkIn()` | `POST /api/v1/employee/attendance/check-in` |
| `AttendanceProvider.checkOut()` | `POST /api/v1/employee/attendance/check-out` |
| `AttendanceProvider.getHistory()` | `GET /api/v1/employee/attendance/history` |

## Best Practices

1. **Keep models synced with backend** - Match Laravel API Resource fields
2. **Type all responses** - Create response wrapper classes
3. **Handle errors consistently** - Return typed error responses
4. **Use dependency injection** - Register in bindings, not inline
5. **Separate concerns** - Controller handles logic, Provider handles API
