import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String description;
  const Description({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Product Description",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Meilleur contraste
            letterSpacing: 0.5, // Espacement pour plus d'élégance
          ),
        ),
        const SizedBox(height: 12), // Espacement plus équilibré
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black54, // Texte légèrement atténué
            height: 1.5, // Meilleure lisibilité
          ),
        ),
      ],
    );
  }
}
