import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const OrderSummaryCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Debug the items we're getting
    print('Items reçus: ${items.length}');
    print('OrderSummaryCard items: $items');
    
    // Afficher un message si aucun article n'est disponible
    if (items.isEmpty) {
      print('Aucun item à afficher');
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Aucun produit dans la commande',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
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
            height: 150, 
            child: ListView(
              scrollDirection: Axis.horizontal, 
              children: items.map((item) {
                // Get image URL from multiple possible fields
                final imageUrl = item['image_url'] ?? item['image'] ?? 
                  'https://via.placeholder.com/60?text=No+Image';
                
                return Container(
                  width: 100, 
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Image.network( 
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => 
                          Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported, color: Colors.grey),
                          ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['name'] ?? 'Nom non disponible',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${item['price']} MAD x ${item['quantity'] ?? 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}