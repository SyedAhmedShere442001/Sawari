import 'package:flutter/material.dart';

import '../models.dart';
import '../state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({
    super.key,
    required this.place,
    required this.service,
    required this.payment,
    required this.driver,
    required this.discount,
  });

  final Place place;
  final RideService service;
  final PaymentMethod payment;
  final Driver driver;
  final int discount;

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final String _tripId =
      'SW-${DateTime.now().millisecondsSinceEpoch % 100000}';
  int _rating = 5;
  int _tip = 0;

  static const _ratingLabels = [
    'Not great',
    'Could be better',
    'Okay',
    'Good ride',
    'Excellent!',
  ];

  int get _fare => widget.service.fareFor(widget.place.distanceKm);

  int get _total => _fare - widget.discount;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final city = state.city;
    final km = widget.place.distanceKm;
    final totalPaid = _total + _tip;
    final distanceFare = _fare - widget.service.baseFare;
    final firstName = widget.driver.name.split(' ').first;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutBack,
                builder: (context, value, child) => Transform.scale(
                  scale: .6 + .4 * value,
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  ),
                ),
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 66,
                      height: 66,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Trip completed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  letterSpacing: -0.6,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                'You arrived at ${widget.place.name}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.muted,
                ),
              ),
            ),
            const SizedBox(height: 22),
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconBubble(
                        icon: widget.service.icon,
                        size: 44,
                        background: AppColors.primarySoft,
                        foreground: AppColors.primaryDark,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.service.name} ride',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${city.hub} → ${widget.place.area}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Pill(
                        label: _tripId,
                        background: AppColors.bg,
                        foreground: AppColors.inkSoft,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(),
                  ),
                  _FareRow(
                    label: 'Base fare',
                    value: formatPkr(widget.service.baseFare),
                  ),
                  const SizedBox(height: 10),
                  _FareRow(
                    label:
                        'Distance • ${km.toStringAsFixed(1)} km • ${estimateMinutes(km)} min',
                    value: formatPkr(distanceFare),
                  ),
                  if (widget.discount > 0) ...[
                    const SizedBox(height: 10),
                    _FareRow(
                      label: 'Promo SAWARI50',
                      value: '- ${formatPkr(widget.discount)}',
                      accent: AppColors.primary,
                    ),
                  ],
                  if (_tip > 0) ...[
                    const SizedBox(height: 10),
                    _FareRow(
                      label: 'Tip for $firstName',
                      value: '+ ${formatPkr(_tip)}',
                      accent: AppColors.primary,
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Total paid',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formatPkr(totalPaid),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.payment.icon,
                          size: 16,
                          color: AppColors.inkSoft,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Paid via ${widget.payment.name} • ${widget.payment.detail}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkSoft,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      AvatarCircle(
                        initials: widget.driver.initials,
                        size: 42,
                        background: AppColors.primarySoft,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How was your ride with $firstName?',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Your feedback keeps Sawari safe.',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  RatingStars(
                    value: _rating,
                    size: 36,
                    onChanged: (value) => setState(() => _rating = value),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _ratingLabels[_rating - 1],
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add a tip',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '100% of your tip goes to your driver.',
                      style: TextStyle(fontSize: 11, color: AppColors.muted),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tip in const [0, 50, 100, 200])
                        _TipChip(
                          label: tip == 0 ? 'No tip' : 'Rs $tip',
                          selected: _tip == tip,
                          onTap: () => setState(() => _tip = tip),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _finish(context, totalPaid),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => showSnack(
                  context,
                  'Support will reach out about $_tripId shortly.',
                  icon: Icons.support_agent_rounded,
                ),
                child: const Text('Need help with this trip?'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _finish(BuildContext context, int totalPaid) {
    final state = AppScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final city = state.city;
    final km = widget.place.distanceKm;

    state.addTrip(
      TripRecord(
        id: _tripId,
        from: city.hub,
        to: widget.place.name,
        cityName: city.name,
        service: widget.service,
        payment: widget.payment,
        driverName: widget.driver.name,
        fare: totalPaid,
        km: km,
        minutes: estimateMinutes(km),
        when: DateTime.now(),
        rating: _rating,
      ),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          _tip > 0
              ? 'Trip saved. Your ${formatPkr(_tip)} tip was sent. Shukriya!'
              : 'Trip saved. Thank you for riding with Sawari!',
        ),
      ),
    );
  }
}

class _FareRow extends StatelessWidget {
  const _FareRow({
    required this.label,
    required this.value,
    this.accent,
  });

  final String label;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: AppColors.inkSoft),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: accent ?? AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _TipChip extends StatelessWidget {
  const _TipChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primarySoft : AppColors.bg,
      borderRadius: BorderRadius.circular(100),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: .4)
                  : AppColors.line,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.primaryDark : AppColors.inkSoft,
            ),
          ),
        ),
      ),
    );
  }
}
