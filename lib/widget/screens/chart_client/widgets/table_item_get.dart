import 'package:flutter/material.dart';

class TableItemGet extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const TableItemGet({
    Key? key,
    required this.orders,
  }) : super(key: key);

  List<Map<String, dynamic>> analyzeItemsData(
    List<Map<String, dynamic>> orders,
  ) {
    Map<String, Map<String, dynamic>> itemsSummary = {};

    for (var order in orders) {
      List<dynamic> items = order['items'] ?? [];
      
      for (var item in items) {
        String itemName = item['item'] ?? '';
        int itemId = item['id'] ?? 0;
        int quantity = item['qtn'] ?? 0;
        
        if (itemName.isNotEmpty) {
          if (itemsSummary.containsKey(itemName)) {
            itemsSummary[itemName]!['qtn'] = 
                (itemsSummary[itemName]!['qtn'] ?? 0) + quantity;
            itemsSummary[itemName]!['order_count'] = 
                (itemsSummary[itemName]!['order_count'] ?? 0) + 1;

          } else {
            itemsSummary[itemName] = {
              'item_id': itemId,
              'item': itemName,
              'qtn': quantity,
              'order_count': 1,
            };
          }
        }
      }
    }

    List<Map<String, dynamic>> result = itemsSummary.values.toList();
    result.sort((a, b) => (b['qtn'] ?? 0).compareTo(a['qtn'] ?? 0));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No data',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final itemsData = analyzeItemsData(orders);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DataTable(
        columns: [
          DataColumn(
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DataColumn(
            label: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Text(
                    'Qty',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        rows: itemsData.map((item) {
          return DataRow(
            cells: [
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['item'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['qtn'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.green.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
        columnSpacing: 4,
        horizontalMargin: 8,
        headingRowHeight: 45,
      ),
    );
  }
}
