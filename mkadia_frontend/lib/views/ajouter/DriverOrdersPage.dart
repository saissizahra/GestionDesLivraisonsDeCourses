import 'package:flutter/material.dart';
import 'package:mkadia/services/OrderApiService.dart';

class DriverOrdersPage extends StatefulWidget {
  final int driverId; // Type explicitement défini comme int
  
  const DriverOrdersPage({Key? key, required this.driverId}) : super(key: key);

  @override
  _DriverOrdersPageState createState() => _DriverOrdersPageState();
}

class _DriverOrdersPageState extends State<DriverOrdersPage> {
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

Future<void> _loadOrders() async {
  try {
    final response = await OrderApiService.getDriverOrders(widget.driverId);
    
    // Debug amélioré
    if (response.isNotEmpty) {
      debugPrint('Structure complète de la première commande: ${response[0]}');
    }

    setState(() {
      _orders = response.cast<Map<String, dynamic>>();
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _error = 'Erreur: ${e.toString()}';
      _isLoading = false;
    });
    debugPrint('Erreur détaillée: ${e.toString()}');
  }
}

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mes Livraisons'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : _orders.isEmpty
                    ? const Center(child: Text('Aucune livraison assignée'))
                    : ListView.builder(
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          
                          // Solution la plus robuste
                          final phone = order['phone']?? 'phone non reconnu';            
                          final deliveryAddress = order['delivery_address']?.toString() ?? 'Adresse inconnue';
                          final status = _getStatusText(order['order_status'] ?? order['status'] ?? 'inconnu');

                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              title: Text('Commande #${order['id']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Statut: $status'),
                                  Text('Adresse: $deliveryAddress'),
                                  Text('Téléphone: $phone'), // Utilisation de la variable pré-calculée
                                ],
                              ),
                              trailing: _buildActionButton(order),
                              onTap: () => _showOrderDetails(order),
                            ),
                          );
                        },
                      )
      );
    }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed': return 'Confirmée';
      case 'assigned': return 'Assignée';
      case 'in_progress': return 'En cours';
      case 'delivered': return 'Livrée';
      default: return status; // Retourne la valeur originale si non reconnue
    }
  }

  Widget? _buildActionButton(Map<String, dynamic> order) {
    final status = order['order_status'] ?? order['status'];
    
    switch (status) {
      case 'assigned':
        return ElevatedButton(
          child: const Text('Commencer'),
          onPressed: () => _updateOrderStatus(order['id'], 'in_progress'),
        );
      case 'in_progress':
        return ElevatedButton(
          child: const Text('Livrer'),
          onPressed: () => _updateOrderStatus(order['id'], 'delivered'),
        );
      default:
        return null;
    }
  }

  Future<void> _updateOrderStatus(int orderId, String status) async {
    try {
      await OrderApiService.updateOrderStatus(orderId, status);
      await _loadOrders(); // Recharger les données après mise à jour
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Commande #${order['id']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statut: ${_getStatusText(order['order_status'] ?? order['status'])}'),
              const SizedBox(height: 8),
              Text('Adresse: ${order['delivery_address']}'),
              const SizedBox(height: 16),
              const Text('Articles:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...(order['items'] as List?)?.map<Widget>((item) => 
                ListTile(
                  title: Text(item['product_name'] ?? 'Produit inconnu'),
                  subtitle: Text('${item['quantity']} x ${item['price']}'),
                )
              ) ?? [const Text('Aucun article')],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}