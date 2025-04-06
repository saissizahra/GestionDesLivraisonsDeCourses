import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/UserProvider.dart';
import 'package:mkadia/views/ReviewPage.dart';
import 'package:provider/provider.dart';
import 'package:mkadia/provider/cartProvider.dart';

class PaymentDetailsCard extends StatelessWidget {
  final double totalProducts;
  final double tax;
  final double deliveryFee;
  final double totalAmount;

  const PaymentDetailsCard({
    super.key,
    required this.totalProducts,
    required this.tax,
    required this.deliveryFee,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id;
    final cartProvider = Provider.of<CartProvider>(context);
    // Pour l'ordre, nous utilisons la dernière réponse d'ordre si disponible
    final lastOrder = cartProvider.lastOrderResponse;
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Subtotal",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "$totalProducts MAD",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tax",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "$tax MAD",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Delivery Fee",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "$deliveryFee MAD",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Paid',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "$totalAmount MAD",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Créer un objet ordre basé sur l'état actuel
              final orderData = {
                'id': lastOrder != null ? lastOrder['order_id'] : DateTime.now().millisecondsSinceEpoch.toString(),
                'user_id': userId, // Remplacer par l'ID réel de l'utilisateur
                'total_amount': totalAmount,
                'items': cartProvider.isOrderConfirmed 
                    ? cartProvider.confirmedItems.map((item) => {
                        'product_id': item['id'],
                        'quantity': item['quantity'],
                        'price': item['price'],
                        'product': {
                          'id': item['id'],
                          'name': item['name'],
                          'image_url': item['image'] ?? null
                        }
                      }).toList()
                    : cartProvider.cart.map((item) => {
                        'product_id': item['id'],
                        'quantity': item['quantity'],
                        'price': item['price'],
                        'product': {
                          'id': item['id'],
                          'name': item['name'],
                          'image_url': item['image'] ?? null
                        }
                      }).toList(),
              };
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewPage(order: orderData),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primaryText,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Review",
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