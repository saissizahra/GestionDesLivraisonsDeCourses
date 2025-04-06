import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/services/OrderApiService.dart';
import 'package:mkadia/views/Delivery/ConfirmationPage.dart';

class DeliveryTrackingPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const DeliveryTrackingPage({Key? key, required this.order}) : super(key: key);

  @override
  State<DeliveryTrackingPage> createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  late Map<String, dynamic> _order;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _order = Map<String, dynamic>.from(widget.order);
  }

  Future<void> _refreshOrderStatus() async {
    try {
      setState(() => _isLoading = true);
      final updatedOrder = await OrderApiService.getOrderDetails(_order['id']);
      setState(() {
        _order = updatedOrder;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<void> _confirmDelivery() async {
    try {
      setState(() => _isLoading = true);
      await OrderApiService.confirmDelivery(_order['id']);
      
      // Après confirmation, naviguer vers DeliveryConfirmationPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DeliveryConfirmationPage(),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Valeurs par défaut sécurisées
    final orderId = _order['id']?.toString() ?? 'N/A';
    final orderStatus = _order['order_status']?.toString() ?? 'confirmed';
    final driver = _order['driver'] as Map<String, dynamic>?;
    final deliveryAddress = _order['delivery_address']?.toString() ?? 'Adresse non spécifiée';

    final steps = [
      {'status': 'confirmed', 'label': 'Confirmée'},
      {'status': 'assigned', 'label': 'Assignée'},
      {'status': 'in_progress', 'label': 'En cours'},
      {'status': 'delivered', 'label': 'Livrée'},
      {'status': 'completed', 'label': 'Confirmée par client'},
    ];
    
    final currentIndex = steps.indexWhere((step) => step['status'] == orderStatus);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi Commande'),
        backgroundColor: TColor.primaryText,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshOrderStatus,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrderStatus,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStatusIndicator(steps, currentIndex),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Livreur', style: TextStyle(fontWeight: FontWeight.bold)),
                      if (driver != null) ...[
                        const SizedBox(height: 8),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(driver['name']?.toString() ?? 'Nom inconnu'),
                          subtitle: Text(driver['phone']?.toString() ?? 'Téléphone non disponible'),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        const Text('Aucun livreur assigné', style: TextStyle(color: Colors.grey)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Adresse', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(deliveryAddress),
                    ],
                  ),
                ),
              ),
              
              // Bouton de confirmation pour le client quand la commande est livrée
              if (orderStatus == 'delivered')
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primaryText,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: _isLoading ? null : _confirmDelivery,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text('Confirmer la livraison', style: TextStyle(fontSize: 16)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(List<Map<String, dynamic>> steps, int currentIndex) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: steps.map((step) {
                final index = steps.indexOf(step);
                final isCompleted = index <= currentIndex;
                
                return Column(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? TColor.primaryText : Colors.grey[300],
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 18, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 4),
                    Text(step['label']!, style: TextStyle(fontSize: 11)),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: currentIndex >= 0 ? (currentIndex + 1) / steps.length : 0,
              backgroundColor: Colors.grey[300],
              color: TColor.primaryText,
            ),
          ],
        ),
      ),
    );
  }
}