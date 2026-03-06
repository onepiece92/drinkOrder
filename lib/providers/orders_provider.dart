import 'package:flutter/material.dart';
import '../models/order.dart';
import '../data/drinks_data.dart';

class OrdersProvider extends ChangeNotifier {
  final List<Order> _orders = List.from(DrinksData.recentOrders);

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }
}
