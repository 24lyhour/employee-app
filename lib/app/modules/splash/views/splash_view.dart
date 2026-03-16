import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/clock_loading_widget.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF0FDF4),
              Color(0xFFDCFCE7),
            ],
          ),
        ),
        child: const SafeArea(
          child: _AnimatedSplashContent(),
        ),
      ),
    );
  }
}

class _AnimatedSplashContent extends StatefulWidget {
  const _AnimatedSplashContent();

  @override
  State<_AnimatedSplashContent> createState() => _AnimatedSplashContentState();
}

class _AnimatedSplashContentState extends State<_AnimatedSplashContent>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _taglineOpacity;
  late Animation<double> _loadingOpacity;
  late Animation<double> _footerOpacity;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Pulse animation controller (continuous)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo animations
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Title animations
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    // Tagline animations
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Loading animation
    _loadingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: Curves.easeOut,
      ),
    );

    // Footer animation
    _footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Pulse animation (continuous)
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.15, end: 0.35).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations in sequence
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _loadingController.forward();

    // Start continuous pulse animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 3),

        // Animated Logo
        AnimatedBuilder(
          animation: Listenable.merge([_logoController, _pulseController]),
          builder: (context, child) {
            return Opacity(
              opacity: _logoOpacity.value,
              child: Transform.scale(
                scale: _logoScale.value * _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: _glowAnimation.value),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 110,
                    height: 110,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 40),

        // Animated Title
        AnimatedBuilder(
          animation: _textController,
          builder: (context, child) {
            return SlideTransition(
              position: _titleSlide,
              child: Opacity(
                opacity: _titleOpacity.value,
                child: Text(
                  AppStrings.appName,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 1.5,
                      ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // Animated Tagline
        AnimatedBuilder(
          animation: _textController,
          builder: (context, child) {
            return SlideTransition(
              position: _taglineSlide,
              child: Opacity(
                opacity: _taglineOpacity.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AnimatedLine(animation: _taglineOpacity),
                    const SizedBox(width: 12),
                    Text(
                      'attendance_made_easy'.tr,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(width: 12),
                    _AnimatedLine(animation: _taglineOpacity),
                  ],
                ),
              ),
            );
          },
        ),

        const Spacer(flex: 3),

        // Animated Loading
        AnimatedBuilder(
          animation: _loadingController,
          builder: (context, child) {
            return Opacity(
              opacity: _loadingOpacity.value,
              child: Column(
                children: [
                  const ClockLoadingWidget(size: 50),
                  const SizedBox(height: 20),
                  Text(
                    'please_wait'.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            );
          },
        ),

        const Spacer(flex: 2),

        // Animated Footer
        AnimatedBuilder(
          animation: _loadingController,
          builder: (context, child) {
            return Opacity(
              opacity: _footerOpacity.value,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    Text(
                      'powered_by'.tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'your_company'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Animated decorative line
class _AnimatedLine extends StatelessWidget {
  final Animation<double> animation;

  const _AnimatedLine({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 30 * animation.value,
          height: 2,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      },
    );
  }
}
