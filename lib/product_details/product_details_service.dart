import 'dart:convert';
import 'package:http/http.dart' as http;

import '../storage/token_storage.dart';

class ProductDetailsService {

  static Future<Map<String, dynamic>?> fetchProductDetails(String productId) async {
    final url = 'https://jumlaonline.com/api/product_details.php?product_id=$productId';
    print('🔍 Requesting Product Details from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      print('📶 HTTP Status Code: ${response.statusCode}');
      print('📥 Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        print('✅ Parsed JSON: $jsonBody');

        if (jsonBody['status'] == 'success') {
          print('🎯 Successfully retrieved product data.');
          return jsonBody['data'];
        } else {
          print('⚠️ API responded with failure status: ${jsonBody['status']}');
          return null;
        }
      } else {
        print('❌ HTTP error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('🚨 Exception occurred during API call: $e');
      return null;
    }
  }


  static Future<Map<String, dynamic>> addToCart({
    required String productId,
    required String quantity,
    int? colorId,
    int? variantId,
  }) async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Unauthorized. Please log in first.');
    }

    final url = Uri.parse('https://jumlaonline.com/api/add_to_cart.php');

    // Build request body with optional fields
    final Map<String, dynamic> body = {
      'product_id': productId,
      'quantity': quantity,
    };

    if (colorId != null) body['color_id'] = colorId;
    if (variantId != null) body['variant_id'] = variantId;

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['status'] == 'success') {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Add to cart failed');
    }
  }


  static Future<String?> getCurrentCartSellerId() async {
    try {
      final token = await TokenStorage.getToken();
      final url = Uri.parse('https://jumlaonline.com/api/get_current_seller_id.php');

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      print('📥 getCurrentCartSellerId() Response: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final data = responseData['data'];

        if (data is Map<String, dynamic> && data.containsKey('seller_id')) {
          final sellerId = data['seller_id'];
          return sellerId == "null" ? null : sellerId;
        } else {
          print('⚠️ Unexpected data format: $data');
          return null;
        }
      } else {
        print('⚠️ Error status from server: $responseData');
        return null;
      }
    } catch (e) {
      print('🚨 Exception in getCurrentCartSellerId(): $e');
      return null;
    }
  }


  static Future<List<Map<String, dynamic>>> fetchSuggestedProductsBySubCategory(String subCategoryId) async {
    final url = Uri.parse('https://jumlaonline.com/api/subcategory_products.php?sub_category_id=$subCategoryId');

    final response = await http.get(url);
    final body = jsonDecode(response.body);

    print('✅ Suggested Products API Response: $body');

    if (response.statusCode == 200 && body['status'] == 'success') {
      final data = body['data'];

      if (data is List) {
        print('✅ Suggested products list: $data');
        return List<Map<String, dynamic>>.from(data);
      } else {
        print('⚠️ "data" is not a List. Actual type: ${data.runtimeType}');
        return [];
      }
    } else {
      throw Exception('Failed to fetch suggested products');
    }
  }

  static Future<bool> updateProduct({
    required String productId,
    required String price,
    required String stock,
  }) async {
    try {
      final token = await TokenStorage.getToken(); // get Bearer token
      final response = await http.put(
        Uri.parse('https://jumlaonline.com/api/update_product.php'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'product_id': int.parse(productId),
          'price': double.parse(price),
          'stock': double.parse(stock),
        }),
      );

      final data = json.decode(response.body);
      print('🔁 Update Response: $data');

      return data['status'] == 'success';
    } catch (e) {
      print('❌ Update error: $e');
      return false;
    }
  }




}
