import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/OrderProvider.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/services/api_service.dart';
import 'package:mkadia/views/ConfirmationOrder/OrderConfirmationPage.dart';
import 'package:mkadia/views/home/widget/navbar.dart';
import 'package:provider/provider.dart';

class ZPaymentDetailsCard extends StatefulWidget {
  final double totalProducts;
  final double tax;
  final double deliveryFee;
  final double totalAmount;

  const ZPaymentDetailsCard({
    super.key,
    required this.totalProducts,
    required this.tax,
    required this.deliveryFee,
    required this.totalAmount,
  });

  @override
  _ZPaymentDetailsCardState createState() => _ZPaymentDetailsCardState();
}

class _ZPaymentDetailsCardState extends State<ZPaymentDetailsCard> {
  String _promoCode = '';
  double _discount = 0.0;
  double _finalTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _finalTotal = widget.totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Container(
      height: 415,
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

          // Champ pour le code promo
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
                  // Valider et appliquer le code promo
                  final response = await ApiService.verifyPromoCode(_promoCode);
                  if (response['status'] == true) {
                    final applyResponse = await ApiService.applyPromoCode(
                      _promoCode,
                      widget.totalAmount,
                    );
                    if (applyResponse['status'] == true) {
                      setState(() {
                        _discount = double.parse(applyResponse['discount'].toString());
                        _finalTotal = widget.totalProducts + widget.tax + widget.deliveryFee - _discount;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Promo code applied! Discount: $_discount MAD'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(applyResponse['message'])),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'])),
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
                "${widget.deliveryFee} MAD",
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
              final orderProvider = Provider.of<OrderProvider>(context, listen: false);
              
              if (orderProvider.addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez entrer une adresse de livraison')),
                );
                return;
              }
              _placeOrder(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primaryText,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Confirmer la commande",
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

Future<void> _placeOrder(BuildContext context) async {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  final orderProvider = Provider.of<OrderProvider>(context, listen: false);
  
  try {
    if (orderProvider.addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer une adresse valide')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final orderResponse = await cartProvider.confirmOrder(
      context,
      widget.tax,
      widget.deliveryFee,
      _promoCode.isNotEmpty ? _promoCode : null,
      orderProvider.addressController.text, 
    );

    debugPrint('Commande créée avec ID: ${orderResponse['id']}');

    if (context.mounted) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>const BottomNavBar(),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }
}
}