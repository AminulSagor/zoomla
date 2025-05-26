import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoryService {
  static Future<List<Map<String, String>>> fetchCategories(String token) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final url = Uri.parse('$baseUrl/get_all_category.php');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final categories = data['categories'] as List;
        return categories.map<Map<String, String>>((e) {
          return {
            'id': e['id'].toString(),
            'category': e['category'].toString(),
          };
        }).toList();
      }
    }

    throw Exception('Failed to load categories');
  }

  static Future<List<Map<String, String>>> fetchSubCategories(String categoryId, String token) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final url = Uri.parse('$baseUrl/get_sub_categories.php?id=$categoryId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final subCategories = data['sub_categories'] as List;

        return subCategories.map<Map<String, String>>((e) {
          return {
            'id': e['id'].toString(),
            'name': e['sub_category'].toString(),
          };
        }).toList();
      }
    }

    throw Exception('Failed to load sub-categories');
  }


}
