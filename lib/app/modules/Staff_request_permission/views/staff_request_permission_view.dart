import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/staff_request_permission_controller.dart';
import '../data/models/permission_request_model.dart';
import '../widgets/widgets.dart';

class StaffRequestPermissionView extends GetView<StaffRequestPermissionController> {
  const StaffRequestPermissionView({super.key});

  static const _primaryColor = Color(0xFF5EA500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('request_permission'.tr),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            const PermissionHeaderCard(),

            // Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Permission Type Section
                    SectionTitle(
                      title: 'select_permission_type'.tr,
                      icon: Icons.category,
                    ),
                    const SizedBox(height: 12),
                    _buildRoleSelector(),
                    const SizedBox(height: 24),

                    // Department Section
                    SectionTitle(
                      title: 'select_department'.tr,
                      icon: Icons.business,
                    ),
                    const SizedBox(height: 12),
                    _buildDepartmentSelector(),
                    const SizedBox(height: 24),

                    // Date Range Section
                    SectionTitle(
                      title: 'select_date_range'.tr,
                      icon: Icons.calendar_month,
                    ),
                    const SizedBox(height: 12),
                    _buildDateRangeSelector(context),
                    const SizedBox(height: 24),

                    // Reason Section
                    SectionTitle(
                      title: 'reason'.tr,
                      icon: Icons.edit_note,
                    ),
                    const SizedBox(height: 12),
                    _buildReasonField(),
                    const SizedBox(height: 32),

                    // Submit Button
                    _buildSubmitButton(),
                    const SizedBox(height: 32),

                    // Request History Section
                    _buildHistorySection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Obx(() => Column(
          children: RoleOption.availableRoles.map((role) {
            final isSelected = controller.selectedRole.value?.id == role.id;
            return RoleSelectorItem(
              role: role,
              isSelected: isSelected,
              onTap: () => controller.selectRole(role),
            );
          }).toList(),
        ));
  }

  Widget _buildDepartmentSelector() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<DepartmentOption>(
            value: controller.selectedDepartment.value,
            decoration: InputDecoration(
              hintText: 'choose_department'.tr,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.apartment,
                  color: controller.selectedDepartment.value != null
                      ? _primaryColor
                      : Colors.grey.shade400,
                  size: 20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _primaryColor, width: 2),
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade600,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            items: controller.departments.map((department) {
              return DropdownMenuItem<DepartmentOption>(
                value: department,
                child: Text(_getDepartmentName(department.id)),
              );
            }).toList(),
            onChanged: controller.selectDepartment,
          ),
        ));
  }

  String _getDepartmentName(String id) {
    final Map<String, String> departmentKeys = {
      'hr': 'human_resources',
      'it': 'it_department',
      'finance': 'finance',
      'marketing': 'marketing',
      'sales': 'sales',
      'operations': 'operations',
      'engineering': 'engineering',
      'design': 'design',
      'support': 'customer_support',
      'admin': 'administration',
    };
    return (departmentKeys[id] ?? id).tr;
  }

  Widget _buildDateRangeSelector(BuildContext context) {
    return Obx(() => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DateField(
                    label: 'from_date'.tr,
                    value: controller.formattedFromDate,
                    onTap: () => controller.selectFromDate(context),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: _primaryColor,
                    size: 16,
                  ),
                ),
                Expanded(
                  child: DateField(
                    label: 'to_date'.tr,
                    value: controller.formattedToDate,
                    onTap: () => controller.selectToDate(context),
                  ),
                ),
              ],
            ),
            if (controller.totalDays > 0) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _primaryColor.withValues(alpha: 0.1),
                      _primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: _primaryColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.timelapse,
                        size: 14,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${'total_duration'.tr}: ${controller.totalDays} ${controller.totalDays > 1 ? 'days'.tr : 'day'.tr}',
                      style: const TextStyle(
                        color: _primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ));
  }

  Widget _buildReasonField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller.reasonController,
        maxLines: 3,
        style: const TextStyle(fontSize: 12),
        validator: controller.validateReason,
        decoration: InputDecoration(
          hintText: 'describe_reason'.tr,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final isEnabled = !controller.isLoading.value && controller.selectedRole.value != null;
      return Container(
          width: double.infinity,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: _primaryColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed: (controller.isLoading.value || controller.selectedRole.value == null)
                ? null
                : controller.submitRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBackgroundColor: _primaryColor.withValues(alpha: 0.6),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send_rounded, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'submit_request'.tr,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        );
    });
  }

  Widget _buildHistorySection() {
    return Obx(() {
      if (controller.requestHistory.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'request_history'.tr,
            icon: Icons.history,
          ),
          const SizedBox(height: 12),
          ...controller.requestHistory.map((request) => PermissionHistoryCard(
                request: request,
                roleName: controller.getRoleName(request.role),
              )),
        ],
      );
    });
  }
}
