import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Add this for MIME type

class ProductUploadService {
  static Future<Map<String, dynamic>> uploadProduct({
    required String token,
    required String subCategoryId,
    required String productName,
    required String brand,
    required String model,
    required String price,
    required String stock,
    String? delCharge,
    String? description,
    List<String>? colors,
    List<String>? variants,
    List<String>? keywords,
    required List<File> images,
  }) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final uri = Uri.parse('$baseUrl/post_product.php');

    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['sub_category_id'] = subCategoryId;
    request.fields['product_name'] = productName;
    request.fields['brand'] = brand;
    request.fields['model'] = model;
    request.fields['price'] = price;
    request.fields['stock'] = stock;

    if (delCharge != null) request.fields['del_charge'] = delCharge;
    if (description != null) request.fields['description'] = description;
    if (colors != null && colors.isNotEmpty) {
      request.fields['color'] = jsonEncode(colors);
    }
    if (variants != null && variants.isNotEmpty) {
      request.fields['variant'] = jsonEncode(variants);
    }
    if (keywords != null && keywords.isNotEmpty) {
      request.fields['keyword'] = jsonEncode(keywords);
    }

    final payload = {
      'sub_category_id': subCategoryId,
      'product_name': productName,
      'brand': brand,
      'model': model,
      'price': price,
      'stock': stock,
      if (delCharge != null) 'del_charge': delCharge,
      if (description != null) 'description': description,
      if (colors != null && colors.isNotEmpty) 'color': colors,
      if (variants != null && variants.isNotEmpty) 'variant': variants,
      if (keywords != null && keywords.isNotEmpty) 'keyword': keywords,
    };
    print('📦 Payload being sent (excluding images):');
    print(const JsonEncoder.withIndent('  ').convert(payload));

    for (var file in images) {
      final extension = file.path.split('.').last.toLowerCase();
      final mimeType = extension == 'png'
          ? 'image/png'
          : extension == 'gif'
          ? 'image/gif'
          : 'image/jpeg'; // default fallback

      request.files.add(
        await http.MultipartFile.fromPath(
          'img_paths[]',
          file.path,
          contentType: MediaType('image', mimeType.split('/').last),
        ),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print('🔵 Raw Response Body: $responseBody');
    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw Exception("Upload failed: ${response.reasonPhrase}");
    }
  }
}
