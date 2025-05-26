import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PendingProductService {
  static Future<List<Map<String, dynamic>>> fetchPendingProducts(String token) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final url = Uri.parse('$baseUrl/get_posted_products.php?status=pending');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    print('🔵 Raw Pending Product Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(data['products']);
      }
    }
    throw Exception('Failed to fetch pending products');
  }
}