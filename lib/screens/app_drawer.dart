import 'package:flutter/material.dart';
import '../services/session_manager.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';
import 'my_crops_screen.dart';
import 'market_prices_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'register_screen.dart';

class AppDrawer extends StatelessWidget {
  final String userId;
  final String userName;
  final String userRole;

  const AppDrawer({
    super.key,
    required this.userId,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFFB8860B), AppColors.primaryDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.grass, size: 42, color: Colors.white),
                ),
                const SizedBox(height: 14),
                Text(
                  userName,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  userRole == 'farmer' ? 'حساب مزارع' : 'حساب مشترٍ',
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.person_outline,
                  label: 'الملف الشخصي',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(userId: userId)));
                  },
                ),
                if (userRole == 'farmer')
                  _DrawerItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'محاصيلي',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyCropsScreen(farmerId: userId)));
                    },
                  ),
                _DrawerItem(
                  icon: Icons.trending_up,
                  label: 'أسعار السوق',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const MarketPricesScreen()));
                  },
                ),
                const Divider(height: 24),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  label: 'الإعدادات',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()));
                  },
                ),
                _DrawerItem(
                  icon: Icons.info_outline,
                  label: 'عن التطبيق',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()));
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _DrawerItem(
            icon: Icons.logout,
            label: 'تسجيل الخروج',
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: () async {
              await SessionManager.clearSession();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  (route) => false,
                );
              }
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(label, style: TextStyle(color: textColor ?? AppColors.textDark, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}