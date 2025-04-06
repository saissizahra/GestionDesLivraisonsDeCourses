class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? address;
  final String? phone;
  final String? avatarURL;
  final List<dynamic>? orders;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.address,
    this.phone,
    this.avatarURL,
    this.orders,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ,
      address: json['address'],
      phone: json['phone'],
      avatarURL: json['avatarURL'],
      orders: json['orders'] != null ? List<dynamic>.from(json['orders']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'address': address,
      'phone': phone,
      'avatarURL': avatarURL,
      'orders': orders,
    };
  }
}