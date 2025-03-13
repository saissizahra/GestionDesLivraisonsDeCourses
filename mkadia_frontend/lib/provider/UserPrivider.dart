import 'package:flutter/material.dart';
import 'package:mkadia/models/user.dart'; // Import de la classe User

class UserProvider with ChangeNotifier {
  // Utilisateur par défaut pour la première utilisation
  User? _user = User(
    name: "Fatima",
    email: "fatima@example.com",
    address: "123 Rue de Maroc",
    phone: "+212 600000000",
    avatarURL: "assets/img/HO.png", // Changez ce chemin selon vos besoins
    orders: ["Commande #001 - 12/01/2024", "Commande #002 - 18/01/2024"],
  );

  // Getter pour l'utilisateur
  User? get user => _user;

  // Setter pour définir un nouvel utilisateur
  void setUser(User newUser) {
    _user = newUser;
    notifyListeners(); // Notifie les écouteurs que l'utilisateur a changé
  }

  // Méthode de déconnexion
  void logout() {
    _user = null; // L'utilisateur est déconnecté
    notifyListeners(); // Notifie les écouteurs de la déconnexion
  }
}