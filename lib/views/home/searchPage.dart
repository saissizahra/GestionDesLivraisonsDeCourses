import 'package:flutter/material.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:mkadia/provider/searchProvider';
import 'package:mkadia/views/cart/cart.dart';
import 'package:provider/provider.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/models/product.dart';
import 'package:mkadia/views/detail/detail.dart';

class SearchPage extends StatefulWidget {
  final List<Product> products;

  const SearchPage({super.key, required this.products});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.clear(); // Vider la barre de recherche lors de l'initialisation
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    final provider = CartProvider.of(context);
    final finalList = provider.cart;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: Container(
              height: 160, 
              color: TColor.primaryText, 
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 24),),
                  Row(
                    children: [
                      // todo:Icône de retour
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      //todo: Barre de recherche
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search in Mkadia',
                              hintStyle: TextStyle(color: TColor.placeholder),
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchResults = widget.products
                                    .where((product) =>
                                        product.name.toLowerCase().contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                            onSubmitted: (value) {
                              // Ajouter le terme de recherche à l'historique
                              searchProvider.addSearchTerm(value);
                              _searchController.clear(); // Vider la barre de recherche
                            },
                          ),
                        ),
                      ),
                      // todo:Icône du panier
                      IconButton(
                        icon: Stack(
                          children: [
                            const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 38),
                            if (finalList.isNotEmpty)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(0.25),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 15,
                                    minHeight: 15,
                                  ),
                                  child: Text(
                                    finalList.length.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Cart()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Résultats de recherche ou historique
          if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final product = _searchResults[index];
                  return ListTile(
                    leading: Image.asset(product.image, width: 50, height: 50),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price}'),
                    onTap: () {
                      // Ajouter le terme de recherche à l'historique
                      searchProvider.addSearchTerm(_searchController.text);

                      // Naviguer vers la page de détails
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detail(product: product),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          else if (searchProvider.searchHistory.isNotEmpty)
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColor.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: searchProvider.searchHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.history, color: Colors.grey),
                          title: Text(searchProvider.searchHistory[index]),
                          onTap: () {
                            _searchController.text = searchProvider.searchHistory[index];
                            setState(() {
                              _searchResults = widget.products
                                  .where((product) => product.name
                                      .toLowerCase()
                                      .contains(_searchController.text.toLowerCase()))
                                  .toList();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/search.png', 
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Search for items',
                      style: TextStyle(
                        fontSize: 18,
                        color: TColor.placeholder,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}