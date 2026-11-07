import 'package:flutter/material.dart';

import '../models.dart';
import '../state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'booking_screen.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openBooking(Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BookingScreen(place: place)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final city = AppScope.of(context).city;
    final query = _query.trim().toLowerCase();
    final results = query.isEmpty
        ? city.places
        : city.places
            .where((place) =>
                place.name.toLowerCase().contains(query) ||
                place.area.toLowerCase().contains(query))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Where to?'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const _GreenDot(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Picking up from ${city.label}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: (value) => setState(() => _query = value),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Search area, mall, airport…',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              if (query.isEmpty) ...[
                _SavedPlacesRow(city: city, onSelect: _openBooking),
                const SizedBox(height: 22),
              ],
              Expanded(
                child: results.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 16),
                          EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No places found',
                            message:
                                'Try another area, landmark or airport name.',
                          ),
                        ],
                      )
                    : ListView.separated(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: results.length + 1,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Text(
                                    query.isEmpty
                                        ? 'Popular in ${city.name}'
                                        : '${results.length} result${results.length == 1 ? '' : 's'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.ink,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (query.isEmpty)
                                    const Pill(
                                      label: 'LIVE',
                                      icon: Icons.bolt_rounded,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 5,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }
                          final place = results[index - 1];
                          return _PlaceTile(
                            place: place,
                            onTap: () => _openBooking(place),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreenDot extends StatelessWidget {
  const _GreenDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .25),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _SavedPlacesRow extends StatelessWidget {
  const _SavedPlacesRow({required this.city, required this.onSelect});

  final City city;
  final ValueChanged<Place> onSelect;

  @override
  Widget build(BuildContext context) {
    final home = city.places.first;
    final work = city.places.length > 3 ? city.places[3] : city.places[1];
    final airport = city.findPlace(PlaceType.airport);

    return Row(
      children: [
        Expanded(
          child: _SavedTile(
            label: 'Home',
            place: home,
            icon: Icons.home_rounded,
            onTap: () => onSelect(home),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SavedTile(
            label: 'Work',
            place: work,
            icon: Icons.work_rounded,
            onTap: () => onSelect(work),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SavedTile(
            label: 'Airport',
            place: airport,
            icon: Icons.flight_takeoff_rounded,
            onTap: () => onSelect(airport),
          ),
        ),
      ],
    );
  }
}

class _SavedTile extends StatelessWidget {
  const _SavedTile({
    required this.label,
    required this.place,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Place place;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: [
              IconBubble(
                icon: icon,
                size: 32,
                background: AppColors.bg,
                foreground: AppColors.primaryDark,
              ),
              const SizedBox(height: 7),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                place.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceTile extends StatelessWidget {
  const _PlaceTile({required this.place, required this.onTap});

  final Place place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              IconBubble(
                icon: place.type.icon,
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
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${place.area} • ${place.distanceKm.toStringAsFixed(1)} km away',
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
              const Icon(
                Icons.north_east_rounded,
                size: 18,
                color: AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
