import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class MyCropsScreen extends StatefulWidget {
  final String farmerId;
  const MyCropsScreen({super.key, required this.farmerId});

  @override
  State<MyCropsScreen> createState() => _MyCropsScreenState();
}

class _MyCropsScreenState extends State<MyCropsScreen> {
  List<dynamic> crops = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMyCrops();
  }

  Future<void> loadMyCrops() async {
    setState(() => isLoading = true);
    try {
      final result = await ApiService.getMyCrops(widget.farmerId);
      setState(() {
        crops = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleDelete(String cropId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنتِ متأكدة من حذف هذا المحصول؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.deleteCrop(cropId);
      loadMyCrops();
    }
  }

  void showEditDialog(Map<String, dynamic> crop) {
    final titleController = TextEditingController(text: crop['title']);
    final priceController = TextEditingController(text: '${crop['price']}');
    final quantityController = TextEditingController(text: '${crop['quantity']}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل المحصول'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'الاسم')),
            const SizedBox(height: 10),
            TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'السعر')),
            const SizedBox(height: 10),
            TextField(controller: quantityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الكمية')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              await ApiService.updateCrop(
                cropId: crop['_id'],
                title: titleController.text,
                category: crop['category'],
                price: double.tryParse(priceController.text) ?? 0,
                quantity: double.tryParse(quantityController.text) ?? 0,
                unit: crop['unit'],
                location: crop['location'],
              );
              if (mounted) Navigator.pop(context);
              loadMyCrops();
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محاصيلي')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : crops.isEmpty
              ? Center(child: Text('لم تنشري أي محصول بعد', style: TextStyle(color: AppColors.textGrey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: crops.length,
                  itemBuilder: (context, index) {
                    final crop = crops[index];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(crop['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${crop['price']} جنيه - الكمية: ${crop['quantity']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                              onPressed: () => showEditDialog(crop),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error),
                              onPressed: () => handleDelete(crop['_id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}