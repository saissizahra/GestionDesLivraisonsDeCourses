import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';

class AdminOrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const AdminOrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commande #${order['id']}'),
        backgroundColor: TColor.primaryText,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Statut', order['order_status']),
            const SizedBox(height: 16),
            _buildInfoCard('Adresse', order['delivery_address']),
            const SizedBox(height: 16),
            _buildInfoCard(
              'Montant total',
              '${order['total_amount']} MAD',
            ),
            const SizedBox(height: 24),
            const Text(
              'Articles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...order['items'].map<Widget>((item) {
              return ListTile(
                leading: Image.network(
                  item['product']['image_url'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(item['product']['name']),
                subtitle: Text('${item['quantity']} x ${item['price']} MAD'),
                trailing: Text('${item['total']} MAD'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              '$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}