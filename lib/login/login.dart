import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'forget.dart'; // Import de la page de réinitialisation
import 'singup.dart'; // Import de la page d'inscription

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo de l'application
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/logoshop.png", // Remplace par le nom de ton image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Titre de l'application
              const Text(
                'Mkadia',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 76, 175, 80), // Couleur verte personnalisée
                ),
              ),
              const SizedBox(height: 100),

              // Champ de saisie : Email
              TextField(
                decoration: InputDecoration(
                  labelText: 'Adresse e-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),

              // Champ de saisie : Mot de passe
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 10),
              
              // Lien "Mot de passe oublié ?" en français
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Navigation vers la page forget.dart
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bouton "Se connecter"
              ElevatedButton(
                onPressed: () {
                  // Action de connexion
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Se connecter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Bouton "Créer un compte" avec redirection vers la page d'inscription
              OutlinedButton(
                onPressed: () {
                  // Navigation vers la page d'inscription (singup.dart)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.green),
                ),
                child: const Text(
                  'Créer un compte',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Boutons de connexion avec Google et Facebook
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red, size: 35),
                    onPressed: () {
                      // Action pour Google
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue, size: 35),
                    onPressed: () {
                      // Action pour Facebook
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Texte en bas
              const Text.rich(
                TextSpan(
                  text: 'En cliquant sur ',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'Se connecter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ', vous acceptez notre '),
                    TextSpan(
                      text: 'politique de confidentialité',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' et nos '),
                    TextSpan(
                      text: 'conditions d\'utilisation.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
