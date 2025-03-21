import 'package:mkadia/models/delivery.dart';

class Order {
  final String id;
  final List<OrderItem> items; // Attend une liste d'objets OrderItem
  final double totalAmount;
  final DateTime orderDate;
  final Delivery delivery;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.delivery,
  });
}

class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });
}