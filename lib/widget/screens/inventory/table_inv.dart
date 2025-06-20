import 'package:flutter/material.dart';
import '../../../utility/hooks.dart';
import '../../common/btn.dart';
import '../../../database/database.dart';

class TableInv extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool sortAscending;
  final int? sortColumnIndex;
  final Function(int, bool) onSort;
  final DatabaseService db = DatabaseService();
  final onRefresh;

  TableInv({
    super.key,
    required this.data,
    required this.sortAscending,
    required this.sortColumnIndex,
    required this.onSort,
    required this.onRefresh,
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
          table: 'inventory',
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            
            columns: [
              DataColumn(label: Text('id'), onSort: onSort),
              DataColumn(label: Text('date'), onSort: onSort),
              DataColumn(label: Text('show'), onSort: onSort),
              DataColumn(label: Text('delete')),
            ],
            rows: data.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item['id'].toString())),
                  DataCell(Text(item['date'].toString().split(' ')[0])),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () => dinamecRouter(
                        context,
                        '/inventory_by_id',
                        {'id': item['id']},
                      ),
                    ),
                  ),
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
