import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/UserPrivider.dart';
import 'package:mkadia/views/profil/widgets/FAQPage.dart';
import 'package:mkadia/views/profil/widgets/OrderHistoryPage.dart';
import 'package:provider/provider.dart'; 
import 'package:mkadia/views/parametre/parametre.dart';
import 'package:mkadia/views/home/HomeView.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profil Utilisateur'),
          backgroundColor: TColor.primaryText,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()), 
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Utilisateur'),
        backgroundColor: TColor.primaryText,
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
                backgroundColor: TColor.primaryText
              ),
            ),
            const SizedBox(height: 20),

            // Nom de l'utilisateur
            Center(
              child: Text(
                user.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TColor.primaryText,
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
                  leading: Icon(Icons.history, color: TColor.primaryText),
                  title: const Text('Voir l\'historique'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderHistoryPage(),
                      ),
                    );
                   
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
                  leading: Icon(Icons.settings, color: TColor.primaryText),
                  title: const Text('Paramètres'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParametrePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_outline, color: TColor.primaryText),
                  title: const Text('FAQ'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FAQPage(),
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.primaryText,
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
      leading: Icon(icon, color: TColor.primaryText),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}