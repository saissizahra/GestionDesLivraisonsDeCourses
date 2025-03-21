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
  int _serviceRating = 0;
  final Map<String, int> _productRatings = {};
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    // Initialiser les ratings des produits à 0
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
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Construire les données de review
      final reviewData = {
        'order_id': widget.order['id'].toString(),
        'user_id': 1, // Remplacer par l'ID de l'utilisateur actuel si disponible
        'delivery_rating': _deliveryRating, // Supprimez `service_rating`
        'comment': _commentController.text,
        'product_reviews': _productRatings.entries.map((entry) => {
          'product_id': entry.key,
          'rating': entry.value,
        }).toList(),
      };

      print('Envoi des données de review: $reviewData');

      // Envoyer les données à l'API
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reviewData),
      );

      if (response.statusCode == 201) {
        print('Review soumise avec succès: ${response.body}');
        setState(() {
          _isSubmitted = true;
          _isSubmitting = false;
        });

        // Réinitialiser l'état du panier si nécessaire
        Provider.of<CartProvider>(context, listen: false).clearConfirmedItems();
        Provider.of<CartProvider>(context, listen: false).resetOrder();

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Votre évaluation a été envoyée avec succès!')),
        );

        // Attendre avant de revenir à l'écran précédent
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      } else {
        print('Erreur lors de l\'envoi de la review: ${response.body}');
        setState(() {
          _isSubmitting = false;
        });
        
        // Afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response.statusCode}. Veuillez réessayer.')),
        );
      }
    } catch (e) {
      print('Exception lors de l\'envoi de la review: $e');
      setState(() {
        _isSubmitting = false;
      });
      
      // Afficher un message d'erreur
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
      body: _isSubmitted 
        ? _buildSuccessContent() 
        : _buildReviewForm(),
    );
  }

  Widget _buildSuccessContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: TColor.primaryText,
            size: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            "Merci pour votre évaluation !",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Votre avis nous aide à améliorer nos services.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Évaluation du service
          _buildRatingSection(
            title: "Évaluation du service",
            onRatingUpdate: (rating) {
              setState(() {
                _serviceRating = rating;
              });
            },
            rating: _serviceRating,
          ),
          
          const SizedBox(height: 20),
          
          // Évaluation de la livraison
          _buildRatingSection(
            title: "Évaluation de la livraison",
            onRatingUpdate: (rating) {
              setState(() {
                _deliveryRating = rating;
              });
            },
            rating: _deliveryRating,
          ),
          
          const SizedBox(height: 20),
          
          // Liste des produits à évaluer
          const Text(
            "Évaluation des produits",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 10),
          
          _buildProductRatingsList(),
          
          const SizedBox(height: 20),
          
          // Champ de commentaire
          const Text(
            "Commentaire",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 10),
          
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: "Partagez votre expérience...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            maxLines: 4,
          ),
          
          const SizedBox(height: 30),
          
          // Bouton de soumission
          ElevatedButton(
            onPressed: _isSubmitting || _serviceRating == 0 || _deliveryRating == 0 
                ? null 
                : _submitReview,
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
        ],
      ),
    );
  }

  Widget _buildRatingSection({
    required String title,
    required Function(int) onRatingUpdate,
    required int rating,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              iconSize: 30,
              onPressed: () => onRatingUpdate(index + 1),
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: index < rating ? Colors.amber : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProductRatingsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.order['items'].length,
      itemBuilder: (context, index) {
        final item = widget.order['items'][index];
        final productId = item['product_id'].toString();
        
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // Image du produit
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      item['product']?['image_url'] ?? 'https://via.placeholder.com/60',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(width: 15),
              
              // Nom du produit et quantité
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['product']?['name'] ?? 'Produit inconnu',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Quantité: ${item['quantity']}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Étoiles pour évaluer le produit
              Row(
                children: List.generate(5, (starIndex) {
                  return IconButton(
                    iconSize: 24,
                    padding: const EdgeInsets.all(2),
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
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}