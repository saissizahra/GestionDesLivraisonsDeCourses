import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  Map<String, dynamic>? _currentOrder;
  List<Map<String, dynamic>> _assignedOrders = [];

  Map<String, dynamic>? get currentOrder => _currentOrder;
  List<Map<String, dynamic>> get assignedOrders => _assignedOrders;

  final TextEditingController addressController = TextEditingController();

  void setOrder(Map<String, dynamic> order) {
    _currentOrder = order;
        if (addressController.text.isNotEmpty) {
      _currentOrder?['delivery_address'] = addressController.text;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  void setAssignedOrders(List<Map<String, dynamic>> orders) {
    _assignedOrders = orders;
    notifyListeners();
  }

  void updateOrderStatus(String status) {
    if (_currentOrder != null) {
      _currentOrder!['delivery_status'] = status;
      notifyListeners();
    }
  }

  void clearOrder() {
    _currentOrder = null;
    notifyListeners();
  }
}