import 'package:flutter/material.dart';
import '../../../hooks.dart';
import '../../common/btn.dart';  

class TableStorage extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool sortAscending;
  final int? sortColumnIndex;
  final Function(int, bool) onSort;
  final Function(String) onDelete;

  const TableStorage({
    super.key,
    required this.data,
    required this.sortAscending,
    required this.sortColumnIndex,
    required this.onSort,
    required this.onDelete,
  });

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
                  DataCell(
                    Btn(title: item['item'],
                    height: 40,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(2),
                     onTap: ()=>dinamecRouter(context,'/all_input_by_id',{'id': item['id'],'item': item['item']})
                     ),
                  ),
                  DataCell(
                    Btn(title: item['qtn']?.toString() ?? '0',
                    height: 40,
                    color: const Color.fromARGB(255, 156, 96, 96)!,
                    width: 70,
                    borderRadius: BorderRadius.circular(2),
                     onTap: ()=>dinamecRouter(context,'/all_output_by_id',{'id': item['id'],'item': item['item']})
                     ),
                  ),
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
