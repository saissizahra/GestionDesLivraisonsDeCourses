// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const ReviewPage({super.key, required this.order});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _deliveryRating = 0;
  final Map<String, int> _productRatings = {};
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    for (var item in widget.order['items']) {
      _productRatings[item['product_id'].toString()] = 0;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    setState(() => _isSubmitting = true);
    
    try {
      final reviewData = {
        'order_id': widget.order['id'].toString(),
        'user_id': 1,
        'delivery_rating': _deliveryRating,
        'comment': _commentController.text,
        'product_reviews': _productRatings.entries.map((entry) => {
          'product_id': entry.key,
          'rating': entry.value,
        }).toList(),
      };

      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reviewData),
      );

      if (response.statusCode == 201) {
        setState(() {
          _isSubmitted = true;
          _isSubmitting = false;
        });
        Provider.of<CartProvider>(context, listen: false).clearConfirmedItems();
        Provider.of<CartProvider>(context, listen: false).resetOrder();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Votre évaluation a été envoyée avec succès!')),
        );
        
        Future.delayed(const Duration(seconds: 2), () => Navigator.of(context).pop());
      } else {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response.statusCode}. Veuillez réessayer.')),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Une erreur est survenue: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Évaluation de commande",
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
      body: _isSubmitted ? _buildSuccessContent() : _buildReviewForm(),
    );
  }

  Widget _buildSuccessContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: TColor.primaryText, size: 100),
          const SizedBox(height: 20),
          const Text(
            "Merci pour votre évaluation !",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Votre avis nous aide à améliorer nos services.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Évaluation de la livraison
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Évaluation de la livraison",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => IconButton(
                    iconSize: 30,
                    onPressed: () => setState(() => _deliveryRating = index + 1),
                    icon: Icon(
                      index < _deliveryRating ? Icons.star : Icons.star_border,
                      color: index < _deliveryRating ? Colors.amber : Colors.grey,
                    ),
                  )),
                ),
              ],
            ),
          ),

          const Divider(thickness: 1, height: 30),

          // Évaluation des produits
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Évaluation des produits",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children: widget.order['items'].map<Widget>((item) {
                    final productId = item['product_id'].toString();
                    final product = item['product'] ?? item;
                    final productName = product['name']?.toString() ?? 'Produit inconnu';
                    final quantity = item['quantity']?.toString() ?? '1';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '$productName x$quantity',
                              style: const TextStyle(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: List.generate(5, (starIndex) => IconButton(
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                setState(() {
                                  _productRatings[productId] = starIndex + 1;
                                });
                              },
                              icon: Icon(
                                starIndex < (_productRatings[productId] ?? 0) 
                                    ? Icons.star 
                                    : Icons.star_border,
                                color: starIndex < (_productRatings[productId] ?? 0) 
                                    ? Colors.amber 
                                    : Colors.grey,
                              ),
                            )),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const Divider(thickness: 1, height: 30),

          // Commentaire
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Commentaire",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Partagez votre expérience...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Bouton de soumission
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting || _deliveryRating == 0 ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryText,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isSubmitting 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Soumettre l'évaluation",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}