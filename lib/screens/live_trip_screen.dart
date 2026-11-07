import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/taxi_map.dart';
import 'receipt_screen.dart';

class LiveTripScreen extends StatefulWidget {
  const LiveTripScreen({
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
  State<LiveTripScreen> createState() => _LiveTripScreenState();
}

class _LiveTripScreenState extends State<LiveTripScreen> {
  int _stage = 0;
  Timer? _timer;

  static const _progressByStage = [.12, .2, .55, .9];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_stage >= 3) {
        timer.cancel();
        _completeTrip();
        return;
      }
      setState(() => _stage++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _completeTrip() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ReceiptScreen(
          place: widget.place,
          service: widget.service,
          payment: widget.payment,
          driver: widget.driver,
          discount: widget.discount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final city = AppScope.of(context).city;
    final km = widget.place.distanceKm;
    final minutes = estimateMinutes(km);
    final total = widget.service.fareFor(km) - widget.discount;
    final etaLabels = [
      '${widget.service.etaMinutes} min',
      'Arrived',
      '$minutes min',
      '2 min',
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(28),
            ),
            child: SizedBox(
              height: 268,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: .04,
                        end: _progressByStage[_stage],
                      ),
                      duration: const Duration(milliseconds: 1400),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) =>
                          TaxiMap(progress: value, showCar: true),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          _MapCircleButton(
                            icon: Icons.close_rounded,
                            onTap: _confirmCancel,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1413261D),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.near_me_rounded,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _stage == 0 ? 'Driver arriving' : etaLabels[_stage],
                                  style: const TextStyle(
                                    fontSize: 12,
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
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              children: [
                _StatusCard(
                  stage: _stage,
                  pin: '4821',
                  title: _stageTitle(minutes),
                  subtitle: _stageSubtitle(city, minutes),
                  progress: _progressByStage[_stage],
                ),
                const SizedBox(height: 12),
                _DriverCard(
                  driver: widget.driver,
                  service: widget.service,
                ),
                const SizedBox(height: 12),
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      _QuickAction(
                        icon: Icons.call_rounded,
                        label: 'Call',
                        onTap: _callDriver,
                      ),
                      _QuickAction(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: 'Message',
                        onTap: _messageDriver,
                      ),
                      _QuickAction(
                        icon: Icons.share_rounded,
                        label: 'Share',
                        onTap: _shareTrip,
                      ),
                      _QuickAction(
                        icon: Icons.shield_outlined,
                        label: 'Safety',
                        onTap: _showSafety,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      IconBubble(
                        icon: widget.service.icon,
                        size: 40,
                        background: AppColors.primarySoft,
                        foreground: AppColors.primaryDark,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.service.name} to ${widget.place.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${km.toStringAsFixed(1)} km • $minutes min • ${widget.payment.name}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatPkr(total),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: TextButton(
                    onPressed: _confirmCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.danger,
                    ),
                    child: const Text('Cancel ride'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _stageTitle(int minutes) {
    return switch (_stage) {
      0 => 'Driver is on the way',
      1 => 'Your driver has arrived',
      2 => 'On the way to ${widget.place.name}',
      _ => 'Almost there',
    };
  }

  String _stageSubtitle(City city, int minutes) {
    final firstName = widget.driver.name.split(' ').first;
    return switch (_stage) {
      0 => '$firstName is heading to ${city.hub} right now.',
      1 => 'Meet $firstName at ${city.hub} and share PIN 4821.',
      2 => 'Sit back and relax. ETA ${(minutes - 6).clamp(1, 99)} minutes.',
      _ => 'You will reach ${widget.place.name} in about 2 minutes.',
    };
  }

  void _callDriver() {
    final driver = widget.driver;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AvatarCircle(
                initials: driver.initials,
                size: 60,
                background: AppColors.primarySoft,
              ),
              const SizedBox(height: 12),
              Text(
                driver.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                driver.phone,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        showSnack(
                          context,
                          'Calling ${driver.phone}…',
                          icon: Icons.call_rounded,
                        );
                      },
                      child: const Text('Call now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _messageDriver() {
    const messages = [
      "I'm at the pickup point.",
      'Please wait 2 minutes.',
      "I'm coming down now.",
      'Please call me when you arrive.',
    ];
    final firstName = widget.driver.name.split(' ').first;

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
                'Message $firstName',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Quick replies to ${widget.driver.name}',
                style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              for (final message in messages) ...[
                Material(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      showSnack(
                        context,
                        'Message sent to $firstName',
                        icon: Icons.send_rounded,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              message,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.north_east_rounded,
                            size: 15,
                            color: AppColors.muted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        );
      },
    );
  }

  void _shareTrip() {
    Clipboard.setData(
      const ClipboardData(text: 'https://sawari.pk/trip/SW-1042'),
    );
    showSnack(
      context,
      'Live trip link copied. Send it to family or friends.',
      icon: Icons.share_rounded,
    );
  }

  void _showSafety() {
    showSawariSheet(
      context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const IconBubble(
                    icon: Icons.shield_rounded,
                    size: 44,
                    background: AppColors.primarySoft,
                    foreground: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Safety toolkit',
                          style: Theme.of(sheetContext).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'You are covered on every Sawari ride.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _EmergencyTile(
                title: 'Police helpline',
                number: '15',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  showSnack(context, 'Calling Police helpline 15…',
                      icon: Icons.call_rounded);
                },
              ),
              const SizedBox(height: 8),
              _EmergencyTile(
                title: 'Rescue 1122',
                number: '1122',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  showSnack(context, 'Calling Rescue 1122…',
                      icon: Icons.local_hospital_rounded);
                },
              ),
              const SizedBox(height: 8),
              _EmergencyTile(
                title: 'Motorway Police',
                number: '130',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  showSnack(context, 'Calling Motorway Police 130…',
                      icon: Icons.call_rounded);
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    _shareTrip();
                  },
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text('Share live trip with family'),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Sawari support is available 24/7 in Urdu and English.',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmCancel() async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Cancel this ride?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: const Text(
            'Your driver is already on the way. A small cancellation fee may '
            'apply in a live booking.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Keep ride'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
              child: const Text('Cancel ride'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Ride cancelled. No fee applied for this demo.'),
      ),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.stage,
    required this.pin,
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  final int stage;
  final String pin;
  final String title;
  final String subtitle;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Pill(
                label: stage >= 2 ? 'ON TRIP' : 'DRIVER ASSIGNED',
                icon: Icons.sensors_rounded,
              ),
              const Spacer(),
              if (stage <= 1)
                Pill(
                  label: 'PIN $pin',
                  icon: Icons.lock_outline_rounded,
                  background: AppColors.ink,
                  foreground: Colors.white,
                ),
            ],
          ),
          const SizedBox(height: 11),
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.inkSoft,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.line,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Text(
                'Trip progress',
                style: TextStyle(fontSize: 10.5, color: AppColors.muted),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.driver, required this.service});

  final Driver driver;
  final RideService service;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AvatarCircle(
                    initials: driver.initials,
                    size: 48,
                    background: AppColors.primarySoft,
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: AppColors.amber,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${driver.rating} • ${formatCount(driver.trips)} trips',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Pill(
                label: service.name,
                icon: service.icon,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.directions_car_rounded,
                  size: 16,
                  color: AppColors.inkSoft,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    '${driver.vehicle}  •  ${driver.plate}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ),
                const Icon(
                  Icons.verified_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, size: 19, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkSoft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapCircleButton extends StatelessWidget {
  const _MapCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _EmergencyTile extends StatelessWidget {
  const _EmergencyTile({
    required this.title,
    required this.number,
    required this.onTap,
  });

  final String title;
  final String number;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              const Icon(
                Icons.emergency_rounded,
                size: 20,
                color: AppColors.danger,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Text(
                number,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.call_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
