import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data.dart';
import '../models.dart';
import '../state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/taxi_map.dart';
import 'finding_driver_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.place});

  final Place place;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  RideService _service = rideServices[2];
  String? _promoCode;

  int get _baseFare => _service.fareFor(widget.place.distanceKm);

  int get _discount => _promoCode == null
      ? 0
      : math.min(300, (_baseFare * .5).ceil());

  int get _total => _baseFare - _discount;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final city = state.city;
    final minutes = estimateMinutes(widget.place.distanceKm);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review ride'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: 196,
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: TaxiMap(progress: .04, showLabels: false),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Pill(
                            label:
                                '${widget.place.distanceKm.toStringAsFixed(1)} km  •  $minutes min',
                            icon: Icons.route_rounded,
                            background: Colors.white,
                            foreground: AppColors.ink,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: RouteIndicator(height: 68),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PICKUP',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.muted,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              city.label,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 9),
                              child: Divider(),
                            ),
                            const Text(
                              'DROP-OFF',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.muted,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.place.name}, ${widget.place.area}',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Choose a ride'),
                const SizedBox(height: 10),
                for (final service in rideServices) ...[
                  _ServiceOption(
                    service: service,
                    km: widget.place.distanceKm,
                    selected: service.id == _service.id,
                    onTap: () => setState(() => _service = service),
                  ),
                  const SizedBox(height: 9),
                ],
                const SizedBox(height: 8),
                AppCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () => _pickPayment(state),
                  child: Row(
                    children: [
                      IconBubble(
                        icon: state.payment.icon,
                        size: 42,
                        background: AppColors.bg,
                        foreground: AppColors.primaryDark,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment method',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${state.payment.name} • ${state.payment.detail}',
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
                      const Icon(
                        Icons.expand_more_rounded,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                AppCard(
                  padding: const EdgeInsets.all(14),
                  onTap: _showPromoDialog,
                  child: Row(
                    children: [
                      IconBubble(
                        icon: Icons.local_offer_rounded,
                        size: 42,
                        background: _promoCode == null
                            ? AppColors.bg
                            : AppColors.primarySoft,
                        foreground: _promoCode == null
                            ? AppColors.inkSoft
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Promo code',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _promoCode == null
                                  ? 'Tap to apply SAWARI50'
                                  : '$_promoCode applied — you save ${formatPkr(_discount)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: _promoCode == null
                                    ? AppColors.muted
                                    : AppColors.primary,
                                fontWeight: _promoCode == null
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _promoCode == null
                            ? Icons.add_rounded
                            : Icons.check_circle_rounded,
                        color: _promoCode == null
                            ? AppColors.muted
                            : AppColors.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fares include taxes. Toll and parking charges are extra.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10.5, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              formatPkr(_total),
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                                letterSpacing: -0.4,
                              ),
                            ),
                            if (_discount > 0) ...[
                              const SizedBox(width: 7),
                              Text(
                                formatPkr(_baseFare),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.muted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${_service.name} • ${state.payment.name}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 164,
                    child: FilledButton(
                      onPressed: () => _book(state),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Book ride'),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _book(AppState state) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FindingDriverScreen(
          place: widget.place,
          service: _service,
          payment: state.payment,
          discount: _discount,
        ),
      ),
    );
  }

  void _pickPayment(AppState state) {
    showSawariSheet(
      context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment method',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 3),
              const Text(
                'Choose how you want to pay for this ride',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              for (final method in paymentMethods) ...[
                _PaymentTile(
                  method: method,
                  selected: method.id == state.payment.id,
                  onTap: () {
                    state.payment = method;
                    Navigator.of(sheetContext).pop();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPromoDialog() async {
    var code = _promoCode ?? '';
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Apply promo code',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            onChanged: (value) => code = value,
            onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
            decoration: const InputDecoration(
              hintText: 'e.g. SAWARI50',
              prefixIcon: Icon(Icons.local_offer_outlined),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(code.trim()),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
    if (!mounted || result == null) return;

    if (result.toUpperCase() == 'SAWARI50') {
      setState(() => _promoCode = 'SAWARI50');
      showSnack(
        context,
        'SAWARI50 applied — 50% off this ride',
        icon: Icons.local_offer_rounded,
      );
    } else if (result.isEmpty) {
      setState(() => _promoCode = null);
    } else {
      showSnack(
        context,
        'That code is not valid. Try SAWARI50.',
        icon: Icons.error_outline_rounded,
      );
    }
  }
}

class _ServiceOption extends StatelessWidget {
  const _ServiceOption({
    required this.service,
    required this.km,
    required this.selected,
    required this.onTap,
  });

  final RideService service;
  final double km;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primarySoft : Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: .4)
                  : AppColors.line,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              IconBubble(
                icon: service.icon,
                size: 44,
                background: selected ? Colors.white : AppColors.bg,
                foreground: AppColors.primaryDark,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        if (service.popular) ...[
                          const SizedBox(width: 7),
                          const Pill(
                            label: 'Popular',
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.tagline,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 11,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            '${service.etaMinutes} min pickup • ${service.seatsLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatPkr(service.fareFor(km)),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    selected ? 'Selected' : 'Tap to select',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: selected ? AppColors.primary : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primarySoft : Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: .4)
                  : AppColors.line,
            ),
          ),
          child: Row(
            children: [
              IconBubble(
                icon: method.icon,
                size: 38,
                background: selected ? Colors.white : AppColors.bg,
                foreground: AppColors.primaryDark,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      method.detail,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? AppColors.primary : AppColors.muted,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
