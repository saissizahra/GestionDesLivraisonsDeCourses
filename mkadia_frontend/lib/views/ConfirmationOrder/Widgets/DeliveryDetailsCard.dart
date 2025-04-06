import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:provider/provider.dart'; // Pour le formatage de l'heure

class DeliveryDetailsCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const DeliveryDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Extraction sécurisée des données
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
     final String orderId = order['id'].toString(); // Utiliser directement comme String
    // Utilisez l'adresse du controller si elle existe, sinon celle de l'order
    final String address = orderProvider.addressController.text.isNotEmpty
        ? orderProvider.addressController.text
        : order['delivery_address'] ?? 'Adresse non spécifiée';

    // Formatage de l'heure sans secondes
    String formattedTime = 'Heure non estimée';
    try {
      final deliveryTime = order['delivery']?['estimated_delivery_time']?.toString();
      if (deliveryTime != null) {
        final dateTime = DateTime.parse(deliveryTime);
        formattedTime = DateFormat('HH:mm').format(dateTime); // Format 24h sans secondes
      }
    } catch (e) {
      debugPrint('Erreur de formatage: $e');
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Votre commande Mkadia est en route !',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            'Commande #$orderId',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 15),

          const Text(
            'Adresse de livraison :',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.location_on, size: 20, color: Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          const Text(
            'Livraison estimée :',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.access_time, size: 20, color: Colors.grey),
              const SizedBox(width: 10),
              Text(
                formattedTime,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}