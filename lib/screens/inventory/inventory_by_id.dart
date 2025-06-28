import 'package:flutter/material.dart';
import '../../database/database.dart';
import '../../widget/common/bar.dart';
import '../../widget/common/table_storage.dart';
import 'dart:convert';

class InventoryById extends StatefulWidget {
  const InventoryById({super.key});

  @override
  InventoryByIdState createState() => InventoryByIdState();
}

class InventoryByIdState extends State<InventoryById> {
  late Map<String, dynamic> routeArgs;
  List<Map<String, dynamic>> data = [];
  bool _isInitialized = false;
  bool _isLoading = true;
  bool sortAscending = true;
  int? sortColumnIndex;
  final DatabaseService db = DatabaseService();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      getInvById();
      _isInitialized = true;
    }
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;

      data.sort((a, b) {
        var aValue = a.values.elementAt(columnIndex);
        var bValue = b.values.elementAt(columnIndex);

        if (aValue is num && bValue is num) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }

        if (aValue is String && bValue is String) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }

        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return ascending ? -1 : 1;
        if (bValue == null) return ascending ? 1 : -1;

        return ascending
            ? aValue.toString().compareTo(bValue.toString())
            : bValue.toString().compareTo(aValue.toString());
      });
    });
  }

  Future<void> getInvById() async {
    try {
      final response = await db.read(
        table: 'inventory',
        id: routeArgs['id'].toString(),
        context: context,
        errorMessage: "Network error occurred while fetching items",
      );
      setState(() {
        var rawData = response['data'];
        if (rawData is String) {
          try {
            data = List<Map<String, dynamic>>.from(
              jsonDecode(
                rawData,
              ).map((item) => Map<String, dynamic>.from(item)),
            );
          } catch (e) {
            data = [];
          }
        } else if (rawData is List) {
          data = List<Map<String, dynamic>>.from(rawData);
        } else {
          data = [];
        }
        _isLoading = false;
      });
        } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'Inventory ${routeArgs['id']}'),
      body: _isLoading 
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading...'),
              ],
            ),
          )
        : Center(
            child: TableStorage(
              data: data,
              sortAscending: sortAscending,
              sortColumnIndex: sortColumnIndex,
              onSort: onSort,
              onRefresh: () => null,
              type: 'inventory',
            ),
          ),
    );
  }
}
