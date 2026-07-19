import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عن التطبيق')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB8860B), AppColors.primaryDark],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.grass, size: 55, color: Colors.white),
            ),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'منصة المزارعين',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'الإصدار 1.0.0',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'منصة إلكترونية تربط المزارعين بالمشترين مباشرة، بهدف تقليل الاعتماد على '
                'الوسطاء وتحسين شفافية السوق الزراعي المحلي، من خلال تمكين المزارعين من '
                'عرض محاصيلهم مباشرة أمام المشترين، وتوفير معلومات سعرية موثوقة تدعم قرار '
                'التسعير لدى الطرفين.',
                style: TextStyle(height: 1.7, color: AppColors.textDark),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.school_outlined, color: AppColors.primary),
                  title: const Text('مشروع تخرج'),
                  subtitle: const Text('قسم تقانة المعلومات - جامعة شندي'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.code, color: AppColors.primary),
                  title: const Text('التقنيات المستخدمة'),
                  subtitle: const Text('Flutter • Node.js • MongoDB Atlas'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '© 2026 جميع الحقوق محفوظة',
              style: TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
          ),
        ],
      ),
    );
  }
}