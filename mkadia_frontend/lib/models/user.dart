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