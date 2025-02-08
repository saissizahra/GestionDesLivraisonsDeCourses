import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Logo en haut
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
                    'assets/images/logoshop.png', // Remplace par le chemin de ton logo
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Titre de la page (en français)
              const Text(
                "S'inscrire",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Champ de saisie : Nom d'utilisateur
              TextField(
                decoration: InputDecoration(
                  labelText: "Nom d'utilisateur",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),

              // Champ de saisie : Numéro de téléphone
              TextField(
                decoration: InputDecoration(
                  labelText: "Numéro de téléphone",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),

              // Champ de saisie : Email
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              // Champ de saisie : Mot de passe
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),

              // Bouton "S'enregistrer" avec fond noir et texte blanc
              ElevatedButton(
                onPressed: () {
                  // Action d'enregistrement
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  "S'enregistrer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Séparateur "OU"
              Row(
                children: const [
                  Expanded(
                    child: Divider(thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("OU"),
                  ),
                  Expanded(
                    child: Divider(thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Boutons d'inscription avec Facebook et Google
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bouton Facebook
                  ElevatedButton.icon(
                    onPressed: () {
                      // Action pour s'inscrire avec Facebook
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.green),
                      minimumSize: const Size(150, 50),
                    ),
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.green,
                    ),
                    label: const Text(
                      "Facebook",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Bouton Google
                  ElevatedButton.icon(
                    onPressed: () {
                      // Action pour s'inscrire avec Google
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.green),
                      minimumSize: const Size(150, 50),
                    ),
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.green,
                    ),
                    label: const Text(
                      "Google",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
