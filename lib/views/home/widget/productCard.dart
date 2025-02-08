import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/models/product.dart';
import 'package:mkadia/views/detail/detail.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // todo: clic
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context)=> Detail(product: product,)
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10), // Ajout d'un padding pour espacer le contenu du bord
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(31, 232, 228, 228),
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Laisse la taille du contenu
              children: [
                // Image centrée
                Center(
                 
                    child: Image.asset(
                      product.image,
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                  
                ),
                const SizedBox(height: 5),

                // Nom du produit centré et en gras
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center, // Centrer le texte
                ),

                // Poids du produit centré et en gris clair
                Text(
                  product.weight, 
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600, 
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),

                
                Text(
                  "${product.price} Mad",
                  style: TextStyle(
                    fontFamily: "ZabalDemo",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: TColor.primaryText,
                  ),
                  textAlign: TextAlign.center, 
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
