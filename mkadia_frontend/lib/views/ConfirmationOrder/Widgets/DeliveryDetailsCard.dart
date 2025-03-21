import 'package:flutter/material.dart';

class DeliveryDetailsCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const DeliveryDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Extraire les données de la commande
    final int orderId = order['id'];
    final Map<String, dynamic> delivery = order['delivery'];
    final String address = delivery['address'];
    final String estimatedDeliveryTime = delivery['estimated_delivery_time'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your order from Mkadia is on its way!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            'Order code: $orderId',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 15),

          const Text(
            'Ship to:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.location_on, size: 20, color: Colors.grey),
              const SizedBox(width: 10),
              Text(
                address,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 15),

          const Text(
            'Ship at:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.access_time, size: 20, color: Colors.grey),
              const SizedBox(width: 10),
              Text(
                estimatedDeliveryTime,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}