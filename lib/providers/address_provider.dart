import 'package:flutter/foundation.dart';
import '../models/address.dart';
import '../data/drinks_data.dart';

/// Manages the currently selected delivery/pickup address for Liquid Gold.
class AddressProvider extends ChangeNotifier {
  int _selectedId = 1;

  int get selectedId => _selectedId;

  Address get selected => DrinksData.savedAddresses.firstWhere(
    (a) => a.id == _selectedId,
    orElse: () => DrinksData.savedAddresses.first,
  );

  void select(int id) {
    _selectedId = id;
    notifyListeners();
  }
}
