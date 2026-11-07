import 'package:flutter/material.dart';

enum PlaceType { airport, mall, landmark, neighborhood, market, park }

extension PlaceTypeInfo on PlaceType {
  IconData get icon => switch (this) {
        PlaceType.airport => Icons.flight_takeoff_rounded,
        PlaceType.mall => Icons.storefront_rounded,
        PlaceType.landmark => Icons.account_balance_rounded,
        PlaceType.neighborhood => Icons.location_city_rounded,
        PlaceType.market => Icons.local_mall_rounded,
        PlaceType.park => Icons.park_rounded,
      };
}

class Place {
  const Place({
    required this.name,
    required this.area,
    required this.type,
    required this.distanceKm,
  });

  final String name;
  final String area;
  final PlaceType type;
  final double distanceKm;
}

class City {
  const City({
    required this.name,
    required this.hub,
    required this.platePrefix,
    required this.places,
  });

  final String name;

  /// Where a typical pickup happens in this city.
  final String hub;
  final String platePrefix;
  final List<Place> places;

  String get label => '$hub, $name';

  Place findPlace(PlaceType type) => places.firstWhere(
        (p) => p.type == type,
        orElse: () => places.first,
      );
}

class RideService {
  const RideService({
    required this.id,
    required this.name,
    required this.tagline,
    required this.icon,
    required this.baseFare,
    required this.perKm,
    required this.etaMinutes,
    required this.seats,
    this.popular = false,
  });

  final String id;
  final String name;
  final String tagline;
  final IconData icon;
  final int baseFare;
  final int perKm;
  final int etaMinutes;
  final int seats;
  final bool popular;

  int fareFor(double km) => ((baseFare + perKm * km) / 10).ceil() * 10;

  String get seatsLabel => seats == 1 ? '1 seat' : '$seats seats';
}

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.name,
    required this.detail,
    required this.icon,
  });

  final String id;
  final String name;
  final String detail;
  final IconData icon;
}

class Driver {
  const Driver({
    required this.name,
    required this.rating,
    required this.trips,
    required this.vehicle,
    required this.plate,
    required this.phone,
  });

  final String name;
  final double rating;
  final int trips;
  final String vehicle;
  final String plate;
  final String phone;

  String get initials {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length < 2) return name.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class TripRecord {
  const TripRecord({
    required this.id,
    required this.from,
    required this.to,
    required this.cityName,
    required this.service,
    required this.payment,
    required this.driverName,
    required this.fare,
    required this.km,
    required this.minutes,
    required this.when,
    this.rating = 0,
  });

  final String id;
  final String from;
  final String to;
  final String cityName;
  final RideService service;
  final PaymentMethod payment;
  final String driverName;
  final int fare;
  final double km;
  final int minutes;
  final DateTime when;
  final int rating;
}

int estimateMinutes(double km) => (km * 2.4 + 6).round();
