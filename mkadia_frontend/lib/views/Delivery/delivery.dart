import 'package:flutter/material.dart';
import 'package:mkadia/views/ConfirmationOrder/OrderConfirmationPage.dart';
import 'package:provider/provider.dart';
import 'package:mkadia/provider/cartProvider.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Si la commande est confirmée ou s'il y a des produits confirmés, afficher OrderConfirmationPage
    if (cartProvider.isOrderConfirmed || cartProvider.confirmedItems.isNotEmpty) {
      return const OrderConfirmationPage();
    }

    // Sinon, afficher la page de livraison vide
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/panier.png',
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 20),
                  const Column(
                    children: [
                      Text(
                        "Vous n\'avez pas encore passé de commande.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}