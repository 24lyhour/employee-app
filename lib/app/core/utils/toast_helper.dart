import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToastHelper {
  static void showSuccess(String message) {
    _showToast(
      title: 'Success!',
      message: message,
      icon: Icons.check_rounded,
      accentColor: const Color(0xFF22C55E),
      iconBgColor: const Color(0xFFDCFCE7),
      titleColor: const Color(0xFF166534),
    );
  }

  static void showError(String message) {
    _showToast(
      title: 'Error!',
      message: message,
      icon: Icons.close_rounded,
      accentColor: const Color(0xFFEF4444),
      iconBgColor: const Color(0xFFFEE2E2),
      titleColor: const Color(0xFFB91C1C),
    );
  }

  static void showInfo(String message) {
    _showToast(
      title: 'Info',
      message: message,
      icon: Icons.info_outline_rounded,
      accentColor: const Color(0xFF3B82F6),
      iconBgColor: const Color(0xFFDBEAFE),
      titleColor: const Color(0xFF1E40AF),
    );
  }

  static void showWarning(String message) {
    _showToast(
      title: 'Warning!',
      message: message,
      icon: Icons.warning_amber_rounded,
      accentColor: const Color(0xFFF59E0B),
      iconBgColor: const Color(0xFFFEF3C7),
      titleColor: const Color(0xFFB45309),
    );
  }

  static void _showToast({
    required String title,
    required String message,
    required IconData icon,
    required Color accentColor,
    required Color iconBgColor,
    required Color titleColor,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: _AnimatedToastContent(
        title: title,
        message: message,
        icon: icon,
        accentColor: accentColor,
        iconBgColor: iconBgColor,
        titleColor: titleColor,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      borderRadius: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: EdgeInsets.zero,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 400),
    );
  }
}

class _AnimatedToastContent extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color accentColor;
  final Color iconBgColor;
  final Color titleColor;

  const _AnimatedToastContent({
    required this.title,
    required this.message,
    required this.icon,
    required this.accentColor,
    required this.iconBgColor,
    required this.titleColor,
  });

  @override
  State<_AnimatedToastContent> createState() => _AnimatedToastContentState();
}

class _AnimatedToastContentState extends State<_AnimatedToastContent>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _progressController;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();

    // Icon bounce animation
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _iconScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeOut,
    ));

    // Progress bar animation
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _iconController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
            child: Row(
              children: [
                // Icon without background
                AnimatedBuilder(
                  animation: _iconController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _iconScale.value,
                      child: Icon(
                        widget.icon,
                        color: widget.accentColor,
                        size: 28,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 14),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: widget.titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.message,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Close button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF9CA3AF),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Progress bar
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Container(
                height: 3,
                width: double.infinity,
                color: widget.iconBgColor,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 1 - _progressController.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.accentColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
