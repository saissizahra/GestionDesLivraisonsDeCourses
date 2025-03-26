import 'package:flutter/material.dart';
import 'package:mkadia/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mkadia/services/OrderApiService.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:intl/intl.dart';
import 'package:mkadia/views/cart/cart.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserOrders();
  }

  Future<void> _fetchUserOrders() async {
    try {
      final orders = await OrderApiService.getUserOrders(1);
      
      // Trier les commandes du plus récent au plus ancien
      orders.sort((a, b) {
        final dateA = DateTime.parse(a['order_date'] ?? DateTime.now().toString());
        final dateB = DateTime.parse(b['order_date'] ?? DateTime.now().toString());
        return dateB.compareTo(dateA); // Ordre décroissant
      });

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Impossible de charger les commandes';
        _isLoading = false;
      });
      debugPrint('Erreur lors du chargement des commandes: $e');
    }
  }

  void _reorderAndNavigate(List<dynamic> items) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    try {
      for (final item in items) {
        if (item['product_id'] != null) {
          final productResponse = await ApiService.fetchProductById(item['product_id']);
          final productData = productResponse['product'];
          
          final existingIndex = cartProvider.cart.indexWhere(
            (p) => p['id'].toString() == productData['id'].toString()
          );
          
          if (existingIndex >= 0) {
            cartProvider.incrementQtn(
              productData['id'].toString(),
              by: item['quantity'] ?? 1,
            );
          } else {
            cartProvider.toggleFavorite(
              {
                'id': productData['id'],
                'name': productData['name'],
                'price': double.tryParse(productData['price']?.toString() ?? '0') ?? 0.0,
                'image_url': productData['image_url'] ?? '',
                'category': productData['category'] ?? {'name': 'Non catégorisé'},
              },
              item['quantity'] ?? 1,
            );
          }
        }
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Cart()),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Articles ajoutés au panier')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Historique de commande",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_error!),
                        ElevatedButton(
                          onPressed: _fetchUserOrders,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  )
                : _orders.isEmpty
                    ? const Center(child: Text('Aucune commande trouvée'))
                    : ListView.builder(
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          final date = DateTime.parse(order['order_date'] ?? DateTime.now().toString()).toLocal();
                          final items = order['items'] as List<dynamic>? ?? [];
                          final total = double.tryParse(order['total_amount']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // En-tête avec numéro de commande et date
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Commande ${order['id']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yyyy - HH:mm').format(date),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  
                                  // Liste des articles
                                  if (items.isNotEmpty) ...[
                                    const Text(
                                      'Articles:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 90,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: items.length,
                                        itemBuilder: (context, itemIndex) {
                                          final item = items[itemIndex];
                                          final product = item['product'] ?? {};
                                          final imageUrl = product['image_url']?.toString() ?? '';
                                          final productName = product['name']?.toString() ?? 'Produit';
                                          final quantity = item['quantity']?.toString() ?? '1';

                                          return Container(
                                            width: 90,
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: imageUrl.isNotEmpty
                                                        ? DecorationImage(
                                                            image: NetworkImage(imageUrl),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null,
                                                  ),
                                                  child: imageUrl.isEmpty
                                                      ? const Icon(Icons.shopping_bag, color: Colors.grey)
                                                      : null,
                                                ),
                                                const SizedBox(height: 5),
                                                // Nom du produit seul
                                                Text(
                                                  productName,
                                                  style: const TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                // Quantité toujours en dessous
                                                Text(
                                                  'x$quantity',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: TColor.primaryText,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),                          
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                
                                  // Pied de carte avec total et bouton
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total: $total €',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: TColor.primaryText,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                          ),
                                          onPressed: () => _reorderAndNavigate(items),
                                          child: const Text(
                                            'Commander à nouveau',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}