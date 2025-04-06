import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/services/OrderApiService.dart';
import 'package:mkadia/views/ajouter/AdminOrderDetailPage.dart';
import 'package:mkadia/views/ajouter/AssignDriverDialog.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await OrderApiService.getAdminOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commandes à traiter'),
        backgroundColor: TColor.primaryText,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadOrders,
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('Commande #${order['id']}'),
                      subtitle: Text('Statut: ${_getStatusText(order)}'), // Passer l'objet order complet
                      trailing: order['order_status'] == 'confirmed'
                          ? IconButton(
                              icon: const Icon(Icons.assignment_ind),
                              onPressed: () => _showAssignDriverDialog(order),
                            )
                          : null,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminOrderDetailPage(order: order),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  // Modifier cette méthode pour accepter l'objet order complet
  String _getStatusText(Map<String, dynamic> order) {
    switch (order['order_status']) {
      case 'confirmed': 
        return 'Confirmée';
      case 'assigned': 
        return order['driver'] != null 
            ? 'Assignée (${order['driver']['name']})'
            : 'Assignée';
      case 'in_progress': 
        return 'En cours';
      case 'delivered':
        return 'Livrée';
      default: 
        return order['order_status'].toString();
    }
  }

  Future<void> _showAssignDriverDialog(Map<String, dynamic> order) async {
    await showDialog(
      context: context,
      builder: (context) => AssignDriverDialog(
        orderId: order['id'],
        onDriverAssigned: _loadOrders,
      ),
    );
  }
}