import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/models/permission_request_model.dart';
import '../data/providers/permission_request_provider.dart';

class StaffRequestPermissionController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();

  late final PermissionRequestProvider _provider;

  // Form state
  final selectedType = Rxn<PermissionTypeModel>();
  final fromDate = Rxn<DateTime>();
  final toDate = Rxn<DateTime>();
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final reasonText = ''.obs;

  // Permission types from API
  final permissionTypes = <PermissionTypeModel>[].obs;

  // Request history
  final requestHistory = <PermissionRequestModel>[].obs;
  final stats = Rxn<PermissionStats>();

  // Pagination
  final currentPage = 1.obs;
  final hasMorePages = true.obs;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    _provider = Get.find<PermissionRequestProvider>();
    fromDate.value = DateTime.now();
    toDate.value = DateTime.now();
    loadPermissionTypes();
    loadRequestHistory();
  }

  /// Update reason text for reactive validation
  void onReasonChanged(String value) {
    reasonText.value = value;
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

  void selectType(PermissionTypeModel type) {
    selectedType.value = type;
  }

  Future<void> selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      fromDate.value = picked;
      if (toDate.value != null && toDate.value!.isBefore(picked)) {
        toDate.value = picked;
      }
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? fromDate.value ?? DateTime.now(),
      firstDate: fromDate.value ?? DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      toDate.value = picked;
    }
  }

  /// Validator for reason field using FormBuilderValidators
  String? Function(String?) get validateReason => FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter your reason'),
        FormBuilderValidators.minLength(5,
            errorText: 'Reason must be at least 5 characters'),
        FormBuilderValidators.maxLength(1000,
            errorText: 'Reason cannot exceed 1000 characters'),
      ]);

  bool get isFormValid {
    final reason = reasonText.value.trim();
    return selectedType.value != null &&
        fromDate.value != null &&
        toDate.value != null &&
        reason.length >= 5 &&
        reason.length <= 1000;
  }

  /// Load permission types from API
  Future<void> loadPermissionTypes() async {
    final response = await _provider.getTypes();

    if (response.success) {
      permissionTypes.value = response.data;
    }
  }

  /// Load request history from API
  Future<void> loadRequestHistory({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMorePages.value = true;
    }

    if (!hasMorePages.value && !refresh) return;

    isLoading.value = currentPage.value == 1;
    isLoadingMore.value = currentPage.value > 1;

    try {
      final response = await _provider.getRequests(
        page: currentPage.value,
        perPage: 15,
      );

      if (response.success) {
        if (refresh || currentPage.value == 1) {
          requestHistory.value = response.data;
        } else {
          requestHistory.addAll(response.data);
        }

        stats.value = response.stats;
        hasMorePages.value = response.meta?.hasMorePages ?? false;

        if (hasMorePages.value) {
          currentPage.value++;
        }
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Load more data for pagination
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMorePages.value) return;
    await loadRequestHistory();
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadRequestHistory(refresh: true);
  }

  /// Submit permission request
  Future<void> submitRequest() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedType.value == null) {
      Get.snackbar(
        'Error',
        'Please select a permission type',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isSubmitting.value = true;

    try {
      final response = await _provider.createRequest(
        type: selectedType.value!.value,
        reason: reasonController.text.trim(),
        fromDate: DateFormat('yyyy-MM-dd').format(fromDate.value!),
        toDate: DateFormat('yyyy-MM-dd').format(toDate.value!),
      );

      if (response.success) {
        // Add to history at the beginning
        if (response.data != null) {
          requestHistory.insert(0, response.data!);
        }

        // Update stats
        if (stats.value != null) {
          stats.value = PermissionStats(
            total: stats.value!.total + 1,
            pending: stats.value!.pending + 1,
            approved: stats.value!.approved,
            rejected: stats.value!.rejected,
          );
        }

        resetForm();

        Get.snackbar(
          'Success',
          response.message ?? 'Your request has been submitted',
          backgroundColor: const Color(0xFF5EA500).withValues(alpha: 0.1),
          colorText: const Color(0xFF5EA500),
        );
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to submit request',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit request. Please try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Cancel a pending request
  Future<void> cancelRequest(String uuid) async {
    isLoading.value = true;

    try {
      final response = await _provider.cancelRequest(uuid);

      if (response.success) {
        // Remove from list
        requestHistory.removeWhere((r) => r.uuid == uuid);

        // Update stats
        if (stats.value != null) {
          stats.value = PermissionStats(
            total: stats.value!.total - 1,
            pending: stats.value!.pending - 1,
            approved: stats.value!.approved,
            rejected: stats.value!.rejected,
          );
        }

        Get.snackbar(
          'Success',
          response.message ?? 'Request cancelled successfully',
          backgroundColor: const Color(0xFF5EA500).withValues(alpha: 0.1),
          colorText: const Color(0xFF5EA500),
        );
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to cancel request',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    selectedType.value = null;
    fromDate.value = DateTime.now();
    toDate.value = DateTime.now();
    reasonController.clear();
    reasonText.value = '';
  }

  String getTypeName(String typeValue) {
    final type = permissionTypes.firstWhereOrNull((t) => t.value == typeValue);
    return type?.label ?? typeValue;
  }
}
