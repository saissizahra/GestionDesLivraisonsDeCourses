class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final double price;
  final int quantity;
  final double total;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.total,
  });

  // Méthode pour créer un OrderItem à partir de JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'],
      total: double.parse(json['total'].toString()),
    );
  }

  // Méthode pour convertir un OrderItem en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }
}