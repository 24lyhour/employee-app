import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/clock_loading_widget.dart';
import '../controllers/history_controller.dart';
import '../widgets/history_card.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('history'.tr),
      ),
      body: Column(
        children: [
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: controller.previousMonth,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      controller.formattedMonth,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    IconButton(
                      onPressed: controller.canGoNext ? controller.nextMonth : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              )),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: ClockLoadingWidget(size: 50));
              }

              if (controller.attendanceList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_attendance_records'.tr,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.attendanceList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final attendance = controller.attendanceList[index];
                  return HistoryCard(attendance: attendance);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
