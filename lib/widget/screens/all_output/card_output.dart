import 'package:flutter/material.dart';

class CardOutput extends StatelessWidget {
  final Map<String, dynamic> item;

  const CardOutput({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${item['date'] ?? ''}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Client: ${item['client'] ?? ''}'),
            Text('Sender: ${item['sender'] ?? ''}'),
            Text('Invoice: ${item['noa'] ?? ''}'),
            SizedBox(height: 8),
            Text(
              'Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...(item['items'] as List<dynamic>? ?? []).map((item) {
              return Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('${item['item']}: ${item['qtn']}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
