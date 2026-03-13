import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/models/permission_request_model.dart';

class StaffRequestPermissionController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();

  // Form state
  final selectedRole = Rxn<RoleOption>();
  final fromDate = Rxn<DateTime>();
  final toDate = Rxn<DateTime>();
  final isLoading = false.obs;

  // Request history
  final requestHistory = <PermissionRequestModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Set default dates to today
    fromDate.value = DateTime.now();
    toDate.value = DateTime.now();
    loadRequestHistory();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  String get formattedFromDate {
    if (fromDate.value == null) return 'Select date';
    return DateFormat('dd MMM yyyy').format(fromDate.value!);
  }

  String get formattedToDate {
    if (toDate.value == null) return 'Select date';
    return DateFormat('dd MMM yyyy').format(toDate.value!);
  }

  int get totalDays {
    if (fromDate.value == null || toDate.value == null) return 0;
    return toDate.value!.difference(fromDate.value!).inDays + 1;
  }

  void selectRole(RoleOption role) {
    selectedRole.value = role;
  }

  Future<void> selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      fromDate.value = picked;
      // If toDate is before fromDate, update toDate
      if (toDate.value != null && toDate.value!.isBefore(picked)) {
        toDate.value = picked;
      }
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? fromDate.value ?? DateTime.now(),
      firstDate: fromDate.value ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      toDate.value = picked;
    }
  }

  String? validateReason(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your reason';
    }
    if (value.trim().length < 10) {
      return 'Reason must be at least 10 characters';
    }
    return null;
  }

  bool get isFormValid {
    return selectedRole.value != null &&
        fromDate.value != null &&
        toDate.value != null &&
        reasonController.text.trim().length >= 10;
  }

  Future<void> submitRequest() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedRole.value == null) {
      Get.snackbar(
        'Error',
        'Please select a permission type',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final request = PermissionRequestModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: selectedRole.value!.id,
        reason: reasonController.text.trim(),
        fromDate: fromDate.value!,
        toDate: toDate.value!,
        requestDate: DateTime.now(),
        status: PermissionStatus.pending,
      );

      // Add to history
      requestHistory.insert(0, request);

      // Reset form
      resetForm();

      Get.snackbar(
        'Success',
        'Your request has been submitted',
        backgroundColor: const Color(0xFF5EA500).withValues(alpha: 0.1),
        colorText: const Color(0xFF5EA500),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit request. Please try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    selectedRole.value = null;
    fromDate.value = DateTime.now();
    toDate.value = DateTime.now();
    reasonController.clear();
  }

  void loadRequestHistory() {
    // TODO: Load from API
    // For now, using mock data
    requestHistory.value = [
      PermissionRequestModel(
        id: '1',
        role: 'leave',
        reason: 'Family vacation to visit relatives',
        fromDate: DateTime.now().subtract(const Duration(days: 5)),
        toDate: DateTime.now().subtract(const Duration(days: 3)),
        requestDate: DateTime.now().subtract(const Duration(days: 7)),
        status: PermissionStatus.approved,
      ),
      PermissionRequestModel(
        id: '2',
        role: 'remote',
        reason: 'Working from home due to home renovation',
        fromDate: DateTime.now().subtract(const Duration(days: 2)),
        toDate: DateTime.now().subtract(const Duration(days: 1)),
        requestDate: DateTime.now().subtract(const Duration(days: 4)),
        status: PermissionStatus.pending,
      ),
    ];
  }

  String getRoleName(String roleId) {
    final role = RoleOption.availableRoles.firstWhere(
      (r) => r.id == roleId,
      orElse: () => const RoleOption(id: '', name: 'Unknown', description: ''),
    );
    return role.name;
  }
}
