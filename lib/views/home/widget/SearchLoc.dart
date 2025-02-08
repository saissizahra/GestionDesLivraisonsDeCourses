import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';

class SearchLoc extends StatelessWidget {
  const SearchLoc({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Barre de recherche
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search in Mkadia',
                    hintStyle: TextStyle(color: TColor.placeholder),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            // Logo du panier
            IconButton(
              icon: const Icon(Icons.tune_outlined, color: Colors.white, size: 38),
              onPressed: () {
                // TODO: bouton filtre 
              },
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Affichage de la localisation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.white,
              size: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Location',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    fontFamily: "Montserrat",
                    color: TColor.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Affichage de "Safi.Marrakech" avec du padding
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Safi.Marrakech',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat",
                color: TColor.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
