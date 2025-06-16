import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    });
  }

  Future<void> deleteItem(String id) async {
    try {
      await db.delete(
        table: 'store',
        id: id,
        context: context,
        successMessage: "Item deleted successfully",
        errorMessage: "Error deleting item",
      );
      getItems();
    } catch (e) {
      // Error is already handled by DatabaseService
    }
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
              onDelete: deleteItem,
            ),
          ],
        ),
      ),
    );
  }
}
