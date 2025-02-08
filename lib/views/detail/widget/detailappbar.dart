import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';

class DetailAppBar extends StatelessWidget {
  const DetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icône de retour
          Container(
            decoration: const BoxDecoration(
              color: Colors.white, 
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: TColor.primaryText, 
            ),
          ),

          // Texte centré
          Text(
            "Product Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColor.primary,
            ),
          ),

          // Icône du panier
          Container(
            decoration: const BoxDecoration(
              color: Colors.white, 
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined),
              color: TColor.primaryText, 
            ),
          ),
        ],
      ),
    );
  }
}
