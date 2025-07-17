// approve_order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class ApproveOrderService {
  static Future<Map<String, dynamic>> approveOrder({
    required String orderId,
    required String deliveryDateTime, // in Y-m-d H:i:s format
    required double extraDeliveryCharge,
  }) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('https://jumlaonline.com/api/approve_order.php');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'order_id': orderId,
        'del_date_time': deliveryDateTime,
        'extra_del_charge': extraDeliveryCharge,
      }),
    );

    print("🔹 Approve Order Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Approval failed: ${response.reasonPhrase}');
    }
  }
}
