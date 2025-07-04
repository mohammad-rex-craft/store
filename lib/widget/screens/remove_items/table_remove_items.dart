import 'package:flutter/material.dart';
import '../../common/btn.dart';
import '../../../l10n/app_localizations.dart';

class TableRemoveItems extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final VoidCallback onSubmit;
  final Function(int) onDelete;

  const TableRemoveItems({
    super.key,
    required this.items,
    required this.onSubmit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (items.isEmpty) return const SizedBox.shrink();

    // حساب مجموع الكميات
    final totalQuantity = items.fold<int>(0, (sum, item) => sum + (item['qtn'] as int));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey,borderRadius: BorderRadius.circular(10)),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(child: Text(l10n?.items ?? 'Items')),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(child: Text(l10n?.quantity ?? 'Qty')),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(child: Text(l10n?.delete ?? 'Delete')),
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
                          child: Text(item['qtn'].toString(),textAlign: TextAlign.center,),
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
            // عرض مجموع القطع تحت الجدول
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n?.totalItems ?? 'المجموع',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    totalQuantity.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Btn(
              title: l10n?.send ?? 'send',
              width: double.infinity,
              onTap: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
