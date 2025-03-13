import 'package:flutter/material.dart';
import 'package:mkadia/provider/UserPrivider.dart';
import 'package:provider/provider.dart'; // Import pour Provider
import 'package:mkadia/views/parametre/parametre.dart';
import 'package:mkadia/views/home/HomeView.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key}); // Utilisation du super key

  @override
  Widget build(BuildContext context) {
    // Récupère l'utilisateur à partir du provider
    final user = Provider.of<UserProvider>(context).user;

    // Vérifie si l'utilisateur existe
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profil Utilisateur'),
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()), // Ajout de const
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Utilisateur'),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Déconnexion de l'utilisateur
              Provider.of<UserProvider>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeView()), // Ajout de const
              );
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
                    Navigator.pushNamed(context, '/orderHistory'); // Redirection vers l'historique des commandes
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParametrePage(), // Ajout de const
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