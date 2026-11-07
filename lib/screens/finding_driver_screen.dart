import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data.dart';
import '../models.dart';
import '../state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'live_trip_screen.dart';

class FindingDriverScreen extends StatefulWidget {
  const FindingDriverScreen({
    super.key,
    required this.place,
    required this.service,
    required this.payment,
    required this.discount,
  });

  final Place place;
  final RideService service;
  final PaymentMethod payment;
  final int discount;

  @override
  State<FindingDriverScreen> createState() => _FindingDriverScreenState();
}

class _FindingDriverScreenState extends State<FindingDriverScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  Timer? _matchTimer;
  Driver? _driver;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _matchTimer = Timer(const Duration(milliseconds: 3400), _matchDriver);
  }

  void _matchDriver() {
    if (!mounted) return;
    final driver = _driver;
    if (driver == null) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, _, _) => LiveTripScreen(
          place: widget.place,
          service: widget.service,
          payment: widget.payment,
          driver: driver,
          discount: widget.discount,
        ),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _matchTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final city = state.city;
    final driver = _driver ??= driverFor(city, widget.service, widget.place);
    final km = widget.place.distanceKm;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Finding driver'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
          child: Column(
            children: [
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    const AvatarCircle(
                      initials: '',
                      icon: Icons.route_rounded,
                      size: 38,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${city.hub} → ${widget.place.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${km.toStringAsFixed(1)} km • ${estimateMinutes(km)} min • ${widget.service.name}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Pill(
                      label: formatPkr(
                        widget.service.fareFor(km) - widget.discount,
                      ),
                      background: AppColors.primarySoft,
                      foreground: AppColors.primaryDark,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final dimension = math.min(
                      260.0,
                      math.min(constraints.maxWidth, constraints.maxHeight),
                    );
                    return Center(
                      child: SizedBox.square(
                        dimension: dimension,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: _pulse,
                                builder: (context, child) => CustomPaint(
                                  painter: _RadarPainter(_pulse.value),
                                ),
                              ),
                            ),
                            Container(
                              width: dimension * .28,
                              height: dimension * .28,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withValues(alpha: .22),
                                    blurRadius: 28,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.local_taxi_rounded,
                                size: dimension * .13,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Text(
                'Finding your driver…',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Matching you with a nearby ${widget.service.name.toLowerCase()} in ${city.name}. '
                'This usually takes under a minute.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                child: Row(
                  children: [
                    IconBubble(
                      icon: widget.service.icon,
                      size: 36,
                      background: AppColors.primarySoft,
                      foreground: AppColors.primaryDark,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${driver.vehicle} • ${driver.plate}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.service.etaMinutes} min away',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.danger,
                ),
                child: const Text('Cancel request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2 - 4;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.primary.withValues(alpha: .1);
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, maxRadius * i / 3, ringPaint);
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * math.pi);
    final sweepRect = Rect.fromCircle(center: Offset.zero, radius: maxRadius);
    final sweep = Paint()
      ..shader = SweepGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0),
          AppColors.primary.withValues(alpha: .16),
        ],
      ).createShader(sweepRect);
    canvas.drawCircle(Offset.zero, maxRadius, sweep);
    canvas.restore();

    final pulseRadius = maxRadius * (.2 + .8 * progress);
    canvas.drawCircle(
      center,
      pulseRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.primary.withValues(alpha: (1 - progress) * .35),
    );

    for (var i = 0; i < 6; i++) {
      final angle = i * math.pi / 3 + progress * 1.1;
      final radius = maxRadius * (.44 + .1 * (i % 3));
      final point = center +
          Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      canvas.drawCircle(
        point,
        8,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        point,
        8,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.primary.withValues(alpha: .55),
      );
      canvas.drawCircle(
        point,
        2.4,
        Paint()..color = AppColors.primary,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
