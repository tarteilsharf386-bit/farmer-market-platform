import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // عنوان السيرفر - غيريه لاحقًا وقت النشر الفعلي
  static const String baseUrl = 'http://192.168.43.220:5000/api/auth';
  static const String cropsUrl = 'http://192.168.43.220:5000/api/crops';

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
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
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
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  // جلب كل المحاصيل
  static Future<List<dynamic>> getCrops() async {
    final response = await http.get(Uri.parse(cropsUrl));
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
      Uri.parse(cropsUrl),
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

  // إرسال طلب تواصل مع مزارع
  static Future<Map<String, dynamic>> contactFarmer({
    required String cropId,
    required String buyerId,
  }) async {
    final response = await http.post(
      Uri.parse('$cropsUrl/contact'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'cropId': cropId, 'buyerId': buyerId}),
    );

    return jsonDecode(response.body);
  }
  // جلب متوسط أسعار السوق
  static Future<List<dynamic>> getMarketPrices() async {
    final response = await http.get(Uri.parse('$cropsUrl/market-prices'));
    return jsonDecode(response.body);
  }
  // جلب بيانات المستخدم
  static Future<Map<String, dynamic>> getUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));
    return jsonDecode(response.body);
  }

  // تحديث بيانات المستخدم
  static Future<Map<String, dynamic>> updateUser({
    required String userId,
    required String name,
    required String location,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'name': name, 'location': location}),
    );
    return jsonDecode(response.body);
  }
  // تعديل محصول
  static Future<Map<String, dynamic>> updateCrop({
    required String cropId,
    required String title,
    required String category,
    required double price,
    required double quantity,
    required String unit,
    required String location,
  }) async {
    final response = await http.put(
      Uri.parse('$cropsUrl/$cropId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'title': title, 'category': category, 'price': price,
        'quantity': quantity, 'unit': unit, 'location': location,
      }),
    );
    return jsonDecode(response.body);
  }

  // حذف محصول
  static Future<Map<String, dynamic>> deleteCrop(String cropId) async {
    final response = await http.delete(Uri.parse('$cropsUrl/$cropId'));
    return jsonDecode(response.body);
  }

  // محاصيل مزارع معين
  static Future<List<dynamic>> getMyCrops(String farmerId) async {
    final response = await http.get(Uri.parse('$cropsUrl/farmer/$farmerId'));
    return jsonDecode(response.body);
  }
}
