import 'package:flutter/material.dart';
import 'login.dart'; // Assurez-vous que login.dart contient la classe Login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Utilisation d'un fond blanc principal
        child: Column(
          children: [
            // Image en haut (50% de la hauteur)
            Container(
              height: MediaQuery.of(context).size.height * 0.5, // 50% de la hauteur
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/HO.png'), // Chemin de l'image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Partie blanche incurvée avec image de fond dans la moitié inférieure
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 195, 223, 196),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70), // Incurvé sur le côté gauche
                    topRight: Radius.circular(70), // Incurvé sur le côté droit
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centre les éléments verticalement
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30), // Espacement du haut
                      // Texte principal (en haut de la section)
                      Text(
                        'MKADIA',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20), // Espacement après le titre
                      // Texte secondaire (juste en dessous du titre)
                      Text(
                        'Plus besoin d\'attendre vos courses à domicile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 50), // Espacement avant les boutons
                      // Bouton "Commencer"
                      ElevatedButton(
                        onPressed: () {
                          // Action pour "Commencer"
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shadowColor: Colors.greenAccent,
                          elevation: 5,
                        ),
                        child: Text(
                          'Commencer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Espacement entre les boutons
                      // Bouton "Accéder à votre compte"
                      ElevatedButton(
                        onPressed: () {
                          // Redirection vers login.dart
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(), // Classe définie dans login.dart
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shadowColor: Colors.blueAccent,
                          elevation: 5,
                        ),
                        child: Text(
                          'Accéder à votre compte', // Nouveau texte pour le bouton
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
