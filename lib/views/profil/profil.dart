import 'package:flutter/material.dart';
import 'package:mkadia/models/user.dart';
import 'package:mkadia/views/parametre/parametre.dart'; // Assurez-vous d'importer correctement le fichier user.dart

class ProfilPage extends StatelessWidget {
  final User user;

  const ProfilPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Utilisateur'),
        backgroundColor: Colors.green, // Couleur verte pour l'AppBar
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Action de déconnexion
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar utilisateur
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user.avatarURL.startsWith('assets/')
                    ? AssetImage(user.avatarURL) // Charger une image locale
                    : NetworkImage(user.avatarURL) as ImageProvider, // Charger une image depuis une URL
                backgroundColor: Colors.green.shade100,
              ),
            ),
            const SizedBox(height: 20),

            // Nom de l'utilisateur
            Center(
              child: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Informations du profil
            _buildCard(
              title: 'Informations de Profil',
              children: [
                _buildListTile(Icons.email, 'Email', user.email),
                _buildListTile(Icons.phone, 'Téléphone', user.phone),
                _buildListTile(Icons.location_on, 'Adresse', user.address),
              ],
            ),

            const SizedBox(height: 20),

            // Historique des commandes
            _buildCard(
              title: 'Historique des Commandes',
              children: [
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.green),
                  title: const Text('Voir l\'historique'),
                  onTap: () {
                    Navigator.pushNamed(context, '/orderHistory'); // Redirection vers la page de l'historique des commandes
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Paramètres et préférences
            _buildCard(
              title: 'Paramètres et Préférences',
              children: [
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.green),
                  title: const Text('Paramètres'),
                  onTap: () {
                    // Utilisation de Navigator.push pour une redirection directe vers ParametrePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Parametre(), // Création d'une instance de ParametrePage
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour générer une carte avec du contenu
  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  // Fonction pour créer une ligne d'informations
  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}