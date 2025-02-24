import 'package:flutter/material.dart';
import 'package:mkadia/models/product.dart';
import 'package:provider/provider.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _cart = []; // Panier actuel
  final List<Product> _confirmedItems = []; // Produits confirmés
  bool _isOrderConfirmed = false; // État de la commande

  // Getters
  List<Product> get cart => _cart;
  List<Product> get confirmedItems => _confirmedItems;
  bool get isOrderConfirmed => _isOrderConfirmed;

  // Ajouter ou mettre à jour un produit dans le panier
  void toggleFavorite(Product product, int quantity) {
    final existingProductIndex = _cart.indexWhere((p) => p.id == product.id);
    if (existingProductIndex != -1) {
      // Si le produit existe déjà, mettez à jour la quantité
      _cart[existingProductIndex].quantity += quantity;
    } else {
      // Sinon, ajoutez le produit au panier
      product.quantity = quantity;
      _cart.add(product);
    }
    notifyListeners();
  }

  // Incrémenter la quantité d'un produit
  void incrementQtn(String productId) {
    final productIndex = _cart.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      _cart[productIndex].quantity++;
      notifyListeners();
    }
  }

  // Décrémenter la quantité d'un produit
  void decrementQtn(String productId) {
    final productIndex = _cart.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      if (_cart[productIndex].quantity > 1) {
        _cart[productIndex].quantity--;
      } else {
        _cart.removeAt(productIndex); // Supprimer le produit si la quantité est 1
      }
      notifyListeners();
    }
  }

  // Supprimer un produit du panier par son ID
  void removeProduct(String productId) {
    _cart.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  // Vider le panier (affichage seulement)
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Confirmer la commande
  void confirmOrder() {
    _confirmedItems.addAll(_cart); // Copier les produits dans la liste confirmée
    _cart.clear(); // Vider le panier (affichage seulement)
    _isOrderConfirmed = true; // Marquer la commande comme confirmée
    notifyListeners();
  }

  // Réinitialiser la commande
  void resetOrder() {
    _isOrderConfirmed = false;
    notifyListeners();
  }

  // Vider les produits confirmés
  void clearConfirmedItems() {
    _confirmedItems.clear();
    notifyListeners();
  }

  // Calculer le prix total du panier
  double totalPrice() {
    double total = 0.0;
    for (Product element in _cart) {
      total += element.price * element.quantity;
    }
    return double.parse(total.toStringAsFixed(2));
  }

  // Méthode statique pour accéder au provider
  static CartProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<CartProvider>(
      context,
      listen: listen,
    );
  }
}