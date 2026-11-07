import 'package:flutter/widgets.dart';

import 'data.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  City _city = cityByName('Lahore');
  PaymentMethod _payment = paymentMethods.first;
  final List<TripRecord> _trips = seedTrips();

  City get city => _city;
  PaymentMethod get payment => _payment;
  List<TripRecord> get trips => List.unmodifiable(_trips);

  set city(City value) {
    if (value.name == _city.name) return;
    _city = value;
    notifyListeners();
  }

  set payment(PaymentMethod value) {
    if (value.id == _payment.id) return;
    _payment = value;
    notifyListeners();
  }

  void addTrip(TripRecord trip) {
    _trips.insert(0, trip);
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this widget');
    return scope!.notifier!;
  }
}
