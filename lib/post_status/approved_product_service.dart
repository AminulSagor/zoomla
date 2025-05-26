import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApprovedProductService {
  static Future<List<Map<String, dynamic>>> fetchApprovedProducts(String token) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final url = Uri.parse('$baseUrl/get_posted_products.php?status=approved');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final List<dynamic> products = data['products'];
        return products.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    }

    throw Exception('Failed to load approved products');
  }
}
