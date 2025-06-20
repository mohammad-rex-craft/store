import 'package:flutter/material.dart';
import '../../../utility/hooks.dart';
import '../../common/btn.dart';
import '../../../database/database.dart';

class TableStorage extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool sortAscending;
  final int? sortColumnIndex;
  final Function(int, bool) onSort;
  final DatabaseService db = DatabaseService();
  final onRefresh;
  final String type;

  TableStorage({
    super.key,
    required this.data,
    required this.sortAscending,
    required this.sortColumnIndex,
    required this.onSort,
    required this.onRefresh,
    required this.type,
  });
  Future<void> deleteItem(int id, BuildContext context) async {
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
      try {
        await db.delete(
          table: 'store',
          id: id,
          context: context,
          successMessage: "Item deleted successfully",
          errorMessage: "Error deleting item",
        );
        onRefresh();
      } catch (e) {
        // Error is already handled by DatabaseService
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: data.isEmpty 
        ? Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Item Name'), onSort: onSort),
                  DataColumn(label: Text('Quantity'), onSort: onSort),
                  DataColumn(label: Text('Box'), onSort: onSort),
                  if (type == 'store')
                    DataColumn(label: Text('Actions')),
                ],
                rows: data.map((item) {
                  return DataRow(
                    cells: [
                      
                      if (type == 'inventory')
                        DataCell(
                          Text(item['item']),
                        ),
                      if (type == 'store')
                      DataCell(
                        Btn(
                          title: item['item'],
                          height: 40,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(2),
                          onTap: () => dinamecRouter(context, '/all_input_by_id', {
                            'id': item['id'],
                            'item': item['item'],
                          }),
                        ),
                      ),
                      if (type == 'inventory')
                        DataCell(
                          Text(item['qtn'].toString()),
                        ),
                      if (type == 'store')
                      DataCell(
                        Btn(
                          title: item['qtn']?.toString() ?? '0',
                          height: 40,
                          color: const Color.fromARGB(255, 156, 96, 96)!,
                          width: 70,
                          borderRadius: BorderRadius.circular(2),
                          onTap: () => dinamecRouter(context, '/all_output_by_id', {
                            'id': item['id'],
                            'item': item['item'],
                          }),
                        ),
                      ),
                        DataCell(
                          Text(
                            '${(item['qtn'] ~/ item['box'])}/${item['qtn'] % item['box']}',
                          ),
                        ),
                      if (type == 'store')
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteItem(item['id'], context),
                          ),
                        ),
                    ],
                  );
                }).toList(),
                columnSpacing: 20,
                horizontalMargin: 10,
                sortColumnIndex: sortColumnIndex,
                sortAscending: sortAscending,
              ),
            ),
          ),
    );
  }
}
