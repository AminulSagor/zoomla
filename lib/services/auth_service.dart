import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final String? _baseUrl = dotenv.env['BASE_URL'];

  static Future<Map<String, dynamic>> sendOtp({
    required String phone,
    required String method,
  }) async {
    final url = Uri.parse('$_baseUrl/send_otp.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phone,
        'otp_method': method, // 'signup' or 'reset'
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to send OTP");
    }
  }


  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final url = Uri.parse('$_baseUrl/verify_otp.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': otp}),
    );

    final body = jsonDecode(response.body);
    print("verifyOtp response: $body");

    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      return body;
    } else {
      throw Exception(body['message'] ?? "Failed to verify OTP");
    }
  }


  Future<Map<String, dynamic>> registerSeller({
    required String name,
    required String phone,
    required String password,
    required String storeName,
    required String storeType,
    required String regNum,
    required String regType,
    required String storeAddress,
    required String description,
    required File profileImage,
    required File coverImage,
    required String otp, // Header
  }) async {
    final uri = Uri.parse('$_baseUrl/seller_registration.php');

    var request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['phone'] = phone
      ..fields['password'] = password
      ..fields['store_name'] = storeName
      ..fields['store_type'] = storeType
      ..fields['reg_num'] = regNum
      ..fields['reg_type'] = regType
      ..fields['store_address'] = storeAddress
      ..fields['description'] = description
      ..headers['otp'] = otp // Header for OTP
      ..files.add(await http.MultipartFile.fromPath('pro_path', profileImage.path))
      ..files.add(await http.MultipartFile.fromPath('cover_path', coverImage.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw Exception("Registration failed: ${response.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>> loginSeller({
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/seller_login.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Login failed: ${response.reasonPhrase}");
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String password,
    required String otp,
  }) async {
    final url = Uri.parse('$_baseUrl/reset_password.php');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'otp': otp,
      },
      body: jsonEncode({
        'phone': phone,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

}
