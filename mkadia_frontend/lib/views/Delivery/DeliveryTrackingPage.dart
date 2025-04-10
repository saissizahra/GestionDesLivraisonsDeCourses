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
    debugPrint('Statut initial: ${_order['order_status']}');
    debugPrint('Driver data: ${_order['driver']}');
  }

Future<void> _refreshOrderStatus() async {
  try {
    setState(() => _isLoading = true);
    final updatedOrder = await OrderApiService.getOrderDetails(_order['id']);
    
    setState(() {
      // Préserver les données existantes si les nouvelles données sont incomplètes
      _order = {
        ..._order, // Conserve les anciennes données
        ...updatedOrder, // Applique les nouvelles données
      };
      _isLoading = false;
    });
    
    debugPrint('Statut après rafraîchissement: ${_order['order_status']}');
  } catch (e) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur lors du rafraîchissement: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final orderStatus = _order['order_status']?.toString() ?? 'confirmed';
    final driver = _order['driver'] as Map<String, dynamic>?;
    final deliveryAddress = _order['delivery_address']?.toString() ?? 'Adresse non spécifiée';

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
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
                onPressed: _refreshOrderStatus,
              ),
            ],
            title: const Text(
              "Suivi de commande",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrderStatus,
        color: TColor.primaryText,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Text(
                  "Suivez votre commande en temps réel",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryText,
                  ),
                ),
              ),

              // Carte d'adresse
              _buildInfoCard(
                icon: Icons.location_on,
                title: "Adresse de livraison",
                content: deliveryAddress,
              ),

              // Carte du livreur - Afficher si le statut est 'assigned' ou supérieur
              if (driver != null && _shouldShowDriver(orderStatus))
                _buildDriverCard(driver),

              // Timeline avec 4 étapes
              const SizedBox(height: 16),
              Text(
                "Progression de votre commande",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: TColor.primaryText,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatusTimeline(orderStatus),

              // Bouton de confirmation - Apparaît seulement quand le statut est 'delivered'
              if (orderStatus == 'delivered') ...[
                const SizedBox(height: 30),
                _buildDeliveryConfirmationButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String content}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: TColor.primaryText, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColor.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> driver) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TColor.primaryText.withOpacity(0.1),
              ),
              child: Icon(
                Icons.person,
                size: 30,
                color: TColor.primaryText,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Votre livreur",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    driver['name'] ?? 'Nom non disponible',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver['phone'] ?? 'Téléphone non disponible',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            if (driver['phone'] != null)
              IconButton(
                icon: Icon(Icons.phone, color: TColor.primaryText),
                onPressed: () {
                  // Logique pour appeler le livreur
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryConfirmationButton() {
    return SizedBox(
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
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'CONFIRMER LA LIVRAISON',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

Future<void> _confirmDelivery() async {
  try {
    setState(() => _isLoading = true);
    
    // Utilisez la méthode dédiée confirmDelivery au lieu de updateOrderStatus
    final response = await OrderApiService.confirmDelivery(_order['id']);
    
    // Mettre à jour localement le statut
    setState(() {
      _order['order_status'] = 'completed';
      _isLoading = false;
    });

    // Naviguer vers la page de confirmation
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DeliveryConfirmationPage(),
      ),
    );
    
  } catch (e) {
    setState(() => _isLoading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur de confirmation: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
    debugPrint('Erreur lors de la confirmation: $e');
  }
}

  Widget _buildStatusTimeline(String currentStatus) {
    // Seulement 4 étapes comme demandé
    final steps = [
      {'status': 'confirmed', 'label': 'Commande confirmée', 'icon': Icons.check_circle},
      {'status': 'assigned', 'label': 'Livreur assigné', 'icon': Icons.person_pin},
      {'status': 'in_progress', 'label': 'En cours de livraison', 'icon': Icons.delivery_dining},
      {'status': 'delivered', 'label': 'Livraison effectuée', 'icon': Icons.home},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: steps.map((step) {
            final status = step['status'] as String;
            final label = step['label'] as String;
            final icon = step['icon'] as IconData;
            final isCompleted = _isStepCompleted(currentStatus, status);
            final isCurrent = currentStatus == status;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted ? TColor.primaryText : Colors.grey[200],
                          border: isCurrent 
                              ? Border.all(color: TColor.primaryText, width: 2)
                              : null,
                        ),
                        child: Icon(
                          icon,
                          size: 20,
                          color: isCompleted ? Colors.white : Colors.grey[600],
                        ),
                      ),
                      if (steps.indexOf(step) != steps.length - 1)
                        Container(
                          width: 2,
                          height: 40,
                          color: isCompleted ? TColor.primaryText : Colors.grey[300],
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            fontSize: 15,
                            color: TColor.primaryText,
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(height: 4),
                          Text(
                            _getStatusDescription(currentStatus),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _isStepCompleted(String currentStatus, String stepStatus) {
    final statusOrder = ['confirmed', 'assigned', 'in_progress', 'delivered'];
    return statusOrder.indexOf(currentStatus) >= statusOrder.indexOf(stepStatus);
  }

  bool _shouldShowDriver(String status) {
    final statusOrder = ['confirmed', 'assigned', 'in_progress', 'delivered'];
    return statusOrder.indexOf(status) >= statusOrder.indexOf('assigned');
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'confirmed':
        return 'Votre commande a été confirmée par le restaurant';
      case 'assigned':
        return 'Un livreur a été assigné à votre commande';
      case 'in_progress':
        return 'Votre commande est en chemin';
      case 'delivered':
        return 'Votre commande est arrivée - Merci de confirmer';
      default:
        return 'Statut inconnu';
    }
  }
}