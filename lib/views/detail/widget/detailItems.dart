import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/models/product.dart';

class DetailItems extends StatelessWidget {
  final Product product;
  const DetailItems({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding:  EdgeInsets.only(top:10)),
        // Nom 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28, 
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            // Poids 
            Text(
              product.weight,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), 
        // Prix 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${product.price} MAD",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20, 
                color: Colors.black,
              ),
            ),
            // Rate
            Container(
              width: 70, 
              height: 32, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), 
                color: TColor.primary,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6), 
                  Text(
                    product.rate.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16, 
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
