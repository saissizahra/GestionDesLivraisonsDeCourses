import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const OrderSummaryCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Afficher un message si aucun article n'est disponible
    if (items.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Aucun produit dans la commande',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 130, 
            child: ListView(
              scrollDirection: Axis.horizontal, 
              children: items.map((item) => Container(
                width: 100, 
                padding: const EdgeInsets.all(8),
                
                child: Column(
                  children: [
                    Image.network( 
                      item['image_url'], 
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['name'] ?? 'Nom non disponible',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item['price']} MAD x ${item['quantity']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}