import 'package:flutter/material.dart';
import '../hooks.dart';
import '../widget/screens/storage/table_storage.dart';
import '../widget/screens/storage/form_create_items.dart';
import '../widget/screens/storage/form_update_items.dart';
import '../widget/common/bar.dart';
import '../database/database.dart';
  
var primeColor = hexToColor('#03A9F4');

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtnController = TextEditingController();
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> indata = [];
  final DatabaseService db = DatabaseService();

  bool sortAscending = true;
  int? sortColumnIndex;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  Future<void> getItems() async {
    getItems2();
    try {
      final response = await db.readAll(
        table: 'store',
        context: context,
        errorMessage: "Network error occurred while fetching items",
      );
      if (response != null) {
        setState(() {
          data = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      // Error is already handled by DatabaseService
    }
  }

  Future<void> getItems2() async {
    try {
      final response = await db.readAll(
        table: 'inputs',
        context: context,
        errorMessage: "Network error occurred while fetching inputs",
      );
      if (response != null) {
        setState(() {
          indata = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      // Error is already handled by DatabaseService
    }
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;

      data.sort((a, b) {
        var aValue = a.values.elementAt(columnIndex);
        var bValue = b.values.elementAt(columnIndex);

        // Handle numeric values
        if (aValue is num && bValue is num) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        }

        // Handle string values
        if (aValue is String && bValue is String) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        }

        // Handle null values
        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return ascending ? -1 : 1;
        if (bValue == null) return ascending ? 1 : -1;

        // Default comparison
        return ascending ? aValue.toString().compareTo(bValue.toString()) 
                        : bValue.toString().compareTo(aValue.toString());
      });
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'Storage'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FormCreateItems(
              onItemCreated: () {
                getItems();
              },
            ),
            SizedBox(height: 16),
            FormUpdateItems(
              items: data,
              onItemUpdated: () {
                getItems();
              },
            ),
            SizedBox(height: 16),
            TableStorage(
              data: data,
              sortAscending: sortAscending,
              sortColumnIndex: sortColumnIndex,
              onSort: onSort,
              onRefresh:getItems
            ),
          ],
        ),
      ),
    );
  }
}
