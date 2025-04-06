import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/views/ConfirmationOrder/Widgets/DeliveryDetailsCard.dart';
import 'package:mkadia/views/ConfirmationOrder/Widgets/OrderSummaryCard.dart';
import 'package:mkadia/views/ConfirmationOrder/Widgets/PaymentDetailsCard.dart';
import 'package:provider/provider.dart';

class OrderConfirmationPage extends StatelessWidget {
  final Map<String, dynamic>? order;

  const OrderConfirmationPage({super.key, this.order});
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.currentOrder;

    final itemsToDisplay = cartProvider.confirmedItems;

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
              title: Text(
                "Order detail",
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
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Image.asset(
                'assets/img/panier.png',
                width: 300,
                height: 300,
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
            ],
          ),
        ),
      );
    }

    // *Si une commande existe
    
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
            title: Text(
              "Order detail",
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
            const SizedBox(height: 20,), 
            OrderSummaryCard(items: itemsToDisplay),
            PaymentDetailsCard(  
              orderData: orderProvider.currentOrder ?? {'items': itemsToDisplay},
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