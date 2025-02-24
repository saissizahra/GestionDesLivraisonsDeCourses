class User {
  final String name;
  final String email;
  final String address;
  final String phone;
  final String avatarURL; // Peut être soit une URL distante, soit un chemin local
  final List<String> orders;

  User({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.avatarURL,
    required this.orders,
  });
}

// Exemple de données pour deux utilisateurs
final List<User> users = [
  User(
    name: "Fatima",
    email: "fatima@example.com",
    address: "123 Rue de Maroc",
    phone: "+212 600000000",
    avatarURL: "assets/img/HO.png", // Remplacez par le chemin relatif de l'image locale
    orders: ["Commande #001 - 12/01/2024", "Commande #002 - 18/01/2024"],
  ),
  User(
    name: "Zahra",
    email: "zahra@example.com",
    address: "456 Rue de Rabat",
    phone: "+212 611111111",
    avatarURL: "assets/img/HO.png", // Remplacez par le chemin relatif de l'image locale
    orders: ["Commande #003 - 25/01/2024"],
  ),
];