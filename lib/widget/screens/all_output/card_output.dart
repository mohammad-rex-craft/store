import 'package:flutter/material.dart';
import '../../../database/database.dart';
import '../../../utility/hooks.dart';

class CardOutput extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<Map<String, dynamic>> store;
  final onRefresh;
  final DatabaseService db = DatabaseService();
  CardOutput({
    super.key,
    required this.item,
    required this.store,
    required this.onRefresh,
  });

  Future<void> onDelete(int id, BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // عرض تأكيد الحذف
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Order ?'),
            content: const Text(
              'This will delete the order record.',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => navigator.pop(false),
              ),
              TextButton(
                child: const Text('Continue', style: TextStyle(color: Colors.red)),
                onPressed: () => navigator.pop(true),
              ),
            ],
          );
        },
      );

      if (confirm != true) return;

      final result = await db.rpc(
        'delete_order',
        params: {'p_id': id},
        context: context,
      );

      if (result.containsKey('error')) {
        throw result['error'] ?? 'Failed to delete order';
      }

      // عرض رسالة نجاح
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Order deleted and quantities deducted from the store'),
        ),
      );

      // تحديث الواجهة
      onRefresh();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error : ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 8,
      color: const Color.fromARGB(255, 200, 178, 178),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sender: ${item['sender'] ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Client: ${item['client']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item['date'] ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.edit, color: Colors.blue, size: 25),
                  onPressed: () =>
                      dinamecRouter(context, '/edit', {'items': item, 'type': 'orders'}),
                ),

                Text(
                  '${item['noa'] ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.delete, color: Colors.red, size: 25),
                  onPressed: () => onDelete(item['id'], context),
                ),
              ],
            ),

            Divider(),
            Table(
              columnWidths: {0: FlexColumnWidth(3), 1: FlexColumnWidth(1)},
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Item Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Qty',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...(item['items'] as List).map((subItem) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(subItem['item']?.toString() ?? ''),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(subItem['qtn']?.toString() ?? ''),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
