import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/provider/PayementManager.dart';
import 'package:mkadia/views/parametre/ChangeMotDePassePage.dart';
import 'package:mkadia/views/parametre/PaymentSavePage.dart';
import 'package:mkadia/views/home/HomeView.dart';
import 'package:mkadia/views/parametre/UpdateAdressesLivraisonPage.dart' as livraison;
import 'package:mkadia/views/parametre/GererLaConfidentialitePage.dart' as confidentialite;
import 'package:mkadia/views/profil/ProfilPage.dart';

class ParametrePage extends StatefulWidget {
  const ParametrePage({Key? key}) : super(key: key);

  @override
  ParametrePageState createState() => ParametrePageState();
}

class ParametrePageState extends State<ParametrePage> {
  bool _notificationsEnabled = true;
  final PaymentManager paymentManager = PaymentManager(); // Instance de PaymentManager

  @override
  Widget build(BuildContext context) {
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
              "Paramètres",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              title: 'Notifications',
              children: [
                SwitchListTile(
                  title: const Text('Activer les notifications'),
                  value: _notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Sécurité et confidentialité',
              children: [
                ListTile(
                  leading: const Icon(Icons.lock, color: Colors.green),
                  title: const Text('Changer le mot de passe'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeMotDePassePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.security, color: Colors.green),
                  title: const Text('Gérer la confidentialité'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => confidentialite.GererLaConfidentialitePage(),
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

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}