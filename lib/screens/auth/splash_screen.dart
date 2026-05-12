import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../theme/app_theme.dart';
import '../../routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _mainController.forward();

    // Navigate to login after 3 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        context.go(AppRouter.login);
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: _buildBlob(AppColors.primary.withAlpha(40), 300),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildBlob(AppColors.primaryAccent.withAlpha(30), 250),
          ),

          // Glassmorphism overlay for background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Main Content
          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 140,
                              height: 140,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha(
                                      (40 + (20 * _pulseController.value))
                                          .toInt(),
                                    ),
                                    blurRadius:
                                        40 + (20 * _pulseController.value),
                                    spreadRadius: 5 * _pulseController.value,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                                border: Border.all(
                                  color: AppColors.primary.withAlpha(30),
                                  width: 1,
                                ),
                              ),
                              child: Image.asset(
                                'assets/logo/logo.png',
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),

                      // App Name with slide animation
                      Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Column(
                          children: [
                            Text(
                              'MEDY24',
                              style: AppTextStyles.header.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 40,
                                letterSpacing: 8,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(20),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'SUPER ADMIN PANEL',
                                style: AppTextStyles.tagline.copyWith(
                                  fontSize: 12,
                                  letterSpacing: 2,
                                  color: AppColors.primaryAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),

                      // Minimal Loading Indicator
                      _buildLoader(),
                    ],
                  ),
                );
              },
            ),
          ),

          // Version info at bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'POWERED BY MEDY24 INTELLIGENCE',
                  style: AppTextStyles.caption.copyWith(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildLoader() {
    return SizedBox(
      width: 50,
      child: LinearProgressIndicator(
        backgroundColor: AppColors.primary.withAlpha(20),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        borderRadius: BorderRadius.circular(10),
        minHeight: 3,
      ),
    );
  }
}
