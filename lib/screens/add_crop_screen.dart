import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class AddCropScreen extends StatefulWidget {
  final String farmerId;
  const AddCropScreen({super.key, required this.farmerId});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  String message = '';
  bool isLoading = false;

  Future<void> handleAddCrop() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      final result = await ApiService.addCrop(
        farmerId: widget.farmerId,
        title: titleController.text,
        category: categoryController.text,
        price: double.tryParse(priceController.text) ?? 0,
        quantity: double.tryParse(quantityController.text) ?? 0,
        unit: 'كيلو',
        location: locationController.text,
      );

      setState(() {
        message = result['message'] ?? 'تم النشر';
        isLoading = false;
      });

      if (result['crop'] != null && mounted) {
        Navigator.pop(context, true);
      }
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
      appBar: AppBar(title: const Text('إضافة محصول جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'اسم المحصول',
                prefixIcon: Icon(Icons.local_florist_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'الفئة (خضروات / فواكه ...)',
                prefixIcon: Icon(Icons.category_outlined),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'السعر (جنيه)',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'الكمية',
                      prefixIcon: Icon(Icons.scale_outlined),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'الموقع',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 26),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: handleAddCrop,
                    child: const Text('نشر المحصول'),
                  ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
