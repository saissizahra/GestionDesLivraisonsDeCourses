import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Soumettre une évaluation
  static Future<Map<String, dynamic>> submitReview(Map<String, dynamic> reviewData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reviewData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Erreur lors de la soumission de l\'évaluation: ${response.body}');
      throw Exception('Failed to submit review: ${response.statusCode}');
    }
  }

  // Récupérer les évaluations d'un produit
  static Future<List<dynamic>> getProductReviews(int productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$productId/reviews'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load product reviews');
    }
  }

  // Récupérer les évaluations d'un utilisateur
  static Future<List<dynamic>> getUserReviews(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/reviews'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user reviews');
    }
  }

  // Récupérer une évaluation spécifique
  static Future<Map<String, dynamic>> getReview(int reviewId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reviews/$reviewId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load review');
    }
  }
}