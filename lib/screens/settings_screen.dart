import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle('التفضيلات العامة'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                  title: const Text('الإشعارات'),
                  subtitle: const Text('تلقي إشعار عند وجود طلب تواصل جديد'),
                  value: notificationsEnabled,
                  activeColor: AppColors.primary,
                  onChanged: (value) => setState(() => notificationsEnabled = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                  title: const Text('الوضع الليلي'),
                  subtitle: const Text('قريباً في تحديث قادم'),
                  value: darkModeEnabled,
                  activeColor: AppColors.primary,
                  onChanged: null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle('اللغة'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language_outlined, color: AppColors.primary),
              title: const Text('لغة التطبيق'),
              trailing: const Text('العربية', style: TextStyle(color: AppColors.textGrey)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('التطبيق مصمم باللغة العربية حالياً فقط')),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle('الخصوصية والأمان'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: AppColors.primary),
                  title: const Text('تغيير كلمة المرور'),
                  trailing: const Icon(Icons.chevron_left, size: 18),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                  title: const Text('سياسة الخصوصية'),
                  trailing: const Icon(Icons.chevron_left, size: 18),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textGrey),
      ),
    );
  }
}