import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  List<String> _searchHistory = [];

  List<String> get searchHistory => _searchHistory;

  void addSearchTerm(String term) {
    _searchHistory.insert(0, term); // Ajouter en tête de liste
    notifyListeners();
  }

  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }
}