import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

static Future<List<dynamic>> getDriverOrders(int driverId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/drivers/$driverId/orders'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Failed to load driver orders: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error in getDriverOrders: $e');
    rethrow;
  }
}

  static Future<Map<String, dynamic>> updateDeliveryStatus(int orderId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/orders/$orderId/delivery-status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'delivery_status': status}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update delivery status');
    }
  }
}