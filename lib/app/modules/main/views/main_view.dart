import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/toast_helper.dart';
import '../../home/views/home_view.dart';
import '../../attendance/views/attendance_view.dart';
import '../../history/views/history_view.dart';
import '../../profile/views/profile_view.dart';
import '../../scanner/views/camera_scanner_view.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              HomeView(),
              AttendanceView(),
              HistoryView(),
              ProfileView(),
            ],
          )),
      bottomNavigationBar: Obx(() => Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FFF0),
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: AppStrings.home,
                    isSelected: controller.currentIndex.value == 0,
                    onTap: () => controller.changePage(0),
                  ),
                  _NavItem(
                    icon: Icons.fingerprint_outlined,
                    selectedIcon: Icons.fingerprint,
                    label: AppStrings.attendance,
                    isSelected: controller.currentIndex.value == 1,
                    onTap: () => controller.changePage(1),
                  ),
                  // Center scan button
                  _ScanButton(onTap: () => _openScanner(context)),
                  _NavItem(
                    icon: Icons.history_outlined,
                    selectedIcon: Icons.history,
                    label: AppStrings.history,
                    isSelected: controller.currentIndex.value == 2,
                    onTap: () => controller.changePage(2),
                  ),
                  _NavItem(
                    icon: Icons.person_outlined,
                    selectedIcon: Icons.person,
                    label: AppStrings.profile,
                    isSelected: controller.currentIndex.value == 3,
                    onTap: () => controller.changePage(3),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _openScanner(BuildContext context) async {
    final result = await Get.to<String>(() => const CameraScannerView());

    if (result != null) {
      final attendanceController = Get.find<AttendanceController>();
      if (attendanceController.canCheckIn) {
        attendanceController.checkInWithQR(result);
      } else if (attendanceController.canCheckOut) {
        attendanceController.checkOutWithQR(result);
      } else {
        ToastHelper.showInfo('You have already completed attendance for today');
      }
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF5EA500);
    final unselectedColor = const Color(0xFF6B7280);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: primaryColor.withValues(alpha: 0.2),
        highlightColor: primaryColor.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? primaryColor : unselectedColor,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? primaryColor : unselectedColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ScanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF5EA500),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5EA500).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
