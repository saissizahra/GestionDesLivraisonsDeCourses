import 'package:flutter/material.dart';
import 'package:flutter_application_catmkadia/models/product.dart';
import 'package:provider/provider.dart';

class CartProvider extends ChangeNotifier{

  final List<Product> _cart =[];
  List<Product> get cart => _cart;

  void toggleFavorite(Product product, int quantity) {
  if (_cart.contains(product)) {
    final index = _cart.indexOf(product);
    _cart[index].quantity += quantity; // Ajouter la quantité choisie
  } else {
    product.quantity = quantity; // Définir la quantité initiale
    _cart.add(product);
  }
  notifyListeners();
  }


  //incrementQtn(int index) => _cart[index].quantity ++;
  //decrementQtn(int index) => _cart[index].quantity --;

void incrementQtn(int index) {
  _cart[index].quantity++;
  notifyListeners(); 
}

void decrementQtn(int index) {
  if (_cart[index].quantity > 1) {
    _cart[index].quantity--;
  } else {
    _cart.removeAt(index); // Supprime le produit si quantité = 0
  }
  notifyListeners(); 
}

void removeProduct(int index) {
  _cart.removeAt(index); 
  notifyListeners(); 
}


  totalPrice(){
    double total1 = 0.0;
    for(Product element in _cart){
      total1 += element.price * element.quantity;
    }
    return double.parse(total1.toStringAsFixed(2));
  }

  static CartProvider of(BuildContext context,{
    bool listen = true,
  }){
    return Provider.of<CartProvider>(
      context,
      listen: listen,
    );
  }
}