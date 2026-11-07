import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SawariApp());
}

class SawariApp extends StatefulWidget {
  const SawariApp({super.key});

  @override
  State<SawariApp> createState() => _SawariAppState();
}

class _SawariAppState extends State<SawariApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: "Sawari — Pakistan's Taxi App",
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        builder: (context, child) => _DesktopFrame(
          child: child ?? const SizedBox.shrink(),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

/// Keeps the phone-first layout comfortable when the app runs in a wide
/// browser window or on Windows.
class _DesktopFrame extends StatelessWidget {
  const _DesktopFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) return child;
        final height = (constraints.maxHeight - 44).clamp(360.0, 920.0);
        return ColoredBox(
          color: const Color(0xFFE1E8DD),
          child: Center(
            child: Container(
              width: 432,
              height: height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3313261D),
                    blurRadius: 60,
                    offset: Offset(0, 24),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
