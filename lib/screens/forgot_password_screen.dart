import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool otpSent = false;
  bool success = false;
  bool isLoading = false;
  String message = '';
  String generatedOtpDisplay = '';

  Future<void> handleSendOtp() async {
    setState(() {
      isLoading = true;
      message = '';
    });
    try {
      final result = await ApiService.sendOtp(phoneController.text);
      setState(() {
        isLoading = false;
        if (result['otp'] != null) {
          otpSent = true;
          generatedOtpDisplay = result['otp'];
          message = 'تم إرسال رمز التحقق (محاكاة تجريبية للمشروع)';
        } else {
          message = result['message'] ?? 'حدث خطأ';
        }
      });
    } catch (e) {
      setState(() {
        message = 'فشل الاتصال بالسيرفر';
        isLoading = false;
      });
    }
  }

  Future<void> handleVerify() async {
    setState(() {
      isLoading = true;
      message = '';
    });
    try {
      final result = await ApiService.verifyOtp(
        phone: phoneController.text,
        otp: otpController.text,
        newPassword: newPasswordController.text,
      );
      setState(() {
        isLoading = false;
        message = result['message'] ?? 'حدث خطأ';
        success = message == 'تم تغيير كلمة المرور بنجاح';
      });
    } catch (e) {
      setState(() {
        message = 'فشل الاتصال بالسيرفر';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استعادة كلمة المرور')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.lock_reset, size: 60, color: AppColors.primary),
            const SizedBox(height: 16),

            TextField(
              controller: phoneController,
              enabled: !otpSent,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 14),

            if (!otpSent)
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: handleSendOtp,
                      child: const Text('إرسال رمز التحقق'),
                    ),

            if (otpSent) ...[
              if (generatedOtpDisplay.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'رمز التحقق التجريبي (لأغراض العرض بمشروع التخرج):',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        generatedOtpDisplay,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.accent),
                      ),
                    ],
                  ),
                ),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'رمز التحقق',
                  prefixIcon: Icon(Icons.pin_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: handleVerify,
                      child: const Text('تأكيد وتغيير كلمة المرور'),
                    ),
            ],

            if (message.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: success ? AppColors.primary : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            if (success) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('العودة لتسجيل الدخول'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}