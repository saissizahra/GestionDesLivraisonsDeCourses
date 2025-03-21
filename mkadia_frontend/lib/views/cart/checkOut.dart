import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/models/delivery.dart';
import 'package:mkadia/models/driver.dart';
import 'package:mkadia/models/order.dart';
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/provider/PayementManager.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/views/cart/checkoutPage.dart';
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
                "Subtotal",
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
              final cartProvider = Provider.of<CartProvider>(context, listen: false);
              final orderProvider = Provider.of<OrderProvider>(context, listen: false);
              final paymentManager = Provider.of<PaymentManager>(context, listen: false);
              
              // Convertir cartProvider.cart en liste d'OrderItem
              final List<OrderItem> orderItems = cartProvider.cart.map((item) {
                return OrderItem(
                  productId: item['id'].toString(),
                  name: item['name'] ?? 'Nom non disponible',
                  price: double.parse(item['price'].toString()),
                  quantity: item['quantity'],
                );
              }).toList();

              // Créer une nouvelle commande
              final order = Order(
                id: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
                items: orderItems, // Utiliser la liste convertie
                totalAmount: cartProvider.totalPrice(),
                orderDate: DateTime.now(),
                delivery: Delivery(
                  id: "DL002",
                  orderId: "ORD124",
                  status: DeliveryStatus.preparing,
                  estimatedDeliveryTime: DateTime.now().add(const Duration(hours: 3)),
                  driver: drivers[1], // Assurez-vous que `drivers` est défini
                  address: "456 Avenue des Tests, Ville",
                  notes: "Call upon arrival.",
                ),
              );

              // Définir la commande dans OrderProvider
              orderProvider.setOrder(order);

              // Naviguer vers la page de paiement
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
              "Check out",
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