import 'package:flutter/material.dart';
import "../../../database/database.dart";

class CardInputs extends StatelessWidget {
  final Map<String, dynamic> item;
  final DatabaseService db = DatabaseService();
  final List<Map<String, dynamic>> store;
  final onRefresh;

  CardInputs({
    required this.item,
    required this.store,
    required this.onRefresh,
  });

  Future<void> onDelete(int id, BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Are You Sure ?'),
          actions: [
            TextButton(
              child: Text('no'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('yas', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      final items = item['items'] as List;
      print(store);
      items.forEach((t) {
        store.forEach((e) {
          if (e['id'] == t['id']) {
            db.update(
              table: 'store',
              id: e['id'],
              data: {'qtn': e['qtn'] - t['qtn']},
              context: context,
              successMessage: "oreder deleted successfully",
              errorMessage: "Error deleting item",
            );
          }
        });
      });
      await db.delete(table: 'inputs', id: id, context: context);
      onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 8,

      color: item['noa'] != null ? Colors.red[200] : null,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  onPressed: () => {},
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
