import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  String phone = '';
  String role = '';
  bool isLoading = true;
  bool isSaving = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final user = await ApiService.getUser(widget.userId);
      setState(() {
        nameController.text = user['name'] ?? '';
        locationController.text = user['location'] ?? '';
        phone = user['phone'] ?? '';
        role = user['role'] == 'farmer' ? 'مزارع' : 'مشترٍ';
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleSave() async {
    setState(() {
      isSaving = true;
      message = '';
    });
    try {
      final result = await ApiService.updateUser(
        userId: widget.userId,
        name: nameController.text,
        location: locationController.text,
      );
      setState(() {
        message = result['message'] ?? 'تم الحفظ';
        isSaving = false;
      });
    } catch (e) {
      setState(() {
        message = 'فشل الاتصال بالسيرفر';
        isSaving = false;
      });
    }
  }

  Future<void> handleLogout() async {
    await SessionManager.clearSession();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.primary.withOpacity(0.15),
                      child: const Icon(Icons.person, size: 50, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Chip(
                      label: Text(role),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      labelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'رقم الهاتف',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      hintText: phone,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'الموقع',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),
                  isSaving
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: handleSave,
                          child: const Text('حفظ التغييرات'),
                        ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.primary)),
                  ],
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: handleLogout,
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}