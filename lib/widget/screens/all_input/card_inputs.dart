import 'package:flutter/material.dart';
import "../../../database/database.dart";
import '../../../utility/hooks.dart';

class CardInputs extends StatelessWidget {
  final Map<String, dynamic> item;
  final DatabaseService db = DatabaseService();
  final List<Map<String, dynamic>> store;
  final Function onRefresh;

  CardInputs({
    required this.item,
    required this.store,
    required this.onRefresh,
  });

  Future<void> onDelete(int id, BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Production'),
            content: const Text(
              'This will delete the production record.',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => navigator.pop(false),
              ),
              TextButton(
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => navigator.pop(true),
              ),
            ],
          );
        },
      );

      if (confirm != true) return;

      final result = await db.rpc(
        'delete_input',
        params: {'p_id': id},
        context: context,
      );

      if (result.containsKey('error')) {
        throw result['error'] ?? 'Failed to delete production';
      }

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Production deleted and Remove deducted from the store')),
      );

      onRefresh();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 8,
      color: item['noa'] != null ? Colors.red[200] : null,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item['date'] ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                  onPressed: () =>
                      dinamecRouter(context, '/edit', {'items': item, 'type': 'inputs'}),
                ),
                Text(
                  '${item['noa'] ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                  onPressed: () => onDelete(item['id'], context),
                ),
              ],
            ),
            const Divider(),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: const [
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
                        padding: const EdgeInsets.all(8.0),
                        child: Text(subItem['item']?.toString() ?? ''),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
