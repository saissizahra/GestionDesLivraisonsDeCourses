import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/provider/PayementManager.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/services/OrderApiService.dart';
import 'package:mkadia/views/payement/PaymentPage.dart';
import 'package:provider/provider.dart';

class CheckoutBox extends StatelessWidget {
  const CheckoutBox({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context);

    return Container(
      height: 250, // Ajuste la hauteur après suppression des éléments
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sous-total",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "${provider.totalPrice()} MAD",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${provider.totalPrice()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 1. Récupérer les providers nécessaires
              final cartProvider = Provider.of<CartProvider>(context, listen: false);
              final paymentManager = Provider.of<PaymentManager>(context, listen: false);
              final orderProvider = Provider.of<OrderProvider>(context, listen: false);
              
              // 2. Préparer les données temporaires pour la page de paiement
              final orderData = {
                'items': cartProvider.cart,
                'subtotal': cartProvider.totalPrice(),
                'tax': 0.1 * cartProvider.totalPrice(),
                'delivery_fee': 10.0,
                'total_amount': cartProvider.totalPrice() * 1.1 + 10.0,
                'delivery_address': '', // À remplir dans la page de paiement
              };
              
              // 3. Enregistrer la commande temporaire
              orderProvider.setTemporaryOrder(orderData);
              
              // 4. Naviguer vers la page de paiement
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    paymentManager: paymentManager,
                    cartProvider: cartProvider,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primaryText, 
              minimumSize: const Size(double.infinity, 55),
            ),
            child: const Text(
              "Paiement",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}