import 'package:flutter/material.dart';
import '../../../utility/hooks.dart';
import '../../../database/database.dart';
import '../../../l10n/app_localizations.dart';

class DashboardStats extends StatefulWidget {
  const DashboardStats({super.key});

  @override
  State<DashboardStats> createState() => _DashboardStatsState();
}

class _DashboardStatsState extends State<DashboardStats> {
  final DatabaseService db = DatabaseService();
  Map<String, dynamic> stats = {};
  List<Map<String, dynamic>> outOfStockProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboardStats();
  }

  Future<void> loadDashboardStats() async {
    try {
      setState(() {
        isLoading = true;
      });

      // جلب إحصائيات المخزون
      final storeItems = await db.readAll(
        table: 'store',
        context: context,
        errorMessage: "Error loading store data",
      );

      // جلب إحصائيات الطلبات
      final orders = await db.readAll(
        table: 'orders',
        context: context,
        errorMessage: "Error loading orders data",
      );

      // جلب إحصائيات الإدخال
      final inputs = await db.readAll(
        table: 'inputs',
        context: context,
        errorMessage: "Error loading inputs data",
      );

      // حساب الإحصائيات
      int totalItems = storeItems.length;
      int totalOrders = orders.length;
      int totalInputs = inputs.length;
      
      // حساب الكميات
      int outOfStockItems = 0;

      for (var item in storeItems) {
        int qty = item['qtn'] ?? 0;
        
        if (qty == 0) {
          outOfStockItems++;
          outOfStockProducts.add(item);
        }
      }

      // حساب إجمالي قيمة المخزون (تقريبي)
      double totalValue = 0;
      for (var item in storeItems) {
        int qty = item['qtn'] ?? 0;
        double price = (item['price'] ?? 0).toDouble();
        totalValue += qty * price;
      }

      setState(() {
        stats = {
          'totalItems': totalItems,
          'totalOrders': totalOrders,
          'totalInputs': totalInputs,
          'outOfStockItems': outOfStockItems,
          'totalValue': totalValue,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.dashboard,
                    color: hexToColor('#303F9F'),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n?.dashboard ?? 'Dashboard',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: hexToColor('#303F9F'),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: hexToColor('#303F9F'),
                  size: 14,
                ),
                onPressed: loadDashboardStats,
                tooltip: 'reload',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 3.1,
            children: [
              _buildAlertCard(
                title: l10n?.totalItems ??'Total Products',
                value: '${stats['totalItems'] ?? 0}',
                icon: Icons.inventory,
                color: Colors.blue,
              ),
              _buildAlertCard(
                title: l10n?.totalOutputs ??'Orders',
                value: '${stats['totalOrders'] ?? 0}',
                icon: Icons.receipt,
                color: Colors.orange,
              ),
              _buildAlertCard(
                title: l10n?.totalInputs ??'Inputs',
                value: '${stats['totalInputs'] ?? 0}',
                icon: Icons.input,
                color: Colors.purple,
              ),
              _buildAlertCard(
                title: l10n?.outofstock ??'Out of stock',
                value: '${stats['outOfStockItems'] ?? 0}',
                icon: Icons.error,
                color: Colors.red,
                onTap:_showOutOfStockDrawer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 14,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard({
    required String title,
    required String value,
    required String currency,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hexToColor('#303F9F'), hexToColor('#1976D2')],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.attach_money,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$value $currency',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOutOfStockDrawer() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n?.soldout ??'Sold-out products',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: outOfStockProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 50),
                          const SizedBox(height: 16),
                          Text(
                            l10n?.noData ??'No products sold out',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: outOfStockProducts.map((product) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red.withOpacity(0.1),
                                child: const Icon(Icons.inventory, color: Colors.red),
                              ),
                              title: Text(
                                product['item'] ?? 'no name',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${l10n?.quantity ?? 'Quantity'}: 0 ',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 