import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();
  String selectedRole = 'farmer';
  String message = '';
  bool isLoading = false;

  Future<void> handleRegister() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      final result = await ApiService.register(
        name: nameController.text,
        phone: phoneController.text,
        password: passwordController.text,
        role: selectedRole,
        location: locationController.text,
      );

      setState(() {
        message = result['message'] ?? 'حدث خطأ غير معروف';
        isLoading = false;
      });
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
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'الموقع'),
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: selectedRole,
                items: const [
                  DropdownMenuItem(value: 'farmer', child: Text('مزارع')),
                  DropdownMenuItem(value: 'buyer', child: Text('مشترٍ')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: handleRegister,
                      child: const Text('تسجيل'),
                    ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('لديك حساب؟ سجلي دخولك'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
