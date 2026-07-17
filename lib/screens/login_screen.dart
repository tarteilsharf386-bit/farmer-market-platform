import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';
  bool isLoading = false;

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      final result = await ApiService.login(
        phone: phoneController.text,
        password: passwordController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (result['token'] != null) {
        // نجح تسجيل الدخول
        setState(() {
          message = 'مرحباً ${result['user']['name']} 👋';
        });
        // هنا لاحقاً بنضيف: حفظ الـ token والانتقال للشاشة الرئيسية
      } else {
        setState(() {
          message = result['message'] ?? 'حدث خطأ';
        });
      }
    } catch (e) {
      setState(() {
        message = 'فشل الاتصال بالسيرفر: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'كلمة المرور'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: handleLogin,
                    child: const Text('دخول'),
                  ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(color: Colors.green, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}