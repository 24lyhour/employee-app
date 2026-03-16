import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  static const _primaryColor = Color(0xFF5EA500);
  static const _presentColor = Color(0xFF22C55E);
  static const _absentColor = Color(0xFFEF4444);
  static const _lateColor = Color(0xFFF59E0B);
  static const _leaveColor = Color(0xFF8B5CF6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('My Dashboard'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _primaryColor),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: _primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User greeting card
                _buildUserGreetingCard(),
                const SizedBox(height: 16),

                // Today's attendance status
                _buildTodayAttendanceCard(),
                const SizedBox(height: 16),

                // Filter chips
                _buildFilterChips(),
                const SizedBox(height: 16),

                // Monthly stats cards
                _buildMonthlyStatsCards(),
                const SizedBox(height: 24),

                // Attendance Pie Chart
                _buildAttendancePieChart(),
                const SizedBox(height: 24),

                // Work Hours Summary
                _buildWorkHoursSummary(),
                const SizedBox(height: 24),

                // Weekly Status
                _buildWeeklyStatusCard(),
                const SizedBox(height: 24),

                // Attendance History
                _buildAttendanceHistory(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUserGreetingCard() {
    return Obx(() {
      final user = controller.user.value;
      final now = DateTime.now();
      String greeting;
      if (now.hour < 12) {
        greeting = 'Good Morning';
      } else if (now.hour < 17) {
        greeting = 'Good Afternoon';
      } else {
        greeting = 'Good Evening';
      }

      return Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting,',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.name ?? 'Employee',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.department ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Text(
                user?.name.isNotEmpty == true
                    ? user!.name[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTodayAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final attendance = controller.todayAttendance.value;
        final isCheckedIn = controller.isCheckedIn;
        final isCheckedOut = controller.isCheckedOut;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Attendance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCheckedIn
                        ? _presentColor.withValues(alpha: 0.1)
                        : _absentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isCheckedIn
                        ? (isCheckedOut ? 'Completed' : 'Working')
                        : 'Not Checked In',
                    style: TextStyle(
                      color: isCheckedIn ? _presentColor : _absentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _TimeCard(
                    icon: Icons.login,
                    label: 'Check In',
                    time: controller.todayCheckInTime,
                    color: _presentColor,
                    isActive: isCheckedIn,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimeCard(
                    icon: Icons.logout,
                    label: 'Check Out',
                    time: controller.todayCheckOutTime,
                    color: _lateColor,
                    isActive: isCheckedOut,
                  ),
                ),
              ],
            ),
            if (attendance != null && attendance.workDuration != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer, color: _primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Work Duration: ${attendance.workDurationFormatted}',
                      style: const TextStyle(
                        color: _primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() => Row(
            children: controller.filterOptions.map((filter) {
              final isSelected = controller.selectedFilter.value == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (_) => controller.setFilter(filter),
                  selectedColor: _primaryColor.withValues(alpha: 0.2),
                  checkmarkColor: _primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? _primaryColor : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }

  Widget _buildMonthlyStatsCards() {
    return Obx(() => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Days',
                    value: '${controller.totalWorkDays.value}',
                    icon: Icons.calendar_today,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Present',
                    value: '${controller.presentDays.value}',
                    icon: Icons.check_circle,
                    color: _presentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Late',
                    value: '${controller.lateDays.value}',
                    icon: Icons.schedule,
                    color: _lateColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Absent',
                    value: '${controller.absentDays.value}',
                    icon: Icons.cancel,
                    color: _absentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Leave',
                    value: '${controller.leaveDays.value}',
                    icon: Icons.event_busy,
                    color: _leaveColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Attendance',
                    value: '${controller.attendancePercentage.value.toStringAsFixed(1)}%',
                    icon: Icons.percent,
                    color: controller.attendancePercentage.value >= 90
                        ? _presentColor
                        : controller.attendancePercentage.value >= 70
                            ? _lateColor
                            : _absentColor,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildAttendancePieChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attendance Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Obx(() {
              final present = controller.presentDays.value.toDouble();
              final late = controller.lateDays.value.toDouble();
              final absent = controller.absentDays.value.toDouble();
              final leave = controller.leaveDays.value.toDouble();

              if (present + late + absent + leave == 0) {
                return const Center(
                  child: Text(
                    'No attendance data',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          if (present > 0)
                            PieChartSectionData(
                              value: present,
                              title:
                                  '${controller.attendancePercentage.value.toStringAsFixed(0)}%',
                              color: _presentColor,
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          if (late > 0)
                            PieChartSectionData(
                              value: late,
                              title: '',
                              color: _lateColor,
                              radius: 45,
                            ),
                          if (absent > 0)
                            PieChartSectionData(
                              value: absent,
                              title: '',
                              color: _absentColor,
                              radius: 45,
                            ),
                          if (leave > 0)
                            PieChartSectionData(
                              value: leave,
                              title: '',
                              color: _leaveColor,
                              radius: 45,
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendItem(
                          color: _presentColor,
                          label: 'Present',
                          value: controller.presentDays.value,
                        ),
                        const SizedBox(height: 8),
                        _LegendItem(
                          color: _lateColor,
                          label: 'Late',
                          value: controller.lateDays.value,
                        ),
                        const SizedBox(height: 8),
                        _LegendItem(
                          color: _absentColor,
                          label: 'Absent',
                          value: controller.absentDays.value,
                        ),
                        const SizedBox(height: 8),
                        _LegendItem(
                          color: _leaveColor,
                          label: 'Leave',
                          value: controller.leaveDays.value,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkHoursSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Work Hours Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Row(
                children: [
                  Expanded(
                    child: _WorkHoursCard(
                      icon: Icons.access_time_filled,
                      label: 'Total Hours',
                      value: controller.formattedTotalHours,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _WorkHoursCard(
                      icon: Icons.trending_up,
                      label: 'Daily Average',
                      value: controller.formattedAverageHours,
                      color: _presentColor,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: controller.weeklyStatus.map((dayStatus) {
                  final isToday = dayStatus.date.day == DateTime.now().day &&
                      dayStatus.date.month == DateTime.now().month;
                  return _WeekDayWidget(
                    dayStatus: dayStatus,
                    isToday: isToday,
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _SmallLegendItem(
                  color: _presentColor, label: 'Present'),
              _SmallLegendItem(color: _lateColor, label: 'Late'),
              _SmallLegendItem(color: _absentColor, label: 'Absent'),
              _SmallLegendItem(color: _leaveColor, label: 'Leave'),
              _SmallLegendItem(
                  color: const Color(0xFF9CA3AF), label: 'Weekend'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Attendance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final history = controller.attendanceHistory.take(7).toList();
            if (history.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No attendance history',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
            return Column(
              children: history
                  .map((attendance) => _AttendanceHistoryTile(
                        attendance: attendance,
                      ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color color;
  final bool isActive;

  const _TimeCard({
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? color.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? color.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? color : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              color: isActive ? color : Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int? value;

  const _LegendItem({
    required this.color,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value != null ? '$label ($value)' : label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

class _SmallLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _SmallLegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _WorkHoursCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _WorkHoursCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekDayWidget extends StatelessWidget {
  final WeekDayStatus dayStatus;
  final bool isToday;

  const _WeekDayWidget({
    required this.dayStatus,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          dayStatus.day,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? const Color(0xFF5EA500) : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: dayStatus.color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: const Color(0xFF5EA500), width: 2)
                : null,
          ),
          child: Icon(
            dayStatus.icon,
            color: dayStatus.color,
            size: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dayStatus.date.day.toString(),
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _AttendanceHistoryTile extends StatelessWidget {
  final dynamic attendance;

  const _AttendanceHistoryTile({required this.attendance});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d');
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (attendance.status.toString().split('.').last) {
      case 'present':
        statusColor = const Color(0xFF22C55E);
        statusIcon = Icons.check_circle;
        statusText = 'Present';
        break;
      case 'late':
        statusColor = const Color(0xFFF59E0B);
        statusIcon = Icons.schedule;
        statusText = 'Late';
        break;
      case 'absent':
        statusColor = const Color(0xFFEF4444);
        statusIcon = Icons.cancel;
        statusText = 'Absent';
        break;
      case 'leave':
        statusColor = const Color(0xFF8B5CF6);
        statusIcon = Icons.event_busy;
        statusText = 'Leave';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Unknown';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(attendance.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${attendance.checkInTimeFormatted}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      ' - ',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    Text(
                      '${attendance.checkOutTimeFormatted}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
