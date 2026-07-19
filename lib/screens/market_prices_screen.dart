import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  List<dynamic> prices = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadPrices();
  }

  Future<void> loadPrices() async {
    setState(() => isLoading = true);
    try {
      final result = await ApiService.getMarketPrices();
      setState(() {
        prices = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'فشل تحميل الأسعار';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('متوسط أسعار السوق')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : prices.isEmpty
                  ? Center(
                      child: Text('لا توجد بيانات أسعار متاحة بعد',
                          style: TextStyle(color: AppColors.textGrey)),
                    )
                  : RefreshIndicator(
                      onRefresh: loadPrices,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: prices.length,
                        itemBuilder: (context, index) {
                          final item = prices[index];
                          final avg = (item['avgPrice'] as num).toDouble();
                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(14),
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.trending_up, color: AppColors.accent),
                              ),
                              title: Text(
                                item['_id'] ?? 'غير محدد',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Text('عدد المنشورات: ${item['count']}'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    avg.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text('جنيه (متوسط)', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}