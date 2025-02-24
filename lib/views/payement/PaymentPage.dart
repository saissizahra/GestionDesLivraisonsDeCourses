import 'package:flutter/material.dart';
import 'package:mkadia/models/Infopaiement.dart.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  // Utilisation des données de Infopaiement.dart
  PaymentInfo paymentInfo = PaymentInfo.examplePayments()[0]; // Utilisation du premier objet de la liste examplePayments

  String _selectedPaymentMethod = 'Carte de Crédit';

  void _confirmPayment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Action de confirmation, vous pouvez ajouter une autre page de confirmation si nécessaire
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: Text('Paiement confirmé pour ${paymentInfo.name}.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Fermer'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage de l'adresse de livraison
            Text(
              'Adresse de Livraison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('${paymentInfo.address}, ${paymentInfo.city}, ${paymentInfo.country}', style: const TextStyle(fontSize: 16)),
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Sélection de la méthode de paiement
            Text(
              'Méthode de Paiement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButton<String>(
                  value: _selectedPaymentMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPaymentMethod = newValue!;
                    });
                  },
                  items: <String>['Carte de Crédit', 'PayPal', 'Apple Pay', 'Google Pay']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Formulaire de paiement pour la carte de crédit
            if (_selectedPaymentMethod == 'Carte de Crédit')
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nom sur la carte'),
                      validator: (value) => value == null || value.isEmpty ? 'Entrez votre nom' : null,
                      onSaved: (value) => paymentInfo.name = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Numéro de carte'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.length != 16 ? 'Numéro invalide' : null,
                      onSaved: (value) => paymentInfo.cardNumber = value!,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'Date d\'expiration'),
                            keyboardType: TextInputType.datetime,
                            validator: (value) => value == null || value.isEmpty ? 'Entrez la date' : null,
                            onSaved: (value) => paymentInfo.expiryDate = value!,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'CVV'),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            validator: (value) => value == null || value.length != 3 ? 'CVV invalide' : null,
                            onSaved: (value) => paymentInfo.cvv = value!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Bouton de confirmation de paiement
            ElevatedButton(
              onPressed: _confirmPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // couleur du bouton
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Confirmer et Payer', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}