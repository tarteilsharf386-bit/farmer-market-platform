import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class CropDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> crop;
  final String buyerId;

  const CropDetailsScreen({
    super.key,
    required this.crop,
    required this.buyerId,
  });

  @override
  State<CropDetailsScreen> createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  bool isSending = false;
  String message = '';
  double avgRating = 0;
  int ratingCount = 0;
  bool loadingRating = true;

  @override
  void initState() {
    super.initState();
    loadRating();
  }

  Future<void> loadRating() async {
    try {
      final farmerId = widget.crop['farmer']?['_id'];
      if (farmerId == null) {
        setState(() => loadingRating = false);
        return;
      }
      final result = await ApiService.getFarmerRatings(farmerId);
      setState(() {
        avgRating = (result['average'] as num?)?.toDouble() ?? 0;
        ratingCount = result['count'] ?? 0;
        loadingRating = false;
      });
    } catch (e) {
      setState(() => loadingRating = false);
    }
  }

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
      if (mounted) showRatingDialog();
    } catch (e) {
      setState(() {
        message = 'فشل الاتصال بالسيرفر';
        isSending = false;
      });
    }
  }

  void showRatingDialog() {
    int selectedScore = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('قيّمي تجربتك مع المزارع'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedScore ? Icons.star : Icons.star_border,
                      color: AppColors.accent,
                      size: 30,
                    ),
                    onPressed: () =>
                        setDialogState(() => selectedScore = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(labelText: 'تعليق (اختياري)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('تخطي'),
            ),
            ElevatedButton(
              onPressed: () async {
                final farmerId = widget.crop['farmer']?['_id'];
                if (farmerId != null) {
                  await ApiService.addRating(
                    buyerId: widget.buyerId,
                    farmerId: farmerId,
                    score: selectedScore,
                    comment: commentController.text,
                  );
                }
                if (mounted) Navigator.pop(context);
                loadRating();
              },
              child: const Text('إرسال التقييم'),
            ),
          ],
        ),
      ),
    );
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
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
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
                    _InfoRow(
                      icon: Icons.attach_money,
                      label: 'السعر',
                      value: '${crop['price']} جنيه / ${crop['unit']}',
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.scale_outlined,
                      label: 'الكمية المتاحة',
                      value: '${crop['quantity']} ${crop['unit']}',
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'الموقع',
                      value: crop['location'] ?? '—',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                farmer?['name'] ?? 'مزارع',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                farmer?['phone'] ?? '',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (loadingRating)
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else if (ratingCount == 0)
                      Text(
                        'لا يوجد تقييمات بعد',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                        ),
                      )
                    else
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < avgRating.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: AppColors.accent,
                                size: 18,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${avgRating.toStringAsFixed(1)} ($ratingCount تقييم)',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 13,
                            ),
                          ),
                        ],
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
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
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

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

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
