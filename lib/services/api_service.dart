import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // عنوان السيرفر - غيريه لاحقًا وقت النشر الفعلي
  static const String baseUrl = 'http://192.168.43.220:5000/api/auth';

  // دالة التسجيل
  static Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
    required String role,
    required String location,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'password': password,
        'role': role,
        'location': location,
      }),
    );

    return jsonDecode(response.body);
  }

  // دالة تسجيل الدخول
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    return jsonDecode(response.body);
  }
}
