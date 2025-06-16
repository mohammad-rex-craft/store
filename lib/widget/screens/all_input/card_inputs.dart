import 'package:flutter/material.dart';

class CardInputs extends StatelessWidget {
  final Map<String, dynamic> item;

  const CardInputs({super.key, required this.item});
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
                Text(
                  '${item['noa'] ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (item['no'] != null)
                  Text(
                    'NO: ${item['no']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
