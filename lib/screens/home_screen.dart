import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';
import '../models.dart';
import '../state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/taxi_map.dart';
import 'booking_screen.dart';
import 'destination_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenActivity});

  final VoidCallback onOpenActivity;

  void _openDestination(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DestinationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final city = state.city;
    final recentTrips = state.trips.take(2).toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          _HomeHeader(onBell: () => _showNotifications(context)),
          const SizedBox(height: 18),
          _MapPanel(
            city: city,
            onCityTap: () => _showCityPicker(context, state),
            onSearchTap: () => _openDestination(context),
            onRecenter: () => showSnack(
              context,
              'Centred on ${city.hub}, ${city.name}',
              icon: Icons.my_location_rounded,
            ),
          ),
          const SizedBox(height: 14),
          _QuickPlaces(city: city),
          const SizedBox(height: 26),
          SectionHeader(
            title: 'Choose your sawari',
            actionLabel: 'All options',
            onAction: () => _openDestination(context),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 156,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: rideServices.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final service = rideServices[index];
                return SizedBox(
                  width: 156,
                  child: AppCard(
                    padding: const EdgeInsets.all(14),
                    onTap: () => _openDestination(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconBubble(
                              icon: service.icon,
                              size: 40,
                              background: AppColors.primarySoft,
                              foreground: AppColors.primaryDark,
                            ),
                            const Spacer(),
                            if (service.popular)
                              const Icon(
                                Icons.star_rounded,
                                size: 17,
                                color: AppColors.amber,
                              ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          service.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          service.tagline,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${formatPkr(service.baseFare)}+',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.schedule_rounded,
                              size: 12,
                              color: AppColors.muted,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                '${service.etaMinutes} min',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          const _PromoBanner(),
          const SizedBox(height: 26),
          SectionHeader(
            title: 'Recent trips',
            actionLabel: 'See all',
            onAction: onOpenActivity,
          ),
          const SizedBox(height: 12),
          for (final trip in recentTrips) ...[
            _RecentTripCard(trip: trip, onTap: onOpenActivity),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  void _showCityPicker(BuildContext context, AppState state) {
    showSawariSheet(
      context,
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * .72,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 4, 22, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose your city',
                            style: Theme.of(sheetContext).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sawari is live in ${cities.length} cities across Pakistan',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  itemCount: cities.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    final selected = city.name == state.city.name;
                    return Material(
                      color: selected ? AppColors.primarySoft : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          state.city = city;
                          Navigator.of(sheetContext).pop();
                          showSnack(
                            context,
                            'City switched to ${city.name}',
                            icon: Icons.swap_horiz_rounded,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary.withValues(alpha: .35)
                                  : AppColors.line,
                            ),
                          ),
                          child: Row(
                            children: [
                              IconBubble(
                                icon: Icons.location_city_rounded,
                                size: 38,
                                background: selected
                                    ? Colors.white
                                    : AppColors.bg,
                                foreground: AppColors.primaryDark,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      city.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14.5,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${city.hub} • ${city.places.length} popular spots',
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
                                    ? Icons.check_circle_rounded
                                    : Icons.chevron_right_rounded,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.muted,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotifications(BuildContext context) {
    showSawariSheet(
      context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const _NotificationTile(
                icon: Icons.local_offer_rounded,
                title: 'SAWARI50 is live',
                message: 'Get 50% off your next three rides in any city.',
              ),
              const SizedBox(height: 10),
              const _NotificationTile(
                icon: Icons.shield_rounded,
                title: 'New safety toolkit',
                message: 'Share your live trip with family in one tap.',
              ),
              const SizedBox(height: 10),
              const _NotificationTile(
                icon: Icons.tune_rounded,
                title: 'Better fares in peak hours',
                message: 'Fares are now locked before you book. No surprises.',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onBell});

  final VoidCallback onBell;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const AvatarCircle(initials: 'AS', size: 46),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bg, width: 2.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assalam-o-Alaikum',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              SizedBox(height: 1),
              Text(
                riderName,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: onBell,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 22,
                  color: AppColors.ink,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 11,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MapPanel extends StatelessWidget {
  const _MapPanel({
    required this.city,
    required this.onCityTap,
    required this.onSearchTap,
    required this.onRecenter,
  });

  final City city;
  final VoidCallback onCityTap;
  final VoidCallback onSearchTap;
  final VoidCallback onRecenter;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140C2418),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: SizedBox(
          height: 252,
          child: Stack(
            children: [
              const Positioned.fill(
                child: TaxiMap(progress: .16, showLabels: true),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  elevation: 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: onCityTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _PulseDot(),
                          const SizedBox(width: 8),
                          Text(
                            '${city.hub}, ${city.name}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.expand_more_rounded,
                            size: 16,
                            color: AppColors.inkSoft,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    onPressed: onRecenter,
                    iconSize: 19,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Recenter map',
                    icon: const Icon(
                      Icons.my_location_rounded,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onSearchTap,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const IconBubble(
                            icon: Icons.search_rounded,
                            size: 38,
                            background: AppColors.primarySoft,
                            foreground: AppColors.primaryDark,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Where to in ${city.name}?',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                const Text(
                                  'Search area, landmark or airport',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: .18 + .22 * _controller.value,
                ),
                blurRadius: 2 + 6 * _controller.value,
                spreadRadius: 1 + 3 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickPlaces extends StatelessWidget {
  const _QuickPlaces({required this.city});

  final City city;

  @override
  Widget build(BuildContext context) {
    final home = city.places.first;
    final work = city.places.length > 3 ? city.places[3] : city.places[1];
    final airport = city.findPlace(PlaceType.airport);

    return SizedBox(
      height: 62,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _QuickPlaceTile(
            label: 'Home',
            place: home,
            icon: Icons.home_rounded,
          ),
          const SizedBox(width: 10),
          _QuickPlaceTile(
            label: 'Work',
            place: work,
            icon: Icons.work_rounded,
          ),
          const SizedBox(width: 10),
          _QuickPlaceTile(
            label: 'Airport',
            place: airport,
            icon: Icons.flight_takeoff_rounded,
          ),
        ],
      ),
    );
  }
}

class _QuickPlaceTile extends StatelessWidget {
  const _QuickPlaceTile({
    required this.label,
    required this.place,
    required this.icon,
  });

  final String label;
  final Place place;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BookingScreen(place: place),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              IconBubble(
                icon: icon,
                size: 36,
                background: AppColors.bg,
                foreground: AppColors.primaryDark,
              ),
              const SizedBox(width: 9),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 1),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 92),
                    child: Text(
                      place.name,
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
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, Color(0xFF0B7A4D)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E034D31),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -50,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .14),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              'LIMITED OFFER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '50% off your\nnext 3 rides',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              height: 1.18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Valid in all cities. Minimum fare Rs 100.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .72),
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .16),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.local_offer_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(
                          const ClipboardData(text: 'SAWARI50'),
                        );
                        showSnack(
                          context,
                          'Code SAWARI50 copied to clipboard',
                          icon: Icons.copy_rounded,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SAWARI50',
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.copy_rounded,
                              color: AppColors.primary,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTripCard extends StatelessWidget {
  const _RecentTripCard({required this.trip, required this.onTap});

  final TripRecord trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: [
          IconBubble(
            icon: trip.service.icon,
            size: 42,
            background: AppColors.bg,
            foreground: AppColors.primaryDark,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.to,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${relativeTripDate(trip.when)} • ${trip.cityName} • ${trip.service.name}',
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
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatPkr(trip.fare),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 3),
              RatingStars(value: trip.rating, size: 11),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBubble(
            icon: icon,
            size: 38,
            background: Colors.white,
            foreground: AppColors.primaryDark,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.inkSoft,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
