import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/providers/attendance_provider.dart';

class AttendanceController extends GetxController {
  final AttendanceProvider provider;
  AttendanceController({required this.provider});

  final todayAttendance = Rxn<AttendanceModel>();
  final currentTime = DateTime.now().obs;
  final isLoading = false.obs;

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
      todayAttendance.value = await provider.getTodayAttendance('1');
    } finally {
      isLoading.value = false;
    }
  }

  bool get isCheckedIn => todayAttendance.value?.isCheckedIn ?? false;
  bool get isCheckedOut => todayAttendance.value?.isCheckedOut ?? false;
  bool get canCheckIn => !isCheckedIn;
  bool get canCheckOut => isCheckedIn && !isCheckedOut;

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

  Future<void> checkIn() async {
    if (!canCheckIn) return;

    isLoading.value = true;
    try {
      final attendance = await provider.checkIn('1');
      todayAttendance.value = attendance;
      Get.snackbar(
        'Success',
        'You have checked in at ${attendance.checkInTimeFormatted}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check in. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkOut() async {
    if (!canCheckOut || todayAttendance.value == null) return;

    isLoading.value = true;
    try {
      final attendance = await provider.checkOut(todayAttendance.value!);
      todayAttendance.value = attendance;
      Get.snackbar(
        'Success',
        'You have checked out at ${attendance.checkOutTimeFormatted}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // QR Code check in/out
  Future<void> checkInWithQR(String qrCode) async {
    if (!canCheckIn) return;

    isLoading.value = true;
    try {
      // Validate QR code here if needed
      final attendance = await provider.checkIn('1');
      todayAttendance.value = attendance;
      Get.snackbar(
        'Success',
        'QR Check-in successful at ${attendance.checkInTimeFormatted}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'QR Check-in failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkOutWithQR(String qrCode) async {
    if (!canCheckOut || todayAttendance.value == null) return;

    isLoading.value = true;
    try {
      // Validate QR code here if needed
      final attendance = await provider.checkOut(todayAttendance.value!);
      todayAttendance.value = attendance;
      Get.snackbar(
        'Success',
        'QR Check-out successful at ${attendance.checkOutTimeFormatted}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'QR Check-out failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
