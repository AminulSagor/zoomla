import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class OrderService {

  static const String baseUrl = 'https://jumlaonline.com/api';

  static Future<List<Map<String, dynamic>>> getOrdersByStatus(String status) async {
    final token = await TokenStorage.getToken(); // implement this if needed
    final url = Uri.parse('https://jumlaonline.com/api/get_seller_orders.php?status=$status');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("🔹 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(data['orders']);
      } else {
        throw Exception('Failed to fetch orders: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch orders: ${response.statusCode}');
    }
  }




  static Future<Map<String, dynamic>> updateOrderStatus(String orderId, String status) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/update_order_status.php');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // ✅ inject real token here
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'order_id': orderId,
        'status': status,
      }),
    );

    print("📤 Sent: order_id=$orderId, status=$status");
    print("🔹 Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update order status: ${response.statusCode}');
    }
  }




}
