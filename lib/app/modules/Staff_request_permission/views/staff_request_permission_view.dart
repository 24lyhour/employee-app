import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/staff_request_permission_controller.dart';
import '../widgets/widgets.dart';

class StaffRequestPermissionView
    extends GetView<StaffRequestPermissionController> {
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
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header Card with Stats
              _buildHeaderCard(),

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
                      _buildTypeSelector(),
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
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Obx(() {
      final stats = controller.stats.value;
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5EA500), Color(0xFF7BC62D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.assignment,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'permission_requests'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'submit_your_request'.tr,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (stats != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatItem('total'.tr, stats.total),
                  _buildStatItem('pending'.tr, stats.pending),
                  _buildStatItem('approved'.tr, stats.approved),
                  _buildStatItem('rejected'.tr, stats.rejected),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Obx(() {
      if (controller.permissionTypes.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Column(
        children: controller.permissionTypes.map((type) {
          final isSelected = controller.selectedType.value?.value == type.value;
          return TypeSelectorItem(
            type: type,
            isSelected: isSelected,
            onTap: () => controller.selectType(type),
          );
        }).toList(),
      );
    });
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _primaryColor.withValues(alpha: 0.1),
                      _primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: _primaryColor.withValues(alpha: 0.2)),
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
        maxLength: 1000,
        style: const TextStyle(fontSize: 12),
        validator: controller.validateReason,
        onChanged: controller.onReasonChanged,
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
      final isEnabled = !controller.isSubmitting.value && controller.isFormValid;
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
          onPressed: (controller.isSubmitting.value || !controller.isFormValid)
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
          child: controller.isSubmitting.value
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
      if (controller.isLoading.value && controller.requestHistory.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.requestHistory.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 12),
                Text(
                  'no_requests_yet'.tr,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
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
                typeName: controller.getTypeName(request.type),
              )),
          if (controller.hasMorePages.value)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: controller.isLoadingMore.value
                    ? const CircularProgressIndicator()
                    : TextButton(
                        onPressed: controller.loadMore,
                        child: Text('load_more'.tr),
                      ),
              ),
            ),
        ],
      );
    });
  }
}
