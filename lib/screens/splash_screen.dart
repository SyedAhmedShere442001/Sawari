import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'home_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _timer = Timer(const Duration(milliseconds: 2100), _openApp);
  }

  void _openApp() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, _, _) => const HomeShell(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: _Bubble(size: 260, color: Colors.white.withValues(alpha: .06)),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: _Bubble(size: 220, color: Colors.white.withValues(alpha: .05)),
          ),
          Positioned(
            top: 140,
            left: -40,
            child: _Bubble(size: 120, color: AppColors.mint.withValues(alpha: .12)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 3),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final t = Curves.easeOutBack.transform(_controller.value);
                      return Opacity(
                        opacity: _controller.value.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, 26 * (1 - t)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .16),
                                blurRadius: 30,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_taxi_rounded,
                            size: 46,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Sawari',
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1.5,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Pakistan's ride, on your terms.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: .82),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 4),
                  Row(
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.mint,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Finding sawari near you…',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .8),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Divider(color: Colors.white.withValues(alpha: .15)),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: Colors.white.withValues(alpha: .7),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Made with pride in Pakistan',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .7),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'PKR',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .7),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
