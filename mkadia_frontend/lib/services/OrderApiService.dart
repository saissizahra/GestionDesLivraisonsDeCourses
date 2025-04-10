import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Créer une nouvelle commande
static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      body: jsonEncode(orderData),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = jsonDecode(response.body);
    
    debugPrint('Réponse API: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 201) {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Failed to create order');
    }
  } catch (e) {
    debugPrint('Error in createOrder: $e');
    rethrow;
  }
}
    static Future<List<dynamic>> getAdminOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/orders'));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load admin orders');
    }
  }
static Future<List<Map<String, dynamic>>> getDriverOrders(int driverId) async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/drivers/$driverId/orders'),
    );

    debugPrint('API Response: ${response.body}'); // Log crucial

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Erreur API: $e');
    rethrow;
  }
}
  static Future<Map<String, dynamic>> assignDriver(int orderId, int driverId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/$orderId/assign-driver'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'driver_id': driverId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to assign driver');
    }
  }
    // Méthode spécifique pour que le client confirme la livraison
static Future<Map<String, dynamic>> confirmDelivery(int orderId) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/orders/$orderId/confirm-delivery'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    debugPrint('Confirm Delivery Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to confirm delivery: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error in confirmDelivery: $e');
    rethrow;
  }
}
  // Mettre à jour le statut d'une commande
  // Mettre à jour le statut d'une commande
  static Future<Map<String, dynamic>> updateOrderStatus(int orderId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/orders/$orderId/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Échec de la mise à jour du statut: ${response.statusCode}');
    }
  }
  static Future<List<dynamic>> getUserOrders(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders?user_id=$userId'),
        headers: {'Accept': 'application/json'},
      );

      print('API Response: ${response.statusCode} - ${response.body}'); // Debug

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Vérifiez la structure de réponse attendue
        if (responseData is List) {
          return responseData;
        } else if (responseData['orders'] is List) {
          return responseData['orders'];
        } else {
          throw Exception('Format de réponse inattendu');
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur API: $e');
      throw Exception('Échec du chargement des commandes');
    }
  }

  // Récupérer les détails d'une commande
static Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/orders/$orderId?with_items=true&with_driver=true'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    // Transformation des données pour uniformité
    return {
      'id': data['id'],
      'items': data['items']?.map((item) => {
        'product': {
          'name': item['product']['name'],
          'image_url': item['product']['image_url'],
        },
        'quantity': item['quantity'],
        'price': item['price'],
      }).toList(),
      'driver': data['driver'] ?? {
        'name': 'A assignee',
        'phone': '--',
      },
      'order_status': data['order_status'],
      'created_at': data['created_at'],
    };
  }
  throw Exception('Failed to load order details');
}
}