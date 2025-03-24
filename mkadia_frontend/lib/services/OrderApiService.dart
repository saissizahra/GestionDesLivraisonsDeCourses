import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Créer une nouvelle commande
  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Erreur lors de la création de la commande: ${response.body}');
      throw Exception('Failed to create order');
    }
  }

  // Récupérer les commandes d'un utilisateur
  static Future<List<dynamic>> getUserOrders(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/orders'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user orders');
    }
  }

  // Récupérer les détails d'une commande
  static Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/$orderId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load order details');
    }
  }

  // Mettre à jour le statut d'une commande
  static Future<Map<String, dynamic>> updateOrderStatus(int orderId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/orders/$orderId/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'order_status': status}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update order status');
    }
  }

  static Future<Map<String, dynamic>> createDelivery(Map<String, dynamic> deliveryData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deliveries'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(deliveryData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create delivery');
    }
  }

    // Mettre à jour le statut de la livraison
  static Future<void> updateDeliveryStatus(int deliveryId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/deliveries/$deliveryId/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'delivery_status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update delivery status: ${response.body}');
    }
  }
}