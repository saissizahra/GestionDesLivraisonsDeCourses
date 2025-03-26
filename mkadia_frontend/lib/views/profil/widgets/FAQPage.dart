import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/views/profil/widgets/FAQItems.dart';
import 'package:mkadia/views/profil/widgets/FAQSearchDelegate.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<Map<String, String>> _faqs = [
 {
      'question': 'Comment créer un compte sur MKADIA ?',
      'answer': 'Cliquez sur "S\'inscrire", choisissez entre email/téléphone/réseaux sociaux, et suivez les instructions en 30 secondes !'
    },
    {
      'question': 'Comment annuler une commande ?',
      'answer': 'Dans "Mes Commandes", sélectionnez la commande et cliquez "Annuler" avant son expédition.'
    },
    {
      'question': 'Quels modes de paiement acceptez-vous ?',
      'answer': 'Cartes (Visa/Mastercard), Mobile Money, PayPal, et paiement cash à la livraison.'
    },
    {
      'question': 'Quels sont vos délais de livraison ?',
      'answer': 'Casablanca/Rabat : 2h-24h | Autres villes : 24-48h (jours ouvrables)'
    },
    {
      'question': 'Puis-je modifier mon adresse de livraison ?',
      'answer': 'Oui, avant l\'expédition via "Modifier la commande" dans votre historique.'
    },
    {
      'question': 'Comment utiliser un code promo ?',
      'answer': 'Saisissez-le dans le champ "Code promo" avant le paiement. Valable 1x par compte.'
    },
    {
      'question': 'Proposez-vous des produits bio ?',
      'answer': 'Oui ! Filtrez par catégorie "Bio" pour découvrir nos produits certifiés.'
    },
    {
      'question': 'Comment contacter le service client ?',
      'answer': '24/7 via le chat intégré (icône message) ou par email à support@mkadia.ma'
    },
    {
      'question': 'Ma commande n\'est pas arrivée complète',
      'answer': 'Signalez-le dans les 2h via "Problème de commande". Nous vous rembourserons immédiatement les articles manquants.'
    },
    {
      'question': 'Comment fonctionne la garantie fraîcheur ?',
      'answer': 'Si un produit n\'est pas frais, envoyez une photo dans l\'application pour un remboursement instantané.'
    }
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredFaqs = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqs = List.from(_faqs);
    _searchController.addListener(_filterFAQs);
  }

  void _filterFAQs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFaqs = List.from(_faqs);
      } else {
        _filteredFaqs = _faqs.where((faq) =>
            faq['question']!.toLowerCase().contains(query) ||
            faq['answer']!.toLowerCase().contains(query)).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "FAQ MKADIA",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Questions & Answers',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TColor.primaryText,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: TColor.primaryText),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: FAQSearchDelegate(_faqs),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredFaqs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return FAQItem(
                      question: _filteredFaqs[index]['question']!,
                      answer: _filteredFaqs[index]['answer']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}