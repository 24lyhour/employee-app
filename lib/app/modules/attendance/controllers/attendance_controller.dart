import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/utils/toast_helper.dart';
import '../data/models/attendance_model.dart';
import '../data/providers/attendance_provider.dart';

class AttendanceController extends GetxController {
  final AttendanceProvider provider;
  AttendanceController({required this.provider});

  final todayAttendance = Rxn<AttendanceModel>();
  final currentTime = DateTime.now().obs;
  final isLoading = false.obs;
  final canCheckIn = true.obs;
  final canCheckOut = false.obs;

  // Location
  final currentPosition = Rxn<Position>();
  final isGettingLocation = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    _loadTodayAttendance();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      currentTime.value = DateTime.now();
    });
  }

  Future<void> _loadTodayAttendance() async {
    isLoading.value = true;
    try {
      final response = await provider.getTodayAttendance();
      if (response.success) {
        todayAttendance.value = response.attendance;
        canCheckIn.value = response.canCheckIn;
        canCheckOut.value = response.canCheckOut;
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool get isCheckedIn => todayAttendance.value?.hasCheckedIn ?? false;
  bool get isCheckedOut => todayAttendance.value?.hasCheckedOut ?? false;

  String get formattedTime {
    final time = currentTime.value;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  String get formattedDate {
    final date = currentTime.value;
    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String? get checkInTime => todayAttendance.value?.checkInTime;
  String? get checkOutTime => todayAttendance.value?.checkOutTime;

  /// Get current location
  Future<Position?> _getCurrentLocation() async {
    isGettingLocation.value = true;
    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ToastHelper.showError('Location permission denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ToastHelper.showError('Location permission permanently denied. Please enable in settings.');
        return null;
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      currentPosition.value = position;
      return position;
    } catch (e) {
      ToastHelper.showError('Failed to get location: $e');
      return null;
    } finally {
      isGettingLocation.value = false;
    }
  }

  /// Check-in with QR code
  Future<void> checkInWithQR({
    required int departmentId,
    String? qrCode,
  }) async {
    if (!canCheckIn.value) {
      ToastHelper.showError('Already checked in today');
      return;
    }

    isLoading.value = true;
    try {
      // Get location
      final position = await _getCurrentLocation();
      if (position == null) return;

      final response = await provider.checkIn(
        departmentId: departmentId,
        latitude: position.latitude,
        longitude: position.longitude,
        scanMethod: 'qr',
      );

      if (response.success) {
        todayAttendance.value = response.attendance;
        canCheckIn.value = false;
        canCheckOut.value = true;
        ToastHelper.showSuccess(response.message);

        // Show geofence warning if outside
        if (response.geofence != null && !response.geofence!.withinGeofence) {
          ToastHelper.showWarning(
            'Warning: You are ${response.geofence!.distance?.toStringAsFixed(0)}m outside the geofence',
          );
        }
      } else {
        ToastHelper.showError(response.message);
      }
    } catch (e) {
      ToastHelper.showError('Check-in failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Check-out with QR code
  Future<void> checkOutWithQR({
    required int departmentId,
    String? qrCode,
  }) async {
    if (!canCheckOut.value) {
      ToastHelper.showError('Please check in first');
      return;
    }

    isLoading.value = true;
    try {
      // Get location
      final position = await _getCurrentLocation();
      if (position == null) return;

      final response = await provider.checkOut(
        departmentId: departmentId,
        latitude: position.latitude,
        longitude: position.longitude,
        scanMethod: 'qr',
      );

      if (response.success) {
        todayAttendance.value = response.attendance;
        canCheckOut.value = false;
        ToastHelper.showSuccess(response.message);

        // Show geofence warning if outside
        if (response.geofence != null && !response.geofence!.withinGeofence) {
          ToastHelper.showWarning(
            'Warning: You are ${response.geofence!.distance?.toStringAsFixed(0)}m outside the geofence',
          );
        }
      } else {
        ToastHelper.showError(response.message);
      }
    } catch (e) {
      ToastHelper.showError('Check-out failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh attendance data
  @override
  Future<void> refresh() async {
    await _loadTodayAttendance();
  }

  /// Simple check-in (uses default department from employee profile)
  Future<void> checkIn() async {
    // TODO: Get department ID from employee profile or allow selection
    // For now, we'll show an error asking to use QR scan
    ToastHelper.showInfo('Please scan the department QR code to check in');
  }

  /// Simple check-out (uses default department from employee profile)
  Future<void> checkOut() async {
    // TODO: Get department ID from employee profile or allow selection
    // For now, we'll show an error asking to use QR scan
    ToastHelper.showInfo('Please scan the department QR code to check out');
  }
}
