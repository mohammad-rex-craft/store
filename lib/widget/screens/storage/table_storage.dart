import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TableStorage extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Function getItems;
  
  const TableStorage({required this.data, required this.getItems, Key? key})
    : super(key: key);

  @override
  State<TableStorage> createState() => _TableStorageState();
}

class _TableStorageState extends State<TableStorage> {
  bool sortAscending = true;
  int? sortColumnIndex;

  Future<void> deleteItem(int id) async {
    try {
      await Supabase.instance.client.from('store').delete().eq('id', id);
      await widget.getItems();
    } catch (e) {
      print(e);
    }
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
      widget.data.sort((a, b) {
        if (columnIndex == 0) {
          return ascending
              ? a['item'].toString().compareTo(b['item'].toString())
              : b['item'].toString().compareTo(a['item'].toString());
        } else {
          return ascending
              ? (a['qtn'] as int).compareTo(b['qtn'] as int)
              : (b['qtn'] as int).compareTo(a['qtn'] as int);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable2(
          columns: [
            DataColumn2(
              label: Text('Item Name'),
              size: ColumnSize.L,
              onSort: onSort,
            ),
              DataColumn2(
                label: Text('Quantity'),
                size: ColumnSize.M,
                onSort: onSort,
              ),
              DataColumn2(
                label: Text('Box'),
                size: ColumnSize.M,
                onSort: onSort,
              ),
            DataColumn2(label: Text('Actions'), size: ColumnSize.S),
          ],
          rows: widget.data.map((item) {
            return DataRow2(
              cells: [
                DataCell(Text(item['item'] ?? '')),
                DataCell(Text(item['qtn']?.toString() ?? '0')),
                DataCell(Text('${(item['qtn'] ~/ item['box'])}/${item['qtn'] % item['box']}')),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteItem(item['id']),
                  ),
                ),
              ],
            );
          }).toList(),
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
          headingRowHeight: 60,
          horizontalMargin: 20,
          columnSpacing: 20,
          showCheckboxColumn: false,
        ),
      ),
    );
  }
}
