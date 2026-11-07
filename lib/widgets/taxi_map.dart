import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A stylised, custom-painted city map. It needs no API keys or network, which
/// keeps the demo running anywhere — from a phone in Lahore to Chrome on a
/// laptop.
class TaxiMap extends StatelessWidget {
  const TaxiMap({
    super.key,
    this.progress = 0,
    this.showMarkers = true,
    this.showCar = false,
    this.showLabels = true,
  });

  final double progress;
  final bool showMarkers;
  final bool showCar;
  final bool showLabels;

  static List<Offset> routePoints(Size size) {
    return [
      Offset(size.width * .16, size.height * .84),
      Offset(size.width * .31, size.height * .68),
      Offset(size.width * .48, size.height * .74),
      Offset(size.width * .57, size.height * .55),
      Offset(size.width * .74, size.height * .50),
      Offset(size.width * .82, size.height * .33),
      Offset(size.width * .79, size.height * .17),
    ];
  }

  static Offset pointAlongPolyline(List<Offset> points, double t) {
    if (points.length < 2) return points.first;
    final lengths = <double>[];
    var total = 0.0;
    for (var i = 0; i < points.length - 1; i++) {
      final length = (points[i + 1] - points[i]).distance;
      lengths.add(length);
      total += length;
    }
    var target = total * t.clamp(0.0, 1.0);
    for (var i = 0; i < lengths.length; i++) {
      if (target <= lengths[i] || i == lengths.length - 1) {
        final ratio = lengths[i] == 0 ? 0.0 : target / lengths[i];
        return Offset.lerp(points[i], points[i + 1], ratio.clamp(0.0, 1.0))!;
      }
      target -= lengths[i];
    }
    return points.last;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 400,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 220,
        );
        final points = routePoints(size);
        final car = pointAlongPolyline(points, progress);

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _CityMapPainter(
                  progress: progress,
                  showLabels: showLabels,
                ),
              ),
            ),
            if (showMarkers) ...[
              Positioned(
                left: points.first.dx - 17,
                top: points.first.dy - 17,
                child: const _PickupMarker(),
              ),
              Positioned(
                left: points.last.dx - 17,
                top: points.last.dy - 34,
                child: const _DestinationMarker(),
              ),
            ],
            if (showCar)
              Positioned(
                left: car.dx - 18,
                top: car.dy - 18,
                child: const _CarMarker(),
              ),
          ],
        );
      },
    );
  }
}

class _PickupMarker extends StatelessWidget {
  const _PickupMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: .18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.primary, width: 3),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _DestinationMarker extends StatelessWidget {
  const _DestinationMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.flag_rounded,
            size: 17,
            color: Colors.white,
          ),
        ),
        Container(
          width: 3,
          height: 5,
          color: AppColors.primary.withValues(alpha: .35),
        ),
      ],
    );
  }
}

class _CarMarker extends StatelessWidget {
  const _CarMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: .18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.local_taxi_rounded,
        size: 19,
        color: AppColors.primary,
      ),
    );
  }
}

class _CityMapPainter extends CustomPainter {
  _CityMapPainter({required this.progress, required this.showLabels});

  final double progress;
  final bool showLabels;

  static final _random = math.Random(11);

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);
    _paintBlocks(canvas, size);
    _paintPark(canvas, size);
    _paintRiver(canvas, size);
    _paintRoads(canvas, size);
    if (showLabels) _paintLabels(canvas, size);
    _paintRoute(canvas, size);
  }

  void _paintBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF0F4EC), Color(0xFFE8EFE4)],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _paintBlocks(Canvas canvas, Size size) {
    final rand = math.Random(_random.nextInt(1000));
    final fills = [
      const Color(0xFFE4ECDE),
      const Color(0xFFE9F0E4),
      const Color(0xFFDFE9D9),
      const Color(0xFFEDF2E8),
    ];
    for (var i = 0; i < 48; i++) {
      final w = size.width * (0.05 + rand.nextDouble() * 0.11);
      final h = size.height * (0.05 + rand.nextDouble() * 0.11);
      final left = size.width * (0.02 + rand.nextDouble() * 0.9);
      final top = size.height * (0.03 + rand.nextDouble() * 0.9);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, w, h),
        const Radius.circular(5),
      );
      canvas.drawRRect(rect, Paint()..color = fills[i % fills.length]);

      if (i % 3 == 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              left + w * .18,
              top + h * .2,
              w * .55,
              h * .45,
            ),
            const Radius.circular(3),
          ),
          Paint()..color = const Color(0xFFD8E4D2),
        );
      }
    }
  }

  void _paintPark(Canvas canvas, Size size) {
    final park = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .03,
        size.height * .1,
        size.width * .2,
        size.height * .2,
      ),
      const Radius.circular(18),
    );
    canvas.drawRRect(park, Paint()..color = const Color(0xFFCDE6C4));
    final tree = Paint()..color = const Color(0xFFB4D8A8);
    for (var i = 0; i < 6; i++) {
      canvas.drawCircle(
        Offset(
          size.width * (.06 + (i % 3) * .055),
          size.height * (.14 + (i ~/ 3) * .07),
        ),
        size.width * .013,
        tree,
      );
    }
  }

  void _paintRiver(Canvas canvas, Size size) {
    final river = Path()
      ..moveTo(size.width * .92, -10)
      ..cubicTo(
        size.width * .86,
        size.height * .3,
        size.width * 1.02,
        size.height * .45,
        size.width * .94,
        size.height * .7,
      )
      ..cubicTo(
        size.width * .9,
        size.height * .86,
        size.width * .97,
        size.height * .94,
        size.width * .93,
        size.height + 10,
      );
    canvas.drawPath(
      river,
      Paint()
        ..color = const Color(0xFFD5E8F0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      river,
      Paint()
        ..color = const Color(0xFFE4F1F6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintRoads(Canvas canvas, Size size) {
    final casings = Paint()
      ..color = const Color(0xFFDCE6D7)
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;

    final horizontals = <double>[.2, .44, .62, .85];
    for (final y in horizontals) {
      final dy = size.height * y;
      canvas.drawLine(Offset(-10, dy), Offset(size.width + 10, dy), casings);
      canvas.drawLine(Offset(-10, dy), Offset(size.width + 10, dy), road);
    }

    final verticals = <double>[.1, .33, .52, .71, .89];
    for (final x in verticals) {
      final dx = size.width * x;
      canvas.drawLine(Offset(dx, -10), Offset(dx, size.height + 10), casings);
      canvas.drawLine(Offset(dx, -10), Offset(dx, size.height + 10), road);
    }

    final lanePaint = Paint()
      ..color = const Color(0xFFEFF3EC)
      ..strokeWidth = 1.4;
    for (final y in horizontals) {
      final dy = size.height * y;
      var x = 6.0;
      while (x < size.width) {
        canvas.drawLine(Offset(x, dy), Offset(x + 10, dy), lanePaint);
        x += 22;
      }
    }
  }

  void _paintLabels(Canvas canvas, Size size) {
    _paintLabel(
      canvas,
      'Mall Road',
      Offset(size.width * .35, size.height * .44 - 14),
      angle: 0,
    );
    _paintLabel(
      canvas,
      'Main Boulevard',
      Offset(size.width * .52 + 10, size.height * .74),
      angle: -math.pi / 2,
    );
    _paintLabel(
      canvas,
      'Canal Road',
      Offset(size.width * .7, size.height * .85 - 14),
      angle: 0,
    );
  }

  void _paintLabel(
    Canvas canvas,
    String text,
    Offset offset, {
    required double angle,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF92A398),
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
          letterSpacing: .4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(angle);
    painter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  void _paintRoute(Canvas canvas, Size size) {
    final points = TaxiMap.routePoints(size);
    final path = _smoothPath(points);

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: .95)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final traveledLength = metric.length * progress.clamp(0.0, 1.0);

    if (traveledLength < metric.length - 1) {
      final remaining = metric.extractPath(traveledLength, metric.length);
      _drawDashedPath(
        canvas,
        remaining,
        Paint()
          ..color = AppColors.primary.withValues(alpha: .42)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.2
          ..strokeCap = StrokeCap.round,
      );
    }

    if (traveledLength > 0) {
      final traveled = metric.extractPath(0, traveledLength);
      canvas.drawPath(
        traveled,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  Path _smoothPath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = i == 0 ? points[0] : points[i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i + 2 < points.length ? points[i + 2] : p2;

      final cp1 = p1 + (p2 - p0) / 6;
      final cp2 = p2 - (p3 - p1) / 6;
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dash = 8.0;
    const gap = 6.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CityMapPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showLabels != showLabels;
  }
}
