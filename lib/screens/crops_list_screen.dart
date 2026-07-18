import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'add_crop_screen.dart';

class CropsListScreen extends StatefulWidget {
  final String farmerId;
  final String userName;
  const CropsListScreen({super.key, required this.farmerId, required this.userName});

  @override
  State<CropsListScreen> createState() => _CropsListScreenState();
}

class _CropsListScreenState extends State<CropsListScreen> {
  List<dynamic> crops = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadCrops();
  }

  Future<void> loadCrops() async {
    setState(() => isLoading = true);
    try {
      final result = await ApiService.getCrops();
      setState(() {
        crops = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'فشل تحميل المحاصيل';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مرحباً، ${widget.userName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              final added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCropScreen(farmerId: widget.farmerId),
                ),
              );
              if (added == true) loadCrops();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : crops.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.eco_outlined, size: 60, color: AppColors.textGrey.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          Text('لا توجد محاصيل متاحة حالياً', style: TextStyle(color: AppColors.textGrey)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: loadCrops,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: crops.length,
                        itemBuilder: (context, index) {
                          final crop = crops[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.eco, color: AppColors.primary, size: 28),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          crop['title'] ?? '',
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${crop['category']} • ${crop['location'] ?? ''}',
                                          style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'الكمية: ${crop['quantity']} ${crop['unit']}',
                                          style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${crop['price']}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        'جنيه/${crop['unit']}',
                                        style: TextStyle(fontSize: 11, color: AppColors.textGrey),
                                      ),
                                    ],
                                  ),
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