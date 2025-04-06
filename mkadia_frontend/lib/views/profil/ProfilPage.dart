import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/models/user.dart';
import 'package:mkadia/provider/UserProvider.dart';
import 'package:mkadia/views/home/HomeView.dart';
import 'package:mkadia/views/home/widget/navbar.dart';
import 'package:mkadia/views/profil/widgets/FAQPage.dart';
import 'package:mkadia/views/profil/widgets/OrderHistoryPage.dart';
import 'package:provider/provider.dart';
import 'package:mkadia/views/parametre/parametre.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: AppBar(
            toolbarHeight: 80,
            backgroundColor: TColor.primaryText,
            elevation: 0,
            title: Text(
              "Profil",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
    body: user == null
        ? const Center(child: CircularProgressIndicator())
        : _buildProfileContent(context, user, userProvider),

    );
  }

  void _handleLogout(BuildContext context, UserProvider userProvider) {
    userProvider.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
      (route) => false,
    );
  }

  Widget _buildProfileContent(BuildContext context, User user,UserProvider userProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserAvatar(user),
          const SizedBox(height: 20),
          _buildUserName(user),
          const SizedBox(height: 20),
          _buildProfileInfoCard(user),
          const SizedBox(height: 20),
          _buildOrderHistoryCard(context),
          const SizedBox(height: 20),
          _buildHelpCard(context),
          const SizedBox(height: 20),
          _buildSettingsCard(context),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _handleLogout(context, userProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(User user) {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _getAvatarImage(user.avatarURL),
        backgroundColor: Colors.green.shade100,
        child: (user.avatarURL == null || user.avatarURL!.isEmpty)
            ? const Icon(Icons.person, size: 50, color: Colors.white)
            : null,
      ),
    );
  }

  ImageProvider _getAvatarImage(String? avatarURL) {
    if (avatarURL == null || avatarURL.isEmpty) {
      return const AssetImage('assets/images/default_avatar.png');
    }
    return avatarURL.startsWith('assets/')
        ? AssetImage(avatarURL)
        : NetworkImage(avatarURL) as ImageProvider;
  }

  Widget _buildUserName(User user) {
    return Center(
      child: Text(
        user.name,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: TColor.primaryText,
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard(User user) {
    return _buildCard(
      title: 'Informations de Profil',
      children: [
        _buildListTile(Icons.email, 'Email', user.email),
        _buildListTile(Icons.phone, 'Téléphone', user.phone ?? 'Non renseigné'),
        _buildListTile(Icons.location_on, 'Adresse', user.address ?? 'Non renseignée'),
      ],
    );
  }

  Widget _buildOrderHistoryCard(BuildContext context) {
    return _buildCard(
      title: 'Historique des Commandes',
      children: [
        ListTile(
          leading: Icon(Icons.history, color: TColor.primaryText),
          title: const Text('Voir toutes mes commandes'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpCard(BuildContext context) {
    return _buildCard(
      title: 'Aide & Support',
      children: [
        ListTile(
          leading: Icon(Icons.help_outline, color: TColor.primaryText),
          title: const Text('FAQ'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FAQPage()),
          ),
        ),
        ListTile(
          leading: Icon(Icons.contact_support, color:TColor.primaryText),
          title: const Text('Nous contacter'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showContactDialog(context),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return _buildCard(
      title: 'Paramètres',
      children: [
        ListTile(
          leading: Icon(Icons.settings, color: TColor.primaryText),
          title: const Text('Préférences'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ParametrePage()),
          ),
        ),
      ],
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contactez-nous'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Service client disponible 24/7'),
            const SizedBox(height: 16),
            _buildContactInfo(Icons.phone, '06 12 34 56 78'),
            const SizedBox(height: 8),
            _buildContactInfo(Icons.email, 'support@mkadia.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color:TColor.primaryText),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
                color:TColor.primaryText,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color:TColor.primaryText),
      title: Text(title),
      subtitle: Text(
        subtitle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}