// order_details_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class OrderDetailsService {
  static Future<List<Map<String, dynamic>>> fetchOrderDetails(String orderId) async {
    final token = await TokenStorage.getToken();

    final url = Uri.parse('https://jumlaonline.com/api/order_details.php?order_id=$orderId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("🔹 Order Details Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(data['ordered_products']);
      } else {
        throw Exception("Failed to fetch order details: ${data['status']}");
      }
    } else {
      throw Exception('Failed to fetch order details: ${response.statusCode}');
    }
  }
}
