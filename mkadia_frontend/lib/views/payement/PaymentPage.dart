import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/provider/PayementManager.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/views/ConfirmationOrder/Widgets/OrderSummaryCard.dart';
import 'package:mkadia/views/payement/widgets/ZPaymentDetailsCard.dart';
import 'package:provider/provider.dart';


class PaymentPage extends StatelessWidget {
  final PaymentManager paymentManager;
  final CartProvider cartProvider;
  
  const PaymentPage({super.key, required this.paymentManager, required this.cartProvider});

  @override
  Widget build(BuildContext context) {

  Provider.of<CartProvider>(context);
  final orderProvider = Provider.of<OrderProvider>(context);
  final temporaryOrder = orderProvider.temporaryOrder;

    if (temporaryOrder == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Paiement'),
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: const Center(
          child: Text('Aucune commande trouvée'),
        ),
      );
    }


    // Accéder aux éléments de la commande en tant que Map
    final items = temporaryOrder['items'] as List<dynamic>;
    final double totalProducts = double.parse(
      (items.fold(0.0, (sum, item) => sum + (double.parse(item['price'].toString()) * item['quantity']))).toStringAsFixed(2)
    );    
    final double tax = double.parse(
      (totalProducts * 0.1).toStringAsFixed(2)
    ); 
    final double deliveryFee = 10; 
    final double totalAmount = double.parse((totalProducts + tax + deliveryFee).toStringAsFixed(2));


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
              "Paiement",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            OrderSummaryCard(items: cartProvider.cart),
            // Remplacez la Card actuelle par ce TextField
            const Text(
              'Adresse de Livraison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: orderProvider.addressController,
              decoration: InputDecoration(
                hintText: 'Entrez votre adresse complète',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              maxLines: 3,
               onChanged: (value) {
                // Sauvegardez l'adresse dans le provider immédiatement
                orderProvider.currentOrder?['delivery_address'] = value;
              },
            ),

            ZPaymentDetailsCard(
              totalProducts: totalProducts,
              tax: tax,
              deliveryFee: deliveryFee,
              totalAmount: totalAmount,
            ),
          ],
        ),
      ),
    );
  }


}