import 'package:mkadia/models/OrderItem.dart';

class Order {
  final int id;
  final int userId;
  final double totalAmount;
  final DateTime orderDate;
  final int? deliveryId;
  final String orderStatus;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.orderDate,
    this.deliveryId,
    required this.orderStatus,
    required this.items,
  });

  // Méthode pour créer un Order à partir de JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      totalAmount: double.parse(json['total_amount'].toString()),
      orderDate: DateTime.parse(json['order_date']),
      deliveryId: json['delivery_id'],
      orderStatus: json['order_status'],
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}