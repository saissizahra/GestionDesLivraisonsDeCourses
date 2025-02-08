import 'package:flutter/material.dart';
import 'package:flutter_application_catmkadia/common/color_extension.dart';
import 'package:flutter_application_catmkadia/models/product.dart';

class detailItems extends StatelessWidget {
  final Product product;
  const detailItems({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.black87, // Meilleur contraste
            letterSpacing: 0.5, // Espacement pour plus d'élégance
          ),
        ),
        const SizedBox(height: 8), // Espacement pour l'aération
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${product.price} MAD",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black, // Meilleure lisibilité
                  ),
                ),
                const SizedBox(height: 6), // Espacement ajusté
                Container(
                  width: 60,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: TColor.primary,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rate.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              product.weight,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54, 
              ),
            ),
          ],
        ),
      ],
    );
  }
}
