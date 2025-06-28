import 'package:flutter/material.dart';
import '../../common/btn.dart';

class TableAddItems extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final VoidCallback onSubmit;
  final Function(int) onDelete;
  const TableAddItems({
    super.key,
    required this.items,
    required this.onSubmit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'العناصر المضافة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey,borderRadius: BorderRadius.circular(10)),
              children: [
                const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Items'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Qty'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Delete'),
                      ),
                    ),
                  ],
                ),
                ...items.map((item) {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(item['item']),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            item['qtn'].toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      TableCell(
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => onDelete(items.indexOf(item)),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
            Btn(title: 'Send', width: double.infinity, onTap: onSubmit),
          ],
        ),
      ),
    );
  }
}
