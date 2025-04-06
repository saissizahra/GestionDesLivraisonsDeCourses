import 'package:flutter/material.dart';
import 'package:mkadia/views/Delivery/DeliveryTrackingPage.dart';
import 'package:mkadia/views/home/widget/navbar.dart';

class NavigationButtons extends StatelessWidget {
  final Map<String, dynamic> orderData; // Ajoutez ce paramètre

  const NavigationButtons({
    super.key,
    required this.orderData, // Marquez-le comme requis
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryTrackingPage(order: orderData),
                ),
              );
            },
            child: const Text('Suivre la livraison'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(),
                ),
                (route) => false,
              );
            },
            child: const Text('Retour à l\'accueil'),
          ),
        ],
      ),
    );
  }
}