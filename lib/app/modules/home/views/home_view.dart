import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/clock_loading_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/attendance_status_card.dart';
import '../widgets/quick_stats_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: ClockLoadingWidget(size: 50));
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Text(
                  controller.greeting,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.user.value?.name ?? 'Employee',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),

                // Today's Attendance Status
                AttendanceStatusCard(
                  attendance: controller.todayAttendance.value,
                ),
                const SizedBox(height: 16),

                // Quick Stats
                Text(
                  'This Month',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                QuickStatsCard(stats: controller.stats),
              ],
            ),
          ),
        );
      }),
    );
  }
}
