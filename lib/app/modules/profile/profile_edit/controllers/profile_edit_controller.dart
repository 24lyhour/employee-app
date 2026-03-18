import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../auth/data/models/employee_model.dart';
import '../data/providers/profile_edit_provider.dart';

class ProfileEditController extends GetxController {
  final ProfileEditProvider _provider;
  ProfileEditController({required ProfileEditProvider provider})
      : _provider = provider;

  final formKey = GlobalKey<FormState>();

  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthPlaceController = TextEditingController();
  final addressController = TextEditingController();

  // Reactive state
  final employee = Rxn<EmployeeModel>();
  final selectedGender = Rxn<String>();
  final selectedDateOfBirth = Rxn<DateTime>();
  final selectedAvatarPath = Rxn<String>();
  final isLoading = false.obs;
  final isSaving = false.obs;

  final genderOptions = ['male', 'female', 'other'];

  @override
  void onInit() {
    super.onInit();
    _loadEmployee();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    birthPlaceController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void _loadEmployee() {
    final savedEmployee = StorageService.getEmployee();
    if (savedEmployee != null) {
      employee.value = EmployeeModel.fromJson(savedEmployee);
      _populateFields();
    }
  }

  void _populateFields() {
    final emp = employee.value;
    if (emp == null) return;

    firstNameController.text = emp.firstName;
    lastNameController.text = emp.lastName;
    phoneController.text = emp.phoneNumber ?? '';
    birthPlaceController.text = emp.birthPlace ?? '';
    addressController.text = emp.currentAddress ?? '';
    // Normalize gender to lowercase to match genderOptions
    selectedGender.value = emp.gender?.toLowerCase();

    if (emp.dateOfBirth != null) {
      try {
        selectedDateOfBirth.value = DateTime.parse(emp.dateOfBirth!);
      } catch (_) {}
    }
  }

  // Validators
  String? Function(String?) get validateFirstName =>
      FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'First name is required'),
        FormBuilderValidators.minLength(2,
            errorText: 'First name must be at least 2 characters'),
      ]);

  String? Function(String?) get validateLastName =>
      FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Last name is required'),
        FormBuilderValidators.minLength(2,
            errorText: 'Last name must be at least 2 characters'),
      ]);

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length < 8) {
      return 'Phone number must be at least 8 digits';
    }
    return null;
  }

  // Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();

      // Check if camera is available when camera is selected
      if (source == ImageSource.camera) {
        final hasCamera = await picker.supportsImageSource(ImageSource.camera);
        if (!hasCamera) {
          ToastHelper.showError('camera_not_available'.tr);
          return;
        }
      }

      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedAvatarPath.value = pickedFile.path;
      }
    } catch (e) {
      if (source == ImageSource.camera) {
        ToastHelper.showError('camera_not_available'.tr);
      } else {
        ToastHelper.showError('failed_to_pick_image'.tr);
      }
    }
  }

  // Select date of birth
  Future<void> selectDateOfBirth(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateOfBirth.value ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
    );

    if (picked != null) {
      selectedDateOfBirth.value = picked;
    }
  }

  String get formattedDateOfBirth {
    if (selectedDateOfBirth.value == null) return '';
    final date = selectedDateOfBirth.value!;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String get displayDateOfBirth {
    if (selectedDateOfBirth.value == null) return 'Select date';
    final date = selectedDateOfBirth.value!;
    return '${date.day}/${date.month}/${date.year}';
  }

  // Save profile
  Future<void> saveProfile() async {
    if (formKey.currentState?.validate() != true) return;

    isSaving.value = true;

    try {
      final response = await _provider.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        gender: selectedGender.value,
        dateOfBirth:
            selectedDateOfBirth.value != null ? formattedDateOfBirth : null,
        birthPlace: birthPlaceController.text.trim().isEmpty
            ? null
            : birthPlaceController.text.trim(),
        currentAddress: addressController.text.trim().isEmpty
            ? null
            : addressController.text.trim(),
        avatarPath: selectedAvatarPath.value,
      );

      if (response.success) {
        // Update local employee and storage
        if (response.employee != null) {
          employee.value = response.employee;
          StorageService.saveEmployee(response.employee!.toJson());
        }

        // Show toast
        ToastHelper.showSuccess(response.message ?? 'profile_updated'.tr);

        // Go back
        Get.back(result: true);
      } else {
        ToastHelper.showError(response.message ?? 'failed_to_update_profile'.tr);
      }
    } catch (e) {
      ToastHelper.showError('error_occurred'.tr);
    } finally {
      isSaving.value = false;
    }
  }

  String getGenderLabel(String gender) {
    switch (gender) {
      case 'male':
        return 'male'.tr;
      case 'female':
        return 'female'.tr;
      case 'other':
        return 'other'.tr;
      default:
        return gender;
    }
  }
}
