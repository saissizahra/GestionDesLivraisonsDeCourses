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
  List<dynamic> _filteredOrders = [];
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
        // Filtrer les commandes pour exclure 'completed' et 'delivered'
        _filteredOrders = _orders.where((order) {
          return order['order_status'] != 'completed' && 
                 order['order_status'] != 'delivered';
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: AppBar(
            toolbarHeight: 80,
            backgroundColor: TColor.primaryText,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Commandes à traiter",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadOrders,
              color: TColor.primaryText,
              child: _filteredOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 60, color: Colors.green),
                          const SizedBox(height: 20),
                          Text(
                            "Toutes les commandes sont traitées",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Aucune commande en attente",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredOrders.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final order = _filteredOrders[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminOrderDetailPage(order: order),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Commande #${order['id']}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (order['order_status'] == 'confirmed')
                                        IconButton(
                                          icon: Icon(Icons.person_add,
                                              color: TColor.primaryText),
                                          onPressed: () => _showAssignDriverDialog(order),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Statut: ',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        _getStatusText(order),
                                        style: TextStyle(
                                          color: _getStatusColor(order),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  Color _getStatusColor(Map<String, dynamic> order) {
    switch (order['order_status']) {
      case 'confirmed':
        return Colors.orange;
      case 'assigned':
        return Colors.blue;
      case 'in_progress':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(Map<String, dynamic> order) {
    switch (order['order_status']) {
      case 'confirmed': 
        return 'Confirmée';
      case 'assigned': 
        return order['driver'] != null 
            ? 'Assignée (${order['driver']['name']})'
            : 'Assignée';
      case 'in_progress': 
        return 'En cours de livraison';
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