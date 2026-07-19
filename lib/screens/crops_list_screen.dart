import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'add_crop_screen.dart';
import 'crop_details_screen.dart';
import 'market_prices_screen.dart';
import '../services/session_manager.dart';
import 'register_screen.dart';
import 'profile_screen.dart';
import 'my_crops_screen.dart';
import 'app_drawer.dart';

class CropsListScreen extends StatefulWidget {
  final String farmerId;
  final String userName;
  final String userRole;
  const CropsListScreen({
    super.key,
    required this.farmerId,
    required this.userName,
    required this.userRole,
  });
  @override
  State<CropsListScreen> createState() => _CropsListScreenState();
}

class _CropsListScreenState extends State<CropsListScreen> {
  List<dynamic> allCrops = [];
  List<dynamic> filteredCrops = [];
  bool isLoading = true;
  String errorMessage = '';
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCrops();
    searchController.addListener(applyFilter);
  }

  Future<void> loadCrops() async {
    setState(() => isLoading = true);
    try {
      final result = await ApiService.getCrops();
      setState(() {
        allCrops = result;
        filteredCrops = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'فشل تحميل المحاصيل';
        isLoading = false;
      });
    }
  }

  void applyFilter() {
    final query = searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        filteredCrops = allCrops;
      } else {
        filteredCrops = allCrops.where((crop) {
          final title = (crop['title'] ?? '').toString();
          final category = (crop['category'] ?? '').toString();
          final location = (crop['location'] ?? '').toString();
          return title.contains(query) ||
              category.contains(query) ||
              location.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        userId: widget.farmerId,
        userName: widget.userName,
        userRole: widget.userRole,
      ),
      appBar: AppBar(
        title: Text('مرحباً، ${widget.userName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: widget.farmerId),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.trending_up),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MarketPricesScreen(),
                ),
              );
            },
          ),
          if (widget.userRole == 'farmer')
            IconButton(
              icon: const Icon(Icons.inventory_2_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyCropsScreen(farmerId: widget.farmerId),
                  ),
                );
              },
            ),
          if (widget.userRole == 'farmer')
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () async {
                final added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddCropScreen(farmerId: widget.farmerId),
                  ),
                );
                if (added == true) loadCrops();
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SessionManager.clearSession();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن محصول، فئة، أو منطقة...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => searchController.clear(),
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : filteredCrops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.eco_outlined,
                          size: 60,
                          color: AppColors.textGrey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          allCrops.isEmpty
                              ? 'لا توجد محاصيل متاحة حالياً'
                              : 'لا توجد نتائج مطابقة للبحث',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: loadCrops,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: filteredCrops.length,
                      itemBuilder: (context, index) {
                        final crop = filteredCrops[index];
                        return Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CropDetailsScreen(
                                    crop: crop,
                                    buyerId: widget.farmerId,
                                  ),
                                ),
                              );
                            },
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
                                    child: const Icon(
                                      Icons.eco,
                                      color: AppColors.primary,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          crop['title'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${crop['category']} • ${crop['location'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'الكمية: ${crop['quantity']} ${crop['unit']}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textGrey,
                                          ),
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
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
