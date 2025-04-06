import 'dart:async';

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
  Timer? _refreshTimer; // Utilisez un Timer nullable

  @override
  void initState() {
    super.initState();
    _order = Map<String, dynamic>.from(widget.order);
    _setupAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); // Annulez seulement si le timer existe
    super.dispose();
  }

  void _setupAutoRefresh() {
    _refreshTimer?.cancel(); // Annulez le timer existant
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) _refreshOrderStatus();
    });
  }
Future<void> _refreshOrderStatus() async {
  try {
    if (!mounted || _isLoading) return;
    
    setState(() => _isLoading = true);
    final updatedOrder = await OrderApiService.getOrderDetails(_order['id']);
    
    if (!mounted) return;
    
    setState(() {
      _order = updatedOrder;
      _isLoading = false;
    });
  } catch (e) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    // ... gestion des erreurs
  }
}

  Future<void> _confirmDelivery() async {
    try {
      setState(() => _isLoading = true);
      
      // Vérification finale du statut avant confirmation
      await _refreshOrderStatus();
      if (_order['order_status'] != 'delivered') {
        throw Exception('La commande doit être marquée comme "livrée" avant confirmation');
      }

      final updatedOrder = await OrderApiService.updateOrderStatus(
        _order['id'], 
        'completed'
      );
      
      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DeliveryConfirmationPage(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
final orderStatus = _order['order_status']?.toString() ?? 
                   _order['status']?.toString() ?? 
                   'confirmed';
final driver = _order['driver'] as Map<String, dynamic>?;
    final deliveryAddress = _order['delivery_address']?.toString() ?? 'Adresse non spécifiée';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de Commande'),
        backgroundColor: TColor.primaryText,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: TColor.primary),
            onPressed: _isLoading ? null : _refreshOrderStatus,
          ),
        ],
      ),
      body: _buildTrackingBody(orderStatus, driver, deliveryAddress),
    );
  }

  Widget _buildTrackingBody(String orderStatus, Map<String, dynamic>? driver, String address) {
    return RefreshIndicator(
      onRefresh: _refreshOrderStatus,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatusIndicator(orderStatus),
            const SizedBox(height: 24),
            _buildDriverCard(driver),
            const SizedBox(height: 20),
            _buildAddressCard(address),
            if (orderStatus == 'delivered') _buildConfirmationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String currentStatus) {
    final steps = [
      {'status': 'confirmed', 'label': 'Confirmée'},
      {'status': 'assigned', 'label': 'Assignée'},
      {'status': 'in_progress', 'label': 'En cours'},
      {'status': 'delivered', 'label': 'Livrée'},
      {'status': 'completed', 'label': 'Terminée'},
    ];
    
    final currentIndex = steps.indexWhere((step) => step['status'] == currentStatus);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: steps.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                final isCompleted = index <= currentIndex;
                final isCurrent = index == currentIndex;
                
                return Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? TColor.primaryText : Colors.grey[200],
                        border: isCurrent ? Border.all(color: TColor.primary, width: 2) : null,
                      ),
                      child: isCompleted
                          ? Icon(Icons.check, size: 20, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step['label']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted ? TColor.primaryText : Colors.grey,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: currentIndex >= 0 ? (currentIndex + 1) / steps.length : 0,
              backgroundColor: Colors.grey[200],
              color: TColor.primaryText,
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

// Dans _buildDriverCard, ajoutez une gestion plus robuste
Widget _buildDriverCard(Map<String, dynamic>? driverData) {
  final driver = driverData ?? {
    'name': 'En attente de livreur',
    'phone': '--',
  };

  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LIVREUR',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TColor.primary.withOpacity(0.2),
              ),
              child: Icon(Icons.person, color: TColor.primary),
            ),
            title: Text(
              driver['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(driver['phone']),
          ),
          if (_order['driver_id'] != null && driverData == null)
            Text(
              'ID Livreur: ${_order['driver_id']}',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
        ],
      ),
    ),
  );
}

  Widget _buildAddressCard(String address) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ADRESSE DE LIVRAISON',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, color: TColor.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: TColor.primaryText,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _isLoading ? null : _confirmDelivery,
          child: _isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text(
                  'CONFIRMER LA LIVRAISON',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}