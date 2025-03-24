import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  Map<String, dynamic>? _currentOrder;

  // Getters
  Map<String, dynamic>? get currentOrder => _currentOrder;

  // Définir une commande
  void setOrder(Map<String, dynamic> order) {
    _currentOrder = order;
    notifyListeners();
  }

  // Vider la commande actuelle
  void clearOrder() {
    _currentOrder = null;
    notifyListeners();
  }
}