import 'package:flutter/material.dart';
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
          rows: widget.data.map((item) {
            return DataRow(
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
          columnSpacing: 20,
          horizontalMargin: 10,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
        ),
      ),
    )
    );
  }
}
