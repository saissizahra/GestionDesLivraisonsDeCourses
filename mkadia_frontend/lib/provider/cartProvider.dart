import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/services/OrderApiService.dart';
import 'package:mkadia/services/api_service.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cart = [];
  final List<Map<String, dynamic>> _confirmedItems = []; 
  bool _isOrderConfirmed = false;
  Map<String, dynamic>? _lastOrderResponse; 

  List<Map<String, dynamic>> get cart => _cart;
  List<Map<String, dynamic>> get confirmedItems => _confirmedItems;
  bool get isOrderConfirmed => _isOrderConfirmed;
  Map<String, dynamic>? get lastOrderResponse => _lastOrderResponse;

  void toggleFavorite(Map<String, dynamic> product, int quantity) async {
    final existingProductIndex = _cart.indexWhere((p) => p['id'].toString() == product['id'].toString());
    if (existingProductIndex != -1) {
      _cart[existingProductIndex]['quantity'] += quantity;
    } else {
      product['quantity'] = quantity;
      product['id'] = product['id'].toString();
      _cart.add(product);
    }
    notifyListeners();
  }

  void incrementQtn(String productId) {
    final productIndex = _cart.indexWhere((p) => p['id'].toString() == productId);
    if (productIndex != -1) {
      _cart[productIndex]['quantity']++;
      notifyListeners();
    }
  }

  void decrementQtn(String productId) {
    final productIndex = _cart.indexWhere((p) => p['id'].toString() == productId);
    if (productIndex != -1) {
      if (_cart[productIndex]['quantity'] > 1) {
        _cart[productIndex]['quantity']--;
      } else {
        _cart.removeAt(productIndex);
      }
      notifyListeners();
    }
  }

  void removeProduct(String productId) {
    _cart.removeWhere((p) => p['id'].toString() == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<Map<String, dynamic>> confirmOrder(BuildContext context, double tax, double deliveryFee, String? promoCode, String deliveryAddress) async {
    try {
      final orderData = {
        'user_id': 1,
        'items': _cart.map((item) => {
          'product_id': item['id'],
          'quantity': item['quantity'],
          'price': item['price'],
          'total': (double.parse(item['price'].toString()) * item['quantity']).toString(),
        }).toList(),
        'tax': tax,
        'delivery_fee': deliveryFee,
        'total_amount': totalPrice() + tax + deliveryFee,
        'order_date': DateTime.now().toIso8601String(),
        'delivery_address': deliveryAddress, 
      };

      print('Données envoyées à l\'API : $orderData');

      // Envoyer la commande à l'API
      final orderResponse = await OrderApiService.createOrder(orderData);

      print('Réponse de l\'API : $orderResponse');

      // Si un code promo a été appliqué, confirmer la commande et incrémenter le compteur
      if (promoCode != null) {
        await ApiService.confirmOrder(orderResponse['order_id'], promoCode);
      }

      _lastOrderResponse = orderResponse;

      // Copier les articles du panier dans confirmedItems
      _confirmedItems.clear();
      for (var item in _cart) {
        _confirmedItems.add({
          'id': item['id'],
          'name': item['name'],
          'price': item['price'],
          'quantity': item['quantity'],
          'image': item['image'], 
          'image_url': item['image_url'] ?? item['image'],
        });
      }
      
      print('Items confirmed: $_confirmedItems');
      
      _cart.clear();
      _isOrderConfirmed = true;
      notifyListeners();
      
      print('Commande confirmée avec succès ! ID: ${orderResponse['order_id']}');
      print('Panier vidé : $_cart');

      // Définir la commande actuelle dans OrderProvider
      if (context.mounted) {
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        orderProvider.setOrder(orderResponse);
      }
      
      return orderResponse;
    } catch (e) {
      print('Erreur lors de la confirmation de la commande: $e');
      throw Exception('Failed to confirm order: $e');
    }
  }
  // Réinitialiser la commande
  void resetOrder() {
    _isOrderConfirmed = false;
    _lastOrderResponse = null;
    notifyListeners();
  }

  // Vider les produits confirmés
  void clearConfirmedItems() {
    _confirmedItems.clear();
    notifyListeners();
  }

  double totalPrice() {
    double total = 0.0;
    for (Map<String, dynamic> element in _cart) {
      total += double.parse(element['price'].toString()) * element['quantity'];
    }
    return double.parse(total.toStringAsFixed(2));
  }
  
  // New method: Calculate total price for confirmed items
  double totalConfirmedPrice() {
    double total = 0.0;
    for (Map<String, dynamic> element in _confirmedItems) {
      total += double.parse(element['price'].toString()) * element['quantity'];
    }
    return double.parse(total.toStringAsFixed(2));
  }

  static CartProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<CartProvider>(context, listen: listen);
  }
}