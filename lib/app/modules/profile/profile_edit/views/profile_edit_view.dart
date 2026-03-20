import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/clock_loading_widget.dart';
import '../controllers/profile_edit_controller.dart';

class ProfileEditView extends GetView<ProfileEditController> {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('edit_profile'.tr),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: ClockLoadingWidget(size: 50));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Section
                _buildAvatarSection(context),
                const SizedBox(height: 24),

                // Personal Information Card
                _buildSectionCard(
                  title: 'personal_information'.tr,
                  icon: Icons.person_outline,
                  children: [
                    _buildTextField(
                      controller: controller.firstNameController,
                      label: 'first_name'.tr,
                      hint: 'enter_first_name'.tr,
                      validator: controller.validateFirstName,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.lastNameController,
                      label: 'last_name'.tr,
                      hint: 'enter_last_name'.tr,
                      validator: controller.validateLastName,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildGenderDisplay(),
                    const SizedBox(height: 16),
                    _buildDateOfBirthDisplay(),
                  ],
                ),
                const SizedBox(height: 16),

                // Contact Information Card
                _buildSectionCard(
                  title: 'contact_information'.tr,
                  icon: Icons.contact_phone_outlined,
                  children: [
                    _buildTextField(
                      controller: controller.phoneController,
                      label: 'phone_number'.tr,
                      hint: 'enter_phone_number'.tr,
                      validator: controller.validatePhone,
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Address Information Card
                _buildSectionCard(
                  title: 'address_information'.tr,
                  icon: Icons.location_on_outlined,
                  children: [
                    _buildTextField(
                      controller: controller.birthPlaceController,
                      label: 'birth_place'.tr,
                      hint: 'enter_birth_place'.tr,
                      prefixIcon: Icons.place,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.addressController,
                      label: 'current_address'.tr,
                      hint: 'enter_current_address'.tr,
                      prefixIcon: Icons.home,
                      maxLines: 2,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Save Button
                _buildSaveButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Obx(() {
            final avatarPath = controller.selectedAvatarPath.value;
            final avatarUrl = controller.employee.value?.avatarUrl;

            return Stack(
              children: [
                // Show selected local file or cached network image
                if (avatarPath != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.disabled,
                    backgroundImage: FileImage(File(avatarPath)),
                  )
                else if (avatarUrl != null && avatarUrl.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: avatarUrl,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.disabled,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.disabled,
                      child: const ClockLoadingWidget(size: 24),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.disabled,
                      child: const Icon(Icons.person,
                          size: 50, color: AppColors.iconSecondary),
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.disabled,
                    child: const Icon(Icons.person,
                        size: 50, color: AppColors.iconSecondary),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _showImagePickerOptions(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 8),
          Text(
            'tap_to_change_photo'.tr,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.camera_alt, color: AppColors.iconPrimary),
                title: Text('camera'.tr),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library,
                    color: AppColors.iconPrimary),
                title: Text('gallery'.tr),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppColors.textTertiary, fontSize: 14),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: AppColors.iconSecondary)
                : null,
            filled: true,
            fillColor: AppColors.surfaceVariant,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'gender'.tr,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.disabled,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 20, color: AppColors.iconSecondary),
                  const SizedBox(width: 12),
                  Text(
                    controller.selectedGender.value != null
                        ? controller
                            .getGenderLabel(controller.selectedGender.value!)
                        : '-',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.disabledText,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildDateOfBirthDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'date_of_birth'.tr,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.disabled,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 20, color: AppColors.iconSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      controller.displayDateOfBirth,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.disabledText,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Obx(() {
      final isSaving = controller.isSaving.value;
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: isSaving ? null : controller.saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          ),
          child: isSaving
              ? const ClockLoadingWidget(size: 20, color: AppColors.surface)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'save_changes'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
