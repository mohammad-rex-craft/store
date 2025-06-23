import 'package:flutter/material.dart';
import '../../utility/hooks.dart';
import '../../database/database.dart';

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 10),
              Text('Confirm Delete'),
            ],
          ),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                child: Text('Delete', style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
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
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty 
      ? Container(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 20),
              Text(
                'No items in the store',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Add new items to start',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        )
      : Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                              fontSize: 13,
                            ),
                          ),
                          if (type == 'store') ...[
                            const SizedBox(width: 4),
                            Icon(Icons.input, size: 14, color: Colors.blue.shade700),
                          ]
                        ],
                      ),
                    ),
                    onSort: onSort,
                  ),
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Text(
                            'Qty',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                              fontSize: 13,
                            ),
                          ),
                          if (type == 'store') ...[
                            const SizedBox(width: 4),
                            Icon(Icons.output, size: 14, color: Colors.orange.shade700),
                          ]
                        ],
                      ),
                    ),
                    onSort: onSort,
                  ),
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Text(
                            'Box',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                              fontSize: 13,
                            ),
                          ),
                          if (type == 'store') ...[
                            const SizedBox(width: 4),
                            Icon(Icons.receipt_long, size: 14, color: Colors.purple.shade700),
                          ]
                        ],
                      ),
                    ),
                    onSort: onSort,
                  ),
                  if (type == 'store')
                    DataColumn(
                      label: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                ],
                rows: data.map((item) {
                  return DataRow(
                    cells: [
                      if (type == 'inventory')
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['item'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      if (type == 'store')
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: InkWell(
                              onTap: () => dinamecRouter(context, '/all_input_by_id', {
                                'id': item['id'],
                                'item': item['item'],
                              }),
                              child: Text(
                                item['item'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (type == 'inventory')
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['qtn'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      if (type == 'store')
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: InkWell(
                              onTap: () => dinamecRouter(context, '/all_output_by_id', {
                                'id': item['id'],
                                'item': item['item'],
                              }),
                              child: Text(
                                item['qtn']?.toString() ?? '0',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (type == 'inventory')
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${(item['qtn'] ~/ item['box'])}/${item['qtn'] % item['box']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.purple.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      if (type == 'store')
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: InkWell(
                              onTap: () => dinamecRouter(context, '/all_settlement_by_id', {
                                'id': item['id'],
                                'item': item['item'],
                              }),
                              child: Text(
                                '${(item['qtn'] ~/ item['box'])}/${item['qtn'] % item['box']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.purple.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (type == 'store')
                        DataCell(
                          CircleAvatar(
                            radius: 15, // Small radius for compact design
                            backgroundColor: Colors.red.shade50,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade600,
                                size: 16,
                              ),
                              onPressed: () => deleteItem(item['id'], context),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: 30,
                                minHeight: 30,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }).toList(),
                columnSpacing: 4,
                horizontalMargin: 8,
                sortColumnIndex: sortColumnIndex,
                sortAscending: sortAscending,
                dataRowHeight: 50,
                headingRowHeight: 45,
              ),
            ),
          ),
        );
  }
}
