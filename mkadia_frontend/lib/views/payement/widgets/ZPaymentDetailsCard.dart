// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/models/delivery.dart';
import 'package:mkadia/models/driver.dart';
import 'package:mkadia/models/order.dart';
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/provider/PayementManager.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/services/api_service.dart';
import 'package:mkadia/views/ConfirmationOrder/OrderConfirmationPage.dart';
import 'package:mkadia/views/Delivery/TrackingPage.dart';
import 'package:mkadia/views/home/widget/navbar.dart';
import 'package:provider/provider.dart';

class ZPaymentDetailsCard extends StatefulWidget {
  final double totalProducts;
  final double tax;
  final double deliveryFee;
  final double totalAmount;
  final PaymentManager paymentManager;

  const ZPaymentDetailsCard({
    super.key,
    required this.totalProducts,
    required this.tax,
    required this.deliveryFee,
    required this.totalAmount,
    required this.paymentManager,
  });

  @override
  _ZPaymentDetailsCardState createState() => _ZPaymentDetailsCardState();
}

class _ZPaymentDetailsCardState extends State<ZPaymentDetailsCard> {
  String _promoCode = '';
  double _discount = 0.0;
  double _finalTotal = 0.0;
  final TextEditingController _addressController = TextEditingController(); // Ajouter un contrôleur pour l'adresse

  @override
  void initState() {
    super.initState();
    _finalTotal = widget.totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 415, // Ajuster la hauteur pour accommoder le champ d'adresse
      width: double.infinity,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          // Champ pour l'adresse de livraison
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'Entrez votre adresse de livraison',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 15),

          // Ajout du champ pour le code promo
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 15,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    hintText: "Enter Discount Code",
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _promoCode = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () async {
                  // Réinitialiser les frais de livraison à la valeur par défaut
                  widget.paymentManager.updateDeliveryFee(10);

                  // Valider et appliquer le code promo
                  final response = await ApiService.verifyPromoCode(_promoCode);
                  if (response['status'] == true) {
                    final applyResponse = await ApiService.applyPromoCode(
                      _promoCode,
                      widget.totalAmount,
                    );
                    if (applyResponse['status'] == true) {
                      setState(() {
                        // Convertir les valeurs en double
                        _discount = double.parse(applyResponse['discount'].toString());

                        // Mettre à jour les frais de livraison si le code promo est de type free_shipping
                        if (applyResponse['promotion']['type'] == 'free_shipping') {
                          widget.paymentManager.updateDeliveryFee(0); // Mettre à jour les frais de livraison à 0
                        }

                        // Recalculer le montant total
                        _finalTotal = widget.totalProducts + widget.tax + widget.paymentManager.deliveryFee - _discount;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Promo code applied! Discount: $_discount MAD'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(applyResponse['message']),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response['message']),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: TColor.primaryText,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Apply",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Afficher la réduction appliquée
          if (_discount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Discount",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "-$_discount MAD",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Subtotal",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "${widget.totalProducts} MAD",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tax",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "${widget.tax} MAD",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Delivery Fee",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "${widget.paymentManager.deliveryFee} MAD",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$_finalTotal MAD",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Vérifier que l'adresse de livraison est remplie
              if (_addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez entrer une adresse de livraison')),
                );
                return;
              }

              widget.paymentManager.savePaymentInfo(context);
              _placeOrder(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primaryText,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Confirmer et Payer",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Récupérer la commande actuelle avant de la confirmer
    final currentOrder = orderProvider.currentOrder;

    cartProvider.confirmOrder(
      context,
      widget.tax,
      widget.paymentManager.deliveryFee,
      _promoCode,
      _addressController.text, 
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BottomNavBar()),
    );
  }
}