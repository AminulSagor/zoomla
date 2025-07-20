import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OfferService {
  static Future<Map<String, dynamic>> addOffer({
    required String token,
    required int productId,
    required int discount,
    required int minimumPurchase,
  }) async {
    final url = Uri.parse('${dotenv.env['BASE_URL']}/add_offer.php');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "product_id": productId,
        "discount": discount,
        "minimum_purchase": minimumPurchase,
      }),
    );
    print('🟢 Response Body: ${response.body}');

    final data = jsonDecode(response.body);
    return data;
  }
}
