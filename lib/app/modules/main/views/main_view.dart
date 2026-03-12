import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
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
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              HomeView(),
              AttendanceView(),
              HistoryView(),
              ProfileView(),
            ],
          )),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _openScanner(context),
        backgroundColor: const Color(0xFF9AE600),
        foregroundColor: Colors.black,
        elevation: 4,
        child: const Icon(Icons.qr_code_scanner, size: 20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() => BottomAppBar(
            height: 60,
            padding: EdgeInsets.zero,
            shape: const CircularNotchedRectangle(),
            notchMargin: 6,
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
                const SizedBox(width: 56), // Space for FAB
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
        Get.snackbar(
          'Info',
          'You have already completed attendance for today',
          snackPosition: SnackPosition.BOTTOM,
        );
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
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
