import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/views/Delivery/Widgets/DeliveryDetailsCard.dart';
import 'package:mkadia/views/ConfirmationOrder/Widgets/OrderSummaryCard.dart';
import 'package:mkadia/views/ConfirmationOrder/Widgets/PaymentMethodCard.dart';
import 'package:mkadia/views/Delivery/Widgets/PaymentDetailsCard.dart';
import 'package:provider/provider.dart';

class DeliveryConfirmationPage extends StatelessWidget {
  const DeliveryConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.currentOrder;

    // Déterminer quels articles afficher (cart ou confirmedItems)
    final itemsToDisplay = cartProvider.cart.isEmpty && cartProvider.isOrderConfirmed 
        ? cartProvider.confirmedItems 
        : cartProvider.cart;

    // Si aucune commande n'existe
    if (order == null && itemsToDisplay.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white, 
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
                icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "Delivery Confirmation",
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
            children: [
              Image.asset(
                'assets/img/panier.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                "Vous n'avez pas encore passé de commande.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primaryText,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  "Retourner au panier",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // *Si une commande existe
    
    // Calculer le total basé sur les articles affichés
    final double totalProducts = double.parse(
      (itemsToDisplay.fold(0.0, (sum, item) => sum + (double.parse(item['price'].toString()) * item['quantity']))).toStringAsFixed(2)
    );    
    final double tax = double.parse(
      (totalProducts * 0.1).toStringAsFixed(2)
    ); 
    final double deliveryFee = 10; 
    final double totalAmount = double.parse((totalProducts + tax + deliveryFee).toStringAsFixed(2));
    
    return Scaffold(
      backgroundColor: Colors.white, 
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
              icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Delivery Confirmation",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (order != null) DeliveryDetailsCard(order: order),            
            const PaymentMethodCard(),
            OrderSummaryCard(items: itemsToDisplay),
            PaymentDetailsCard(  
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