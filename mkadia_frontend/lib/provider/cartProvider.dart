import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/provider/UserProvider.dart';
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
    final existingProductIndex = _cart.indexWhere(
      (p) => p['id'].toString() == product['id'].toString(),
    );

    if (existingProductIndex != -1) {
      _cart[existingProductIndex]['quantity'] += quantity;
    } else {
      _cart.add({
        'id': product['id'].toString(),
        'name': product['name'],
        'price': product['price'],
        'quantity': quantity,
        'image_url': product['image_url'],
        'category': product['category'],
      });
    }
    notifyListeners();
  }

  void incrementQtn(String productId, {int by = 1}) {
    final productIndex = _cart.indexWhere((p) => p['id'].toString() == productId);
    if (productIndex != -1) {
      _cart[productIndex]['quantity'] += by;
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

Future<Map<String, dynamic>> confirmOrder(
  BuildContext context,
  double tax,
  double deliveryFee,
  String? promoCode,
  String deliveryAddress,
) async {
  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id;
    
    if (userId == null) throw Exception('Utilisateur non connecté');
    if (deliveryAddress.isEmpty) throw Exception('Adresse requise');
    if (_cart.isEmpty) throw Exception('Panier vide');

    // 1. Sauvegardez les articles AVANT de vider le panier
    _confirmedItems.clear();
    _confirmedItems.addAll(_cart.map((item) => Map<String, dynamic>.from(item)));

    final orderData = {
      'user_id': userId,
      'items': _cart.map((item) => {
        'product_id': item['id'],
        'quantity': item['quantity'],
        'price': item['price'],
      }).toList(),
      'delivery_address': deliveryAddress,
      'tax': tax,
      'delivery_fee': deliveryFee,
      'total_amount': (totalPrice() + tax + deliveryFee).toStringAsFixed(2),
      'order_status': 'confirmed',
    };

    debugPrint('Données envoyées: ${jsonEncode(orderData)}');

    final response = await OrderApiService.createOrder(orderData);

    // 2. Ne vider le panier QUE si la commande est confirmée
    if (response['success'] == true) {
      _cart.clear();
      _isOrderConfirmed = true;
      notifyListeners();
    } else {
      // Si échec, restaurer les articles confirmés
      _confirmedItems.clear();
    }

    return response;
  } catch (e) {
    _confirmedItems.clear(); // Nettoyer en cas d'erreur
    debugPrint('Erreur création commande: $e');
    rethrow;
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