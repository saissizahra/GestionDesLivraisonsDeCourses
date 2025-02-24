import 'package:flutter/material.dart';
import 'package:mkadia/models/delivery.dart';
import 'package:mkadia/models/order.dart';
import 'package:mkadia/provider/BottomNavProvider.dart';
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/views/home/widget/navbar.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation de la commande'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _placeOrder(context);
          },
          child: const Text('Confirmer la commande'),
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context) {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  final orderProvider = Provider.of<OrderProvider>(context, listen: false);
  final bottomNavBarProvider = Provider.of<BottomNavProvider>(context, listen: false);

  final order = Order(
    id: 'ORD123',
    items: List.from(cartProvider.cart), // Créer une copie des produits du panier
    totalAmount: cartProvider.totalPrice(),
    orderDate: DateTime.now(),
    delivery: deliveries[0],
  );

  orderProvider.setOrder(order); // Définir la commande actuelle
  cartProvider.confirmOrder(); // Confirmer la commande (vider le panier et copier les produits)

  // Changer l'index du BottomNavBar pour aller à "Order"
  bottomNavBarProvider.setCurrentIndex(1);
  
  // Fermer CheckoutPage et revenir à BottomNavBar
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const BottomNavBar()),
  );
}

}