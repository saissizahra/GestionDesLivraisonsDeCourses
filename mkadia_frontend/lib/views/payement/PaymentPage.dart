import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/provider/PayementManager.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/views/ConfirmationOrder/Widgets/OrderSummaryCard.dart';
import 'package:mkadia/views/ConfirmationOrder/Widgets/PaymentDetailsCard.dart';
import 'package:mkadia/views/payement/widgets/ZPaymentDetailsCard.dart';
import 'package:provider/provider.dart';
import 'package:mkadia/models/order.dart';


class PaymentPage extends StatelessWidget {
  final PaymentManager paymentManager;
  final CartProvider cartProvider;
  
  const PaymentPage({super.key, required this.paymentManager, required this.cartProvider});

  @override
  Widget build(BuildContext context) {

    Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.currentOrder;

    if (order == null) {
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


    final double totalProducts = double.parse(
      (order.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity))).toStringAsFixed(2)
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
            Text(
              'Adresse de Livraison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  '${paymentManager.paymentInfo.address}, ${paymentManager.paymentInfo.city}, ${paymentManager.paymentInfo.country}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            const Divider(),

            const SizedBox(height: 16),

            Text(
              'Méthode de Paiement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),

            const SizedBox(height: 8),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sélectionnez une méthode de paiement:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: ['Carte de Crédit', 'PayPal', 'Apple Pay', 'Google Pay'].map((method) {
                        return ElevatedButton(
                          onPressed: () {
                            paymentManager.setSelectedPaymentMethod(method);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: paymentManager.selectedPaymentMethod == method ? Colors.green : Colors.grey[300],
                            foregroundColor: paymentManager.selectedPaymentMethod == method ? Colors.white : Colors.black,
                          ),
                          child: Text(method),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (paymentManager.selectedPaymentMethod == 'Carte de Crédit') ...[
              _buildCreditCardForm(paymentManager),
            ] else if (paymentManager.selectedPaymentMethod == 'PayPal') ...[
              _buildPayPalForm(paymentManager),
            ] else if (paymentManager.selectedPaymentMethod == 'Apple Pay') ...[
              _buildApplePayForm(paymentManager),
            ] else if (paymentManager.selectedPaymentMethod == 'Google Pay') ...[
              _buildGooglePayForm(paymentManager),
            ],

            const SizedBox(height: 16),

            ZPaymentDetailsCard(
              totalProducts: totalProducts,
              tax: tax,
              deliveryFee: deliveryFee,
              totalAmount: totalAmount,
              paymentManager: paymentManager,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardForm(PaymentManager paymentManager) {
    return Column(
      children: [
        TextFormField(
          initialValue: paymentManager.paymentInfo.name,
          decoration: const InputDecoration(labelText: 'Nom sur la carte'),
          onChanged: (value) => paymentManager.updatePaymentInfo(paymentManager.paymentInfo.copyWith(name: value)),
        ),
        TextFormField(
          initialValue: paymentManager.paymentInfo.cardNumber,
          decoration: const InputDecoration(labelText: 'Numéro de carte'),
          keyboardType: TextInputType.number,
          onChanged: (value) => paymentManager.updatePaymentInfo(paymentManager.paymentInfo.copyWith(cardNumber: value)),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: paymentManager.paymentInfo.expiryDate,
                decoration: const InputDecoration(labelText: 'Date d\'expiration'),
                onChanged: (value) => paymentManager.updatePaymentInfo(paymentManager.paymentInfo.copyWith(expiryDate: value)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: paymentManager.paymentInfo.cvv,
                decoration: const InputDecoration(labelText: 'CVV'),
                obscureText: true,
                onChanged: (value) => paymentManager.updatePaymentInfo(paymentManager.paymentInfo.copyWith(cvv: value)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPayPalForm(PaymentManager paymentManager) {
    return Column(
      children: [
        TextFormField(
          initialValue: paymentManager.paymentInfo.paypalEmail,
          decoration: const InputDecoration(labelText: 'E-mail PayPal'),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => paymentManager.updatePaymentInfo(paymentManager.paymentInfo.copyWith(paypalEmail: value)),
        ),
      ],
    );
  }

  Widget _buildApplePayForm(PaymentManager paymentManager) {
    return Column(
      children: [
        TextFormField(
          initialValue: paymentManager.paymentInfo.applePayID,
          decoration: const InputDecoration(labelText: 'Apple Pay ID'),
          keyboardType: TextInputType.text,
          onChanged: (value) => paymentManager.updatePaymentInfo(paymentManager.paymentInfo.copyWith(applePayID: value)),
        ),
      ],
    );
  }

  Widget _buildGooglePayForm(PaymentManager paymentManager) {
    return Column(
      children: [
        TextFormField(
          initialValue: paymentManager.paymentInfo.googlePayID,
          decoration: const InputDecoration(labelText: 'Google Pay ID'),
          keyboardType: TextInputType.text,
          onChanged: (value) => paymentManager.updatePaymentInfo(paymentManager.paymentInfo.copyWith(googlePayID: value)),
        ),
      ],
    );
  }
}