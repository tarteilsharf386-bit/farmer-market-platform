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

  // جلب كل المحاصيل
  static Future<List<dynamic>> getCrops() async {
    final response = await http.get(
      Uri.parse('http://192.168.43.220:5000/api/crops'),
    );

    return jsonDecode(response.body);
  }
  // إضافة محصول جديد
  static Future<Map<String, dynamic>> addCrop({
    required String farmerId,
    required String title,
    required String category,
    required double price,
    required double quantity,
    required String unit,
    required String location,
  }) async {
    final response = await http.post(
      Uri.parse('http://192.168.43.220:5000/api/crops'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'farmer': farmerId,
        'title': title,
        'category': category,
        'price': price,
        'quantity': quantity,
        'unit': unit,
        'location': location,
      }),
    );

    return jsonDecode(response.body);
  }
}