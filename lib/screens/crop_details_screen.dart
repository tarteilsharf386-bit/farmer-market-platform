import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class CropDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> crop;
  final String buyerId;

  const CropDetailsScreen({super.key, required this.crop, required this.buyerId});

  @override
  State<CropDetailsScreen> createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  bool isSending = false;
  String message = '';

  Future<void> handleContact() async {
    setState(() {
      isSending = true;
      message = '';
    });

    try {
      final result = await ApiService.contactFarmer(
        cropId: widget.crop['_id'],
        buyerId: widget.buyerId,
      );
      setState(() {
        message = result['message'] ?? 'تم الإرسال';
        isSending = false;
      });
    } catch (e) {
      setState(() {
        message = 'فشل الاتصال بالسيرفر';
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final crop = widget.crop;
    final farmer = crop['farmer'];

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المحصول')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.eco, size: 70, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              crop['title'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            Text(
              crop['category'] ?? '',
              style: TextStyle(fontSize: 15, color: AppColors.textGrey),
            ),
            const SizedBox(height: 18),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoRow(icon: Icons.attach_money, label: 'السعر', value: '${crop['price']} جنيه / ${crop['unit']}'),
                    const Divider(),
                    _InfoRow(icon: Icons.scale_outlined, label: 'الكمية المتاحة', value: '${crop['quantity']} ${crop['unit']}'),
                    const Divider(),
                    _InfoRow(icon: Icons.location_on_outlined, label: 'الموقع', value: crop['location'] ?? '—'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primary.withOpacity(0.15),
                      child: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            farmer?['name'] ?? 'مزارع',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            farmer?['phone'] ?? '',
                            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),

            isSending
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: handleContact,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('تواصل مع المزارع'),
                  ),

            if (message.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: AppColors.textGrey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}