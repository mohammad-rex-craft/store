import 'package:flutter/material.dart';

class TableStorage extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool sortAscending;
  final int? sortColumnIndex;
  final Function(int, bool) onSort;
  final Function(String) onDelete;

  const TableStorage({
    Key? key,
    required this.data,
    required this.sortAscending,
    required this.sortColumnIndex,
    required this.onSort,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(
                label: Text('Item Name'),
                onSort: onSort,
              ),
              DataColumn(
                label: Text('Quantity'),
                onSort: onSort,
              ),
              DataColumn(
                label: Text('Box'),
                onSort: onSort,
              ),
              DataColumn(label: Text('Actions')),
            ],
            rows: data.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item['item'] ?? '')),
                  DataCell(Text(item['qtn']?.toString() ?? '0')),
                  DataCell(Text('${(item['qtn'] ~/ item['box'])}/${item['qtn'] % item['box']}')),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete(item['id'].toString()),
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
