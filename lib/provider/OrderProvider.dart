import 'package:flutter/material.dart';
import 'package:mkadia/models/order.dart';

class OrderProvider with ChangeNotifier {
  Order? _currentOrder;

  Order? get currentOrder => _currentOrder;

  void setOrder(Order order) {
    _currentOrder = order;
    notifyListeners(); // Notifier les écouteurs
  }

  void clearOrder() {
    _currentOrder = null;
    notifyListeners(); // Notifier les écouteurs
  }
}