import 'package:flutter/material.dart';

import 'models.dart';

const riderName = 'Ahmed Shere';
const riderPhone = '+92 300 1234567';
const riderEmail = 'ahmed.shere@example.pk';

const rideServices = <RideService>[
  RideService(
    id: 'bike',
    name: 'Bike',
    tagline: 'Beat the traffic',
    icon: Icons.two_wheeler_rounded,
    baseFare: 60,
    perKm: 28,
    etaMinutes: 3,
    seats: 1,
  ),
  RideService(
    id: 'rickshaw',
    name: 'Rickshaw',
    tagline: 'Desi, budget friendly',
    icon: Icons.electric_rickshaw_rounded,
    baseFare: 80,
    perKm: 32,
    etaMinutes: 5,
    seats: 3,
  ),
  RideService(
    id: 'mini',
    name: 'Mini',
    tagline: 'Alto & Cultus',
    icon: Icons.directions_car_rounded,
    baseFare: 100,
    perKm: 45,
    etaMinutes: 4,
    seats: 4,
    popular: true,
  ),
  RideService(
    id: 'comfort',
    name: 'Comfort',
    tagline: 'Corolla & City',
    icon: Icons.local_taxi_rounded,
    baseFare: 160,
    perKm: 70,
    etaMinutes: 6,
    seats: 4,
  ),
];

const paymentMethods = <PaymentMethod>[
  PaymentMethod(
    id: 'cash',
    name: 'Cash',
    detail: 'Pay the driver in PKR',
    icon: Icons.payments_rounded,
  ),
  PaymentMethod(
    id: 'jazzcash',
    name: 'JazzCash',
    detail: '0300 •••• 4567',
    icon: Icons.phone_android_rounded,
  ),
  PaymentMethod(
    id: 'easypaisa',
    name: 'Easypaisa',
    detail: '0345 •••• 2210',
    icon: Icons.phone_iphone_rounded,
  ),
  PaymentMethod(
    id: 'card',
    name: 'Card',
    detail: 'Visa •••• 4242',
    icon: Icons.credit_card_rounded,
  ),
];

const drivers = <Driver>[
  Driver(
    name: 'Muhammad Usman',
    rating: 4.92,
    trips: 3218,
    vehicle: 'Suzuki Alto',
    plate: 'LEB-4821',
    phone: '+92 321 4455667',
  ),
  Driver(
    name: 'Ali Raza',
    rating: 4.87,
    trips: 2104,
    vehicle: 'Honda City',
    plate: 'KHI-2913',
    phone: '+92 300 7788991',
  ),
  Driver(
    name: 'Hamza Sheikh',
    rating: 4.95,
    trips: 4102,
    vehicle: 'Toyota Corolla',
    plate: 'ICT-9087',
    phone: '+92 333 1122334',
  ),
  Driver(
    name: 'Bilal Ahmed',
    rating: 4.81,
    trips: 1876,
    vehicle: 'Suzuki Every',
    plate: 'FD-5566',
    phone: '+92 345 6677889',
  ),
];

const cities = <City>[
  City(
    name: 'Lahore',
    hub: 'Gulberg III',
    platePrefix: 'LEB',
    places: [
      Place(name: 'Liberty Market', area: 'Gulberg', type: PlaceType.market, distanceKm: 6.2),
      Place(name: 'Packages Mall', area: 'Walton Road', type: PlaceType.mall, distanceKm: 14.8),
      Place(name: 'Allama Iqbal Airport', area: 'Cantt', type: PlaceType.airport, distanceKm: 18.6),
      Place(name: 'Emporium Mall', area: 'Johar Town', type: PlaceType.mall, distanceKm: 12.1),
      Place(name: 'Badshahi Mosque', area: 'Walled City', type: PlaceType.landmark, distanceKm: 8.4),
      Place(name: 'DHA Phase 5', area: 'DHA', type: PlaceType.neighborhood, distanceKm: 16.2),
      Place(name: 'Johar Town', area: 'Block G', type: PlaceType.neighborhood, distanceKm: 13.5),
      Place(name: 'Fortress Stadium', area: 'Cantt', type: PlaceType.landmark, distanceKm: 9.0),
    ],
  ),
  City(
    name: 'Karachi',
    hub: 'Clifton Block 5',
    platePrefix: 'KHI',
    places: [
      Place(name: 'Clifton Beach', area: 'Clifton', type: PlaceType.park, distanceKm: 7.4),
      Place(name: 'Dolmen Mall Clifton', area: 'Clifton', type: PlaceType.mall, distanceKm: 6.8),
      Place(name: 'Jinnah International Airport', area: 'Cantt', type: PlaceType.airport, distanceKm: 16.9),
      Place(name: 'Saddar', area: 'Saddar Town', type: PlaceType.market, distanceKm: 4.2),
      Place(name: 'Gulshan-e-Iqbal', area: 'Block 13-D', type: PlaceType.neighborhood, distanceKm: 11.6),
      Place(name: 'Port Grand', area: 'Mai Kolachi Road', type: PlaceType.landmark, distanceKm: 6.1),
    ],
  ),
  City(
    name: 'Islamabad',
    hub: 'F-7 Markaz',
    platePrefix: 'ICT',
    places: [
      Place(name: 'Faisal Mosque', area: 'Sector E-7', type: PlaceType.landmark, distanceKm: 8.2),
      Place(name: 'The Centaurus Mall', area: 'F-8', type: PlaceType.mall, distanceKm: 5.4),
      Place(name: 'Islamabad International Airport', area: 'Attock Road', type: PlaceType.airport, distanceKm: 28.5),
      Place(name: 'Blue Area', area: 'Jinnah Avenue', type: PlaceType.market, distanceKm: 4.8),
      Place(name: 'DHA Phase 2', area: 'Gate 2', type: PlaceType.neighborhood, distanceKm: 14.0),
      Place(name: 'Rawalpindi Saddar', area: 'Saddar', type: PlaceType.market, distanceKm: 12.8),
    ],
  ),
  City(
    name: 'Rawalpindi',
    hub: 'Bahria Town Phase 4',
    platePrefix: 'RWP',
    places: [
      Place(name: 'Raja Bazaar', area: 'Saddar', type: PlaceType.market, distanceKm: 8.6),
      Place(name: 'Ayub Park', area: 'Westridge', type: PlaceType.park, distanceKm: 6.4),
      Place(name: 'Bahria Town Safari Park', area: 'Phase 4', type: PlaceType.park, distanceKm: 3.2),
      Place(name: 'Rawalpindi Airport', area: 'Chaklala', type: PlaceType.airport, distanceKm: 10.4),
    ],
  ),
  City(
    name: 'Faisalabad',
    hub: 'D Ground',
    platePrefix: 'FD',
    places: [
      Place(name: 'Ghanta Ghar', area: 'Clock Tower', type: PlaceType.landmark, distanceKm: 3.2),
      Place(name: 'Lyallpur Galleria', area: 'East Canal Road', type: PlaceType.mall, distanceKm: 6.4),
      Place(name: 'Faisalabad Airport', area: 'Chak Jhumra Road', type: PlaceType.airport, distanceKm: 12.5),
      Place(name: 'Jinnah Garden', area: 'People’s Colony', type: PlaceType.park, distanceKm: 4.6),
    ],
  ),
  City(
    name: 'Multan',
    hub: 'Cantt',
    platePrefix: 'MN',
    places: [
      Place(name: 'Ghanta Ghar', area: 'Hussain Agahi', type: PlaceType.landmark, distanceKm: 2.4),
      Place(name: 'Mall of Multan', area: 'Abdali Road', type: PlaceType.mall, distanceKm: 5.8),
      Place(name: 'Multan International Airport', area: 'Airport Road', type: PlaceType.airport, distanceKm: 9.2),
      Place(name: 'Shrine of Shah Rukn-e-Alam', area: 'Bohar Gate', type: PlaceType.landmark, distanceKm: 3.6),
    ],
  ),
  City(
    name: 'Peshawar',
    hub: 'University Road',
    platePrefix: 'PSC',
    places: [
      Place(name: 'Qissa Khwani Bazaar', area: 'Old City', type: PlaceType.market, distanceKm: 2.8),
      Place(name: 'Bacha Khan Airport', area: 'Cantt', type: PlaceType.airport, distanceKm: 7.6),
      Place(name: 'Islamia College', area: 'University Road', type: PlaceType.landmark, distanceKm: 4.1),
      Place(name: 'Hayatabad Phase 6', area: 'Hayatabad', type: PlaceType.neighborhood, distanceKm: 11.2),
    ],
  ),
  City(
    name: 'Quetta',
    hub: 'Jinnah Road',
    platePrefix: 'QTA',
    places: [
      Place(name: 'Liaquat Bazaar', area: 'Old City', type: PlaceType.market, distanceKm: 3.0),
      Place(name: 'Quetta Airport', area: 'Samungli Road', type: PlaceType.airport, distanceKm: 8.4),
      Place(name: 'Hanna Lake', area: 'Urak Valley', type: PlaceType.park, distanceKm: 9.8),
      Place(name: 'Jinnah Town', area: 'Sariab Road', type: PlaceType.neighborhood, distanceKm: 5.6),
    ],
  ),
];

City cityByName(String name) =>
    cities.firstWhere((c) => c.name == name, orElse: () => cities.first);

RideService serviceById(String id) =>
    rideServices.firstWhere((s) => s.id == id, orElse: () => rideServices[2]);

PaymentMethod paymentById(String id) =>
    paymentMethods.firstWhere((p) => p.id == id, orElse: () => paymentMethods.first);

Driver driverFor(City city, RideService service, Place place) {
  final seed = place.name.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
  final template = drivers[(seed + service.id.length) % drivers.length];
  final vehicle = switch (service.id) {
    'bike' => 'Honda CD 70',
    'rickshaw' => 'Suzuki Rickshaw',
    'mini' => 'Suzuki Alto',
    'comfort' => 'Toyota Corolla',
    _ => template.vehicle,
  };
  final serial = 1000 + (seed * 137 + service.id.length * 41) % 8999;
  return Driver(
    name: template.name,
    rating: template.rating,
    trips: template.trips,
    vehicle: vehicle,
    plate: '${city.platePrefix}-$serial',
    phone: template.phone,
  );
}

List<TripRecord> seedTrips() {
  final now = DateTime.now();
  return [
    TripRecord(
      id: 'SW-1042',
      from: 'Gulberg III',
      to: 'Packages Mall',
      cityName: 'Lahore',
      service: serviceById('mini'),
      payment: paymentById('cash'),
      driverName: 'Muhammad Usman',
      fare: 380,
      km: 14.8,
      minutes: 34,
      when: now.subtract(const Duration(days: 2, hours: 3)),
      rating: 5,
    ),
    TripRecord(
      id: 'SW-0987',
      from: 'Clifton Block 5',
      to: 'Jinnah International Airport',
      cityName: 'Karachi',
      service: serviceById('comfort'),
      payment: paymentById('jazzcash'),
      driverName: 'Ali Raza',
      fare: 1470,
      km: 16.9,
      minutes: 41,
      when: now.subtract(const Duration(days: 6, hours: 7)),
      rating: 5,
    ),
    TripRecord(
      id: 'SW-0911',
      from: 'F-7 Markaz',
      to: 'Faisal Mosque',
      cityName: 'Islamabad',
      service: serviceById('bike'),
      payment: paymentById('easypaisa'),
      driverName: 'Hamza Sheikh',
      fare: 290,
      km: 8.2,
      minutes: 19,
      when: now.subtract(const Duration(days: 12, hours: 2)),
      rating: 4,
    ),
    TripRecord(
      id: 'SW-0820',
      from: 'D Ground',
      to: 'Lyallpur Galleria',
      cityName: 'Faisalabad',
      service: serviceById('rickshaw'),
      payment: paymentById('cash'),
      driverName: 'Bilal Ahmed',
      fare: 290,
      km: 6.4,
      minutes: 17,
      when: now.subtract(const Duration(days: 24, hours: 5)),
      rating: 5,
    ),
  ];
}
