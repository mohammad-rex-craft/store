import 'package:flutter/material.dart';
import '../../common/btn.dart';

class TableRemoveItems extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final VoidCallback onSubmit;

  const TableRemoveItems({
    super.key,
    required this.items,
    required this.onSubmit,
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
              border: TableBorder.all(),
              children: [
                const TableRow(
                  children: [
                    TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('العنصر'))),
                    TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('الكمية'))),
                  ],
                ),
                ...items.map((item) {
                  return TableRow(
                    children: [
                      TableCell(child: Padding(padding: const EdgeInsets.all(8), child: Text(item['item']))),
                      TableCell(child: Padding(padding: const EdgeInsets.all(8), child: Text(item['qtn'].toString()))),
                    ],
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 16),
            Btn(
              title: 'إرسال',
              width: double.infinity,
              onTap: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
} 